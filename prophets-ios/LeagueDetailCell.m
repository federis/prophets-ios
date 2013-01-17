//
//  LeagueDetailCell.m
//  prophets-ios
//
//  Created by Benjamin Roesch on 12/7/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "LeagueDetailCell.h"
#import "League.h"
#import "Tag.h"
#import "Utilities.h"

@implementation LeagueDetailCell

-(void)setLeague:(League *)league{
    _league = league;
    
    self.nameLabel.text = league.name;
    self.nameLabel.frame = RectWithNewHeight([Utilities heightForString:league.name withFont:self.nameLabel.font width:self.nameLabel.frame.size.width], self.nameLabel.frame);
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@ %@ · %@ %@",
                              league.membershipsCount,
                              [Utilities pluralize:league.membershipsCount
                                          singular:@"member" plural:@"members"],
                              league.questionsCount,
                              [Utilities pluralize:league.questionsCount
                                          singular:@"question" plural:@"questions"]];
    self.detailLabel.frame = RectBelowRectWithSpacingAndSize(self.nameLabel.frame, 5, self.detailLabel.frame.size);
    
    self.creatorLabel.text = [NSString stringWithFormat:@"Created by %@", league.creatorName];
    self.creatorLabel.frame = RectBelowRectWithSpacingAndSize(self.detailLabel.frame, 5, self.creatorLabel.frame.size);
    
    self.tagsLabel.text = [self stringForCategoriesLabelInLeague:league];
    CGSize tagsSize = CGSizeMake(self.tagsLabel.frame.size.width, [Utilities heightForString:[self stringForCategoriesLabelInLeague:league] withFont:self.tagsLabel.font width:self.tagsLabel.frame.size.width]);
    self.tagsLabel.frame = RectBelowRectWithSpacingAndSize(self.creatorLabel.frame, 5, tagsSize);
    
    self.privateLabel.hidden = ![league.priv boolValue];
}

-(NSString *)stringForCategoriesLabelInLeague:(League *)league{
    if (league.tags.count == 0) {
        return @"";
    }
    else{
        NSMutableString *tagsStr = [NSMutableString stringWithFormat:@"Categories: "];
        
        NSArray *tagsArray = [league.tags allObjects];
        for (int i=0; i<league.tags.count; i++) {
            Tag *tag = [tagsArray objectAtIndex:i];
            [tagsStr appendString:tag.name];
            if(i < league.tags.count-1) [tagsStr appendString:@", "];
        }
        
        return tagsStr;
    }
}

-(CGFloat)heightForCellWithLeague:(League *)league{
    CGFloat nameHeight = [Utilities heightForString:league.name withFont:self.nameLabel.font width:self.nameLabel.frame.size.width];
    CGFloat tagsHeight = [Utilities heightForString:[self stringForCategoriesLabelInLeague:league] withFont:self.tagsLabel.font width:self.tagsLabel.frame.size.width];
    
    CGFloat privPad = [league.priv boolValue] ? 24 : 0;
    
    return nameHeight + tagsHeight + privPad + 75;
}

@end
