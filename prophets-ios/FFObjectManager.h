//
//  FFObjectManager.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/11/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "RKObjectManager.h"

@interface FFObjectManager : RKObjectManager

+(void)setupObjectManager;

-(void)setupRequestDescriptors;
-(void)setupResponseDescriptors;
-(void)setupFetchRequestBlocks;

@end
