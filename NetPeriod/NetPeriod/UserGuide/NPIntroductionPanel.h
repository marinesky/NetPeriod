//
//  NPIntroductionPanel.h
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-14.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPIntroductionPanel : NSObject

//Image
@property (nonatomic, retain) UIImage *Image;

//Title
@property (nonatomic, retain) NSString *Title;

//Description
@property (nonatomic, retain) NSString *Description;

//Custom init method
-(id)initWithimage:(UIImage *)image title:(NSString *)title description:(NSString *)description;
-(id)initWithimage:(UIImage *)image description:(NSString *)description;

@end
