//
//  NPMessageBoardView.m
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-15.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NPMessageBoardViewCell.h"

@implementation NPMessageBoardViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)cellFromNib
{
	NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"NPMessageBoardViewCell" owner:nil options:nil];
	return [nibs objectAtIndex:0];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
