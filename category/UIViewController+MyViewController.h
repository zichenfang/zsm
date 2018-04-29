//
//  UIViewController+MyViewController.h
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/20.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MyViewController)
//只有确定按钮
- (void)presentToastAlertWithTitle :(NSString *)title Handler :(void(^)(void))handler;
//包含确定和取消按钮
- (void)presentAlertWithTitle :(NSString *)title Handler :(void(^)(void))handler Cancel :(void(^)(void))cancel;
//包含红色的确认按钮和取消按钮
- (void)presentDestructiveAlertWithTitle :(NSString *)title Handler :(void(^)(void))handler;
@end
