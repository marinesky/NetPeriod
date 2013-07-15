//
//  NPIntroductionView.h
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-14.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPIntroductionPanel.h"
#import <QuartzCore/QuartzCore.h>

typedef enum {
    NPFinishTypeSwipeOut = 0,
    NPFinishTypeSkipButton
}NPFinishType;

typedef enum {
    NPLanguageDirectionLeftToRight = 0,
    NPLanguageDirectionRightToLeft
}NPLanguageDirection;

/******************************/
//Delegate Method Declarations
/******************************/
@protocol NPIntroductionDelegate
@optional
-(void)introductionDidFinishWithType:(NPFinishType)finishType;
-(void)introductionDidChangeToPanel:(NPIntroductionPanel *)panel withIndex:(NSInteger)panelIndex;
@end


/******************************/
//NPIntroductionView
/******************************/
@interface NPIntroductionView : UIView <UIScrollViewDelegate>{
    
    //Array of panel objects passed in at initialization
    NSArray *Panels;
    
    //Array of views created by MYIntroductionController from MYIntroductionPanel objects. For internal use only.
    NSMutableArray *panelViews;
    
    //Keeps track of the index of the last panel navigated to. For internal use only.
    NSInteger LastPanelIndex;
    
    //Variable keeping track of language direction
    NPLanguageDirection LanguageDirection;
}


/******************************/
//Properties
/******************************/

//Delegate
@property (weak) id <NPIntroductionDelegate> delegate;

//Panel management
@property (nonatomic, assign) NSInteger CurrentPanelIndex;

//Intoduction Properties
@property (nonatomic, retain) UIImageView *BackgroundImageView;

//Header properties
@property (nonatomic, retain) UILabel *HeaderLabel;
@property (nonatomic, retain) UIImageView *HeaderImageView;
@property (nonatomic, retain) UIView *HeaderView;

//Content properties
@property (nonatomic, retain) UIScrollView *ContentScrollView;

//PageControl/Skip Button
@property (nonatomic, retain) UIPageControl *PageControl;
@property (nonatomic, retain) UIButton *SkipButton;


/******************************/
//Methods
/******************************/

//Custom Init Methods
- (id)initWithFrame:(CGRect)frame headerText:(NSString *)headerText panels:(NSArray *)panels;
- (id)initWithFrame:(CGRect)frame headerImage:(UIImage *)headerImage panels:(NSArray *)panels;
- (id)initWithFrame:(CGRect)frame headerText:(NSString *)headerText panels:(NSArray *)panels languageDirection:(NPLanguageDirection)languageDirection;
- (id)initWithFrame:(CGRect)frame headerImage:(UIImage *)headerImage panels:(NSArray *)panels languageDirection:(NPLanguageDirection)languageDirection;
- (id)initWithFrame:(CGRect)frame panels:(NSArray *)panels;
- (id)initWithFrame:(CGRect)frame panels:(NSArray *)panels languageDirection:(NPLanguageDirection)languageDirection;

//Header Content
-(void)setHeaderText:(NSString *)headerText;
-(void)setHeaderImage:(UIImage *)headerImage;

//Introduction Content
-(void)setBackgroundImage:(UIImage *)backgroundImage;

//Show/Hide
-(void)showInView:(UIView *)view;
-(void)hideWithFadeOutDuration:(CGFloat)duration;

@end
