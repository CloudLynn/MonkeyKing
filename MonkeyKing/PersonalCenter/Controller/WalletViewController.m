//
//  WalletViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/10.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "WalletViewController.h"
#import "WalletTopView.h"
#import "WalletTableViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "MXWechatSignAdaptor.h"
#import "ShareLogIn.h"

@interface WalletViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WalletTopView *topView;

///充值
@property (nonatomic, strong) UIButton *topupBtn;

///提现
@property (nonatomic, strong) UIButton *downBtn;

@property (nonatomic, strong) UITableView *walletTableView;

@property (nonatomic, strong) NSArray *array;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    
    [self initializeDataSource];
}

- (void)initializeUserInterface{
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    self.navigationItem.title = @"我的钱包";
    
    _topView = [[WalletTopView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 120)];
    [self.view addSubview:_topView];
    
    UILabel *titleLbl = [UILabel new];
    titleLbl.text = @"账单明细";
    titleLbl.textColor = [UIColor darkGrayColor];
    titleLbl.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:titleLbl];
    
    _topupBtn = [UIButton new];
    [_topupBtn setTitle:@"充值" forState:UIControlStateNormal];
    [_topupBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _topupBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
    _topupBtn.layer.borderWidth = 1.0f;
    _topupBtn.layer.cornerRadius = 8.0;
    _topupBtn.layer.masksToBounds = YES;
    [self.topView addSubview:_topupBtn];
    [self.topupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.topView.mas_centerY);
        make.top.equalTo(self.topView.mas_top).offset(20);
        make.right.equalTo(self.topView.mas_right).offset(-15);
        make.size.sizeOffset(CGSizeMake(80, 30));
    }];
    
    [self.topupBtn addTarget:self action:@selector(clickTopupBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _downBtn = [UIButton new];
    [_downBtn setTitle:@"提现" forState:UIControlStateNormal];
    [_downBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _downBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
    _downBtn.layer.borderWidth = 1.0f;
    _downBtn.layer.cornerRadius = 8.0;
    _downBtn.layer.masksToBounds = YES;
    [self.topView addSubview:_downBtn];
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.topView.mas_centerY);
        make.top.equalTo(self.topupBtn.mas_bottom).offset(20);
        make.right.equalTo(self.topView.mas_right).offset(-15);
        make.size.sizeOffset(CGSizeMake(80, 30));
    }];
    
    [self.downBtn addTarget:self action:@selector(clickDownBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(8);
        make.top.equalTo(self.topView.mas_bottom).offset(15);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    _walletTableView = [[UITableView alloc] init];
    _walletTableView.delegate = self;
    _walletTableView.dataSource = self;
    [self.view addSubview:_walletTableView];
    [self.walletTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(titleLbl.mas_bottom).offset(5);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    
    [_walletTableView registerClass:[WalletTableViewCell class] forCellReuseIdentifier:@"walletCell"];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"在线转账" style:UIBarButtonItemStylePlain target:self action:@selector(clickTransferOnline)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)initializeDataSource{
    if (!_array) {
        _array = [NSArray array];
    }
    
    
    NSDictionary *paramDict = @{@"token":@"getPayLog"};
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:USERURL params:paramDict andSuccessBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if (kStringIsEmpty(responseObj[@"error"])) {
//            NSArray *arr = responseObj[@"data"];
//            if (arr.count >0) {
                _topView.balanceLbl.text = [NSString stringWithFormat:@"￥ %@",responseObj[@"data"][@"bmikece"]];
                _topView.withdrawalLbl.text = [NSString stringWithFormat:@"￥ %@",responseObj[@"data"][@"bmikece"]];
                
                _array = responseObj[@"data"][@"log"];
//            }
            
            [self.walletTableView reloadData];
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"交易记录");
        NSLog(@"%@",responseObj);
    } andIsHUD:NO];
    
}

#pragma mark - 在线转账 -
- (void)clickTransferOnline{
    //在线转账
    /*http://api.swktcx.com/A1/order.php?token=Transfer
    request={
        " phone":15221317656  //电话号码
        " pay_moeny":200	//金额
    }*/

    NSString *balance = [NSString stringWithFormat:@"钱包余额：%@",self.topView.balanceLbl.text];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"在线转账" message:balance preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入电话号码";
        textField.keyboardType = UIKeyboardTypePhonePad;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入要转账的金额";
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *phone = alertController.textFields.firstObject;
        UITextField *money = [alertController.textFields objectAtIndex:1];
        
        if (phone.text.length != 11) {
            [PublicMethod showAlert:self message:@"请输入格式正确的电话号码"];
        } else if (money.text != nil){
            NSDictionary *paramDict = @{@"token":@"Transfer",
                                        @"phone":phone,
                                        @"pay_moeny":money};
            [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ORDERURL params:paramDict andSuccessBlock:^(id responseObj) {
                if (kStringIsEmpty(responseObj[@"error"])) {
                    [PublicMethod showAlert:self message:@"转账成功"];
                    [self initializeDataSource];
                } else {
                    [PublicMethod showAlert:self message:responseObj[@"error"]];
                    [self initializeDataSource];
                }
            } andFailedBlock:^(id responseObj) {
                NSLog(@"%@",responseObj);
                NSLog(@"在线转账");
            } andIsHUD:NO];
        }
        
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

#pragma mark - 充值 -

- (void)clickTopupBtn:(UIButton *)sender{
    //充值
    NSLog(@"充值");
    //http://api.swktcx.com/A1/alipayPayUp.php?uid=10000&pay_moeny=1
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"钱包充值" message:@"输入您想充值的金额" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"充值";
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *money = alertController.textFields.firstObject;
        if (money.text != nil) {
            [self chooseTopupWay:money.text];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

- (void)chooseTopupWay:(NSString *)money{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"充值" message:@"选择充值的方式" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alipayAction = [UIAlertAction actionWithTitle:@"使用支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"支付宝充值");
        NSDictionary *paramDict = @{@"uid":USER_UID,
                                    @"pay_moeny":money};
        NSString *alipayupUrl = @"http://api.swktcx.com/A1/alipayPayUp.php?";
        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:alipayupUrl params:paramDict andSuccessBlock:^(id responseObj) {
            
            if (kStringIsEmpty(responseObj[@"error"])) {
                NSString *orderString = responseObj[@"data"][@"sign"];
                NSString *appScheme = @"MonkeyKing";
                
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                    NSString * result = nil;
                    
                    if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                        result = @"支付成功";
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"充值" message:@"支付完成" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                        [alertController addAction:cancelAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                        [self initializeDataSource];
                        
                    } else {
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:result message:@"支付未完成" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                        [alertController addAction:cancelAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    
                }];
                //接收来自APPdelegate的通知(注册观察者)
                //获取通知中心单例对象
                NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
                //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
                [center addObserver:self selector:@selector(notice:) name:@"payAmountResult" object:nil];
                
            } else {
                [PublicMethod showAlert:self message:responseObj[@"error"]];
            }
            
            
            
        } andFailedBlock:^(id responseObj) {
            
            NSLog(@"%@",responseObj);
            NSLog(@"支付宝充值error");
            
            
        } andIsHUD:NO];
    }];
    
    UIAlertAction *wechatAction = [UIAlertAction actionWithTitle:@"使用微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"微信充值");
        //http://api.swktcx.com/A1/wePayUp.php?pay_moeny=100
        NSDictionary *paramDict = @{@"pay_moeny":money};
        NSString *wepayupUrl = @"http://api.swktcx.com/A1/wePayUp.php?";
        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:wepayupUrl params:paramDict andSuccessBlock:^(id responseObj) {
            
            if ([responseObj[@"state"] boolValue] == true) {
                //发起微信充值，设置参数
                
                NSDictionary *dic = responseObj[@"data"];
                NSLog(@"%@",dic); 
                //判断返回的许可
                if ([[dic objectForKey:@"result_code"] isEqualToString:@"SUCCESS"] &&[[dic objectForKey:@"return_code"] isEqualToString:@"SUCCESS"] ){
                    
                    PayReq *request = [[PayReq alloc] init];
                    request.openID = [dic objectForKey:@"appid"];
                    request.partnerId = [dic objectForKey:@"mch_id"];
                    request.prepayId= [dic objectForKey:@"prepay_id"];
                    request.package = @"Sign=WXPay";
                    request.nonceStr= [dic objectForKey:@"nonce_str"];
                    request.timeStamp= [[dic objectForKey:@"timestamp"] intValue];
//          +          request.sign= [dic objectForKey:@"sign"];
                    NSLog(@"时间戳：%@ == %d",[dic objectForKey:@"timestamp"],[[dic objectForKey:@"timestamp"] intValue]);
                    // 签名加密
                    MXWechatSignAdaptor *md5 = [[MXWechatSignAdaptor alloc] init];
                    
                    request.sign=[md5 createMD5SingForPay:request.openID
                                                partnerid:request.partnerId
                                                 prepayid:request.prepayId
                                                  package:request.package
                                                 noncestr:request.nonceStr
                                                timestamp:request.timeStamp];;
                    
                    //           调用微信
                    [WXApi sendReq:request];
                    
                    [self initializeDataSource];
                    
                }
                
            }
            
        } andFailedBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"微信支付error");
        } andIsHUD:NO];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:alipayAction];
    [alertController addAction:wechatAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

#pragma mark - 支付结果展示 -
- (void)notice:(NSDictionary *)sender{
    NSString *str = [NSString stringWithFormat:@"%@",sender];
    NSString *resultStr = [[str substringFromIndex:185]substringToIndex:4];
    
    NSString * result = nil;
    if ([str rangeOfString:@"9000"].location !=NSNotFound) {
        result = @"支付成功";
    } else if ([resultStr isEqualToString:@"6001"]) {
        result = @"用户中途取消";
    } else if ([resultStr isEqualToString:@"6002"]) {
        result = @"网络连接出错";
    } else if ([resultStr isEqualToString:@"4000"]) {
        result = @"支付失败";
    } else if ([resultStr isEqualToString:@"8000"]) {
        result = @"正在处理中";
    } else {
        result = @"支付失败";
    }
    if ([str rangeOfString:@"9000"].location ==NSNotFound) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:result message:@"支付未完成" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"等待商家接单" message:@"支付完成" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    [self initializeDataSource];
    
}

#pragma mark - 提现 -

- (void)clickDownBtn{
    NSLog(@"提现");
    NSString *msg = [NSString stringWithFormat:@"本次可提现金额为：%@",self.topView.balanceLbl.text];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提现" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"提现";
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    UIAlertAction *alipayAction = [UIAlertAction actionWithTitle:@"提现到支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"支付宝提现");
        UITextField *firstTxtField = alertController.textFields.firstObject;
        //http://api.swktcx.com/A1/alipayTransfer.php?uid=10000&pay_moeny=1
        NSString *urlStr = @"http://api.swktcx.com/A1/alipayTransfer.php?";
        NSDictionary *paramDict = @{@"uid":USER_UID,
                                    @"pay_moeny":firstTxtField.text};
        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:urlStr params:paramDict andSuccessBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            if (kStringIsEmpty(responseObj[@"error"])) {
                [PublicMethod showAlert:self message:responseObj[@"data"]];
                [self initializeDataSource];
            } else {
                [PublicMethod showAlert:self message:responseObj[@"error"]];
            }
        } andFailedBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"提现到支付宝error");
        } andIsHUD:NO];
        
    }];
    
//    UIAlertAction *wechatAction = [UIAlertAction actionWithTitle:@"提现到微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"提现到微信");
//        ShareLogIn *share = [ShareLogIn new];
//        [share shareLogInWithType:ShareformTypeWechat selectCancleBlock:^{
//            NSLog(@"点击取消微信授权");
//        } succBlock:^(ShareLogInSuccModel *model) {
//            NSLog(@"微信授权成功");
//            NSLog(@"%@",model.openid);
//        } errorBlock:^(NSError *error) {
//            NSLog(@"微信授权error%@",error);
//        }];
        /*//微信授权
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
        NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
        // 如果已经请求过微信授权登录，那么考虑用已经得到的access_token
        if (accessToken && openID) {
//            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_REFRESH_TOKEN];
            NSString *refreshUrlStr = [NSString stringWithFormat:@"%@/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", WX_BASE_URL, WXPatient_App_ID, refreshToken];
            
            [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:refreshUrlStr params:nil andSuccessBlock:^(id responseObj) {
                NSLog(@"请求reAccess的response = %@", responseObj);
                NSDictionary *refreshDict = [NSDictionary dictionaryWithDictionary:responseObj];
                NSString *reAccessToken = [refreshDict objectForKey:WX_ACCESS_TOKEN];
                // 如果reAccessToken为空,说明reAccessToken也过期了,反之则没有过期
                if (reAccessToken) {
                    // 更新access_token、refresh_token、open_id
                    [[NSUserDefaults standardUserDefaults] setObject:reAccessToken forKey:WX_ACCESS_TOKEN];
                    [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:WX_OPEN_ID] forKey:WX_OPEN_ID];
                    [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:WX_REFRESH_TOKEN] forKey:WX_REFRESH_TOKEN];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    // 当存在reAccessToken不为空时直接执行AppDelegate中的wechatLoginByRequestForUserInfo方法
//                    !self.requestForUserInfoBlock ? : self.requestForUserInfoBlock();
                }
                else {
                    [self wechatLogin];
                }
            } andFailedBlock:^(id responseObj) {
                NSLog(@"用refresh_token来更新accessToken时出错 = %@", responseObj);
            } andIsHUD:NO];
            
            
//            [manager GET:refreshUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                
//            }];
        }
        else {
            [self wechatLogin];
        }*/
        //微信提现后台接口
//        UITextField *firstTxtField = alertController.textFields.firstObject;
//        [self weTransferVeerAction:firstTxtField.text];
//    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:alipayAction];
 //   [alertController addAction:wechatAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
}
#pragma mark - 微信登录
/*
 目前移动应用上德微信登录只提供原生的登录方式，需要用户安装微信客户端才能配合使用。
 对于iOS应用,考虑到iOS应用商店审核指南中的相关规定，建议开发者接入微信登录时，先检测用户手机是否已经安装
 微信客户端(使用sdk中的isWXAppInstall函数),对于未安装的用户隐藏微信 登录按钮，只提供其他登录方式。
 */

- (void)wechatLogin {
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"GSTDoctorApp";
        [WXApi sendReq:req];
    }
    else {
        [self setupAlertController];
    }
}
#pragma mark - 设置弹出提示语，或者调起微信 -
- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)weTransferVeerAction:(NSString *)string{
    //微信提现
    //http://api.swktcx.com/A1/weTransferVeer.php?pay_moeny=100
    NSString *urlStr = @"http://api.swktcx.com/A1/weTransferVeer.php?";
    NSDictionary *paramDict = @{@"uid":USER_UID,
                                @"pay_moeny":string};
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:urlStr params:paramDict andSuccessBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if (kStringIsEmpty(responseObj[@"error"])) {
            [PublicMethod showAlert:self message:responseObj[@"data"]];
            [self initializeDataSource];
        } else {
            [PublicMethod showAlert:self message:responseObj[@"error"]];
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"提现到微信error");
    } andIsHUD:NO];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletTableViewCell *cell = (WalletTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"walletCell"];
    if (!cell) {
        cell = [[WalletTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"walletCell"];
    }
    NSDictionary *dict = _array[indexPath.row];
    [cell setWalletDict:dict];
    
    return cell;
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
