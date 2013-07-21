//
//  MYUiTextField.m
//  NetPeriod
//
//  Created by Ye Xianjin on 7/21/13.
//  Copyright (c) 2013 NetEase. All rights reserved.
//

#import "MYUiTextField.h"

@implementation MYUiTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (CGRect)textRectForBounds:(CGRect)bounds {
    int margin = 60;
    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - margin, bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    int margin = 60;
    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - margin, bounds.size.height);
    return inset;
}
@end
