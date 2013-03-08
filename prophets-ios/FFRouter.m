//
//  FFRouter.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/11/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFRouter.h"

#import "User.h"
#import "League.h"
#import "Question.h"
#import "Bet.h"
#import "Answer.h"
#import "Tag.h"
#import "Membership.h"

@interface FFRouter()

-(void)setupRoutes;

@end


@implementation FFRouter

- (id)initWithBaseURL:(NSURL *)baseURL
{
    self = [super initWithBaseURL:baseURL];
    if (self) {
        [self setupRoutes];
    }
    
    return self;
}

- (id)init{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%@ Failed to call designated initializer. Invoke initWithBaseURL: instead.", NSStringFromClass([self class])]
                                 userInfo:nil];
}

-(void)setupRoutes{
    // GETS
    [self.routeSet addRoute:[RKRoute routeWithClass:[User class] pathPattern:@"/users/:remoteId" method:RKRequestMethodGET]];
    
    [self.routeSet addRoute:[RKRoute routeWithClass:[League class] pathPattern:@"/leagues/:remoteId" method:RKRequestMethodGET]];
    
    [self.routeSet addRoute:[RKRoute routeWithClass:[Question class] pathPattern:@"/leagues/:leagueId/questions/:remoteId" method:RKRequestMethodGET]];
    
    [self.routeSet addRoute:[RKRoute routeWithRelationshipName:@"memberships" objectClass:[User class] pathPattern:@"/memberships" method:RKRequestMethodGET]];
    
    [self.routeSet addRoute:[RKRoute routeWithRelationshipName:@"questions" objectClass:[League class] pathPattern:@"/leagues/:remoteId/questions" method:RKRequestMethodGET]];
    
    [self.routeSet addRoute:[RKRoute routeWithName:@"unapproved_questions" pathPattern:@"/leagues/:remoteId/questions?type=unapproved" method:RKRequestMethodGET]];
    
    [self.routeSet addRoute:[RKRoute routeWithName:@"pending_judgement_questions" pathPattern:@"/leagues/:remoteId/questions?type=pending_judgement" method:RKRequestMethodGET]];
    
    [self.routeSet addRoute:[RKRoute routeWithName:@"complete_questions" pathPattern:@"/leagues/:remoteId/questions?type=complete" method:RKRequestMethodGET]];
    
    [self.routeSet addRoute:[RKRoute routeWithRelationshipName:@"bets" objectClass:[League class] pathPattern:@"/leagues/:remoteId/bets" method:RKRequestMethodGET]];
    
    [self.routeSet addRoute:[RKRoute routeWithRelationshipName:@"comments" objectClass:[League class] pathPattern:@"/leagues/:remoteId/comments" method:RKRequestMethodGET]];
    
    [self.routeSet addRoute:[RKRoute routeWithRelationshipName:@"leaderboard" objectClass:[League class] pathPattern:@"/leagues/:remoteId/leaderboard" method:RKRequestMethodGET]];
    
    [self.routeSet addRoute:[RKRoute routeWithRelationshipName:@"memberships" objectClass:[League class] pathPattern:@"/leagues/:remoteId/memberships" method:RKRequestMethodGET]];
    
    [self.routeSet addRoute:[RKRoute routeWithRelationshipName:@"comments" objectClass:[Question class] pathPattern:@"/questions/:remoteId/comments" method:RKRequestMethodGET]];
    
    [self.routeSet addRoute:[RKRoute routeWithRelationshipName:@"leagues" objectClass:[Tag class] pathPattern:@"/tags/:remoteId/leagues" method:RKRequestMethodGET]];
    
    [self.routeSet addRoute:[RKRoute routeWithName:@"tags" pathPattern:@"/tags" method:RKRequestMethodGET]];
    
    [self.routeSet addRoute:[RKRoute routeWithName:@"leagues" pathPattern:@"/leagues" method:RKRequestMethodGET]];
    
    // POSTS
    // post requests should use :relationshipId (ie. questionId) instead of :relationship.remoteId since they do not exist yet
    // The response mapping should connect the relationship upon creation - NOT before we successfully create the resource
    [self.routeSet addRoute:[RKRoute routeWithClass:[Bet class] pathPattern:@"/answers/:answerId/bets" method:RKRequestMethodPOST]];
    
    [self.routeSet addRoute:[RKRoute routeWithClass:[Question class] pathPattern:@"/leagues/:leagueId/questions" method:RKRequestMethodPOST]];
    
    [self.routeSet addRoute:[RKRoute routeWithClass:[Answer class] pathPattern:@"/questions/:questionId/answers" method:RKRequestMethodPOST]];
    
    [self.routeSet addRoute:[RKRoute routeWithClass:[Membership class] pathPattern:@"/leagues/:leagueId/memberships" method:RKRequestMethodPOST]];
    
    
    // PUTS
    // put requests should use :relationship.remoteId instead of :relationshipId (ie. questionId) since they already exist
    
    //comment put routes are in the form bc RKRouter can't handle two paths for the same verb on a resource, but comments need to be put to leagues and questions
    
    [self.routeSet addRoute:[RKRoute routeWithClass:[League class] pathPattern:@"/leagues/:remoteId" method:RKRequestMethodPUT]];
    
    [self.routeSet addRoute:[RKRoute routeWithClass:[Question class] pathPattern:@"/leagues/:league.remoteId/questions/:remoteId" method:RKRequestMethodPUT]];
    
    [self.routeSet addRoute:[RKRoute routeWithName:@"approve_question" pathPattern:@"/leagues/:league.remoteId/questions/:remoteId/approve" method:RKRequestMethodPUT]];
    
    [self.routeSet addRoute:[RKRoute routeWithName:@"judge_answer" pathPattern:@"/questions/:question.remoteId/answers/:remoteId/judge" method:RKRequestMethodPUT]];
    
    [self.routeSet addRoute:[RKRoute routeWithClass:[Answer class] pathPattern:@"/questions/:question.remoteId/answers/:remoteId" method:RKRequestMethodPUT]]; 
    
    // DELETES
    // delete requests should use :relationship.remoteId instead of :relationshipId (ie. questionId) since they already exist
    
    [self.routeSet addRoute:[RKRoute routeWithClass:[Question class] pathPattern:@"/leagues/:league.remoteId/questions/:remoteId" method:RKRequestMethodDELETE]];
    
    [self.routeSet addRoute:[RKRoute routeWithClass:[Membership class] pathPattern:@"/leagues/:league.remoteId/memberships/:remoteId" method:RKRequestMethodDELETE]];
    
    [self.routeSet addRoute:[RKRoute routeWithClass:[Answer class] pathPattern:@"/questions/:question.remoteId/answers/:remoteId" method:RKRequestMethodDELETE]];
    
}

@end
