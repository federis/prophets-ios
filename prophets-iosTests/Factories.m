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

+(Answer *)answerFactory{
    Answer *answer = [Answer object];
    answer.remoteId = [NSNumber numberWithInt:1];
    
    return answer;
}

+(Bet *)betFactory{
    Bet *bet = [Bet object];
    bet.remoteId = [NSNumber numberWithInt:1];
    
    return bet;
}


@end
