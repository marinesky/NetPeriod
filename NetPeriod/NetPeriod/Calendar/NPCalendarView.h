//
//  NPCalendarView.h
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-16.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

@protocol NPCalendarDelegate;

@interface NPDateItem : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@end

typedef enum {
    startSunday = 1,
    startMonday = 2,
} NPCalendarStartDay;

@interface NPCalendarView : UIView

- (id)initWithStartDay:(NPCalendarStartDay)firstDay;
- (id)initWithStartDay:(NPCalendarStartDay)firstDay frame:(CGRect)frame;

@property (nonatomic) NPCalendarStartDay calendarStartDay;
@property (nonatomic, strong) NSLocale *locale;

@property (nonatomic, readonly) NSArray *datesShowing;

@property (nonatomic) BOOL onlyShowCurrentMonth;
@property (nonatomic) BOOL adaptHeightToNumberOfWeeksInMonth;

@property (nonatomic, weak) id<NPCalendarDelegate> delegate;

// Theming
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *dateOfWeekFont;
@property (nonatomic, strong) UIColor *dayOfWeekTextColor;
@property (nonatomic, strong) UIFont *dateFont;

- (void)setMonthButtonColor:(UIColor *)color;
- (void)setInnerBorderColor:(UIColor *)color;
- (void)setDayOfWeekBottomColor:(UIColor *)bottomColor topColor:(UIColor *)topColor;

- (void)selectDate:(NSDate *)date makeVisible:(BOOL)visible;
- (void)reloadData;
- (void)reloadDates:(NSArray *)dates;

// Helper methods for delegates, etc.
- (BOOL)date:(NSDate *)date1 isSameDayAsDate:(NSDate *)date2;
- (BOOL)dateIsInCurrentMonth:(NSDate *)date;

@end

@protocol NPCalendarDelegate <NSObject>

@optional
- (void)calendar:(NPCalendarView *)calendar configureDateItem:(NPDateItem *)dateItem forDate:(NSDate *)date;
- (BOOL)calendar:(NPCalendarView *)calendar willSelectDate:(NSDate *)date;
- (void)calendar:(NPCalendarView *)calendar didSelectDate:(NSDate *)date;
- (BOOL)calendar:(NPCalendarView *)calendar willDeselectDate:(NSDate *)date;
- (void)calendar:(NPCalendarView *)calendar didDeselectDate:(NSDate *)date;

- (BOOL)calendar:(NPCalendarView *)calendar willChangeToMonth:(NSDate *)date;
- (void)calendar:(NPCalendarView *)calendar didChangeToMonth:(NSDate *)date;

- (void)calendar:(NPCalendarView *)calendar didLayoutInRect:(CGRect)frame;

@end