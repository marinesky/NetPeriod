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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (id)cellFromNib
{
	NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"NPMessageBoardViewCell" owner:nil options:nil];
	return [nibs objectAtIndex:0];
}

- (void)initCellWithTitle:(NSString *)aTitle date:(NSString *)aDate article:(NSString *)aArticle comment:(NSString *)comment
{
    
}
@end
