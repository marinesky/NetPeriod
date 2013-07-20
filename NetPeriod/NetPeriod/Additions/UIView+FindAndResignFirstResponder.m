//
//  UIView+FindAndResignFirstResponder.m
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-20.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "UIView+FindAndResignFirstResponder.h"

@implementation UIView (FindAndResignFirstResponder)

- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}
@end

