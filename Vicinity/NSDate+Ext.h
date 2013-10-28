//
//  NSDate+Ext.h
//  
//
//  Created by Ben Ford on 3/1/12.
//  Copyright (c) 2012 Ben Ford All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Ext)
- (BOOL)extEarlierThanDate:(NSDate *)date;
- (BOOL)extEarlierThanOrEqualToDate:(NSDate *)date;

- (BOOL)extLaterThanDate:(NSDate *)date;
- (BOOL)extLaterThanOrEqualToDate:(NSDate *)date;

- (BOOL)extEqualToDate:(NSDate *)date;

- (BOOL)extHasExpired;

- (NSUInteger)extMonth;
- (NSUInteger)extDay;
- (NSUInteger)extYear;

+ (NSDate *)extDateWithMonth:(NSUInteger)month day:(NSUInteger)day year:(NSUInteger)year;

- (NSUInteger)extDaysInMonth;
- (NSUInteger)extWeekday;

+ (NSArray *)extGenerateMonthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (NSUInteger)extLastDayOfMonth;

- (NSDate *)extMakeNormalizedDateWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

+ (NSString *)extFormatDayNumber:(NSUInteger)dayNumber;
@end
