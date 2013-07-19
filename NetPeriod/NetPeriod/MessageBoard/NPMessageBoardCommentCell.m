//
//  NPMessageBoardCommentCell.m
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-19.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NPMessageBoardCommentCell.h"

@implementation NPMessageBoardCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (id)cellFromNib
{
	NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"NPMessageBoardCommentCell" owner:nil options:nil];
	return [nibs objectAtIndex:0];
}
@end
