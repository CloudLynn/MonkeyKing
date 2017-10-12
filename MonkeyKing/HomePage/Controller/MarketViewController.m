//
//  MarketViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/28.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "MarketViewController.h"
#import "TalentTableViewCell.h"
#import "MarketDetailViewController.h"

@interface MarketViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) UILabel *promptLbl;
@property (nonatomic, strong) UITableView *marketTableView;
@property (nonatomic, strong) NSArray *marketArray;
@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation MarketViewController

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
    
//    _promptLbl = [UILabel new];
//    _promptLbl.numberOfLines = 0;
//    [self.view addSubview:_promptLbl];
//    [self.promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(0);
//        make.top.equalTo(self.view.mas_top).offset(64);
//        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH, 130));
//    }];
    
    _marketTableView = [[UITableView alloc] init];
    _marketTableView.delegate = self;
    _marketTableView.dataSource = self;
    [self.view addSubview:_marketTableView];
    [self.marketTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    
    [self.marketTableView registerClass:[TalentTableViewCell class] forCellReuseIdentifier:@"talentCell"];
    
    //下拉刷新,上拉加载
    self.marketTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNumber = 1;
        [self initializeDataSource];
        [self.marketTableView.mj_header endRefreshing];
    }];
    
    self.marketTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNumber = _pageNumber+1;
        [self initializeDataSource];
        [self.marketTableView.mj_footer endRefreshing];
    }];
    
}

- (void)initializeDataSource{
    //http://api.swktcx.com/A1/serve.php?token=recrPage&p=1&id=319
    
    if (!_marketArray) {
        _marketArray = [NSArray array];
    }
    //http://api.swktcx.com/A1/serve.php?token=recrPage&page=1&id=305&lng=106.484686&lat=29.531369
    NSDictionary *paramDic = @{@"token":@"recrPage",
                               @"page":@(_pageNumber),
                               @"id":_ID,
                               @"lng":USER_LNG,
                               @"lat":USER_LAT};
    
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:SERVEURL params:paramDic andSuccessBlock:^(id responseObj) {
        if (kStringIsEmpty(responseObj[@"error"])) {
            _marketArray = responseObj[@"data"];
            [self.marketTableView reloadData];
        } else {
            [PublicMethod showAlert:self message:responseObj[@"error"]];
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
    } andIsHUD:NO];
    
//    NSString *textUrl = [NSString stringWithFormat:@"%@%@",PROMPTURL,_ID];
//    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:textUrl params:nil andSuccessBlock:^(id responseObj) {
//        NSLog(@"%@",responseObj);
//        if (kStringIsEmpty(responseObj[@"error"])) {
//            self.promptLbl.text = responseObj[@"data"][@"text"];
//        } else {
//            [PublicMethod showAlert:self message:responseObj[@"error"]];
//        }
//        
//        
//    } andFailedBlock:^(id responseObj) {
//        NSLog(@"%@",responseObj);
//        NSLog(@"顶级服务类MarketVC error====%@",responseObj);
//    } andIsHUD:NO];
    
}

- (void)clickRightItem{
    if (ISLOGIN) {
        //        NSLog(@"已经登录");
        ReleaseViewController *releaseVC = [[ReleaseViewController alloc] init];
        [self.navigationController pushViewController:releaseVC animated:YES];
        
    } else {
        //        NSLog(@"没有登录");
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _marketArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 116;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TalentTableViewCell *cell = (TalentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"talentCell"];
    if (!cell) {
        cell = [[TalentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"talentCell"];
    }
    
    NSDictionary *marketDict = _marketArray[indexPath.row];
    [cell setMarketDict:marketDict];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = _marketArray[indexPath.row];
    
    MarketDetailViewController *detailVC = [[MarketDetailViewController alloc] init];
    detailVC.serve_id = dict[@"serve_id"];
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
