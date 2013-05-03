//
//  ErrorCollection.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/13/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "ErrorCollection.h"

@implementation ErrorCollection

-(NSString *)messagesString{
    if (self.message) {
        return self.message;
    }
    else{
        NSMutableString *str = [[NSMutableString alloc] init];
        for (int i=0; i<self.messages.count; i++) {
            NSString *msg = [self.messages objectAtIndex:i];
            if (i==self.messages.count-1) {
                [str appendFormat:@"%@", msg];
            } else {
                [str appendFormat:@"%@\n", msg];
            }
        }
        return str;
    }
}

@end
