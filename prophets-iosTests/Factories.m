//
//  ObjectFactories.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/5/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "Factories.h"
#import "User.h"
#import "League.h"
#import "Question.h"
#import "Answer.h"
#import "Bet.h"

@implementation Factories

+(User *)userFactory{
    User *user = [User object];
    user.remoteId = [NSNumber numberWithInt:1];
    user.email = @"bcroesch@gmail.com";
    
    return user;
}

+(League *)leagueFactory{
    League *league = [League object];
    league.remoteId = [NSNumber numberWithInt:1];
    
    return league;
}

+(Question *)questionFactory{
    Question *question = [Question object];
    question.remoteId = [NSNumber numberWithInt:1];
    question.approvedAt = [NSDate dateWithTimeIntervalSinceNow:-3600*24*10];
    question.bettingClosesAt = [NSDate dateWithTimeIntervalSinceNow:3600*24*10]; // 10 days from now
    question.content = @"Is this a question?";
    
    return question;
}

+(Answer *)answerFactory{
    Answer *answer = [Answer object];
    answer.remoteId = [NSNumber numberWithInt:1];
    answer.content = @"Answer name";
    
    return answer;
}

+(Bet *)betFactory{
    Bet *bet = [Bet object];
    bet.remoteId = [NSNumber numberWithInt:1];
    bet.amount = [NSDecimalNumber decimalNumberWithString:@"10"];
    bet.probability = [NSDecimalNumber decimalNumberWithString:@"0.2"];
    
    return bet;
}


@end
