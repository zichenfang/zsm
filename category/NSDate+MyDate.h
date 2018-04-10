//
//  NSDate+MyDate.h
//  ttdoctor
//
//  Created by zichenfang on 16/3/15.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MyDate)
//转化成yyyy-MM-dd HH:mm:ss格式的时间
- (NSString *)formatTimeInyyyyMMddHHmmss;
//转化成yyyy-MM-dd 格式的时间
- (NSString *)formatTimeInyyyyMMdd;
//10分钟之前，1个小时之前这种时间
- (NSString *)roughTimeDes;
//零点
- (NSDate *)zeroDate;
//格式化时间为X天X小时X分钟
- (NSString *)day_hour_minute;
@end
