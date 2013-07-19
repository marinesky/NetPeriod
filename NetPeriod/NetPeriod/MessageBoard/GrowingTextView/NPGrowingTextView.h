//
//  NPTextView.h
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-19.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NPGrowingTextView;
@class NPTextViewInternal;

@protocol NPGrowingTextViewDelegate

@optional
- (BOOL)growingTextViewShouldBeginEditing:(NPGrowingTextView *)growingTextView;
- (BOOL)growingTextViewShouldEndEditing:(NPGrowingTextView *)growingTextView;

- (void)growingTextViewDidBeginEditing:(NPGrowingTextView *)growingTextView;
- (void)growingTextViewDidEndEditing:(NPGrowingTextView *)growingTextView;

- (BOOL)growingTextView:(NPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)growingTextViewDidChange:(NPGrowingTextView *)growingTextView;

- (void)growingTextView:(NPGrowingTextView *)growingTextView willChangeHeight:(float)height;
- (void)growingTextView:(NPGrowingTextView *)growingTextView didChangeHeight:(float)height;

- (void)growingTextViewDidChangeSelection:(NPGrowingTextView *)growingTextView;
- (BOOL)growingTextViewShouldReturn:(NPGrowingTextView *)growingTextView;
@end

@interface NPGrowingTextView : UIView <UITextViewDelegate> {
	NPTextViewInternal *internalTextView;	
	
	int minHeight;
	int maxHeight;
	
	//class properties
	int maxNumberOfLines;
	int minNumberOfLines;
	
	BOOL animateHeightChange;
    NSTimeInterval animationDuration;
	
	//uitextview properties
	NSObject <NPGrowingTextViewDelegate> *__unsafe_unretained delegate;
	UITextAlignment textAlignment; 
	NSRange selectedRange;
	BOOL editable;
	UIDataDetectorTypes dataDetectorTypes;
	UIReturnKeyType returnKeyType;
    
    UIEdgeInsets contentInset;
}

//real class properties
@property int maxNumberOfLines;
@property int minNumberOfLines;
@property (nonatomic) int maxHeight;
@property (nonatomic) int minHeight;
@property BOOL animateHeightChange;
@property NSTimeInterval animationDuration;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UITextView *internalTextView;	


//uitextview properties
@property(unsafe_unretained) NSObject<NPGrowingTextViewDelegate> *delegate;
@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) UIFont *font;
@property(nonatomic,strong) UIColor *textColor;
@property(nonatomic) UITextAlignment textAlignment;    // default is UITextAlignmentLeft
@property(nonatomic) NSRange selectedRange;            // only ranges of length 0 are supported
@property(nonatomic,getter=isEditable) BOOL editable;
@property(nonatomic) UIDataDetectorTypes dataDetectorTypes __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_3_0);
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (assign) UIEdgeInsets contentInset;
@property(nonatomic) BOOL enablesReturnKeyAutomatically;

//uitextview methods
//need others? use .internalTextView
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
- (BOOL)isFirstResponder;

- (BOOL)hasText;
- (void)scrollRangeToVisible:(NSRange)range;

// call to force a height change (e.g. after you change max/min lines)
- (void)refreshHeight;

@end
