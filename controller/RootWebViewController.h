//
//  RootWebViewController.h
//  Helper
//
//  Created by 方子辰 on 2018/4/9.
//  Copyright © 2018年 方子辰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTVenderHeader.h"

@interface RootWebViewController : UIViewController
- (void)callJsAlipaySuccess;
- (void)callJsAlipayfail;

- (void)callJsWechatpaySuccess;
- (void)callJsWechatpayfail;
@end
