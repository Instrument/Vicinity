//
//  NSDate+Ext.m
//  
//
//  Created by Ben Ford on 3/1/12.
//  Copyright (c) 2012 Ben Ford All rights reserved.
//

#import "NSDate+Ext.h"

@implementation NSDate(Ext)
+ (NSDate *)extDateWithMonth:(NSUInteger)month day:(NSUInteger)day year:(NSUInteger)year {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = day;
    components.month = month;
    components.year = year;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (BOOL)extEarlierThanDate:(NSDate *)date {
    return [self timeIntervalSinceDate:date] < 0;
}

- (BOOL)extEarlierThanOrEqualToDate:(NSDate *)date {
    return [self timeIntervalSinceDate:date] < 0;
}

- (BOOL)extLaterThanDate:(NSDate *)date {
    return [self timeIntervalSinceDate:date] > 0;    
}

- (BOOL)extLaterThanOrEqualToDate:(NSDate *)date {
    return [self timeIntervalSinceDate:date] >= 0;    
}

- (BOOL)extEqualToDate:(NSDate *)date {
    return [self timeIntervalSinceDate:date] == 0;
}

- (BOOL)extHasExpired {
    return [self extEarlierThanDate:[NSDate date]];
}

- (NSUInteger)extMonth {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self];
    return components.month;
}

- (NSUInteger)extDay {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self];
    return components.day;
}

- (NSUInteger)extYear {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];
    return components.year;
}

- (NSUInteger)extDaysInMonth {
    NSRange days = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                                      inUnit:NSMonthCalendarUnit
                                                     forDate:self];

    return days.length;
}

- (NSUInteger)extWeekday {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
    return components.weekday;
}

+ (NSArray *)extGenerateMonthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSMutableArray *months = [[NSMutableArray alloc] init];
    [months addObject:fromDate];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:1];
    
    while( [[months lastObject] extMonth] != [toDate extMonth] || [[months lastObject] extYear] != [toDate extYear] ) {
        
        NSDate *nextMonth = [gregorian dateByAddingComponents:offsetComponents toDate:[months lastObject] options:0];
        [months addObject:nextMonth];
    }
    
    return months;
}

- (NSUInteger)extLastDayOfMonth {
    NSRange daysRange = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    
    return daysRange.length;
}

- (NSDate *)extMakeNormalizedDateWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSDate *normalizedDate = self;
    
    if( [self extEarlierThanDate:startDate] )
        normalizedDate = startDate;
    if( [self extLaterThanDate:endDate] )
        normalizedDate = endDate;
    
    return normalizedDate;
        
}

+ (NSString *)extFormatDayNumber:(NSUInteger)originalDayNumber {
    NSUInteger dayNumber;
    if (originalDayNumber > 20) {
        //look at last digit (i.e., the 2 in "22" = 22nd)
        NSString *dayString = [NSString stringWithFormat:@"%lu", (unsigned long)originalDayNumber];
        dayString = [dayString substringFromIndex:dayString.length-1];
        dayNumber = [dayString integerValue];
    }
    else {
        dayNumber = originalDayNumber;
    }
    
    NSString *postfix;
    if( dayNumber == 1 )
        postfix = @"st";
    else if( dayNumber == 2 )
        postfix = @"nd";
    else if( dayNumber == 3 )
        postfix = @"rd";
    else if( dayNumber >= 4 )
        postfix = @"th";
    
    // special case for 21,31,41 etc..
    if( (dayNumber - 1) % 10 == 0 && originalDayNumber > 11 )
        postfix = @"st";
    else if (originalDayNumber == 11 || originalDayNumber == 30)
        postfix = @"th";
    
    return [NSString stringWithFormat:@"%lu%@", (unsigned long)originalDayNumber, postfix];
}
@end
