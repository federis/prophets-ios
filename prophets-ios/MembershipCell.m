//
//  MembershipCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 9/30/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/UI.h>

#import "MembershipCell.h"

@implementation MembershipCell

+(RKTableViewCellMapping *)mappingForCell{
    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClassName = NSStringFromClass([self class]);
    cellMapping.reuseIdentifier = NSStringFromClass([self class]);
    cellMapping.rowHeight = 65.0;
    [cellMapping mapKeyPath:@"league.name" toAttribute:@"leagueNameLabel.text"];
    [cellMapping mapKeyPath:@"balance.currencyValue" toAttribute:@"balanceLabel.text"];
    return cellMapping;
}

@end
