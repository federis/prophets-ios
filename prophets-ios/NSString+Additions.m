//
//  NSString+Additions.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/17/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

-(NSString *)humanized{
    return [[self replaceCapsWith:@" "] capitalizedString];
}

-(NSNumber *)numberValue{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    return [f numberFromString:self];
}

-(NSDate *)dateFromLocalStringUsingFormat:(NSString *)dateFormat{
    // Popular:
    // @"hh:mma zzz MMM dd,yyyy"
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    
    return [dateFormatter dateFromString:self];
}

-(NSString *)replaceCapsWith:(NSString *)replacement{
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    scanner.caseSensitive = YES;
    
    NSString *builder = [NSString string];
    NSString *buffer = nil;
    NSUInteger lastScanLocation = 0;
    
    while ([scanner isAtEnd] == NO) {
        
        if ([scanner scanCharactersFromSet:[NSCharacterSet lowercaseLetterCharacterSet] intoString:&buffer]) {
            
            builder = [builder stringByAppendingString:buffer];
            
            if ([scanner scanCharactersFromSet:[NSCharacterSet uppercaseLetterCharacterSet] intoString:&buffer]) {
                
                builder = [builder stringByAppendingString:replacement];
                builder = [builder stringByAppendingString:[buffer lowercaseString]];
            }
        }
        
        // If the scanner location has not moved, there's a problem somewhere.
        if (lastScanLocation == scanner.scanLocation){
            return nil;
        }
        lastScanLocation = scanner.scanLocation;
    }
    
    return builder;
}


@end
