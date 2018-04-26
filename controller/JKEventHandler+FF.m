//
//  JKEventHandler+FF.m
//  臻饰美
//
//  Created by 方子辰 on 2018/4/26.
//  Copyright © 2018年 方子辰. All rights reserved.
//

#import "JKEventHandler+FF.h"
#import "TTVenderHeader.h"

@implementation JKEventHandler (FF)


- (void)getUserMobileInfo:(id)params :(void(^)(id response))callBack{
    NSLog(@"%s",__func__);
    if(callBack){
        NSString *phone = [TTUserInfoManager account];
        if (phone == nil) {
            phone  =@"";
        }
        NSString *token = [TTUserInfoManager password];
        if (token == nil) {
            token  =@"";
        }
        NSDictionary *dic = @{@"phone":phone,@"token":token};
        callBack(dic.json_String);
    }
    [[UIApplication sharedApplication].keyWindow makeToast:@"获取用户信息"];
}
- (void)setUserMobileInfo:(id)params :(void(^)(id response))callBack{
    NSLog(@"%s",__func__);
    NSLog(@"params %@",params);
    
    NSString *phone = [params objectForKey:@"phone"];
    NSString *token = [params objectForKey:@"token"];
    [TTUserInfoManager setAccount:phone];
    [TTUserInfoManager setPassword:token];
    NSString *toastStr = [NSString stringWithFormat:@"设置用户信息 %@",params];
    [[UIApplication sharedApplication].keyWindow makeToast:toastStr];
}
- (void)jumpToWechatPay:(id)params :(void(^)(id response))callBack{
    NSLog(@"%s",__func__);
    NSLog(@" %@",params);
    NSString *toastStr = [NSString stringWithFormat:@"跳转到支付 %@",params];
    [[UIApplication sharedApplication].keyWindow makeToast:toastStr];
}
- (void)share:(id)params :(void(^)(id response))callBack{
    NSLog(@"%s",__func__);
    NSLog(@" %@",params);
    NSString *toastStr = [NSString stringWithFormat:@"跳转到分享 %@",params];
    [[UIApplication sharedApplication].keyWindow makeToast:toastStr];
}
- (void)logOut:(id)params :(void(^)(id response))callBack{
    NSLog(@"%s",__func__);
    NSLog(@" %@",params);
    [[UIApplication sharedApplication].keyWindow makeToast:@"退出登录"];
    [TTUserInfoManager setAccount:@""];
    [TTUserInfoManager setPassword:@""];

}
@end
