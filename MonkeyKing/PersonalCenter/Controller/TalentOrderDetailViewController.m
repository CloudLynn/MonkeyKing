//
//  TalentOrderDetailViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/6/14.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "TalentOrderDetailViewController.h"

@interface TalentOrderDetailViewController ()
///头像
@property (nonatomic, strong) UIImageView *headImgView;
///姓名
@property (nonatomic, strong) UILabel *nameLbl;
///昵称
@property (nonatomic, strong) UILabel *nicknameLbl;
///求职类别
@property (nonatomic, strong) UILabel *jobTypeLbl;
///面试单位
@property (nonatomic, strong) UILabel *companyLbl;
///面试地址
@property (nonatomic, strong) UILabel *addressLbl;
///下单时间
@property (nonatomic, strong) UILabel *ordertimeLbl;
///合计金额
@property (nonatomic, strong) UILabel *moneyLbl;
@end

@implementation TalentOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeUserInterface];
    
    [self initializeDataSource];
    
}

- (void)initializeUserInterface{
    self.navigationItem.title = @"订单详情";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.view.mas_top).offset(70);
        make.size.sizeOffset(CGSizeMake(60, 60));
    }];
    
    UILabel *nameTitle = [UILabel new];
    nameTitle.text = @"姓名";
    [self.view addSubview:nameTitle];
    [nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.top.equalTo(self.headImgView.mas_top);
        make.size.sizeOffset(CGSizeMake(60, 30));
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameTitle.mas_right).offset(15);
        make.centerY.equalTo(nameTitle.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
    UILabel *nickNameTitle = [UILabel new];
    nickNameTitle.text = @"昵称";
    [self.view addSubview:nickNameTitle];
    [nickNameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.top.equalTo(nameTitle.mas_bottom).offset(8);
        make.size.sizeOffset(CGSizeMake(60, 30));
    }];
    
    [self.nicknameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickNameTitle.mas_right).offset(15);
        make.centerY.equalTo(nickNameTitle.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
//    NSArray *titleArray = @[@"求职类别",@"面试单位",@"面试地址",@"下单时间",@"合计金额"];
//    ui
//    for (int i = 0; i < titleArray.count; i ++) {
//        UILabel *lable = [UILabel new];
//        lable.text = titleArray[i];
//        [self.view addSubview:lable];
//        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.view.mas_left).offset(20);
//            make.top.equalTo(nickNameTitle.mas_bottom).offset(
//        }];
//    }
    UILabel *typeLabel = [UILabel new];
    typeLabel.text = @"求职类别";
    [self.view addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(nickNameTitle.mas_bottom).offset(20);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    UILabel *companyLabel = [UILabel new];
    companyLabel.text = @"面试单位：";
    [self.view addSubview:companyLabel];
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(typeLabel.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    UILabel *addressLabel = [UILabel new];
    addressLabel.text = @"面试地址：";
    [self.view addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(companyLabel.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.text = @"下单时间：";
    [self.view addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(addressLabel.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    UILabel *totalLabel = [UILabel new];
    totalLabel.text = @"合计金额：";
    [self.view addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(timeLabel.mas_bottom).offset(20);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    [self.jobTypeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLabel.mas_right).offset(15);
        make.centerY.equalTo(typeLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
    [self.companyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyLabel.mas_right).offset(15);
        make.centerY.equalTo(companyLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
    [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLabel.mas_right).offset(15);
        make.centerY.equalTo(addressLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
    [self.ordertimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right).offset(15);
        make.centerY.equalTo(timeLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
    [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totalLabel.mas_right).offset(15);
        make.centerY.equalTo(totalLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
}

- (void)initializeDataSource{
    //http://api.swktcx.com/A1/order.php?token=getOrderInfo&uid=10000&order_id=103
    NSDictionary *paramDic = @{@"token":@"getOrderInfo",
                               @"order_id":_order_id};
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ORDERURL params:paramDic andSuccessBlock:^(id responseObj) {
        if (kStringIsEmpty(responseObj[@"error"])) {
            NSLog(@"%@",responseObj[@"data"]);
 
            [self.headImgView sd_setImageWithURLString:responseObj[@"data"][@"user_image"] placeholderImage:[UIImage imageNamed:@"user_headImg"]];
            self.nameLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"realname"]];
            self.nicknameLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"nickname"]];
            self.jobTypeLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"type"]];
            self.companyLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"name"]];
            self.addressLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"address"]];
            self.ordertimeLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"addtime"]];
            self.moneyLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"total"]];
            
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"查看人才订单详情");
    } andIsHUD:NO];
}

#pragma mark - initUI - 

- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [UIImageView new];
        _headImgView.layer.cornerRadius = 30;
        _headImgView.layer.masksToBounds = YES;
        [self.view addSubview:_headImgView];
    }
    return _headImgView;
}

- (UILabel *)nameLbl{
    if (!_nameLbl) {
        _nameLbl = [UILabel new];
        [self.view addSubview:_nameLbl];
    }
    return _nameLbl;
}

- (UILabel *)nicknameLbl{
    if (!_nicknameLbl) {
        _nicknameLbl = [UILabel new];
        [self.view addSubview:_nicknameLbl];
    }
    return _nicknameLbl;
}

- (UILabel *)jobTypeLbl{
    if (!_jobTypeLbl) {
        _jobTypeLbl = [UILabel new];
        [self.view addSubview:_jobTypeLbl];
    }
    return _jobTypeLbl;
}

- (UILabel *)companyLbl{
    if (!_companyLbl) {
        _companyLbl = [UILabel new];
        [self.view addSubview:_companyLbl];
    }
    return _companyLbl;
}

- (UILabel *)addressLbl{
    if (!_addressLbl) {
        _addressLbl = [UILabel new];
        [self.view addSubview:_addressLbl];
    }
    return _addressLbl;
}

- (UILabel *)ordertimeLbl{
    if (!_ordertimeLbl) {
        _ordertimeLbl = [UILabel new];
        [self.view addSubview:_ordertimeLbl];
    }
    return _ordertimeLbl;
}

- (UILabel *)moneyLbl{
    if (!_moneyLbl) {
        _moneyLbl = [UILabel new];
        [self.view addSubview:_moneyLbl];
    }
    return _moneyLbl;
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
