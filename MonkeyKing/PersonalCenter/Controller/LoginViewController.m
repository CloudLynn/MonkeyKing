//
//  LoginViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/8.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "LoginViewController.h"
#import "InputTextView.h"
#import "RegisterViewController.h"

@interface LoginViewController ()
///APPIcon
@property (nonatomic, strong) UIImageView *iconImgView;
///账号视图
@property (nonatomic, strong) InputTextView *accountView;
///账号
@property (nonatomic, strong) NSString *accountStr;
///mima视图
@property (nonatomic, strong) InputTextView *pwdView;
///密码
@property (nonatomic, strong) NSString *pwdStr;
///登录
@property (nonatomic, strong) UIButton *loginBtn;
///注册
@property (nonatomic, strong) UIButton *registerBtn;
///找回密码
@property (nonatomic, strong) UIButton *findPwdBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    
}

- (void)initializeUserInterface{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"登录";
    
    _iconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appImg"]];
    [self.view addSubview:_iconImgView];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(100);
        make.width.mas_offset(@100);
        make.height.mas_offset(@100);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    _accountView = [[InputTextView alloc] initWithFrame:CGRectMake(20, 240, SCREEN_WIDTH-40, 40) andTitle:@"账号"];
    [self.view addSubview:_accountView];
    [self.accountView returnText:^(NSString *contentText) {
        _accountStr = contentText;
        NSLog(@"=====%@",_accountStr);
    }];
    
    _pwdView = [[InputTextView alloc] initWithFrame:CGRectMake(20, 290, SCREEN_WIDTH-40, 40) andTitle:@"密码"];
    _pwdView.contentTxt.secureTextEntry = YES;
    [self.view addSubview:_pwdView];
    [self.pwdView returnText:^(NSString *contentText) {
        _pwdStr = contentText;
        NSLog(@"=====%@",_pwdStr);
    }];
    
    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 350, SCREEN_WIDTH-40, 40)];
    [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    _loginBtn.backgroundColor = COLOR_APP(0.7);
    _loginBtn.layer.cornerRadius = 10;
    _loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:_loginBtn];
    [_loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _registerBtn = [[UIButton alloc] init];
    [_registerBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    [_registerBtn setTitleColor:COLOR_APP(1.0) forState:UIControlStateNormal];
    _registerBtn.titleLabel.font = FONT_15;
    [self.view addSubview:_registerBtn];
    [_registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginBtn.mas_left);
        make.height.mas_offset(@30);
        make.width.mas_offset(@100);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(15);
    }];
    
    _findPwdBtn = [[UIButton alloc] init];
    [_findPwdBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [_findPwdBtn setTitleColor:COLOR_APP(1.0) forState:UIControlStateNormal];
    _findPwdBtn.titleLabel.font = FONT_15;
    [self.view addSubview:_findPwdBtn];
    [_findPwdBtn addTarget:self action:@selector(clickFindPwdBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.findPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loginBtn.mas_right);
        make.height.mas_offset(@30);
        make.width.mas_offset(@100);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(15);
    }];
}

#pragma mark -按钮的点击事件-
- (void)clickLoginBtn{
    NSLog(@"登录");
    [self.view endEditing:YES];
    if (_accountStr.length != 11) {
        [PublicMethod showAlert:self message:@"账号格式有误！"];
        return;
    }
    if (kStringIsEmpty(_pwdStr)) {
        [PublicMethod showAlert:self message:@"密码不能为空！"];
        return;
    }
    
    NSDictionary *paramsDict = @{
                                 @"token": @"login",
                                 @"user":_accountStr,
                                 @"pass":_pwdStr,
                                 @"lat":USER_LAT,
                                 @"lng":USER_LNG
                                 };
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:USERURL params:paramsDict andSuccessBlock:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        NSMutableDictionary *responderObject = responseObj;
        //登录成功
        if (!kStringIsEmpty(responseObj[@"error"])) {
            [PublicMethod showAlert:self message:responderObject[@"error"]];
        } else {
            [USER_DEFAULTS setBool:YES forKey:@"isLogin"];
            [USER_DEFAULTS setObject:responseObj[@"data"][@"uid"] forKey:@"uid"];
            [USER_DEFAULTS setObject:self.accountStr forKey:@"user"];
            [USER_DEFAULTS setObject:self.pwdStr forKey:@"pwd"];
            [USER_DEFAULTS synchronize];
            
            
            //登录环信
            [self loginWithUsername:self.accountStr password:self.accountStr];
            
            
            [self.navigationController popViewControllerAnimated:YES];
            //发起通知
            NSNotification *notice = [NSNotification notificationWithName:@"changeLogin" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notice];
            
        }
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
    } andIsHUD:YES];
}

//点击登陆后的操作（环信）
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
    //异步登陆账号
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself hideHud];
            if (!error) {
                //设置是否自动登录
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                
                //保存最近一次登录用户名
                [weakself saveLastLoginUsername];
                //发送自动登陆状态通知
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:[NSNumber numberWithBool:YES]];
                
            } else {
                switch (error.code)
                {
                    case EMErrorUserNotFound:
                        TTAlertNoTitle(NSLocalizedString(@"error.usernotExist", @"User not exist!"));
                        break;
                    case EMErrorNetworkUnavailable:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                        break;
                    case EMErrorServerNotReachable:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                        break;
                    case EMErrorUserAuthenticationFailed:
                        TTAlertNoTitle(error.errorDescription);
                        break;
                    case EMErrorServerTimeout:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                        break;
                    case EMErrorServerServingForbidden:
                        TTAlertNoTitle(NSLocalizedString(@"servingIsBanned", @"Serving is banned"));
                        break;
                    default:
                        TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
                        break;
                }
            }
        });
    });
}

- (void)clickRegisterBtn{
    NSLog(@"注册");
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    registerVC.navTitle = @"注册";
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)clickFindPwdBtn{
    NSLog(@"找回密码");
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    registerVC.navTitle = @"找回密码";
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.accountView.contentTxt resignFirstResponder];
    [self.pwdView.contentTxt resignFirstResponder];
}

- (void)showAlert:(UIViewController *)controller message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [controller presentViewController:alert animated:YES completion:nil];
}

#pragma  mark - private

- (void)saveLastLoginUsername
{
    NSString *username = [[EMClient sharedClient] currentUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
        [ud synchronize];
    }
}

- (NSString*)lastLoginUsername
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
    if (username && username.length > 0) {
        return username;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
