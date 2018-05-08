//
//  MessageHandlerViewController.m
//  臻饰美
//
//  Created by 方子辰 on 2018/4/28.
//  Copyright © 2018年 方子辰. All rights reserved.
//

#import "MessageHandlerViewController.h"
#import <WebKit/WebKit.h>
#import "TTVenderHeader.h"

@interface MessageHandlerViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *refresh_token;
@property (strong, nonatomic) NSString *openid;
@property (strong, nonatomic) NSString *unionid;

@end

@implementation MessageHandlerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.preferences = [WKPreferences new];
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    config.userContentController = [[WKUserContentController alloc] init];
    
    [config.userContentController addScriptMessageHandler:self name:@"getUserMobileInfo"];
    [config.userContentController addScriptMessageHandler:self name:@"setUserMobileInfo"];
    [config.userContentController addScriptMessageHandler:self name:@"share"];
    [config.userContentController addScriptMessageHandler:self name:@"jumpToWechatPay"];
    [config.userContentController addScriptMessageHandler:self name:@"logOut"];
    [config.userContentController addScriptMessageHandler:self name:@"getWechatUserInfo"];


    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:config];
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
//    [self refreshWeb];

    //添加支付通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResped:) name:@"payResp" object:nil];
    //添加微信登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authResped:) name:@"authResp" object:nil];
    //添加网络通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWeb) name:@"refreshWeb" object:nil];

}
- (void)refreshWeb{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://zsm.qingcangshu.cn"]]];
    //    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.0.104:8888/index.html"]]];
}
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"message.name =%@",message.name);
    NSLog(@"message.body =%@",message.body);
    
//    [self.view makeToast:[NSString stringWithFormat:@"方法名：%@,\n 参数:%@",message.name,message.body]];
    
    if ([message.name isEqualToString:@"getUserMobileInfo"]) {
        [self ggetUserMobileInfo];
//#warning delete this
//        [self ggetWechatInfo];
    }
    else if ([message.name isEqualToString:@"setUserMobileInfo"]) {
        [self ssetUserMobileInfoWithMessage:message];
    }
    //分享
    else if ([message.name isEqualToString:@"share"]) {
        [self shareWithMessage:message];
    }
    else if ([message.name isEqualToString:@"jumpToWechatPay"]) {
        [self wechatPayWithMessage:message];
    }
    else if ([message.name isEqualToString:@"logOut"]) {
        [TTUserInfoManager setAccount:@""];
        [TTUserInfoManager setPassword:@""];
        NSLog(@"phone:%@ --%@ ",[TTUserInfoManager account],[TTUserInfoManager token]);
    }
    else if ([message.name isEqualToString:@"getWechatUserInfo"]) {
        [self ggetWechatInfo];
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
//MARK:微信登录
- (void)ggetWechatInfo{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"zsm_jt";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

//MARK:获取信息
- (void)ggetUserMobileInfo{
    NSString *phone = [TTUserInfoManager account];
    if (phone == nil) {
        phone  =@"";
    }
    NSString *token = [TTUserInfoManager password];
    if (token == nil) {
        token  =@"";
    }
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (phone) {
        [userInfo setObject:phone forKey:@"phone"];
    }
    if (token) {
        [userInfo setObject:token forKey:@"token"];
    }
    if ([TTUserInfoManager jPushRegistID]) {
        [userInfo setObject:[TTUserInfoManager jPushRegistID] forKey:@"jPushRegistID"];
    }
    if ([TTUserInfoManager deviceToken]) {
        [userInfo setObject:[TTUserInfoManager deviceToken] forKey:@"deviceToken"];
    }
    
    NSString *jsStr = [NSString stringWithFormat:@"userInfoDidReceived(%@)",userInfo.json_String];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
    }];
    NSLog(@"evaluateJavaScript :%@",jsStr);

}
    //MARK:设置信息

- (void)ssetUserMobileInfoWithMessage :(WKScriptMessage *)message{
    NSString *phone = [message.body objectForKey:@"phone"];
    NSString *token = [message.body objectForKey:@"token"];
    if(phone && token){
        [TTUserInfoManager setAccount:phone];
        [TTUserInfoManager setPassword:token];
    }

}
    //MARK:分享信息

- (void)shareWithMessage :(WKScriptMessage *)message{
    NSString *shareTitle = [message.body objectForKey:@"title"];
    if (shareTitle == nil){
        shareTitle = @"臻饰美";
    }
    NSString *shareContent = [message.body objectForKey:@"content"];
    if (shareContent == nil){
        shareContent = @"臻饰美应用";
    }
    NSString *shareUrl = [message.body objectForKey:@"url"];
    if (shareUrl == nil){
        shareUrl = @"http://zsm.qingcangshu.cn";
    }
    
    
    WXMediaMessage *wxMessage = [[WXMediaMessage alloc] init];
    [wxMessage setThumbImage:[UIImage imageNamed:@"logo"]];
    wxMessage.title = shareTitle;
    wxMessage.description = shareContent;
    
    WXWebpageObject *pageObj = [WXWebpageObject object];
    pageObj.webpageUrl = shareUrl;
    wxMessage.mediaObject = pageObj;
    
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = wxMessage;
    req.scene = WXSceneSession;
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"分享到" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertC addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        req.scene = WXSceneSession;
        [WXApi sendReq:req];
        
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        req.scene = WXSceneTimeline;
        [WXApi sendReq:req];
        
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertC animated:YES completion:nil];

}
- (void)wechatPayWithMessage :(WKScriptMessage *)message{
    NSString *appid = [message.body objectForKey:@"appid"];//
    //需要动态注册app ID，因为微信商户不止一家
    PayReq* req             = [[PayReq alloc] init];
    req.openID = appid;//        公众账号ID    ``appid    String(32)    是    wx8888888888888888    微信分配的公众账号ID
    req.partnerId  =[message.body objectForKey:@"partnerid"];//        商户号    ``partnerid    String(32)    是    1900000109    微信支付分配的商户号
    req.prepayId  =[message.body objectForKey:@"prepayid"];//        预支付交易会话ID    prepayid    String(32)    是    WX1217752501201407033233368018    微信返回的支付交易会话ID
    
    req.package             = @"Sign=WXPay";//        扩展字段    ``package    String(128)    是    Sign=WXPay    暂填写固定值Sign=WXPay
    req.nonceStr            = [message.body objectForKey:@"noncestr"];//        随机字符串    ``noncestr    String(32)    是    5K8264ILTKCH16CQ2502SI8ZNMTM67VS    随机字符串，不长于32位。推荐随机数生成算法
    req.timeStamp           = (int)[[message.body objectForKey:@"timestamp"] intValue];//        时间戳    ``timestamp    String(10)    是    1412000000    时间戳，请见接口规则-参数规定
    req.sign                = [message.body objectForKey:@"sign"];//        签名    ``sign    String(32)    是    C380BEC2BFD727A4B6845133519F3AD6    签名，详见签名生成算法
    [WXApi sendReq:req];

}
- (void)payResped :(NSNotification *)noti{
    NSLog(@"payResped =%@",noti.object);

    BaseResp *resp = (BaseResp*)noti.object;
    NSLog(@"resp.errCode =%d",resp.errCode);

    NSDictionary *javaResp = @{@"status":@"success"};

    if(resp.errCode != WXSuccess){
        javaResp = @{@"status":@"fail"};
    }
    NSString *jsStr = [NSString stringWithFormat:@"wechatPayResp(%@)",javaResp.json_String];

    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
    }];
    NSLog(@"evaluateJavaScript :%@",jsStr);
}
- (void)authResped :(NSNotification *)noti{
    NSLog(@"authResped =%@",noti.object);
    
    SendAuthResp *resp = (SendAuthResp*)noti.object;
    [self obtainAccess_tokenWithCode:resp.code];
}
- (void)obtainAccess_tokenWithCode :(NSString *)code{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (code) {
        [para setObject:code forKey:@"code"];
    }
    [para setObject:WechatAppID forKey:@"appid"];
    [para setObject:WechatAppSecret forKey:@"secret"];
    [para setObject:@"authorization_code" forKey:@"grant_type"];
    [TTRequestOperationManager GET:@"https://api.weixin.qq.com/sns/oauth2/access_token?" Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSLog(@"%@",responseJsonObject);
        NSString *errcode = [responseJsonObject objectForKey:@"errcode"];
        if (errcode) {
            [self.view makeToast:@"用户授权失败"];
        }
        else{
            self.access_token = [responseJsonObject string_ForKey:@"access_token"];
            self.refresh_token = [responseJsonObject string_ForKey:@"refresh_token"];
            self.openid = [responseJsonObject string_ForKey:@"openid"];
            self.unionid = [responseJsonObject string_ForKey:@"unionid"];
            [self obtainUserInfo];
        }
    } Failure:^(NSError *error) {
        
    }];
}
- (void)obtainUserInfo{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (self.access_token) {
        [para setObject:self.access_token forKey:@"access_token"];
    }
    if (self.openid) {
        [para setObject:self.openid forKey:@"openid"];
    }
    [TTRequestOperationManager GET:@"https://api.weixin.qq.com/sns/userinfo?" Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSLog(@"%@",responseJsonObject);
        NSString *errcode = [responseJsonObject objectForKey:@"errcode"];
        if (errcode) {
            [self.view makeToast:@"用户信息获取失败"];
        }
        else{
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:responseJsonObject];
            if ([TTUserInfoManager jPushRegistID]) {
                [userInfo setObject:[TTUserInfoManager jPushRegistID] forKey:@"jPushRegistID"];
            }
            if ([TTUserInfoManager deviceToken]) {
                [userInfo setObject:[TTUserInfoManager deviceToken] forKey:@"deviceToken"];
            }
            NSLog(@"userInfo =%@",userInfo);
            NSString *jsStr = [NSString stringWithFormat:@"setWechatUserInfo(%@)",userInfo.json_String];
            [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            }];
            NSLog(@"evaluateJavaScript :%@",jsStr);
        }
    } Failure:^(NSError *error) {
        
    }];

}

@end
