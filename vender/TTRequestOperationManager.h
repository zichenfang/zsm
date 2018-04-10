//
//  MyNetWork.h
//  DressIn3D
//
//  Created by Timo on 15/9/19.
//  Copyright (c) 2015年 Timo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "JsonKillNull.h"
//数据请求地址
#define kHTTP @"http://zsm.qingcangshu.cn/"

//MARK: ●IS_MD5
//#define IS_MD5  0

//MARK: ●登录
#define API_USER_LOGIN  @"api/user/login.jspx"

//MARK: ●发送短信验证码
#define API_USER_SEND_CODE  @"api/user/sendSms.jspx"



@interface TTRequestOperationManager : NSObject

+ (id)defaultManager;
//普通的POST传参方式
+ (void)POST:(NSString *)URLString Parameters:(NSMutableDictionary *)parameters Success:(void (^)(NSDictionary *responseJsonObject))mySuccess Failure:(void (^)(NSError *error))myFailure;
//get
+ (void)GET:(NSString *)URLString Parameters:(NSMutableDictionary *)parameters Success:(void (^)(NSDictionary *responseJsonObject))mySuccess Failure:(void (^)(NSError *error))myFailure;


//上传data的post方法
+ (void)POST:(NSString *)URLString parameters:(NSMutableDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block Success:(void (^)(NSDictionary *responseJsonObject))mySuccess Failure:(void (^)(NSError *error))myFailure;


@end
