//
//  TransportViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/3/15.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "TransportViewController.h"
#import "TransportTableViewCell.h"
#import "TransDetailViewController.h"

@interface TransportViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *transTableView;

@property (nonatomic, strong) NSArray *transArray;

@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation TransportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageNumber = 1;
    
    [self initializeUserInterface];
    
    [self initializeDataSource];
    
}

- (void)initializeUserInterface{
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *title;
    if (ISLOGIN) {
        title = @"立即发布";
    } else {
        title = @"立即登录";
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _transTableView = [[UITableView alloc] init];
    _transTableView.delegate = self;
    _transTableView.dataSource = self;
    [self.view addSubview:_transTableView];
    [self.transTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    
    [self.transTableView registerClass:[TransportTableViewCell class] forCellReuseIdentifier:@"transCell"];
    
    //下拉刷新,上拉加载
    self.transTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNumber = 1;
        [self initializeDataSource];
        [self.transTableView.mj_header endRefreshing];
    }];
    
    self.transTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNumber = _pageNumber+1;
        [self initializeDataSource];
        [self.transTableView.mj_footer endRefreshing];
    }];
}

- (void)initializeDataSource{
    if (!_transArray) {
        _transArray = [NSArray new];
    }
    
    //http://api.swktcx.com/A1/serve.php?token=tourPage&id=70&page=1&lng=106.484686&lat=29.531369
    NSDictionary *paramDic = @{@"token":@"tourPage",
                               @"id":_type_id,
                               @"page":@(_pageNumber),
                               @"lng":USER_LNG,
                               @"lat":USER_LAT,};
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:SERVEURL params:paramDic andSuccessBlock:^(id responseObj) {
        if (kStringIsEmpty(responseObj[@"error"])) {
            _transArray = responseObj[@"data"];
            [self.transTableView reloadData];
        } else {
            [PublicMethod showAlert:self message:responseObj[@"error"]];
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"transport error");
    } andIsHUD:NO];
    
    
}
- (void)clickRightItem{
    if (ISLOGIN) {
        //        NSLog(@"已经登录");
        
        
    } else {
        //        NSLog(@"没有登录");
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

#pragma mark - UITableViewDelegate,UITableViewSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _transArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransportTableViewCell *cell = (TransportTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"transCell"];
    if (!cell) {
        cell = [[TransportTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"transCell"];
    }
    
    NSDictionary *dic = _transArray[indexPath.row];
    [cell setTransDict:dic];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _transArray[indexPath.row];
    TransDetailViewController *detailVC = [[TransDetailViewController alloc] init];
    detailVC.serve_id = dic[@"serve_id"];
    detailVC.title = @"详情";//self.title;
    [self.navigationController pushViewController:detailVC animated:YES];
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
