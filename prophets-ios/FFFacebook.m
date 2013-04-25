//
//  FFFacebook.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 4/24/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <SVProgressHUD.h>

#import "FFFacebook.h"
#import "NSManagedObjectContext+Additions.h"
#import "User.h"
#import "FFApplicationConstants.h"
#import "ErrorCollection.h"

@implementation FFFacebook

static FBSession *sharedSession = nil;

+(FBSession *)sharedSession{
    if (!sharedSession) {
        [self setSharedSession:[[FBSession alloc] init]];
    }
    
    return sharedSession;
}

+(void)setSharedSession:(FBSession *)session{
    sharedSession = session;
}

+(void)logInWithFacebookSession:(FBSession *)session success:(void (^)(void))successBlock failure:(void (^)(NSError *))failureBlock{
    
    NSManagedObjectContext *context = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    NSManagedObjectContext *scratch = [context childContext];
    
    User *tmpUser = (User *)[scratch insertNewObjectForEntityForName:@"User"];
    //tmpUser.fbToken = session.accessTokenData.accessToken;
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    
    [[RKObjectManager sharedManager] postObject:tmpUser path:@"/tokens/facebook"
        parameters:@{ @"fb_token": session.accessTokenData.accessToken, @"fb_token_expires_at" : session.accessTokenData.expirationDate }
        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
            [SVProgressHUD dismiss];
            
            User *user = (User *)[context objectWithID:[tmpUser objectID]];
            [User setCurrentUser:user];
            [[NSNotificationCenter defaultCenter] postNotificationName:FFUserDidLogInNotification object:user];
        }
        failure:^(RKObjectRequestOperation *operation, NSError *error){
            [SVProgressHUD dismiss];
            
            ErrorCollection *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
            [SVProgressHUD showErrorWithStatus:[errors messagesString]];
        }];
}

@end
