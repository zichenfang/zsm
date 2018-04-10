//
//  UIColor+MyColor.h
//  ttdoctor
//
//  Created by zichenfang on 16/3/15.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MyColor)
//#FFFFFF格式的颜色转换为UIColor
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (UIColor *)stylePinkColor;
+ (UIColor *)styleYellowColor;


@end
