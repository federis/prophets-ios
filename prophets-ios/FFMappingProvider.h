//
//  FFMappingProvider.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/19/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@interface FFMappingProvider : RKObjectMappingProvider

@property (nonatomic, strong) RKManagedObjectStore *objectStore;

+(id)mappingProviderWithObjectStore:(RKManagedObjectStore *)objectStore;
-(id)initWithObjectStore:(RKManagedObjectStore *)objectStore;

-(RKManagedObjectMapping *)userObjectMapping;
-(RKManagedObjectMapping *)leagueObjectMapping;
-(RKManagedObjectMapping *)questionObjectMapping;
-(RKManagedObjectMapping *)answerObjectMapping;
-(RKManagedObjectMapping *)betObjectMapping;
-(RKManagedObjectMapping *)membershipObjectMapping;

@end
