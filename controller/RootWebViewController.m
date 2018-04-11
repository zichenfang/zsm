//
//  RootWebViewController.m
//  Helper
//
//  Created by 方子辰 on 2018/4/9.
//  Copyright © 2018年 方子辰. All rights reserved.
//

#import "RootWebViewController.h"
#import <WebKit/WebKit.h>
#import "LoginViewController.h"

NSString *jsLoginOut = @"logOut";
NSString *jsShare = @"share";
NSString *jsPay = @"pay";


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
    config.userContentController = [[WKUserContentController alloc] init];
    /*加入监听js方法*/
    [config.userContentController addScriptMessageHandler:self name:jsLoginOut];
    [config.userContentController addScriptMessageHandler:self name:jsShare];
    [config.userContentController addScriptMessageHandler:self name:jsPay];

    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:config];
//    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];

//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://zsm.qingcangshu.cn"]]];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];

    NSLog(@"htmlString =%@",htmlString);
    [self.webView loadHTMLString:htmlString baseURL:nil];

}
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:jsLoginOut]) {
        [self loginOut];
    }
    else if ([message.name isEqualToString:jsShare]){
        [self share];
    }
    else if ([message.name isEqualToString:jsPay]){
        [self pay];
    }
}


//alert 警告框
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"调用alert提示框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    NSLog(@"alert message:%@",message);
}

#pragma mark - 注销用户
- (void)loginOut{
    [self presentAlertWithTitle:@"退出登录？" Handler:^{
        //移除所有注册js方法
        [self.webView.configuration.userContentController removeAllUserScripts];
        [TTUserInfoManager setLogined:NO];
        LoginViewController *mainVC = [[LoginViewController alloc] init];
        [[UIApplication sharedApplication] keyWindow].rootViewController = mainVC;
        
    } Cancel:nil];
}
#pragma mark - 分享
- (void)share{
    NSLog(@"分享");
}
#pragma mark - 支付
- (void)pay{}

@end
