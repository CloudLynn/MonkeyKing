//
//  TalentMarketViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/27.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "TalentMarketViewController.h"
#import "TalentHeaderView.h"
#import "ClassTableViewCell.h"
#import "MarketViewController.h"

@interface TalentMarketViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *_typeArray;
    //收缩或展开
    NSMutableDictionary *_dataSourceDict;
}
///提示
@property (nonatomic, strong) UILabel *promptLbl;
///表格
@property (nonatomic, strong) UITableView *marketTableView;

@end

@implementation TalentMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    
    [self initializeDataSource];
    
}

- (void)initializeUserInterface{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSString *title;
    if (ISLOGIN) {
        title = @"立即发布";
    } else {
        title = @"立即登录";
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _promptLbl = [UILabel new];
    _promptLbl.numberOfLines = 0;
    [self.view addSubview:_promptLbl];
    [self.promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(64);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH, 130));
    }];
    
    _marketTableView = [[UITableView alloc] init];
    _marketTableView.delegate = self;
    _marketTableView.dataSource = self;
    [self.view addSubview:_marketTableView];
    [self.marketTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.promptLbl.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    
    [self.marketTableView registerClass:[ClassTableViewCell class] forCellReuseIdentifier:@"classCell"];
    
}

- (void)initializeDataSource{
    _typeArray = [NSMutableArray array];
    //获取服务顶级类
    NSString *strUrl = [NSString stringWithFormat:@"%@token=getNowSort&id=%@",SORTURL,self.type_id];
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:strUrl params:nil andSuccessBlock:^(id responseObj) {
        if (kStringIsEmpty(responseObj[@"error"])) {
            _typeArray = responseObj[@"data"];
            [self.marketTableView reloadData];
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"人才超市error====%@",responseObj);
    } andIsHUD:NO];
    NSString *remindUrl = [NSString stringWithFormat:@"%@%@",PROMPTURL,_type_id];
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:remindUrl params:nil andSuccessBlock:^(id responseObj) {
        if (kStringIsEmpty(responseObj[@"error"])) {
            self.promptLbl.text = responseObj[@"data"][@"text"];
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"提示error====%@",responseObj);
    } andIsHUD:NO];
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

#pragma mark - UITableViewDelegate,UITableViewDatasource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _typeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!kArrayIsEmpty(_typeArray)){
        for (NSDictionary *dict in _typeArray) {
            if ([_typeArray[section][@"state"] isEqualToString:dict[@"state"]]) {
                NSArray *arr = dict[@"down"];
                return arr.count;
            }
        }
    }
    // Return the number of rows in the section.
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    TalentHeaderView *headerView = [[TalentHeaderView alloc] initWithFrame:CGRectZero];
    NSDictionary *dict = _typeArray[section];
    headerView.classLbl.text = dict[@"state"];
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewAction:)];
    headerView.tag = section;
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addGestureRecognizer:taps];
    
    return headerView;
}

//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_dataSourceDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]]) {
        return 30;
    }
    return 0;
}

// 设置组高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ClassTableViewCell *cell = (ClassTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"classCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[ClassTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"classCell"];
    }
    
    NSDictionary *dict = _typeArray[indexPath.section];
    NSArray *arr = dict[@"down"];
    cell.classLbl.text = arr[indexPath.row][@"state"];
    cell.classImgView.hidden = YES;
    //决定子视图的显示范围
    cell.clipsToBounds = YES;
    return cell;
}

//展开收缩cell
-(void)headerViewAction:(UIView*)sender{
    
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    NSInteger didSection = [singleTap view].tag;
    
    
    NSDictionary *dict = _typeArray[didSection];
    NSArray *arr = dict[@"down"];
    
    if (kArrayIsEmpty(arr)) {
        MarketViewController *marketVC = [[MarketViewController alloc] init];
        marketVC.title = dict[@"state"];
        marketVC.ID = dict[@"id"];
        [self.navigationController pushViewController:marketVC animated:YES];
    } else {
        
        if (!_dataSourceDict) {
            _dataSourceDict = [[NSMutableDictionary alloc]init];
        }
        NSString *key  = [NSString stringWithFormat:@"%ld",didSection];
        if (![_dataSourceDict objectForKey:key]) {
            [_dataSourceDict setObject:@"" forKey:key];
        }else{
            [_dataSourceDict removeObjectForKey:key];
        }
        [self.marketTableView reloadSections:[NSIndexSet indexSetWithIndex:didSection] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = _typeArray[indexPath.section];
    NSArray *arr = dict[@"down"];
    MarketViewController *marketVC = [[MarketViewController alloc] init];
    marketVC.title = [NSString stringWithFormat:@"%@名片",dict[@"state"]];
    
    if (kArrayIsEmpty(arr)) {
        
        marketVC.ID = dict[@"id"];
        
    } else {
        
        marketVC.ID = arr[indexPath.row][@"id"];
    }
    [self.navigationController pushViewController:marketVC animated:YES];
    
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
