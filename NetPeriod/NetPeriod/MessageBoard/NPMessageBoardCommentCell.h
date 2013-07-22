//
//  NPMessageBoardCommentCell.h
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-19.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPMessageBoardCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

+ (id)cellFromNib;

@end
