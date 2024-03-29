//
//  FFNotificationHandler.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 3/13/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "FFNotificationHandler.h"
#import "Utilities.h"
#import "FFDeepLinker.h"
#import "FFApplicationConstants.h"

static FFNotificationHandler *sharedHandler = nil;

@implementation FFNotificationHandler

+ (instancetype)sharedHandler{
    if (sharedHandler) return sharedHandler;
    sharedHandler = [[FFNotificationHandler alloc] init];
    return sharedHandler;
}

-(void)handleNotification:(NSDictionary *)notification{

#ifdef DEBUG
    //[Utilities showOkAlertWithTitle:@"note" message:[notification description]];
#endif
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) return;
    
    NSString *type = [notification objectForKey:@"notificationType"];
    if ([type isEqualToString:@"newQuestion"]){
        [self handleNewQuestionNotification:notification];
    }
    else if ([type isEqualToString:@"questionCreated"]){
        [self handleQuestionCreatedNotification:notification];
    }
    else if ([type isEqualToString:@"newComment"]){
        [self handleNewCommentNotification:notification];
    }
    else if ([type isEqualToString:@"judgement"]){
        [self handlePayoutNotification:notification];
    }
}

-(void)handleNewQuestionNotification:(NSDictionary *)notification{
    NSString *leagueId = [notification objectForKey:@"leagueId"];
    NSString *questionId = [notification objectForKey:@"questionId"];
    
    [[FFDeepLinker sharedLinker] handleUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@://leagues/%@/questions/%@", FFURLScheme, leagueId, questionId]]];
}

-(void)handleQuestionCreatedNotification:(NSDictionary *)notification{
    NSString *leagueId = [notification objectForKey:@"leagueId"];
    NSString *questionId = [notification objectForKey:@"questionId"];
    
    [[FFDeepLinker sharedLinker] handleUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@://leagues/%@/questions/%@/review", FFURLScheme, leagueId, questionId]]];
}

-(void)handleNewCommentNotification:(NSDictionary *)notification{
    NSString *leagueId = [notification objectForKey:@"leagueId"];
    NSString *commentableId = [notification objectForKey:@"commentableId"];
    NSString *commentableType = [notification objectForKey:@"commentableType"];
    
    if ([commentableType isEqualToString:@"League"]) {
        [[FFDeepLinker sharedLinker] handleUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@://leagues/%@/comments", FFURLScheme, leagueId]]];
    }
    else if ([commentableType isEqualToString:@"Question"]) {
        [[FFDeepLinker sharedLinker] handleUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@://leagues/%@/questions/%@", FFURLScheme, leagueId, commentableId]]];
    }
}

-(void)handlePayoutNotification:(NSDictionary *)notification{
    NSString *leagueId = [notification objectForKey:@"leagueId"];
    NSString *questionId = [notification objectForKey:@"questionId"];
    
    [[FFDeepLinker sharedLinker] handleUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@://leagues/%@/questions/%@", FFURLScheme, leagueId, questionId]]];
}

@end
