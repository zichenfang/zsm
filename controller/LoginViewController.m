//
//  LoginViewController.m
//  臻饰美
//
//  Created by 方子辰 on 2018/4/10.
//  Copyright © 2018年 方子辰. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextField *codeTF;
@property (strong, nonatomic) IBOutlet UIButton *codeBtn;
@property (strong, nonatomic) IBOutlet UIButton *registBtn;//注册按钮（在未同意合同之前，不能点击）
@property (nonatomic,assign) int leftCount;//验证码倒计时

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)getCode:(id)sender {
    NSString *phone =[[self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if ([phone isValidateMobile] !=YES) {
        [self.view makeToast:@"请输入正确的手机号"];
        return;
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:phone forKey:@"phone"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager GET:API_USER_SEND_CODE Parameters:para Success:^(NSDictionary *responseJsonObject) {
        [ProgressHUD dismiss];
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        [self.view makeToast:msg];
        if ([code isEqualToString:@"200"])//
        {
            [self startTimeLimit];
        }
        
    } Failure:^(NSError *error) {
        [ProgressHUD dismiss];
        [self.view makeToast:@"网络请求错误"];

    }];
    
}
#pragma mark - 倒计时
- (void)startTimeLimit{
    self.codeBtn.enabled = NO;
    self.leftCount = MESSAGE_CODE_TIMEOUT;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(self.leftCount<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.codeBtn.enabled = YES;
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%d秒后重新获取",self.leftCount] forState:UIControlStateDisabled];
            });
            self.leftCount--;
        }
    });
    dispatch_resume(_timer);
}
- (IBAction)registNow:(id)sender {
    NSString *phone =[[self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if ([phone isValidateMobile] !=YES) {
        [self.view makeToast:@"请输入正确的手机号"];
        return;
    }
    if (self.codeTF.text.length<4) {
        [self.view makeToast:@"请输入正确的验证码"];
        
        return;
    }
    [self presentAlertWithTitle:@"确认提交？" Handler:^{
        [self requestRegist];
    } Cancel:nil];
    
}
- (void)requestRegist{
    NSString *phone =[[self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if ([phone isValidateMobile] !=YES) {
        [self.view makeToast:@"请输入正确的手机号"];
        return;
    }
    if (self.codeTF.text.length<4) {
        [self.view makeToast:@"请输入正确的验证码"];

        return;
    }

    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:phone forKey:@"phone"];
    [para setObject:self.codeTF.text forKey:@"smsCode"];
    if ([TTUserInfoManager deviceToken]) {
        [para setObject:[TTUserInfoManager jPushRegistID] forKey:@"push_token"];
    }
    else{
        [para setObject:@"没有token" forKey:@"push_token"];
    }
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager GET:API_USER_LOGIN Parameters:para Success:^(NSDictionary *responseJsonObject) {
        [ProgressHUD dismiss];
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"200"]) {
            [self.view makeToast:@"登录成功"];
            [TTUserInfoManager setUserInfo:result];
            [TTUserInfoManager setLogined:YES];
            [TTUserInfoManager setAccount:phone];
            [self performSelector:@selector(registSuccess) withObject:nil afterDelay:1.5];
        }
        else{
            [self.view makeToast:msg];
        }
    } Failure:^(NSError *error) {
        [ProgressHUD dismiss];
        [self.view makeToast:@"网络请求错误"];
    }];
}
//注册成功之后，须登录操作
- (void)registSuccess{
//    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
