//
//  OrderDetailViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/3/29.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailTableViewCell.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

///头像
@property (nonatomic, strong) UIImageView *headImgView;
///姓名
@property (nonatomic, strong) UILabel *nameLbl;
///昵称
@property (nonatomic, strong) UILabel *nickNameLbl;
///收货地址
@property (nonatomic, strong) UILabel *addressLbl;
///下单时间
@property (nonatomic, strong) UILabel *timeLbl;
///产品列表
@property (nonatomic, strong) UITableView *productTableView;
///合计金额
@property (nonatomic, strong) UILabel *totalLbl;
///协议金额
@property (nonatomic, strong) UILabel *agreementLbl;

@property (nonatomic, strong) NSArray *productArray;

@property (nonatomic, strong) NSString *headImgUrl;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    [self initializeDataSource];
    
    
}

- (void)initializeUserInterface{
//    _productTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    _productTableView.delegate = self;
//    _productTableView.dataSource = self;
//    [self.view addSubview:_productTableView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"订单详情";
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.view.mas_top).offset(70);
        make.size.sizeOffset(CGSizeMake(70, 70));
    }];
    
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImgSingelAction:)];
    //给图片添加手势
    self.headImgView.userInteractionEnabled = YES;
    [self.headImgView addGestureRecognizer:tapges];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.top.equalTo(self.headImgView.mas_top);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(@30);
    }];
    
    [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(@30);
    }];
    
    [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.headImgView.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(@30);
    }];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.addressLbl.mas_bottom).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(@30);
    }];
    
    [self.agreementLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-55);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.mas_offset(@30);
    }];
    
    [self.totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.bottom.equalTo(self.agreementLbl.mas_top).offset(-5);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.mas_offset(@30);
    }];
    
    [self.productTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.timeLbl.mas_bottom).offset(5);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.totalLbl.mas_top).offset(-5);
    }];
}

- (void)initializeDataSource{
    if (!_productArray) {
        _productArray = [NSArray array];
    }
    //查看订单详情
    //http://api.swktcx.com/A1/order.php?token=getOrderInfo&uid=10000&order_id=103
    NSDictionary *paramDict = @{@"token":@"getOrderInfo",
                                @"uid":USER_UID,
                                @"order_id":_order_id};
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ORDERURL params:paramDict andSuccessBlock:^(id responseObj) {
        if (kStringIsEmpty(responseObj[@"error"])) {
            
            [self.headImgView sd_setImageWithURLString:responseObj[@"data"][@"user_image"] placeholderImage:[UIImage imageNamed:@"user_headImg"]];
            _headImgUrl = responseObj[@"data"][@"user_image"];
            self.nameLbl.text = [NSString stringWithFormat:@"姓名：%@",responseObj[@"data"][@"realname"]];
            self.nickNameLbl.text = [NSString stringWithFormat:@"昵称：%@",responseObj[@"data"][@"nickname"]];
            self.addressLbl.text = [NSString stringWithFormat:@"收货地址：%@",responseObj[@"data"][@"address"]];
            self.timeLbl.text = [NSString stringWithFormat:@"下单时间：%@",responseObj[@"data"][@"addtime"]];
            self.totalLbl.text = [NSString stringWithFormat:@"合计金额：￥%@",responseObj[@"data"][@"total"]];
            self.agreementLbl.text = [NSString stringWithFormat:@"协议金额：￥%@",responseObj[@"data"][@"discount"]];
            _productArray = responseObj[@"data"][@"info"];
            [self.productTableView reloadData];
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"查看订单详情");
    } andIsHUD:NO];
}

#pragma mark - 点击查看大图 -

- (void)headImgSingelAction:(UITapGestureRecognizer *)gestureRecognizer{
    ImgBgView *bgView = [[ImgBgView alloc]initWithFrame:self.view.bounds andImgUrl:_headImgUrl];
    bgView.backgroundColor = [UIColor colorWithRed:41.0/255 green:36.0/255 blue:33.0/255 alpha:0.8];
    [self.view addSubview:bgView];
}

- (void)ImgViewSingelAction:(UITapGestureRecognizer *)gestureRecognizer{
    UIView *v = (UIView *)[gestureRecognizer view];
    NSDictionary *detailDict = [_productArray objectAtIndex:v.tag];
    NSString *url = detailDict[@"image"];
    //创建一个黑色视图做背景
    
    ImgBgView *bgView = [[ImgBgView alloc]initWithFrame:self.view.bounds andImgUrl:url];
    bgView.backgroundColor = [UIColor colorWithRed:41.0/255 green:36.0/255 blue:33.0/255 alpha:0.8];
    [self.view addSubview:bgView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _productArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailTableViewCell *cell = (OrderDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"productCell"];
    if (!cell) {
        cell = [[OrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"productCell"];
    }
    
    NSDictionary *dict = _productArray[indexPath.row];
    [cell setDetailDict:dict];
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImgViewSingelAction:)];
    //给图片添加手势
    cell.proImgView.userInteractionEnabled = YES;
    [cell.proImgView addGestureRecognizer:tapges];
    cell.proImgView.tag = indexPath.row;
    return cell;
}

#pragma mark - initUI -
- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [UIImageView new];
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

- (UILabel *)nickNameLbl{
    if (!_nickNameLbl) {
        _nickNameLbl = [UILabel new];
        [self.view addSubview:_nickNameLbl];
    }
    return _nickNameLbl;
}

- (UILabel *)addressLbl{
    if (!_addressLbl) {
        _addressLbl = [UILabel new];
        [self.view addSubview:_addressLbl];
    }
    return _addressLbl;
}

- (UILabel *)timeLbl{
    if (!_timeLbl) {
        _timeLbl = [UILabel new];
        [self.view addSubview:_timeLbl];
    }
    return _timeLbl;
}

- (UITableView *)productTableView{
    if (!_productTableView) {
        _productTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _productTableView.delegate = self;
        _productTableView.dataSource = self;
        [self.view addSubview:_productTableView];
    }
    return _productTableView;
}

- (UILabel *)totalLbl{
    if (!_totalLbl) {
        _totalLbl = [UILabel new];
        [self.view addSubview:_totalLbl];
    }
    return _totalLbl;
}

- (UILabel *)agreementLbl{
    if (!_agreementLbl) {
        _agreementLbl = [UILabel new];
        [self.view addSubview:_agreementLbl];
    }
    return _agreementLbl;
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
