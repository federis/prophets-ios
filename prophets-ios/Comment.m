//
//  Comment.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/2/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "Comment.h"
#import "League.h"
#import "Question.h"
#import "Bet.h"


@implementation Comment

@dynamic comment;
@dynamic userName;
@dynamic leagueId;
@dynamic questionId;
@dynamic betId;
@dynamic userId;
@dynamic league;
@dynamic question;
@dynamic bet;

-(NSString *)urlPath{
    if (self.remoteId) {
        if(self.questionId){
            return [NSString stringWithFormat:@"/questions/%@/comments/%@", self.questionId, self.remoteId];
        }
        else if (self.betId){
            return [NSString stringWithFormat:@"/bets/%@/comments/%@", self.betId, self.remoteId];
        }
        else{
            return [NSString stringWithFormat:@"/leagues/%@/comments/%@", self.leagueId, self.remoteId];
        }
    }
    else{
        if(self.questionId){
            return [NSString stringWithFormat:@"/questions/%@/comments", self.questionId];
        }
        else if (self.betId){
            return [NSString stringWithFormat:@"/bets/%@/comments", self.betId];
        }
        else{
            return [NSString stringWithFormat:@"/leagues/%@/comments", self.leagueId];
        }
    }

}

+(RKEntityMapping *)responseMapping{
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"comment"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id" : @"remoteId",
     @"league_id" : @"leagueId",
     @"question_id" : @"questionId",
     @"bet_id" : @"betId",
     @"user_id" : @"userId",
     @"user_name" : @"userName",
     @"updated_at" : @"updatedAt",
     @"created_at" : @"createdAt"
     }];
    
    [mapping addConnectionForRelationship:@"league" connectedBy:@{@"leagueId" : @"remoteId"}];
    [mapping addConnectionForRelationship:@"question" connectedBy:@{@"questionId" : @"remoteId"}];
    [mapping addConnectionForRelationship:@"bet" connectedBy:@{@"betId" : @"remoteId"}];
    
    return mapping;
}

+(RKMapping *)requestMapping{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"comment"]];
    return mapping;
}

@end
