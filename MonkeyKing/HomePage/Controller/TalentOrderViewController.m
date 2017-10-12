//
//  TalentOrderViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/6/6.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "TalentOrderViewController.h"
#import "PaymentViewController.h"

@interface TalentOrderViewController ()

///职位类别
@property (nonatomic, strong) UILabel *typeLbl;
///支付金额
@property (nonatomic, strong) UILabel *moenyLbl;
///面试单位
@property (nonatomic, strong) UITextField *companyTxt;
///面试地址
@property (nonatomic, strong) UITextField *addressTxt;
///合计
@property (nonatomic, strong) UILabel *totalLbl;
///取消
@property (nonatomic, strong) UIButton *cancelBtn;
///确认下单
@property (nonatomic, strong) UIButton *orderBtn;

@end

@implementation TalentOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeUserInterface];
    
    [self initializeDataSource];
    
}


- (void)initializeUserInterface{
    
    self.navigationItem.title = @"确认下单";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *typeT = [UILabel new];
    typeT.text = @"求职类别";
    [self.view addSubview:typeT];
    [typeT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(70);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    UILabel *moneyT = [UILabel new];
    moneyT.text = @"支付金额";
    [self.view addSubview:moneyT];
    [moneyT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(typeT.mas_bottom).offset(8);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    UILabel *companyT = [UILabel new];
    companyT.text = @"面试单位";
    [self.view addSubview:companyT];
    [companyT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(moneyT.mas_bottom).offset(15);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    UILabel *addressT = [UILabel new];
    addressT.text = @"面试地址";
    [self.view addSubview:addressT];
    [addressT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(companyT.mas_bottom).offset(8);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    [self.typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeT.mas_right).offset(20);
        make.centerY.equalTo(typeT.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_offset(@30);
    }];
    
    [self.moenyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyT.mas_right).offset(15);
        make.centerY.equalTo(moneyT.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_offset(@30);
    }];
    
    [self.companyTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyT.mas_right).offset(15);
        make.centerY.equalTo(companyT.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_offset(@30);
    }];
    
    [self.addressTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressT.mas_right).offset(15);
        make.centerY.equalTo(addressT.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_offset(@30);
    }];
    
    [self.totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressTxt.mas_bottom).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.size.sizeOffset(CGSizeMake(150, 40));
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
    self.typeLbl.text = self.serve_note;
    self.moenyLbl.text = @"￥100";
}

- (void)clickCancelBtn{
    //取消
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickOrderBtn{
    //下单/*request={ " serve_id ":100171  " name ":面试单位1  " address ":面试地址1  " serve_notes ":求职类别1  " pay_moeny ":100*/
    
    if (kStringIsEmpty(self.companyTxt.text) || kStringIsEmpty(self.addressTxt.text)) {
        [PublicMethod showAlert:self message:@"请输入完整信息"];
    } else {
        NSDictionary *paramDict = @{@"token":@"addOrderRecr",
                                    @"serve_id":self.serve_id,
                                    @"name":self.companyTxt.text,
                                    @"address":self.addressTxt.text,
                                    @"serve_notes":self.serve_note,
                                    @"pay_moeny":@"100"};
        
        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ORDERURL params:paramDict andSuccessBlock:^(id responseObj) {
            
            if (kStringIsEmpty(responseObj[@"error"])) {
                PaymentViewController *paymentVC = [[PaymentViewController alloc] init];
                paymentVC.order_id = responseObj[@"data"][@"order_id"];
                [self.navigationController pushViewController:paymentVC animated:YES];
                
            } else {
                
                [PublicMethod showAlert:self message:responseObj[@"error"]];
            }
        } andFailedBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"人才预定error");
        } andIsHUD:NO];
    }
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.addressTxt resignFirstResponder];
    [self.companyTxt resignFirstResponder];
}

#pragma mark - initUI -
- (UILabel *)typeLbl{
    if (!_typeLbl) {
        _typeLbl = [UILabel new];
        [self.view addSubview:_typeLbl];
    }
    return _typeLbl;
}

- (UILabel *)moenyLbl{
    if (!_moenyLbl) {
        _moenyLbl = [UILabel new];
        [self.view addSubview:_moenyLbl];
    }
    return _moenyLbl;
}

- (UITextField *)companyTxt{
    if (!_companyTxt) {
        _companyTxt = [UITextField new];
        _companyTxt.placeholder = @"请输入面试单位";
        [self.view addSubview:_companyTxt];
    }
    return _companyTxt;
}

- (UITextField *)addressTxt{
    if (!_addressTxt) {
        _addressTxt = [UITextField new];
        _addressTxt.placeholder = @"请输入面试地址";
        [self.view addSubview:_addressTxt];
    }
    return _addressTxt;
}

- (UILabel *)totalLbl {
    if (!_totalLbl) {
        _totalLbl = [UILabel new];
        _totalLbl.text = @"合计：￥100";
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
