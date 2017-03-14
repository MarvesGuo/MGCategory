//
//  NSDate+Common.h
//
//  Created by babytree on 17/2/20.
//  Copyright (c) 2017年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (Common) 


#pragma mark *** 基础方法 ***

- (NSUInteger)day;
- (NSInteger)weekday;               /* Sunday:1  Monday:2 */
- (NSUInteger)month;
- (NSUInteger)year;
- (NSUInteger)hour;
- (NSUInteger)minute;
- (NSUInteger)second;

- (BOOL)isSameDay:(NSDate *)anotherDate;
- (BOOL)isToday;
- (BOOL)isTomorrow;
- (BOOL)isYesterday;
- (BOOL)isInThisWeek;
- (BOOL)isInNextWeek;
- (BOOL)isInLastWeek;
- (BOOL)isInThisMonth;
- (BOOL)isInThisYear;

- (BOOL)isLeapYear;                 /* 是否是闰年 */
- (BOOL)isTypicallyWeekend;         /* 是否是休息日（周六、周天）*/
- (BOOL)isTypicallyWorkday;         /* 是否是工作日 */


- (NSUInteger)weekOfYear;           /* 第几周 */
- (NSUInteger)weeksInMonth;         /* 当前月一共有几周(可能为4,5,6) */
- (NSUInteger)daysToToday;          /* 距现在几天 */

+ (NSDate *)dateAtBeginOfToday;     /* 现在时间 00：00 */
- (NSDate *)dateAtBeginOfDay;       /* 指定时间 00：00 */
- (NSDate *)dateAtEndOfDay;         /* 指定时间 23：59 */

- (NSDate *)firstDayInYear;
- (NSDate *)firstDayInMonth;
- (NSDate *)lastDayInMonth;

- (NSString *)weekdayName;          /* 星期一、星期二。。。*/
- (NSString *)weekdayNameShort;     /* 一、二、。。。 */
+ (NSString *)monthNameWithMonthNumber:(NSInteger)month;

- (NSUInteger)daysInMonth:(NSUInteger)month;    /* 当前年份几月份的天数 */
- (NSUInteger)daysInCurrentMonth;               /* 当月天数 */

+ (NSDate *) currentDateWithSystemTimeZone;
+ (NSDate *) currentDateWithTimeZone:(NSTimeZone *)timezone;

- (NSDateComponents *)dateCompontentsWithYMDHMSWWFormat;

#pragma mark *** 日期增减 ***
/*
 *  以下方法返回计算后的 NSdate 对象，传入负数相当于之前的日期。
 */
- (NSDate *)dateByAddingYears: (NSInteger)numYears;
- (NSDate *)dateByAddingMonths: (NSInteger)numMonths;
- (NSDate *)dateByAddingDays: (NSInteger)numDays;
- (NSDate *)dateByAddingHours: (NSInteger)hours;
- (NSDate *)dateByAddingMinutes: (NSInteger)mins;
- (NSDate *)dateByAddingSeconds: (NSInteger)secs;


#pragma mark *** 格式化时间相关 ***

/*
 *  以下五个方法返回相对应的时间格式字符串
 */
+ (NSString *)ymdFormatString;          /* yyyy-MM-dd */
+ (NSString *)hmsFormatString;          /* HH:mm:ss */
+ (NSString *)hmFormatString;           /* HH:mm */
+ (NSString *)ymd_hmsFormatString;      /* yyyy-MM-dd HH:mm:ss */
+ (NSString *)ymd_hmFormatString;       /* yyyy-MM-dd HH:mm */

/*
 *  以下两个方法NSDate和NSString通用的转换方法
 */
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format;

- (NSString *)stringWithDateFormat:(NSString *)format;

/*
 *  以下五个方法返回展示用的字符串，例如： 刚刚 、x秒前、 x分钟前、 x小时前、x天前  如果大于两天的话就展示传入Format的格式（默认是 yyyy-MM-dd）
 */
+ (NSString *)formattedShowStringWithYMDString:(NSString *)dateString;
+ (NSString *)formattedShowStringWithDateFormat:(NSString *)dateFormat dateString:(NSString *)dateString;
+ (NSString *)formattedShowStringWithDateFormat:(NSString *)dateFormat dateString:(NSString *)dateString showFormat:(NSString *)showFormat;

- (NSString *)formattedShowString;
- (NSString *)formattedShowStringWithFormat:(NSString *)dateFormat;


/*
 *  以下三个方法直接返回对应格式的字符串
 */
- (NSString *)stringWithYMDFormat;          /* yyyy-MM-dd */
- (NSString *)stringWithYMDHMSSFormat;      /* yyyy-MM-dd'T'HH:mm:ss.SSS */
- (NSString *)stringWithISO8601Format;      /* yyyy-MM-dd'T'HH:mm:ssZZZZZ */


#pragma mark *** 农历日期 ***

- (NSDateComponents *)dateComponentsWithChineseFormat;

- (NSInteger)chineseYear;
- (NSInteger)chineseMonth;
- (NSInteger)chineseDay;

- (NSString *)chineseYearString;            /* 甲子、乙丑、丙寅。。。 */
- (NSString *)chineseMonthString;           /* 一月、腊月。。。 */
- (NSString *)chineseDayString;             /* 初一、廿二。。。 */


@end


