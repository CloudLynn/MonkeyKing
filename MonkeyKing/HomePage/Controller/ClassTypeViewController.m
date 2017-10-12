//
//  ClassTypeViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/14.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "ClassTypeViewController.h"
#import "ClassTypeTableViewCell.h"
#import "TypeDetailViewController.h"
#import "MapShowViewController.h"

@interface ClassTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *typeTableView;

@property (nonatomic, strong) NSMutableArray *typeArray;

@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation ClassTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNumber = 1;
    [self initializeUserInterface];
    [self initializeDataSource];
   
}

- (void)initializeUserInterface{
    
    [self.typeTableView registerClass:[ClassTypeTableViewCell class] forCellReuseIdentifier:@"typeCell"];
    
    //下拉刷新,上拉加载
    self.typeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNumber = 1;
        [self initializeDataSource];
        [self.typeTableView.mj_header endRefreshing];
    }];
    
    self.typeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNumber = _pageNumber+1;
        [self initializeDataSource];
        [self.typeTableView.mj_footer endRefreshing];
    }];
    
}

- (UITableView *)typeTableView{
    if (!_typeTableView) {
        _typeTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_typeTableView];
        _typeTableView.delegate = self;
        _typeTableView.dataSource = self;
    }
    return _typeTableView;
}

- (void)initializeDataSource{
    
    if (!_typeArray) {
        _typeArray = [NSMutableArray arrayWithCapacity:0];
    }
    
//    NSString *typeUrl = @"http://api.swktcx.com/A1/serve.php?token=commonPage&type_two=230&page=1&lng=106.484686&lat=29.531369";
    NSDictionary *paramsDict = @{@"token":@"commonPage",
                                 @"type_two":_type_two,
                                 @"page":@(_pageNumber),
                                 @"lng":USER_LNG,
                                 @"lat":USER_LAT,};
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:SERVEURL params:paramsDict andSuccessBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if (kStringIsEmpty(responseObj[@"error"])) {
            _typeArray = responseObj[@"data"];
            [self.typeTableView reloadData];
        } else {
//            [PublicMethod showAlert:self message:responseObj[@"error"]];
        }
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
    } andIsHUD:NO];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _typeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
    if (!cell) {
        cell = [[ClassTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"typeCell"];
    }
    
    NSDictionary *dict = _typeArray[indexPath.row];
    [cell setContentDictionary:dict];
    
    cell.distanceLbl.userInteractionEnabled = YES;
    cell.distanceLbl.tag = indexPath.row;
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMapShow:)];
    [cell.distanceLbl addGestureRecognizer:tapges];
    
    return cell;
}

- (void)clickMapShow:(UITapGestureRecognizer *)gestureRecognizer{
    
    UIView *v = (UIView *)[gestureRecognizer view];
    
    NSDictionary *dict = _typeArray[v.tag];
    MapShowViewController *mapVC = [[MapShowViewController alloc] init];
    mapVC.latitude = [dict[@"lat"] doubleValue];
    mapVC.longitude = [dict[@"lng"] doubleValue];
    [self.navigationController pushViewController:mapVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TypeDetailViewController *detailVC = [[TypeDetailViewController alloc] init];
    NSDictionary *dict = _typeArray[indexPath.row];
    detailVC.serve_id = dict[@"serve_id"];
    detailVC.title = @"详情";
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
