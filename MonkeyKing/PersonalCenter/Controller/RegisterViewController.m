//
//  RegisterViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/8.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "RegisterViewController.h"
#import "InputTextView.h"
#import "AgreementViewController.h"


@interface RegisterViewController ()
///手机号
@property (nonatomic, strong) InputTextView *phoneView;
@property (nonatomic, strong) NSString *phoneStr;
///验证码
@property (nonatomic, strong) InputTextView *codeView;
@property (nonatomic, strong) NSString *codeStr;
///密码
@property (nonatomic, strong) InputTextView *pwdView;
@property (nonatomic, strong) NSString *pwdStr;
///确认密码
@property (nonatomic, strong) InputTextView *checkPwdView;
@property (nonatomic, strong) NSString *checkPwdStr;
///获取验证码
@property (nonatomic, strong) UIButton *getCodeBtn;
///提交注册/找回密码
@property (nonatomic, strong) UIButton *submitBtn;
///勾选用户协议
@property (nonatomic, strong) UIButton *selectBtn;
///用户协议
@property (nonatomic, strong) UILabel *agreementLbl;
@property (nonatomic, strong) UIButton *agreementBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    
}

- (void)initializeUserInterface{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = self.navTitle;
    
    _phoneView = [[InputTextView alloc] initWithFrame:CGRectMake(15, 100, SCREEN_WIDTH-100, 40) andTitle:@"手机号"];
    [self.view addSubview:_phoneView];
    [self.phoneView returnText:^(NSString *contentText) {
        self.phoneStr = contentText;
        NSLog(@"=====%@",_phoneStr);
    }];
    
    _getCodeBtn = [[UIButton alloc] init];
    [_getCodeBtn setTitle:@"验证码" forState:UIControlStateNormal];
    _getCodeBtn.titleLabel.font = FONT_15;
    _getCodeBtn.backgroundColor = COLOR_APP(1.0);
    _getCodeBtn.layer.cornerRadius = 10;
    _getCodeBtn.layer.masksToBounds = YES;
    [self.view addSubview:_getCodeBtn];
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneView.mas_right).offset(5);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.height.mas_offset(@30);
        make.centerY.mas_equalTo(self.phoneView.mas_centerY);
    }];
    [_getCodeBtn addTarget:self action:@selector(clickGetCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _codeView = [[InputTextView alloc] initWithFrame:CGRectMake(15, 160, SCREEN_WIDTH-30, 40) andTitle:@"验证码"];
    [self.view addSubview:_codeView];
    [self.codeView returnText:^(NSString *contentText) {
        self.codeStr = contentText;
        NSLog(@"=====%@",_codeStr);
    }];
    
    _pwdView = [[InputTextView alloc] initWithFrame:CGRectMake(15, 220, SCREEN_WIDTH-30, 40) andTitle:@"密码"];
    _pwdView.contentTxt.secureTextEntry = YES;
    [self.view addSubview:_pwdView];
    [self.pwdView returnText:^(NSString *contentText) {
        self.pwdStr = contentText;
        NSLog(@"密码：%@",self.pwdStr);
    }];
    
    _checkPwdView = [[InputTextView alloc] initWithFrame:CGRectMake(15, 280, SCREEN_WIDTH-30, 40) andTitle:@"确认密码"];
    _checkPwdView.contentTxt.secureTextEntry = YES;
    [self.view addSubview:_checkPwdView];
    [self.checkPwdView returnText:^(NSString *contentText) {
        self.checkPwdStr = contentText;
        NSLog(@"确认密码：%@",self.checkPwdStr);
    }];
    
    _selectBtn = [[UIButton alloc] init];
    [_selectBtn setImage:[UIImage imageNamed:@"select1"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"select1"] forState: UIControlStateHighlighted];
    [_selectBtn setImage:[UIImage imageNamed:@"selected1"] forState:UIControlStateSelected];
    [_selectBtn setImage:[UIImage imageNamed:@"selected1"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.view addSubview:_selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(25, 25));
        make.left.mas_equalTo(self.checkPwdView.mas_left);
        make.top.mas_equalTo(self.checkPwdView.mas_bottom).offset(20);
    }];
    [self.selectBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _agreementLbl = [[UILabel alloc] init];
    _agreementLbl.text = @"我已阅读并接受";
    _agreementLbl.textColor = [UIColor redColor];
    _agreementLbl.font = FONT_15;
    [self.view addSubview:_agreementLbl];
    [self.agreementLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectBtn.mas_right).offset(8);
        make.centerY.mas_equalTo(self.selectBtn.mas_centerY);
        make.size.sizeOffset(CGSizeMake(120, 30));
    }];
    
    _agreementBtn = [UIButton new];
    [_agreementBtn setTitle:@"用户协议" forState:UIControlStateNormal];
    _agreementBtn.titleLabel.font = FONT_15;
    [_agreementBtn setTitleColor:COLOR_APP(1.0) forState:UIControlStateNormal];
    _agreementBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:_agreementBtn];
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.agreementLbl.mas_right).offset(-8);
        make.centerY.mas_equalTo(self.selectBtn.mas_centerY);
        make.size.sizeOffset(CGSizeMake(80, 30));
    }];
    [self.agreementBtn addTarget:self action:@selector(clickAgreementBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _submitBtn = [UIButton new];
    [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_submitBtn setBackgroundColor:COLOR_APP(1.0)];
    _submitBtn.layer.cornerRadius = 15.0f;
    _submitBtn.layer.masksToBounds = YES;
    [self.view addSubview:_submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.agreementLbl.mas_bottom).offset(25);
        make.height.mas_offset(@30);
    }];
    [self.submitBtn addTarget:self action:@selector(clickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.navTitle isEqualToString:@"注册"]) {
        self.selectBtn.hidden = NO;
        self.agreementLbl.hidden = NO;
    } else if ([self.navTitle isEqualToString:@"找回密码"]){
        self.selectBtn.hidden = YES;
        self.agreementLbl.hidden = YES;
    }
}


#pragma mark - 点击事件 -
- (void)clickGetCodeBtn:(UIButton *)button{
    NSLog(@"获取验证码");
    if (self.phoneStr.length != 11) {
        [PublicMethod showAlert:self message:@"请输入正确的手机号！"];
    }else if ([self checkUserExist]){
        [PublicMethod showAlert:self message:@"该用户已存在"];
    } else {
        // 发送验证码
        [self sendCode];
    }
}
- (void)clickSelectBtn:(UIButton *)button{
    button.selected = !button.selected;
}
- (void)clickAgreementBtn:(UIButton *)button{
    NSLog(@"用户协议");
    AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
    [self.navigationController pushViewController:agreementVC animated:YES];
}
- (void)clickSubmitBtn:(UIButton *)button{
    
    if (self.phoneStr.length != 11) {
        [PublicMethod showAlert:self message:@"请输入正确的手机号"];
    } else if (self.codeStr.length == 0) {
        [PublicMethod showAlert:self message:@"验证码不能为空"];
    } else if (self.pwdStr.length < 6) {
        [PublicMethod showAlert:self message:@"请输入6位以上密码"];
    } else if (self.checkPwdView.contentTxt.text != self.pwdView.contentTxt.text) {
        [PublicMethod showAlert:self message:@"确认密码不一致"];
    } else {
        if ([self.navTitle isEqualToString:@"注册"]) {
            if (!self.selectBtn.selected) {
                [PublicMethod showAlert:self message:@"请阅读并同意用户协议"];
            } else {
                //提交注册
                [self startCommitInfo];
            }
        } else if ([self.navTitle isEqualToString:@"找回密码"]){
            //找回密码
            [self changePassword];
        }
    }
    
    
    
    
}

//验证用户是否已经存在
- (BOOL)checkUserExist{
    static BOOL isExist = NO;
    if ([self.navTitle isEqualToString:@"注册"]) {
        //http://api.swktcx.com/A1/user.php?token=only&user=xxxxxx
        
        NSDictionary *paramsDict = @{@"token":@"only",
                                     @"user":self.phoneStr};
        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:USERURL params:paramsDict andSuccessBlock:^(id responseObj) {
            
            if ([responseObj[@"state"] boolValue] == false || [responseObj[@"error"] isEqualToString:@"用户已注册"]) {
                isExist = YES;
            }
        } andFailedBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"验证用户是否存在error");
        } andIsHUD:YES];
        
    }
    return isExist;
}
//发送验证码
- (BOOL)sendCode{
    //http://api.swktcx.com/A1/user.php?token=gave&user=xxxxxx
    static BOOL isSend = NO;
    NSDictionary *paramsDict = @{@"token":@"gave",
                                 @"user":self.phoneStr};
//    [self.codeButton setTitle:@"正在发送..." forState:UIControlStateNormal];
    [PublicMethod buttonSetCountDownWithCount:59 andButton:self.getCodeBtn];
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:USERURL params:paramsDict andSuccessBlock:^(id responseObj) {
        
        if ([responseObj[@"data"] isEqualToString:@"发送成功"]) {
            isSend = YES;
            [self.getCodeBtn setTitle:@"验证码" forState:UIControlStateNormal];
            self.getCodeBtn.userInteractionEnabled = NO;
        } else {
            [PublicMethod showAlert:self message:@"验证码发送失败"];
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"发送验证码error");
    } andIsHUD:NO];
    return isSend;
}
// 注册
- (void)startCommitInfo{
    //http://api.swktcx.com/A1/user.php?token=new&user=xxxxxx&code=xxx&pass=xxx&tpass=xxx
    NSDictionary *dict = @{
                           @"token": @"new",
                           @"user":self.phoneStr,
                           @"code":self.codeStr,
                           @"pass":self.pwdStr,
                           @"tpass":self.checkPwdStr,
                           };
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:USERURL params:dict andSuccessBlock:^(id responseObj) {
        NSDictionary *responseObject = responseObj;
        NSLog(@"%@",responseObject[@"data"]);
        if ([responseObject[@"data"] isEqualToString:@"注册成功"]) {
            [PublicMethod autoDisappearAlert:self time:1 msg:@"注册成功！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [PublicMethod showAlert:self message:responseObject[@"error"]];
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"注册error");
    } andIsHUD:NO];
    
}
//找回密码
- (void)changePassword{
    //http://api.swktcx.com/A1/user.php?token=seek&user=150000000000&pass=123456&tpass=123456&code=129100
    NSDictionary *dict = @{
                           @"token": @"seek",
                           @"user":self.phoneStr,
                           @"code":self.codeStr,
                           @"pass":self.pwdView.contentTxt.text,
                           @"tpass":self.checkPwdView.contentTxt.text,
                           };
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:USERURL params:dict andSuccessBlock:^(id responseObj) {
        NSDictionary *responseObject = responseObj;
        NSLog(@"%@",responseObject[@"data"]);
        if ([responseObject[@"data"] isEqualToString:@"重置密码成功"]) {
            [PublicMethod autoDisappearAlert:self time:1 msg:@"重置密码成功！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [PublicMethod showAlert:self message:responseObject[@"error"]];
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"注册error");
    } andIsHUD:NO];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneView.contentTxt resignFirstResponder];
    [self.codeView.contentTxt resignFirstResponder];
    [self.pwdView.contentTxt resignFirstResponder];
    [self.checkPwdView.contentTxt resignFirstResponder];
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
