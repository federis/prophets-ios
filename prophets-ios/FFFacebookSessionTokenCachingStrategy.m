//
//  FFFacebookSessionTokenCachingStrategy.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 4/29/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "FFFacebookSessionTokenCachingStrategy.h"
#import "FFFacebook.h"
#import "User.h"

@implementation FFFacebookSessionTokenCachingStrategy

-(void)cacheFBAccessTokenData:(FBAccessTokenData *)accessToken{
    User *user = [User currentUser];
    user.fbToken = accessToken.accessToken;
    user.fbTokenExpiresAt = accessToken.expirationDate;
    user.fbTokenRefreshedAt = accessToken.refreshDate;
    //[FFFacebook saveTokenDataToRemote:accessToken forUser:[User currentUser] withSuccessHandler:^{} failure:^(NSError *error){}];
    //[super cacheFBAccessTokenData:accessToken];
}

-(void)cacheTokenInformation:(NSDictionary *)tokenInformation{
    [super cacheTokenInformation:tokenInformation];
}

-(NSDictionary *)fetchTokenInformation{
    if (![User currentUser]) return nil;
    
    NSMutableDictionary *tokenDict = [NSMutableDictionary dictionary];
    
    if ([User currentUser].fbToken) {
        tokenDict[FBTokenInformationTokenKey] = [User currentUser].fbToken;
    }
    
    if ([User currentUser].fbTokenExpiresAt) {
        tokenDict[FBTokenInformationExpirationDateKey] = [User currentUser].fbTokenExpiresAt;
    }
    
    if ([User currentUser].fbTokenRefreshedAt) {
        tokenDict[FBTokenInformationRefreshDateKey] = [User currentUser].fbTokenRefreshedAt;
    }
    
    return tokenDict;
}
/*
-(FBAccessTokenData *)fetchFBAccessTokenData{
    return [super fetchFBAccessTokenData];
}
*/

-(void)clearToken{
    [super clearToken];
}

@end
