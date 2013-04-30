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
    
    NSDictionary *tokenDict = @{
                                FBTokenInformationTokenKey : [User currentUser].fbToken,
                                FBTokenInformationExpirationDateKey : [User currentUser].fbTokenExpiresAt,
                                FBTokenInformationRefreshDateKey : [User currentUser].fbTokenRefreshedAt
                                };
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
