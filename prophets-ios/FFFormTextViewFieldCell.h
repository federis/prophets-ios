//
//  FFFormTextViewCell.h
//  prophets-ios
//
//  Created by Benjamin Roesch on 11/12/12.
//  Copyright (c) 2012 Benjamin Roesch. All rights reserved.
//

#import "FFFormFieldCell.h"

@interface FFFormTextViewFieldCell : FFFormFieldCell<UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;

@end
