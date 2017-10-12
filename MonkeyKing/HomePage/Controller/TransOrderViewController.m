//
//  TransOrderViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "TransOrderViewController.h"
#import "PaymentViewController.h"

@interface TransOrderViewController ()

///起步价
@property (nonatomic, strong) UILabel *startPLbl;
///乘运价
@property (nonatomic, strong) UILabel *transPLbl;


///金额
@property (nonatomic, strong) UILabel *moneyLbl;
///输入协议价
@property (nonatomic, strong) UITextField *agreeMTxt;
///显示协议价
@property (nonatomic, strong) UILabel *agreeMLbl;
///合计
@property (nonatomic, strong) UILabel *totalLbl;
///取消
@property (nonatomic, strong) UIButton *cancelBtn;
///确认下单
@property (nonatomic, strong) UIButton *orderBtn;


@end

@implementation TransOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeUserInterface];
    
    [self initializeDataSource];
    
}

- (void)initializeUserInterface{
    
    self.navigationItem.title = @"确认下单";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *startTitle = [UILabel new];
    startTitle.text = @"起步价：";
    [self.view addSubview:startTitle];
    [startTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.view.mas_top).offset(75);
        make.size.sizeOffset(CGSizeMake(80, 30));
    }];
    
    UILabel *transTitle = [UILabel new];
    transTitle.text = @"乘运价：";
    [self.view addSubview:transTitle];
    [transTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(startTitle.mas_bottom).offset(8);
        make.size.sizeOffset(CGSizeMake(80, 30));
    }];
    
    
    UILabel *moneyTitle = [UILabel new];
    moneyTitle.text = @"金额：￥";
    [self.view addSubview:moneyTitle];
    [moneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(transTitle.mas_bottom).offset(8);
        make.size.sizeOffset(CGSizeMake(80, 30));
    }];
    
    UILabel *agreeTitle = [UILabel new];
    agreeTitle.text = @"协议价：￥";
    [self.view addSubview:agreeTitle];
    [agreeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(moneyTitle.mas_bottom).offset(8);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    [self.startPLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startTitle.mas_right).offset(15);
        make.centerY.equalTo(startTitle.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
    [self.transPLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(transTitle.mas_right).offset(15);
        make.centerY.equalTo(transTitle.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
    [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyTitle.mas_right).offset(15);
        make.centerY.equalTo(moneyTitle.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
    [self.agreeMTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agreeTitle.mas_right).offset(15);
        make.centerY.equalTo(agreeTitle.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
    [self.agreeMTxt addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UILabel *totalTitle = [UILabel new];
    totalTitle.text = @"合计:￥";
    [self.view addSubview:totalTitle];
    [totalTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(150);
        make.top.equalTo(self.agreeMTxt.mas_bottom).offset(20);
        make.size.sizeOffset(CGSizeMake(70, 30));
    }];
    
    [self.totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totalTitle.mas_right).offset(0);
        make.centerY.equalTo(totalTitle.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
        make.size.sizeOffset(CGSizeMake(100, 40));
    }];
    
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
        make.size.sizeOffset(CGSizeMake(100, 40));
    }];
    
    [self.cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.orderBtn addTarget:self action:@selector(clickOrderBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initializeDataSource{
    self.startPLbl.text = self.startStr;
    self.transPLbl.text = self.transStr;
    self.moneyLbl.text = [NSString stringWithFormat:@"%.2f",[self.moneyStr doubleValue]];
    _agreeMTxt.placeholder = @"请输入和商家协商金额";
    _agreeMTxt.keyboardType = UIKeyboardTypeDecimalPad;
    self.totalLbl.text = self.moneyStr;
}

#pragma mark - UITextFieldDelegate - 
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.agreeMTxt) {
        self.totalLbl.text = [NSString stringWithFormat:@"%.2f",[textField.text doubleValue]];
    }
}

- (void)clickCancelBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickOrderBtn{
    NSLog(@"立即下单");
    //http://api.swktcx.com/A1/order.php?token=addOrderTour&uid=10000&serve_id=244&buyer_address=重庆渝北&pay_moeny=100&seller_address=重庆渝中&distance=100
    if (ISLOGIN) {
        NSDictionary *paramDict = @{@"token":@"addOrderTour",
                                    @"uid":USER_UID,
                                    @"serve_id":_serve_id,
                                    @"buyer_address":self.beginStr,
                                    @"pay_moeny":self.totalLbl.text,
                                    @"seller_address":self.endStr,
                                    @"distance":self.distanceStr};
        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ORDERURL params:paramDict andSuccessBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            if (kStringIsEmpty(responseObj[@"error"])) {
                PaymentViewController *paymentVC = [[PaymentViewController alloc] init];
                paymentVC.order_id = responseObj[@"data"][@"order_id"];
                [self.navigationController pushViewController:paymentVC animated:YES];
                
            } else {
                
                [PublicMethod showAlert:self message:responseObj[@"error"]];
                
            }
            
        } andFailedBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"旅游交通下单");
        } andIsHUD:NO];
        
    } else {
        [PublicMethod showAlert:self message:@"您还未登录，请先登录"];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.agreeMTxt resignFirstResponder];
}

#pragma mark - initUI -

- (UILabel *)startPLbl{
    if (!_startPLbl) {
        _startPLbl = [UILabel new];
        [self.view addSubview:_startPLbl];
    }
    return _startPLbl;
}

- (UILabel *)transPLbl{
    if (!_transPLbl) {
        _transPLbl = [UILabel new];
        [self.view addSubview:_transPLbl];
    }
    return _transPLbl;
}


- (UILabel *)moneyLbl{
    if (!_moneyLbl) {
        _moneyLbl = [UILabel new];
        [self.view addSubview:_moneyLbl];
    }
    return _moneyLbl;
}

- (UITextField *)agreeMTxt{
    if (!_agreeMTxt) {
        _agreeMTxt = [UITextField new];
        [self.view addSubview:_agreeMTxt];
    }
    return _agreeMTxt;
}

- (UILabel *)agreeMLbl{
    if (!_agreeMLbl) {
        _agreeMLbl = [UILabel new];
        [self.view addSubview:_agreeMLbl];
    }
    return _agreeMLbl;
}


- (UILabel *)totalLbl {
    if (!_totalLbl) {
        _totalLbl = [UILabel new];
        _totalLbl.textColor = [UIColor orangeColor];
        [self.view addSubview:_totalLbl];
    }
    return _totalLbl;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        _cancelBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
        _cancelBtn.layer.borderWidth = 1.0;
        _cancelBtn.layer.cornerRadius = 8.0f;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.view addSubview:_cancelBtn];
    }
    return _cancelBtn;
}

- (UIButton *)orderBtn{
    if (!_orderBtn) {
        _orderBtn = [UIButton new];
        _orderBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
        _orderBtn.layer.borderWidth = 1.0;
        _orderBtn.layer.cornerRadius = 8.0f;
        _orderBtn.layer.masksToBounds = YES;
        [_orderBtn setTitle:@"确认下单" forState:UIControlStateNormal];
        [_orderBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.view addSubview:_orderBtn];
    }
    return _orderBtn;
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
