//
//  NSString+MyCustomString.h
//  DressIn3D
//
//  Created by Timo on 15/10/9.
//  Copyright © 2015年 Timo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (MyCustomString)
//去掉空格
- (NSString *)absoluteString;
- (NSString *)absolute_String;

//32位MD5加密方式,并且返回大写
- (NSString *)md5_32Bit_String;
//只有数字的字符串
- (NSString *)onlyIntegerString;
//转化成汉语拼音
- (NSString *)pinyinString;
//转化字成典
- (NSDictionary *)dictionary;

//随机字符串
+(NSString *)random32bitString;
- (CGFloat)heightWithFont:(UIFont *)font Width :(float)width;
- (CGFloat)heightWithFont:(UIFont *)font LineSpacing :(float )lineSpacing Width :(float)width;

- (CGFloat)widthWithFont:(UIFont *)font Height :(float)height;



- (BOOL)isValidateEmail:(NSString *)email;
- (BOOL)isValidateMobile;


- (BOOL)isValidateQQ:(NSString *)QQ;
+ (NSString *)localIP;

//获得设备型号
+ (NSString *)getCurrentDeviceModel;

//普通字符串转换为base64
- (NSString *)normalToBase64Str;
//baee64转化为普通字符串
- (NSString *)base64ToNormalStr;
//过滤掉emoji表情
- (NSString *)killEmoji;
@end
