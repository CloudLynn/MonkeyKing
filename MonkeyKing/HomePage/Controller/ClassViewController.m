//
//  ClassViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/13.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "ClassViewController.h"
#import "MainDataModel.h"
#import "ClassTableViewCell.h"
#import "ClassTypeViewController.h"
#import "TransportViewController.h"

@interface ClassViewController ()<UITableViewDelegate,UITableViewDataSource>

///提示
@property (nonatomic, strong) UILabel *promptLbl;
///分类
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *classArray;


@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    [self initializeDataSource];
}

- (void)initializeUserInterface{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = _classTitle;
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
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.promptLbl.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    
    [self.tableView registerClass:[ClassTableViewCell class] forCellReuseIdentifier:@"classCell"];
    
}

- (void)initializeDataSource{
//    NSDictionary *dict = [MainDataModel returnPromptText:_type_id];
//    self.promptLbl.text = dict[@"data"][@"text"];
    
    NSString *textUrl = [NSString stringWithFormat:@"%@%@",PROMPTURL,_type_id];
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:textUrl params:nil andSuccessBlock:^(id responseObj) {
        
        self.promptLbl.text = responseObj[@"data"][@"text"];
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"顶级服务类ClassVC error====%@",responseObj);
    } andIsHUD:NO];
    
    
    _classArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@token=getNowSort&id=%@",SORTURL,_type_id];
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:strUrl params:nil andSuccessBlock:^(id responseObj) {
        
        if (kStringIsEmpty(responseObj[@"error"])) {
            _classArray = responseObj[@"data"];
        }
        
        [self.tableView reloadData];
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"顶级服务类ClassVC error====%@",responseObj);
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

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_classArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassTableViewCell *cell = (ClassTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"classCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[ClassTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"classCell"];
    }
    if (!kArrayIsEmpty(_classArray)) {
        NSDictionary *dict = _classArray[indexPath.row];
        cell.classLbl.text = dict[@"state"];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = _classArray[indexPath.row];
    if ([_classTitle isEqualToString:@"旅游交通运输服务"]) {
        TransportViewController *transVC = [[TransportViewController alloc] init];
        transVC.type_id = dict[@"type_two"];
        transVC.title = [NSString stringWithFormat:@"%@名片",dict[@"state"]];
        [self.navigationController pushViewController:transVC animated:YES];
    } else {
        
        ClassTypeViewController *classTypeVC = [[ClassTypeViewController alloc] init];
        classTypeVC.type_two = dict[@"type_two"];
        classTypeVC.title = [NSString stringWithFormat:@"%@名片",dict[@"state"]];
        [self.navigationController pushViewController:classTypeVC animated:YES];
    }
    
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
