//
//  JKEventHandler+FF.h
//  臻饰美
//
//  Created by 方子辰 on 2018/4/26.
//  Copyright © 2018年 方子辰. All rights reserved.
//

#import "JKEventHandler.h"

@interface JKEventHandler (FF)

- (void)getUserMobileInfo:(id)params :(void(^)(id response))callBack;
- (void)setUserMobileInfo:(id)params :(void(^)(id response))callBack;

- (void)jumpToWechatPay:(id)params :(void(^)(id response))callBack;
- (void)share:(id)params :(void(^)(id response))callBack;
- (void)logOut:(id)params :(void(^)(id response))callBack;


@end
