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
#import "FFFacebookSession.h"
#import "NSManagedObjectContext+Additions.h"
#import "User.h"
#import "FFApplicationConstants.h"
#import "ErrorCollection.h"

@implementation FFFacebook

+(FBSession *)fbSession{
    FFFacebookSessionTokenCachingStrategy *fbTokenCache = [[FFFacebookSessionTokenCachingStrategy alloc] init];
    
    FFFacebookSession *session = [[FFFacebookSession alloc] initWithAppID:nil
                                                              permissions:@[@"email"]
                                                          defaultAudience:nil
                                                          urlSchemeSuffix:nil
                                                       tokenCacheStrategy:fbTokenCache];
    
    [FBSession setActiveSession:session];
    
    return session;
}

+(void)connectAccountForCurrentUser:(void (^)(void))successBlock failure:(void (^)(NSError *, NSHTTPURLResponse *))failureBlock{
    FBSession *session = [self fbSession];
    
    [session openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent
            completionHandler:^(FBSession *session, FBSessionState state, NSError *err){
                if (session.isOpen) {
                    [self saveTokenDataToRemotePath:@"/users/facebook" forUser:[User currentUser] withSuccessHandler:^{
                        successBlock();
                    } failure:^(NSError *error, NSHTTPURLResponse *httpResponse){
                        failureBlock(error, httpResponse);
                    }];
                }
            }];
}

+(void)openSessionForAlreadyConnectedUser{
    FBSession *session = [self fbSession];
    
    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
            completionHandler:^(FBSession *session, FBSessionState state, NSError *err){
                if (session.isOpen) {
                    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *conn, id result, NSError *err){
                        DLog(@"here");
                    }];
                }
            }];
}

+(void)logInViaFacebookWithSuccessHandler:(void (^)(User *))successBlock failure:(void (^)(NSError *, NSHTTPURLResponse *))failureBlock{
    
    NSManagedObjectContext *context = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    NSManagedObjectContext *scratch = [context childContext];
    User *tmpUser = (User *)[scratch insertNewObjectForEntityForName:@"User"];
    
    FBSession *session = [self fbSession];
    
    [session openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent
            completionHandler:^(FBSession *session, FBSessionState state, NSError *err){
                if (session.isOpen) {
                    tmpUser.fbToken = session.accessTokenData.accessToken;
                    tmpUser.fbTokenExpiresAt = session.accessTokenData.expirationDate;
                    tmpUser.fbTokenRefreshedAt = session.accessTokenData.refreshDate;
                    
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
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    
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
