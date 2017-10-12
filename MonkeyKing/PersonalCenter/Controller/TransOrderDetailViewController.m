//
//  TransOrderDetailViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/6/14.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "TransOrderDetailViewController.h"

@interface TransOrderDetailViewController ()

///头像
@property (nonatomic, strong) UIImageView *headImgView;
///姓名
@property (nonatomic, strong) UILabel *nameLbl;
///昵称
@property (nonatomic, strong) UILabel *nicknameLbl;
///起点位置
@property (nonatomic, strong) UILabel *beginPLbl;
///终点位置
@property (nonatomic, strong) UILabel *endPLbl;
///下单时间
@property (nonatomic, strong) UILabel *orderTimeLbl;

///起步价
@property (nonatomic, strong) UILabel *startPLbl;
///乘运价
@property (nonatomic, strong) UILabel *transPLbl;

///里程
@property (nonatomic, strong) UILabel *distanceLbl;

///输入协议价
@property (nonatomic, strong) UILabel *agreeMLbl;
///合计
@property (nonatomic, strong) UILabel *totalLbl;
@end

@implementation TransOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeUserInterface];
    
    [self initializeDataSource];
    
}

- (void)initializeUserInterface{
    
    self.navigationItem.title = @"订单详情";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    UILabel *orderTitle = [UILabel new];
//    orderTitle.text = @"订单详情";
//    orderTitle.font = [UIFont systemFontOfSize:15.0 weight:1.5];
//    [self.view addSubview:orderTitle];
//    
//    [orderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.top.equalTo(self.view.mas_top).offset(70);
//        make.size.sizeOffset(CGSizeMake(100, 35));
//    }];
    
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
    
    UILabel *beginTitle = [UILabel new];
    beginTitle.text = @"起点位置";
    [self.view addSubview:beginTitle];
    [beginTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(nickNameTitle.mas_bottom).offset(20);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    UILabel *endTitle = [UILabel new];
    endTitle.text = @"终点位置";
    [self.view addSubview:endTitle];
    [endTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(beginTitle.mas_bottom).offset(8);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    UILabel *timeTitle = [UILabel new];
    timeTitle.text = @"下单时间";
    [self.view addSubview:timeTitle];
    [timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(endTitle.mas_bottom).offset(8);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    [self.beginPLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beginTitle.mas_right).offset(15);
        make.centerY.equalTo(beginTitle.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
    [self.endPLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endTitle.mas_right).offset(15);
        make.centerY.equalTo(endTitle.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
    [self.orderTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeTitle.mas_right).offset(15);
        make.centerY.equalTo(timeTitle.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
    UILabel *detailTitle = [UILabel new];
    detailTitle.text = @"服务信息";
    detailTitle.font = [UIFont systemFontOfSize:15.0 weight:1.5];
    [self.view addSubview:detailTitle];
    
    [detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.orderTimeLbl.mas_bottom).offset(20);
        make.size.sizeOffset(CGSizeMake(100, 35));
    }];
    
    UILabel *startTitle = [UILabel new];
    startTitle.text = @"起步价";
    [self.view addSubview:startTitle];
    [startTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(detailTitle.mas_bottom).offset(15);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    UILabel *transTitle = [UILabel new];
    transTitle.text = @"乘运价";
    [self.view addSubview:transTitle];
    [transTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(startTitle.mas_bottom).offset(8);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    UILabel *distanceTitle = [UILabel new];
    distanceTitle.text = @"里程";
    [self.view addSubview:distanceTitle];
    [distanceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(transTitle.mas_bottom).offset(8);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    UILabel *totalTitle = [UILabel new];
    totalTitle.text = @"合计金额";
    [self.view addSubview:totalTitle];
    [totalTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(distanceTitle.mas_bottom).offset(8);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    UILabel *agreeTitle = [UILabel new];
    agreeTitle.text = @"协议价";
    [self.view addSubview:agreeTitle];
    [agreeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(totalTitle.mas_bottom).offset(8);
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
    
    [self.distanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(distanceTitle.mas_right).offset(15);
        make.centerY.equalTo(distanceTitle.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
    [self.totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totalTitle.mas_right).offset(15);
        make.centerY.equalTo(totalTitle.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
    [self.agreeMLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agreeTitle.mas_right).offset(15);
        make.centerY.equalTo(agreeTitle.mas_centerY);
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
            NSLog(@"%@",responseObj);
            [self.headImgView sd_setImageWithURLString:responseObj[@"data"][@"user_image"] placeholderImage:[UIImage imageNamed:@"user_headImg"]];
            self.nameLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"realname"]];
            self.nicknameLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"nickname"]];
            self.beginPLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"buyer_address"]];
            self.endPLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"seller_address"]];
            self.orderTimeLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"addtime"]];
            self.startPLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"serve"][@"start"]];
            self.transPLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"serve"][@"course"]];
            self.distanceLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"serve"][@"length"]];
            self.totalLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"serve"][@"total"]];
            self.agreeMLbl.text = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"serve"][@"discount"]];
            
            
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"查看交通订单详情");
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

- (UILabel *)beginPLbl{
    if (!_beginPLbl) {
        _beginPLbl = [UILabel new];
        [self.view addSubview:_beginPLbl];
    }
    return _beginPLbl;
}

- (UILabel *)endPLbl{
    if (!_endPLbl) {
        _endPLbl = [UILabel new];
        [self.view addSubview:_endPLbl];
    }
    return _endPLbl;
}


- (UILabel *)orderTimeLbl{
    if (!_orderTimeLbl) {
        _orderTimeLbl = [UILabel new];
        [self.view addSubview:_orderTimeLbl];
    }
    return _orderTimeLbl;
}

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

- (UILabel *)distanceLbl{
    if (!_distanceLbl) {
        _distanceLbl = [UILabel new];
        [self.view addSubview:_distanceLbl];
    }
    return _distanceLbl;
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
