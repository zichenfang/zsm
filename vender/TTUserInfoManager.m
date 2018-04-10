//
//  UserInfoManager.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//




#import "TTUserInfoManager.h"
#import "JsonKillNull.h"


NSString *const UserInfo = @"UserInfo_userinfo";
//是否启动过APP
NSString *const AppHasLaunched = @"AppHasLaunched";
//登录状态
NSString *const Logined = @"Logined";
//deivceToken
NSString *const deviceTokenKey = @"deviceToken";
//极光推送注册ID
NSString *const jpushRid = @"jpushRid";
//拒绝更新的版本号key
NSString *const USERDEFAULTS_KEY_REJECT_VERSION_UPDATE = @"userdefaults_004";



@interface TTUserInfoManager()
@property(nonatomic, strong)NSDictionary *userInfo;
@end
@implementation TTUserInfoManager


+ (TTUserInfoManager *)defaultManager {
    static TTUserInfoManager *manager = nil;
    if (!manager) {
        manager = [[TTUserInfoManager alloc] init];
        manager.userInfo =[[NSUserDefaults standardUserDefaults] objectForKey:UserInfo];

    }
    return manager;
}
#pragma mark -用户信息
//用户信息
- (void)setUserInfo:(NSDictionary *)userInfo
{
    if (userInfo) {
        [[NSUserDefaults standardUserDefaults] setObject:[userInfo noNullObject] forKey:UserInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _userInfo = userInfo;
    }
}

+ (void)setUserInfo:(NSDictionary *)userInfo
{
    [[TTUserInfoManager defaultManager]setUserInfo:userInfo];
}

+ (NSDictionary *)userInfo
{
    return [[TTUserInfoManager defaultManager] userInfo];
}

//用户账户
- (void)setAccount:(NSString *)account
{
    if (account!=nil) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:UserInfo]];
        [dic setObject:account forKey:@"account"];
        [TTUserInfoManager setUserInfo:dic];
    }
}
+ (void)setAccount:(NSString *)account
{
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)account
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"account"];
}
+ (NSString *)token
{
    return [[[TTUserInfoManager defaultManager] userInfo] string_ForKey:@"token"];
}
//用户密码
- (void)setPassword:(NSString *)password
{
    if (password!=nil) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:UserInfo]];
        [dic setObject:password forKey:@"password"];
        [TTUserInfoManager setUserInfo:dic];
    }
}
+ (void)setPassword:(NSString *)password
{
    [[TTUserInfoManager defaultManager]setPassword:password];
}
+ (NSString *)password
{
    return [[[TTUserInfoManager defaultManager] userInfo] string_ForKey:@"password"];
}
#pragma mark -系统信息
//系统是否第一次启动
+ (void)setAppHasLaunched:(BOOL)launched
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",launched] forKey:AppHasLaunched];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)appHasLaunched
{
    return [[[NSUserDefaults standardUserDefaults] stringForKey:AppHasLaunched] boolValue];
}

//登录状态
+ (void)setLogined:(BOOL)logined
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",logined] forKey:Logined];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)logined
{
    return [[[NSUserDefaults standardUserDefaults] stringForKey:Logined] boolValue];
}

//注册APNs通知token
+ (void)setAPNsDeviceToken:(NSString *)deviceToken{
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:deviceTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)deviceToken{
    return [[NSUserDefaults standardUserDefaults] stringForKey:deviceTokenKey];
}
//极光推送注册ID
+ (void)setJPUSHRegistID:(NSString *)rID{
    [[NSUserDefaults standardUserDefaults] setObject:rID forKey:jpushRid];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)jPushRegistID{
    return [[NSUserDefaults standardUserDefaults] stringForKey:jpushRid];
}
+ (void)setArea_name:(NSString *)area_name
{
    [[NSUserDefaults standardUserDefaults] setObject:area_name forKey:@"area_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)area_name
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"area_name"];
}

+ (void)setArea_id:(NSString *)area_id
{
    [[NSUserDefaults standardUserDefaults] setObject:area_id forKey:@"area_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)area_id
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"area_id"];
}
//    MARK:拒绝版本更新的版本号
+ (void)setRejectUpdateVersion:(NSString *)version
{
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:USERDEFAULTS_KEY_REJECT_VERSION_UPDATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)rejectUpdateVersion
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULTS_KEY_REJECT_VERSION_UPDATE];
}
@end
/*
 "available_predeposit" = "999999.00";
 "available_rc_balance" = "0.00";
 "customer_service_phone" = 40080088888;
 exp = 0;
 "freeze_predeposit" = "0.00";
 "freeze_rc_balance" = "0.00";
 "inform_allow" = 1;
 "inviter_id" = "<null>";
 "is_allowtalk" = 1;
 "is_buy" = 1;
 "member_areaid" = "<null>";
 "member_areainfo" = "<null>";
 "member_avatar" = "http://jingtushop.heizitech.com/data/upload/shop/common/default_user_portrait.gif";
 "member_birthday" = "<null>";
 "member_cityid" = "<null>";
 "member_email" = "";
 "member_email_bind" = 0;
 "member_exppoints" = 0;
 "member_gender" = "<null>";
 "member_id" = 15;
 "member_login_ip" = "49.223.185.19";
 "member_login_num" = 1;
 "member_login_time" = 1508419005;
 "member_lv" = 0;
 "member_lv_des" = "<null>";
 "member_mobile" = 18661801270;
 "member_mobile_bind" = 1;
 "member_name" = "186****1270";
 "member_old_login_ip" = "49.223.185.19";
 "member_old_login_time" = 1508419005;
 "member_passwd" = 96e79218965eb72c92a549dd5a330112;
 "member_paypwd" = 96e79218965eb72c92a549dd5a330112;
 "member_points" = 20;
 "member_privacy" = "<null>";
 "member_provinceid" = "<null>";
 "member_qq" = "<null>";
 "member_qqinfo" = "<null>";
 "member_qqopenid" = "<null>";
 "member_quicklink" = "<null>";
 "member_sex" = "<null>";
 "member_sinainfo" = "<null>";
 "member_sinaopenid" = "<null>";
 "member_snsvisitnum" = 0;
 "member_state" = 1;
 "member_time" = 1508419005;
 "member_truename" = "<null>";
 "member_ww" = "<null>";
 "rongyun_token" = "";
 token = 9d23fa1c642076440697170e95e277e4;
 "weixin_info" = "<null>";
 "weixin_unionid" = "<null>";
 
 */
