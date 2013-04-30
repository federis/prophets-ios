//
//  User.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <Lockbox.h>

#import "User.h"
#import "FFApplicationConstants.h"
#import "Membership.h"
#import "League.h"
#import "NSManagedObjectContext+Additions.h"

@implementation User

static User *currentUser = nil;

@synthesize password = _password;
@synthesize currentPassword = _currentPassword;
@synthesize deviceToken;

@dynamic email;
@dynamic name;
@dynamic fbUid;
@dynamic fbToken;
@dynamic fbTokenExpiresAt;
@dynamic fbTokenRefreshedAt;
@dynamic answers;
@dynamic judgedAnswers;
@dynamic bets;
@dynamic createdLeagues;
@dynamic memberships;
@dynamic questions;
@dynamic approvedQuestions;
@dynamic wantsNewQuestionNotifications;
@dynamic wantsNewCommentNotifications;
@dynamic wantsQuestionCreatedNotifications;
@dynamic wantsNotifications;

-(Membership *)membershipInLeague:(id)leagueOrId;{
    NSParameterAssert(leagueOrId);
    
    NSNumber *leagueId = nil;
    if ([leagueOrId isKindOfClass:[League class]]) {
        leagueId = ((League *)leagueOrId).remoteId;
    }
    else if([leagueOrId isKindOfClass:[NSNumber class]]){
        leagueId = (NSNumber *)leagueOrId;
    }
    
    NSAssert(leagueId != nil, @"You must pass a League object or a NSNumber representing the league's ID");
    
    NSSet *objs = [self.managedObjectContext fetchObjectsForEntityName:NSStringFromClass([Membership class])
                                                         withPredicate:@"leagueId = %@ AND userId = %@", leagueId, self.remoteId];
    
    return [objs anyObject]; //should only be 1
}

+(User *)currentUser{
    if(!currentUser){
        NSNumber *remoteId = [NSDecimalNumber decimalNumberWithString:[Lockbox stringForKey:@"currentUserId"]];
        currentUser = [User findById:remoteId inContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    }
    
    return currentUser;
}

+(void)setCurrentUser:(User *)user{
    currentUser = user;
    if(!user)
        [Lockbox setString:@"" forKey:@"currentUserId"];
    else
        [Lockbox setString:user.remoteId.stringValue forKey:@"currentUserId"];
}

-(NSString *)authenticationToken{
    if(!_authenticationToken){
        _authenticationToken = [Lockbox stringForKey:@"authToken"];
    }
    return _authenticationToken;
}

-(void)setAuthenticationToken:(NSString *)token{
    [Lockbox setString:token forKey:@"authToken"];
    _authenticationToken = token;
}

+(RKEntityMapping *)responseMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"email", @"name"]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"id" : @"remoteId",
        @"authentication_token" : @"authenticationToken",
        @"fb_uid" : @"fbUid",
        @"fb_token" : @"fbToken",
        @"fb_token_expires_at" : @"fbTokenExpiresAt",
        @"fb_token_refreshed_at" : @"fbTokenRefreshedAt",
        @"wants_notifications" : @"wantsNotifications",
        @"wants_new_question_notifications" : @"wantsNewQuestionNotifications",
        @"wants_new_comment_notifications" : @"wantsNewCommentNotifications",
        @"wants_question_created_notifications" : @"wantsQuestionCreatedNotifications",
        @"updated_at" : @"updatedAt",
        @"created_at" : @"createdAt"
     }];
    
    return mapping;
}

+(RKMapping *)requestMapping{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromArray:@[@"email", @"name", @"password"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"remoteId" : @"id",
     @"fbUid" : @"fb_uid",
     @"fbToken" : @"fb_token",
     @"fbTokenExpiresAt" : @"fb_token_expires_at",
     @"fbTokenRefreshedAt" : @"fb_token_refreshed_at",
     @"currentPassword" : @"current_password",
     @"wantsNotifications" : @"wants_notifications",
     @"wantsNewQuestionNotifications" : @"wants_new_question_notifications",
     @"wantsNewCommentNotifications" : @"wants_new_comment_notifications",
     @"wantsQuestionCreatedNotifications" : @"wants_question_created_notifications",
     }];
    return mapping;
}


@end
