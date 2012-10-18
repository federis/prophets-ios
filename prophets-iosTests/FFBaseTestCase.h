//
//  FFBaseTestCase.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 10/4/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import <RestKit/Testing.h>

#import "CoreData+MagicalRecord.h"
#import "Factories.h"
#import "KeychainItemWrapper.h"
#import "ApplicationConstants.h"

@interface FFBaseTestCase : SenTestCase{
    KeychainItemWrapper *keychain;
}

@end
