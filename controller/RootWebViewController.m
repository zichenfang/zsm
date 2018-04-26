//
//  RootWebViewController.m
//  Helper
//
//  Created by 方子辰 on 2018/4/9.
//  Copyright © 2018年 方子辰. All rights reserved.
//

#import "RootWebViewController.h"
#import <WebKit/WebKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "LoginViewController.h"
#import "JKEventHandler+FF.h"
#import "JKEventHandler.h"


@interface RootWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (strong, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation RootWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.preferences = [WKPreferences new];
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    WKUserScript *usrScript = [[WKUserScript alloc] initWithSource:[JKEventHandler shareInstance].handlerJS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    
    [config.userContentController addUserScript:usrScript];
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:[JKEventHandler shareInstance] name:EventHandler];

    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:config];
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://zsm.qingcangshu.cn"]]];
    
    
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
//    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//
//    NSLog(@"htmlString =%@",htmlString);
//    [self.webView loadHTMLString:htmlString baseURL:nil];
    
    
    
    [JKEventHandler getInject:self.webView];

}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"message =%@",message);
    NSLog(@"message.name =%@",message.name);
    NSLog(@"message.body =%@",message.body);
    NSLog(@"message.body.class =%@",[message.body class]);
    
    [self.view makeToast:[NSString stringWithFormat:@"方法名：%@,\n 参数:%@",message.name,message.body]];

    if ([message.name isEqualToString:@""]) {
    }

}


//alert 警告框
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    NSLog(@"alert message:%@",message);
}

#pragma mark - 注销用户
- (NSDictionary *)logOut{
//    [self presentAlertWithTitle:@"退出登录？" Handler:^{
//        //移除所有注册js方法
//        [self.webView.configuration.userContentController removeAllUserScripts];
//        [TTUserInfoManager setLogined:NO];
//        LoginViewController *mainVC = [[LoginViewController alloc] init];
//        [[UIApplication sharedApplication] keyWindow].rootViewController = mainVC;
//    } Cancel:nil];
    
    return @{@"name":@"Lucy"};
}
#pragma mark - 支付宝支付
- (void)aliPayToNative{
    [[AlipaySDK defaultService] payOrder:@"" fromScheme:@"alipayJtZsm" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
        //充值成功之后，需要重新获取一下积分信息才可以
        if ([resultStatus isEqualToString:@"9000"]) {
            //success
        }
        else{
            //FAILED
        }
    }];
}
#pragma mark - 支付宝支付
- (void)wechatPayToNative{
//    NSString *appid = [weixinPayInfo objectForKey:@"appid"];//
//    //需要动态注册app ID，因为微信商户不止一家
//    [WXApi registerApp:appid withDescription:appid];
//    PayReq* req             = [[PayReq alloc] init];
//    req.openID = [weixinPayInfo objectForKey:@"appid"];//        公众账号ID    ``appid    String(32)    是    wx8888888888888888    微信分配的公众账号ID
//    req.partnerId  =[weixinPayInfo objectForKey:@"partnerid"];//        商户号    ``partnerid    String(32)    是    1900000109    微信支付分配的商户号
//    req.prepayId  =[weixinPayInfo objectForKey:@"prepayid"];//        预支付交易会话ID    prepayid    String(32)    是    WX1217752501201407033233368018    微信返回的支付交易会话ID
//
//    req.package             = @"Sign=WXPay";//        扩展字段    ``package    String(128)    是    Sign=WXPay    暂填写固定值Sign=WXPay
//    req.nonceStr            = [weixinPayInfo objectForKey:@"noncestr"];//        随机字符串    ``noncestr    String(32)    是    5K8264ILTKCH16CQ2502SI8ZNMTM67VS    随机字符串，不长于32位。推荐随机数生成算法
//    req.timeStamp           = (int)[[weixinPayInfo objectForKey:@"timestamp"] intValue];//        时间戳    ``timestamp    String(10)    是    1412000000    时间戳，请见接口规则-参数规定
//    req.sign                = [weixinPayInfo objectForKey:@"sign"];//        签名    ``sign    String(32)    是    C380BEC2BFD727A4B6845133519F3AD6    签名，详见签名生成算法
//    [WXApi sendReq:req];

}
//MARK:---Native->JS---
- (void)callJsloginSuccess{
    
}
- (void)callJsAlipaySuccess{
    NSLog(@"%s",__func__);
}
- (void)callJsAlipayfail{
    NSLog(@"%s",__func__);
}

- (void)callJsWechatpaySuccess{
    NSLog(@"%s",__func__);
}
- (void)callJsWechatpayfail{
    NSLog(@"%s",__func__);
}

- (void)dealloc{
    
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:EventHandler];
    [self.webView evaluateJavaScript:@"JKEventHandler.removeAllCallBacks();" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        
        
    }];//删除所有的回调事件
    
}

@end
