//
//  NSURL+Additions.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 1/31/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import "NSURL+Additions.h"

@implementation NSURL (Additions)

-(NSDictionary *)queryDictionary{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [self.query componentsSeparatedByString:@"&"]) {
        NSArray *pair = [param componentsSeparatedByString:@"="];
        if([pair count] < 2) continue;
        [params setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
    }
    return [NSDictionary dictionaryWithDictionary:params];
}

@end
