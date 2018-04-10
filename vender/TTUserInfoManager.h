//
//  UserInfoManager.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TTUserInfoManager : NSObject


//执行该方法的时候，会发送通知kNoti_userStatsChanged
+ (void)setUserInfo:(NSDictionary *)userInfo;
+ (NSDictionary *)userInfo;

+ (NSString *)token;


+ (void)setAccount:(NSString *)account;
+ (NSString *)account;

+ (void)setPassword:(NSString *)password;
+ (NSString *)password;

//系统是否第一次启动
+ (void)setAppHasLaunched:(BOOL)launched;
+ (BOOL)appHasLaunched;

//登录状态
+ (void)setLogined:(BOOL)logined;
+ (BOOL)logined;

//注册APNs通知token
+ (void)setAPNsDeviceToken:(NSString *)deviceToken;
+ (NSString *)deviceToken;
//极光推送注册ID
+ (void)setJPUSHRegistID:(NSString *)rID;
+ (NSString *)jPushRegistID;
//地区
+ (void)setArea_name:(NSString *)area_name;
+ (NSString *)area_name;

+ (void)setArea_id:(NSString *)area_id;
+ (NSString *)area_id;
//MARK:拒绝版本更新的版本号
+ (void)setRejectUpdateVersion:(NSString *)version;
+ (NSString *)rejectUpdateVersion;

@end
/*
 result =     {
 id = 1;
 "integral_balance" = 0;
 "integral_cost" = 0;
 "integral_freeze" = 0;
 "integral_get" = 0;
 "integral_recharge" = 0;
 "integral_withdraw" = 0;
 "integral_withdraw_balance" = 0;
 introduction = "<null>";
 name = "\U674e\U4e8c\U72d7\U9970\U54c1\U6279\U53d1\U4ee3\U7406\U5546";
 token = 6eb8c56a1800fe9c5175a05af8c657e3;
 };
 */
