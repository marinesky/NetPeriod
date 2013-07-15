//
//  NPIntroductionPanel.m
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-14.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NPIntroductionPanel.h"

@implementation NPIntroductionPanel

-(id)initWithimage:(UIImage *)image title:(NSString *)title description:(NSString *)description{
    if (self = [super init]) {
        //Set panel Image
        self.Image = [[UIImage alloc] init];
        self.Image = image;
        self.Title = title;
        
        //Set panel Description
        self.Description = [[NSString alloc] initWithString:description];
        
    }
    
    return self;
}

-(id)initWithimage:(UIImage *)image description:(NSString *)description{
    if (self = [super init]) {
        //Set panel Image
        self.Image = [[UIImage alloc] init];
        self.Image = image;
        self.Title = @"";
        
        //Set panel Description
        self.Description = [[NSString alloc] initWithString:description];
        
    }
    
    return self;
}

@end
