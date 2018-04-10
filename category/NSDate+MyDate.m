//
//  NSDate+MyDate.m
//  ttdoctor
//
//  Created by zichenfang on 16/3/15.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "NSDate+MyDate.h"

@implementation NSDate (MyDate)


- (NSString *)formatTimeInyyyyMMddHHmmss
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    NSString * str = [formatter stringFromDate:self];
    return str;
}
//转化成yyyy-MM-dd 格式的时间
- (NSString *)formatTimeInyyyyMMdd
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    NSString * str = [formatter stringFromDate:self];
    return str;
}
- (NSString *)roughTimeDes
{
    long long timeValue = [[NSDate date] timeIntervalSince1970] -[self timeIntervalSince1970];
    NSString *tailDes = @"前";
    if (timeValue<0) {
        tailDes = @"后";
    }
    NSString *headDes;
    timeValue = llabs(timeValue);
    if (timeValue<60)//一分钟之内
    {
        headDes = [NSString stringWithFormat:@"%lld秒",timeValue];
    }
    else if (timeValue<60*60)//一个小时之内
    {
        headDes = [NSString stringWithFormat:@"%lld分钟",timeValue/60];
    }
    else if (timeValue<60*60*24)//一天之内
    {
        headDes = [NSString stringWithFormat:@"%lld小时",timeValue/60/60];
    }
    else if (timeValue<60*60*24*3)//3天之内
    {
        headDes = [NSString stringWithFormat:@"%lld天",timeValue/60/60/24];
    }
    else
    {
        return [self formatTimeInyyyyMMdd];
    }
    return [NSString stringWithFormat:@"%@%@",headDes,tailDes];
}
//零点
- (NSDate *)zeroDate{
    NSDate *startOfToday = [[NSCalendar currentCalendar] startOfDayForDate:self];
    return startOfToday;
}
//格式化时间为X天X小时X分钟
- (NSString *)day_hour_minute{
    long long timeValue = [self timeIntervalSince1970] -[[NSDate date] timeIntervalSince1970];
    if (timeValue<=0) {
        return @"0天0小时0分钟";
    }
    long long  day , hour , minute;
    day = timeValue/(24*60*60);
    hour = timeValue%(24*60*60)/(60*60);
    minute = timeValue%(60*60)/60;
    return [NSString stringWithFormat:@"%lld天%lld小时%lld分钟",day,hour,minute];
}
@end
