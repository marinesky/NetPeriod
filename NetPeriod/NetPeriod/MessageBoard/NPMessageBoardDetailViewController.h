//
//  NPMessageBoardDetailViewController.h
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-18.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPGrowingTextView.h"
#import "NPArticle.h"

@interface NPMessageBoardDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NPGrowingTextViewDelegate>

@property (retain, nonatomic) NPArticle *article;

@end
