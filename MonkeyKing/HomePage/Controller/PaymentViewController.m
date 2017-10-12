//
//  PaymentViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/23.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "PaymentViewController.h"
#import "PaymentView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiObject.h"
#import "WXApi.h"
#import "MXWechatSignAdaptor.h"

@interface PaymentViewController ()

@property (nonatomic, strong) PaymentView *walletView;
@property (nonatomic, strong) PaymentView *wechatView;
@property (nonatomic, strong) PaymentView *alipayView;
@property (nonatomic, strong) UIButton *paymentBtn;
//@property (nonatomic, strong) UILabel *totalLbl;

@property (nonatomic, strong) NSString *paymethod;


@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    [self initializeDataSource];
}

- (void)initializeUserInterface{
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    self.navigationItem.title = @"支付";

    _walletView = [[PaymentView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 60)];
    _walletView.typeImgView.image = [UIImage imageNamed:@"walletPay"];
    _walletView.typeLbl.text = @"余额";
    [_walletView.checkBtn setImage:[UIImage imageNamed:@"selected2"] forState:UIControlStateNormal];
    [_walletView.checkBtn addTarget:self action:@selector(payMethodByBalance) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_walletView];
    
    _wechatView = [[PaymentView alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 60)];
    _wechatView.typeImgView.image = [UIImage imageNamed:@"wechatPay"];
    _wechatView.typeLbl.text = @"微信";
    [_wechatView.checkBtn setImage:[UIImage imageNamed:@"select2"] forState:UIControlStateNormal];
    [_wechatView.checkBtn addTarget:self action:@selector(payMentodByWechat) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_wechatView];
    
    _alipayView = [[PaymentView alloc] initWithFrame:CGRectMake(0, 210, SCREEN_WIDTH, 60)];
    _alipayView.typeImgView.image = [UIImage imageNamed:@"aliPay"];
    _alipayView.typeLbl.text = @"支付宝";
    [_alipayView.checkBtn setImage:[UIImage imageNamed:@"select2"] forState:UIControlStateNormal];
    [_alipayView.checkBtn addTarget:self action:@selector(payMentodByAlipay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_alipayView];
    
//    [self.totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(0);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
//        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH/3*2, 40));
//    }];
    
    [self.paymentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
        make.height.mas_offset(@40);
    }];
    [self.paymentBtn addTarget:self action:@selector(clickPayment) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)initializeDataSource{
    _paymethod = @"余额";
    NSLog(@"%@",_order_id);
}

- (void)clickPayment{
    NSLog(@"%@",_paymethod);
    if ([_paymethod isEqualToString:@"余额"]) {
        //http://api.swktcx.com/A1/order.php?token=pay_ment&uid=10000&order_id=122
        NSDictionary *paramDict = @{@"token":@"pay_ment",
                                    @"uid":USER_UID,
                                    @"order_id":_order_id};
        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ORDERURL params:paramDict andSuccessBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            if ([responseObj[@"state"] boolValue]==true&&kStringIsEmpty(responseObj[@"error"])) {
                [PublicMethod showAlert:self message:responseObj[@"data"]];
            } else {
                [PublicMethod showAlert:self message:responseObj[@"error"]];
            }
        } andFailedBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"余额支付error");
        } andIsHUD:NO];
        
        
        
    } else if ([_paymethod isEqualToString:@"支付宝"]) {
        //http://api.swktcx.com/A1/alipayPay.php?order_id=10000000
        NSDictionary *paramDict = @{@"order_id":_order_id};
        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ALIPAYURL params:paramDict andSuccessBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            
            if (kStringIsEmpty(responseObj[@"error"])) {
                NSString *orderString = responseObj[@"data"][@"sign"];
                NSString *appScheme = @"MonkeyKing";
                
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                    NSString * result = nil;
                    
                    if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                        result = @"支付成功";
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"等待商家接单" message:@"支付完成" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                        [alertController addAction:cancelAction];
                        [self presentViewController:alertController animated:YES completion:nil];
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
            NSLog(@"支付宝支付error");
        } andIsHUD:NO];
        
        
    } else if ([_paymethod isEqualToString:@"微信"]) {
        NSLog(@"微信Pay");
        //http://api.swktcx.com/A1/wePay.php?order_id=10000324
        
        NSDictionary *paramDict = @{@"order_id":_order_id};
        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:WEPAYURL params:paramDict andSuccessBlock:^(id responseObj) {
            
            if ([responseObj[@"state"] boolValue] == true) {
                //发起微信支付，设置参数
                
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
                    //                    request.sign= [dic objectForKey:@"sign"];
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
                } else {
                    [PublicMethod showAlert:self message:@"请稍后再试"];
                }
                
            }
            
        } andFailedBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"微信支付error");
        } andIsHUD:NO];
    }
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
    
}


#pragma mark - Different mode of payment -
- (void)payMethodByBalance{
    
    NSLog(@"余额付款");
    
    [_walletView.checkBtn setImage:[UIImage imageNamed:@"selected2"] forState:UIControlStateNormal];
    [_wechatView.checkBtn setImage:[UIImage imageNamed:@"select2"] forState:UIControlStateNormal];
    [_alipayView.checkBtn setImage:[UIImage imageNamed:@"select2"] forState:UIControlStateNormal];
    _paymethod = @"余额";
    
}
- (void)payMentodByAlipay{
    NSLog(@"支付宝付款");
    
    [_walletView.checkBtn setImage:[UIImage imageNamed:@"select2"] forState:UIControlStateNormal];
    [_wechatView.checkBtn setImage:[UIImage imageNamed:@"select2"] forState:UIControlStateNormal];
    [_alipayView.checkBtn setImage:[UIImage imageNamed:@"selected2"] forState:UIControlStateNormal];
    _paymethod = @"支付宝";
}
- (void)payMentodByWechat{
    NSLog(@"微信付款");
    
    [_walletView.checkBtn setImage:[UIImage imageNamed:@"select2"] forState:UIControlStateNormal];
    [_wechatView.checkBtn setImage:[UIImage imageNamed:@"selected2"] forState:UIControlStateNormal];
    [_alipayView.checkBtn setImage:[UIImage imageNamed:@"select2"] forState:UIControlStateNormal];
    _paymethod = @"微信";
}
#pragma mark - inituUI -

- (UIButton *)paymentBtn{
    if (!_paymentBtn) {
        _paymentBtn = [UIButton new];
        [_paymentBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        _paymentBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
        _paymentBtn.layer.borderWidth = 1.5f;
        _paymentBtn.layer.cornerRadius = 12.0f;
        _paymentBtn.layer.masksToBounds = YES;
        [_paymentBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.view addSubview:_paymentBtn];
    }
    return _paymentBtn;
}

//- (UILabel *)totalLbl{
//    if (!_totalLbl) {
//        _totalLbl = [UILabel new];
//        _totalLbl.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:_totalLbl];
//    }
//    return _totalLbl;
//}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
