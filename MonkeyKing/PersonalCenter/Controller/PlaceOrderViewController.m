//
//  PlaceOrderViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/14.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "PlaceOrderViewController.h"
#import "PaymentViewController.h"
#import "CartModel.h"

@interface PlaceOrderViewController ()
///服务名称
@property (nonatomic, strong) UILabel *serviceLbl;
///价格
@property (nonatomic, strong) UILabel *priceLbl;
///协议价
@property (nonatomic, strong) UITextField *agreenmentTxt;
///购买者名称
@property (nonatomic, strong) UITextField *buyerTxt;
///服务地址
@property (nonatomic, strong) UITextField *addressTxt;
///合计
@property (nonatomic, strong) UILabel *totalLbl;
///取消
@property (nonatomic, strong) UIButton *cancelBtn;
///确认下单
@property (nonatomic, strong) UIButton *commitBtn;

@end

@implementation PlaceOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    [self initializeDataSource];
    
}

- (void)initializeUserInterface{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"下单";
    
    NSArray *titleArr = @[@"服务名称",@"金额",@"协议价",@"购买者名称",@"服务地址"];
    for (int i =0;i<titleArr.count;i++) {
        UILabel *titleLbl = [UILabel new];
        titleLbl.text = titleArr[i];
        [self.view addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(8);
            make.top.equalTo(self.view.mas_top).offset(50*i+74);
            make.size.sizeOffset(CGSizeMake(100, 30));
        }];
        UILabel *lineLbl = [UILabel new];
        lineLbl.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:lineLbl];
        [lineLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.bottom.equalTo(titleLbl.mas_bottom).offset(10);
            make.height.mas_offset(@1);
        }];
    }
    
    [self.serviceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(120);
        make.top.equalTo(self.view.mas_top).offset(74);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_offset(@30);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(120);
        make.top.equalTo(self.serviceLbl.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_offset(@30);
    }];
    
    [self.agreenmentTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(120);
        make.top.equalTo(self.priceLbl.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.mas_offset(@30);
    }];
    UILabel *disCountLbl = [UILabel new];
    disCountLbl.text = @"元";
    disCountLbl.font = FONT_15;
    [self.view addSubview:disCountLbl];
    [disCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreenmentTxt.mas_right).offset(5);
        make.centerY.equalTo(self.agreenmentTxt.mas_centerY);
        make.size.sizeOffset(CGSizeMake(30, 30));
    }];
    
    [self.buyerTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(120);
        make.top.equalTo(self.agreenmentTxt.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_offset(@30);
    }];
    
    [self.addressTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(120);
        make.top.equalTo(self.buyerTxt.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_offset(@30);
    }];
    
    [self.totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressTxt.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.size.sizeOffset(CGSizeMake(240, 30));
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-64);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH/2-40, 40));
    }];
    
    [self.cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-64);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH/2-40, 40));
    }];
    
    [self.commitBtn addTarget:self action:@selector(clickCommitBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initializeDataSource{
    
    _serviceLbl.text = _serviceName;
    _priceLbl.text = _orderDict[@"pay_moeny"];
    _totalLbl.text = [NSString stringWithFormat:@"合计：%@",_orderDict[@"pay_moeny"]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@token=get_user&uid=%@",USERURL,USER_UID];
    
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:urlStr params:nil andSuccessBlock:^(id responseObj) {
        if (kStringIsEmpty(responseObj[@"error"])) {
            NSLog(@"%@",responseObj);
            self.buyerTxt.text = responseObj[@"data"][@"realname"];
            self.addressTxt.text = responseObj[@"data"][@"address"];
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
    } andIsHUD:NO];
    
}

- (void)clickCancelBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickCommitBtn{
    
//    CGFloat discount = [self.agreenmentTxt.text doubleValue];
    
    if (kStringIsEmpty(self.buyerTxt.text) || kStringIsEmpty(self.addressTxt.text)) {
        [PublicMethod showAlert:self message:@"请填写完整您的信息"];
    } else if(kStringIsEmpty(self.agreenmentTxt.text)){
//        [PublicMethod showAlert:self message:@"请填写和商家协商的价格"];
        self.agreenmentTxt.text = _orderDict[@"pay_moeny"];
    } else {
        
        [_orderDict setObject:self.agreenmentTxt.text forKey:@"discount"];
        [_orderDict setObject:self.buyerTxt.text forKey:@"buyer_name"];
        [_orderDict setObject:self.addressTxt.text forKey:@"buyer_address"];
        [_orderDict setObject:@"addOrder" forKey:@"token"];
        //http://api.swktcx.com/A1/order.php?token=addOrder&uid=10000&serve_id=242&buyer_address=a服务地址&pay_moeny=200&discount=1.0&serve_notes=暂时不管的描述&buyer_name=买家名称&info[0][info_id]=28&info[0][product_name]=2名称包月清洁&info[0][product_cost]=100&info[0][product_count]=2
        
        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ORDERURL params:_orderDict andSuccessBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            if (kStringIsEmpty(responseObj[@"error"])) {
                PaymentViewController *paymentVC = [[PaymentViewController alloc] init];
                paymentVC.order_id = responseObj[@"data"][@"order_id"];
                [self.navigationController pushViewController:paymentVC animated:YES];

            } else {
                
                [PublicMethod showAlert:self message:responseObj[@"error"]];
                
            }
        } andFailedBlock:^(id responseObj) {
            
        } andIsHUD:NO];
        
    }
    
}

#pragma mark - initUI -

- (UILabel *)serviceLbl{
    if (!_serviceLbl) {
        _serviceLbl = [UILabel new];
        _serviceLbl.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_serviceLbl];
    }
    return _serviceLbl;
}

- (UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [UILabel new];
        _priceLbl.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_priceLbl];
    }
    return _priceLbl;
}

- (UITextField *)agreenmentTxt{
    if (!_agreenmentTxt) {
        _agreenmentTxt = [UITextField new];
        _agreenmentTxt.textAlignment = NSTextAlignmentRight;
        _agreenmentTxt.keyboardType = UIKeyboardTypeDecimalPad;
        _agreenmentTxt.placeholder = @"请填写和商家协商的价格";
        [self.view addSubview:_agreenmentTxt];
    }
    return _agreenmentTxt;
}

- (UITextField *)buyerTxt{
    if (!_buyerTxt) {
        _buyerTxt = [UITextField new];
        _buyerTxt.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_buyerTxt];
    }
    return _buyerTxt;
}

- (UITextField *)addressTxt{
    if (!_addressTxt) {
        _addressTxt = [UITextField new];
        _addressTxt.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_addressTxt];
    }
    return _addressTxt;
}

- (UILabel *)totalLbl{
    if (!_totalLbl) {
        _totalLbl = [UILabel new];
        _totalLbl.text = @"服务名称";
        _totalLbl.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_totalLbl];
    }
    return _totalLbl;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _cancelBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
        _cancelBtn.layer.borderWidth = 1.0f;
        _cancelBtn.layer.cornerRadius = 5.0f;
        _cancelBtn.layer.masksToBounds = YES;
        [self.view addSubview:_cancelBtn];
    }
    return _cancelBtn;
}

- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [UIButton new];
        [_commitBtn setTitle:@"确认下单" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _commitBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
        _commitBtn.layer.borderWidth = 1.0f;
        _commitBtn.layer.cornerRadius = 5.0f;
        _commitBtn.layer.masksToBounds = YES;
        [self.view addSubview:_commitBtn];
    }
    return _commitBtn;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.agreenmentTxt resignFirstResponder];
    [self.buyerTxt resignFirstResponder];
    [self.addressTxt resignFirstResponder];
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
