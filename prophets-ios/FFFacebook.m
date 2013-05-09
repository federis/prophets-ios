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
#import "Bet.h"
#import "Answer.h"
#import "Question.h"
#import "Utilities.h"

@implementation FFFacebook

+(void)connectAccountForCurrentUser:(void (^)(void))successBlock failure:(void (^)(NSError *, NSHTTPURLResponse *))failureBlock isRetry:(BOOL)isRetry{
    [FBSession openActiveSessionWithReadPermissions:@[@"email"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        if (session.isOpen) {
            
            [SVProgressHUD showWithStatus:@"Connecting Facebook Account" maskType:SVProgressHUDMaskTypeGradient];
            // Use this call to make sure we have a valid token
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if(error){
                    [SVProgressHUD dismiss];
                }
                else{
                    [self saveTokenDataToRemotePath:@"/users/facebook" forUser:[User currentUser] withSuccessHandler:^{
                        [SVProgressHUD dismiss];
                        successBlock();
                    } failure:^(NSError *error, NSHTTPURLResponse *httpResponse){
                        [SVProgressHUD dismiss];
                        failureBlock(error, httpResponse);
                    }];
                }
            }];
            
        }
        else if (error){
            if (error.fberrorShouldNotifyUser) {
                [Utilities showOkAlertWithTitle:@"Error Connecting Account" message:error.fberrorUserMessage];
            }
            else{
                if (!isRetry) {
                    // re-try opening the session
                    [self connectAccountForCurrentUser:successBlock failure:failureBlock isRetry:YES];
                }
            }
        }
    }];
}

+(void)logInViaFacebookWithSuccessHandler:(void (^)(User *))successBlock failure:(void (^)(NSError *, NSHTTPURLResponse *))failureBlock{
    
    NSManagedObjectContext *context = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    NSManagedObjectContext *scratch = [context childContext];
    User *tmpUser = (User *)[scratch insertNewObjectForEntityForName:@"User"];
    
    [FBSession openActiveSessionWithReadPermissions:@[@"email"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        if (session.isOpen) {            
            [self saveTokenDataToRemoteForUser:tmpUser withSuccessHandler:^{
                [scratch description]; //access this here so that the block retains it, keeping the tmpUser around
                User *user = (User *)[context objectWithID:[tmpUser objectID]];
                successBlock(user);
            } failure:^(NSError *error, NSHTTPURLResponse *httpResponse){
                failureBlock(error, httpResponse);
            }];
        }
    }];
}

+(void)saveTokenDataToRemoteForUser:(User *)user withSuccessHandler:(void (^)(void))successBlock failure:(void (^)(NSError *, NSHTTPURLResponse *))failureBlock{
    [self saveTokenDataToRemotePath:@"/tokens/facebook" forUser:user withSuccessHandler:successBlock failure:failureBlock];
}

+(void)saveTokenDataToRemotePath:(NSString *)path forUser:(User *)user withSuccessHandler:(void (^)(void))successBlock failure:(void (^)(NSError *, NSHTTPURLResponse *))failureBlock{
    [SVProgressHUD showWithStatus:@"Saving Facebook Info" maskType:SVProgressHUDMaskTypeGradient];
    
    user.fbToken = FBSession.activeSession.accessTokenData.accessToken;
    user.fbTokenExpiresAt = FBSession.activeSession.accessTokenData.expirationDate;
    user.fbTokenRefreshedAt = FBSession.activeSession.accessTokenData.refreshDate;
    
    [[RKObjectManager sharedManager] postObject:user path:path
                                     parameters:@{ @"fb_token": user.fbToken, @"fb_token_expires_at" : user.fbTokenExpiresAt, @"fb_token_refreshed_at" : user.fbTokenRefreshedAt }
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                [SVProgressHUD dismiss];
                
                successBlock();
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error){
                [SVProgressHUD dismiss];
                
                failureBlock(error, operation.HTTPRequestOperation.response);
            }];
}

@end
