//
//  NPMessageBoardView.h
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-15.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPMessageBoardViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;


+ (id)cellFromNib;
- (void)initCellWithTitle:(NSString *)aTitle date:(NSString *)aDate article:(NSString *)aArticle comment:(NSString *)comment;

@end
