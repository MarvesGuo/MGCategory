//
//  NSDate+Common.m
//
//  Created by babytree on 17/2/20.
//  Copyright (c) 2017年 babytree. All rights reserved.
//

#import "NSDate+Common.h"


static NSDateFormatter *_sharedDateFormatter_commonCategory;

@implementation NSDate (Common)

+ (NSDateFormatter *)sharedDateFormatter_commonCategory {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDateFormatter_commonCategory = [[NSDateFormatter alloc] init];
    });
    return _sharedDateFormatter_commonCategory;
}


#pragma mark *** 基础方法 ***

/**
 *  返回日期对应的天数
 *
 */
- (NSUInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitDay) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:self];
#endif
    
    return [dayComponents day];
}

/**
 *  返回日期对应的星期   Sunday:1  Monday:2 。。。
 *
 */
- (NSInteger)weekday
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:self];
    NSInteger weekday = [comps weekday];
    
    return weekday;
}

/**
 *  返回日期对应的月份
 *
 */
- (NSUInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMonth) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:self];
#endif
    return [dayComponents month];
}

/**
 *  返回日期对应的年份
 *
 */
- (NSUInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitYear) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:self];
#endif
    return [dayComponents year];
}

/**
 *  返回日期对应的小时
 *
 */
- (NSUInteger)hour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitHour) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSHourCalendarUnit) fromDate:self];
#endif
    
    return [dayComponents hour];
}

/**
 *  返回日期对应的分钟
 *
 */
- (NSUInteger)minute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMinute) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSMinuteCalendarUnit) fromDate:self];
#endif
    
    return [dayComponents minute];
}

/**
 *  返回日期对应的秒数
 *
 */
- (NSUInteger)second;
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitSecond) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSSecondCalendarUnit) fromDate:self];
#endif
    return [dayComponents second];
}


/**
 *  日期是否相等
 *
 */
- (BOOL)isSameDay:(NSDate *)anotherDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [calendar components:(NSCalendarUnitYear
                                                          | NSCalendarUnitMonth
                                                          | NSCalendarUnitDay)
                                                fromDate:self];
    NSDateComponents *components2 = [calendar components:(NSCalendarUnitYear
                                                          | NSCalendarUnitMonth
                                                          | NSCalendarUnitDay)
                                                fromDate:anotherDate];
    return ([components1 year] == [components2 year]
            && [components1 month] == [components2 month]
            && [components1 day] == [components2 day]);
}


/**
 *  是否是今天
 *
 */
- (BOOL)isToday
{
    return [self isSameDay:[NSDate date]];
}

/**
 *  是否是明天
 *
 */
- (BOOL)isTomorrow
{
    return [self isSameDay:[[NSDate date] dateByAddingDays: 1]];
}

/**
 *  是否是昨天
 *
 */
- (BOOL)isYesterday
{
    return [self isSameDay:[[NSDate date] dateByAddingDays: -1]];
}

/**
 *  是否在本周
 *
 */
- (BOOL)isInThisWeek
{
    return [self weekOfYear] == [[NSDate date] weekOfYear];
}

/**
 *  是否在下周
 *
 */
- (BOOL)isInNextWeek
{
    return [self weekOfYear] == ([[NSDate date] weekOfYear] + 1);
}

/**
 *  是否在上周
 *
 */
- (BOOL)isInLastWeek
{
    return [self weekOfYear] == ([[NSDate date] weekOfYear] - 1);
}

/**
 *  是否在本月
 *
 */
- (BOOL)isInThisMonth
{
    return [self month] == [[NSDate date] month];
}

/**
 *  是否在今年
 *
 */
- (BOOL)isInThisYear
{
    return [self year] == [[NSDate date] year];
}


/**
 *  是否在闰年
 *
 */
- (BOOL)isLeapYear
{
    NSUInteger year = [self year];
    if ((year % 4  == 0 && year % 100 != 0) || year % 400 == 0)
    {
        return YES;
    }
    return NO;
}

/**
 *  是否是休息日（周六、周天）
 *
 */
- (BOOL)isTypicallyWeekend
{
    return [self weekday] == 7 || [self weekday] == 1;
}

/**
 *  是否是工作日
 *
 */
- (BOOL)isTypicallyWorkday
{
    return ![self isTypicallyWeekend];
}

/**
 * 获取该日期是该年的第几周
 *
 */
- (NSUInteger)weekOfYear    //FIXME: 虔灵 待优化
{
    NSUInteger i;
    NSUInteger year = [self year];
    NSDate *lastdate = [self lastDayInMonth];
    
    for (i = 1;[[lastdate dateByAddingDays:-7 * i] year] == year; i++) {
        
    }
    return i;
}

/**
 * 返回当前月一共有几周(可能为4,5,6)
 *
 */
- (NSUInteger)weeksInMonth
{
    return [[self lastDayInMonth] weekOfYear] - [[self firstDayInMonth] weekOfYear] + 1;
}

/**
 * 距离现在时间有几天
 *
 */
- (NSUInteger)daysToToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
#else
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
#endif
    return [components day];
}

/**
 * 今天00：00
 *
 */
+ (NSDate *)dateAtBeginOfToday
{
    return [[NSDate date] dateAtBeginOfDay];
}

/**
 * 当天00：00
 *
 */
- (NSDate *)dateAtBeginOfDay;       // 指定时间 00：00
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    return [[NSCalendar currentCalendar] startOfDayForDate:self];
#else
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
#endif
}

/**
 * 当天23：59
 *
 */
- (NSDate *)dateAtEndOfDay         // 指定时间 23：59: 59
{
    NSDate *tomorrow = [self dateByAddingDays:1];
    NSDate *tomorrowStartDate = [tomorrow dateAtBeginOfDay];
    NSTimeInterval ts = [tomorrowStartDate timeIntervalSince1970];
    ts -= 1;
    return [NSDate dateWithTimeIntervalSince1970:ts];
}

/**
 * 该年第一天
 *
 */
- (NSDate *)firstDayInYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:[self year]];
    NSDate *beginOfYear = [calendar dateFromComponents:components];
    return beginOfYear;
}

/**
 * 该月第一天
 *
 */
- (NSDate *)firstDayInMonth    // 该月的第一天的日期
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *firstDateCpt = [self dateCompontentsWithYMDHMSWWFormat];
    firstDateCpt.day = 1;
    NSDate *firstDate = [gregorianCalendar dateFromComponents:firstDateCpt];
    return firstDate;
}

/**
 * 该月最后一天
 *
 */
- (NSDate *)lastDayInMonth     // 该月的最后一天的日期
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastDateCpt = [self dateCompontentsWithYMDHMSWWFormat];
    NSInteger month = lastDateCpt.month;
    NSInteger year = lastDateCpt.year;
    if (month==12) {
        month = 1;
        year += 1;
    }else{
        month += 1;
    }
    lastDateCpt.year = year;
    lastDateCpt.month = month;
    lastDateCpt.day = 1;
    NSDate *limitDate = [gregorianCalendar dateFromComponents:lastDateCpt];
    NSInteger daySeconds = 24*60*60;
    limitDate = [limitDate dateByAddingTimeInterval:-1*daySeconds];
    return limitDate;
}

/**
 * 星期几
 *
 */
- (NSString *)weekdayName
{
    switch ([self weekday]) {
        case 1:
            return @"星期天";
        case 2:
            return @"星期一";
        case 3:
            return @"星期二";
        case 4:
            return @"星期三";
        case 5:
            return @"星期四";
        case 6:
            return @"星期五";
        case 7:
            return @"星期六";
        default:
            return @"";
    }
}

/**
 * 星期几（缩写）
 *
 */
- (NSString *)weekdayNameShort
{
    switch ([self weekday]) {
        case 1:
            return @"日";
        case 2:
            return @"一";
        case 3:
            return @"二";
        case 4:
            return @"三";
        case 5:
            return @"四";
        case 6:
            return @"五";
        case 7:
            return @"六";
        default:
            return @"";
    }
}

/**
 * 月份
 *
 */
+ (NSString *)monthNameWithMonthNumber:(NSInteger)month
{
    switch(month) {
        case 1:
            return @"一月";
            break;
        case 2:
            return @"二月";
            break;
        case 3:
            return @"三月";
            break;
        case 4:
            return @"四月";
            break;
        case 5:
            return @"五月";
            break;
        case 6:
            return @"六月";
            break;
        case 7:
            return @"七月";
            break;
        case 8:
            return @"八月";
            break;
        case 9:
            return @"九月";
            break;
        case 10:
            return @"十月";
            break;
        case 11:
            return @"十一月";
            break;
        case 12:
            return @"十二月";
            break;
        default:
            break;
    }
    return @"";
}

/**
 * 当年几月的天数 区分闰年
 *
 */
- (NSUInteger)daysInMonth:(NSUInteger)month
{
    switch (month) {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            return 31;
        case 2:
            return [self isLeapYear] ? 29 : 28;
    }
    return 30;
}

/**
 * 当月的天数
 *
 */
- (NSUInteger)daysInCurrentMonth             //当月
{
    return [self daysInMonth:[self month]];
}

/**
 * 系统时区的当前时间
 *
 */
+ (NSDate *) currentDateWithSystemTimeZone
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
#ifdef DEBUG
    NSLog(@"%@", localeDate);
#endif
    return localeDate;
}

/**
 * 指定时区的当前时间
 *
 */
+ (NSDate *) currentDateWithTimeZone:(NSTimeZone *)timezone
{
    NSDate *date = [NSDate date];
    NSInteger interval = [timezone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
#ifdef DEBUG
    NSLog(@"%@", localeDate);
#endif
    return localeDate;
}

/**
 * NSDateComponents 含 year、month、day、hour、minute、second、weekday、weekOfMonth units。
 *
 */
- (NSDateComponents *)dateCompontentsWithYMDHMSWWFormat
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorianCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:self];
    return dateComponents;
}

#pragma mark *** 日期增减 ***

- (NSDate *)dateByAddingYears: (NSInteger)numYears
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:numYears];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self
                                     options:0];
}

- (NSDate *)dateByAddingMonths: (NSInteger)numMonths
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:numMonths];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self
                                     options:0];
}

- (NSDate *)dateByAddingDays: (NSInteger)numDays
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self
                                     options:0];
}

- (NSDate *)dateByAddingHours: (NSInteger)hours
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour:hours];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self
                                     options:0];
}

- (NSDate *)dateByAddingMinutes: (NSInteger)mins
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMinute:mins];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self
                                     options:0];
}

- (NSDate *)dateByAddingSeconds: (NSInteger)secs
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setSecond:secs];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self
                                     options:0];
}


#pragma mark *** 格式化时间相关 ***
/**
 * 格式：yyyy-MM-dd
 *
 */
+ (NSString *)ymdFormatString
{
    return @"yyyy-MM-dd";
}

/**
 * 格式：HH:mm:ss
 *
 */
+ (NSString *)hmsFormatString
{
    return @"HH:mm:ss";
}

/**
 * 格式：HH:mm
 *
 */
+ (NSString *)hmFormatString
{
    return @"HH:mm";
}

/**
 * 格式：yyyy-MM-dd HH:mm:ss
 *
 */
+ (NSString *)ymd_hmsFormatString
{
    return [NSString stringWithFormat:@"%@ %@", [self ymdFormatString], [self hmsFormatString]];
}

/**
 * 格式：yyyy-MM-dd HH:mm
 *
 */
+ (NSString *)ymd_hmFormatString
{
    return [NSString stringWithFormat:@"%@ %@", [self ymdFormatString], [self hmFormatString]];
}

/**
 * 根据指定格式的字符串返回Date
 *
 */
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [NSDate sharedDateFormatter_commonCategory];
    [dateFormatter setDateFormat: format];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

/**
 * 返回规定格式的字符串
 *
 */
- (NSString *)stringWithDateFormat:(NSString *)format
{
    NSDateFormatter *outputFormatter = [NSDate sharedDateFormatter_commonCategory];
    [outputFormatter setDateFormat:format];
    NSString *rstStr = [outputFormatter stringFromDate:self];
    return rstStr;
}

/**
 * 返回规定格式的字符串： 刚刚 、x秒前、 x分钟前、 x小时前、x天前  如果大于两天的话就展示 yyyy-MM-dd
 *
 */
+ (NSString *)formattedShowStringWithYMDString:(NSString *)dateString
{
    return [self formattedShowStringWithDateFormat:[self ymdFormatString] dateString:dateString];
}

/**
 * 返回规定格式的字符串： 刚刚 、x秒前、 x分钟前、 x小时前、x天前  如果大于两天的话就展示 yyyy-MM-dd
 *
 */
+ (NSString *)formattedShowStringWithDateFormat:(NSString *)dateFormat dateString:(NSString *)dateString
{
    NSDate *date = [NSDate dateFromString:dateString withFormat:dateFormat];
    return  [date formattedShowString];
}

/**
 * 返回规定格式的字符串： 刚刚 、x秒前、 x分钟前、 x小时前、x天前  如果大于两天的话就展示 showFormat
 *
 */
+ (NSString *)formattedShowStringWithDateFormat:(NSString *)dateFormat dateString:(NSString *)dateString showFormat:(NSString *)showFormat
{
    NSDate *date = [NSDate dateFromString:dateString withFormat:dateFormat];
    return  [date formattedShowStringWithFormat:showFormat];
}

/**
 * 返回规定格式的字符串： 刚刚 、x秒前、 x分钟前、 x小时前、x天前  如果大于两天的话就展示 yyyy-MM-dd
 *
 */
- (NSString *)formattedShowString
{
    return [self formattedShowStringWithFormat:[NSDate ymdFormatString]];
}

/**
 * 返回规定格式的字符串： 刚刚 、x秒前、 x分钟前、 x小时前、x天前  如果大于两天的话就展示 dateFormat
 *
 */
- (NSString *)formattedShowStringWithFormat:(NSString *)dateFormat
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeStamp = [self timeIntervalSince1970];
    NSInteger past = now - timeStamp;
    if (past <= 0)
    {
        return @"刚刚";
    }
    else if (past < 60)
    {
        return [NSString stringWithFormat:@"%ld秒前", (long)past];
    }
    else if(past < 3600)
    {
        NSInteger min = past / 60;
        return [NSString stringWithFormat:@"%ld分钟前", (long)min];
    }
    else if (past < 86400)
    {
        NSInteger hour = past / 3600;
        return [NSString stringWithFormat:@"%ld小时前", (long)hour];
    }
    else if (past < 86400 * 2)
    {
        NSInteger day = past / 86400;
        return [NSString stringWithFormat:@"%ld天前", (long)day];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *dateFormatter = [NSDate sharedDateFormatter_commonCategory];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:date];
}

/**
 * 返回 yyyy-MM-dd 格式的字符串
 *
 */
- (NSString *)stringWithYMDFormat
{
    return [self stringWithDateFormat:[NSDate ymdFormatString]];
}

/**
 * 返回  yyyy-MM-dd'T'HH:mm:ss.SSS 格式的字符串
 *
 */
- (NSString *)stringWithYMDHMSSFormat
{
    return [self stringWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
}

/**
 * 返回  ISO8601 标准的字符串 （yyyy-MM-dd'T'HH:mm:ssZZZZZ）
 *
 */
- (NSString *)stringWithISO8601Format
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_10_0
    NSISO8601DateFormatter *iso8601formatter = [NSISO8601DateFormatter new];
    return [iso8601formatter stringFromDate:self];
#else
    return [self stringWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
#endif
}


#pragma mark *** 农历日期 ***

- (NSDateComponents *)dateComponentsWithChineseFormat
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *dateCpt = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:self];
    return dateCpt;
    
}

- (NSInteger)chineseYear;
{
    return [self dateComponentsWithChineseFormat].year;
}

- (NSInteger)chineseMonth;
{
    return [self dateComponentsWithChineseFormat].month;
}

- (NSInteger)chineseDay;
{
    return [self dateComponentsWithChineseFormat].day;
}

/**
 * 甲子、乙丑、丙寅。。。。
 *
 */
- (NSString *)chineseYearString
{
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSInteger year = [self chineseYear];
    NSString *yearString = [chineseYears objectAtIndex:year-1];
    return yearString;
    
}

/**
 * 一月、腊月。。。
 *
 */
- (NSString *)chineseMonthString
{
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    NSInteger month = [self chineseMonth];
    NSString *monthString = [chineseMonths objectAtIndex:month-1];
    return monthString;
}

/**
 * 初一、廿二、。。。。
 *
 */
- (NSString *)chineseDayString;
{
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    NSInteger day = [self chineseDay];
    NSString *dayString = [chineseDays objectAtIndex:day-1];
    return dayString;
}


@end






