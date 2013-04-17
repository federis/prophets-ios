//
//  FFFormSection.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 4/16/13.
//  Copyright (c) 2013 Benjamin Roesch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFFormSection : NSObject

@property (nonatomic, strong) NSMutableArray *fields;
@property (nonatomic, strong) NSString *title;

-(id)initWithFields:(NSArray *)fields title:(NSString *)title;

@end
