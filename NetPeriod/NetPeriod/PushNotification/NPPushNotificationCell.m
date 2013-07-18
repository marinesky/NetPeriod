//
//  NPPushNotificationCell.m
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-18.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NPPushNotificationCell.h"

@implementation NPPushNotificationCell

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
	NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"NPPushNotificationCell" owner:nil options:nil];
	return [nibs objectAtIndex:0];
}

@end
