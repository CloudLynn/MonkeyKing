//
//  MyServiceViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/10.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "MyServiceViewController.h"
#import "MyServiceTableViewCell.h"
#import "CommonReleaseViewController.h"
#import "MyProductViewController.h"
#import "SendResumeViewController.h"
#import "TrafficViewController.h"

@interface MyServiceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *array;

@end

@implementation MyServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    
    [self initializeDataSource];
    
}

- (void)initializeUserInterface{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"我的发布";
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    
    [self.tableView registerClass:[MyServiceTableViewCell class] forCellReuseIdentifier:@"myServiceCell"];
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)initializeDataSource{
    if (!_array) {
        _array = [NSArray array];
    }
    
    //http://api.swktcx.com/A1/serve.php?token=getAllServe&uid=100001
    NSDictionary *paramDic = @{@"token":@"getAllServe",
                               @"uid":USER_UID};
//    NSString *strUrl = [NSString stringWithFormat:@"%@token=getAllServe&uid=%@",SERVEURL,USER_UID];
    [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:SERVEURL params:paramDic andSuccessBlock:^(id responseObj) {
        if (kStringIsEmpty(responseObj[@"error"])) {
            _array = responseObj[@"data"];
            [self.tableView reloadData];
        } else {
            [PublicMethod showAlert:self message:responseObj[@"error"]];
        }
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
    } andIsHUD:NO];
    
}

#pragma mark - UITableViewDelegate,UITableViewSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyServiceTableViewCell *cell = (MyServiceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"myServiceCell"];
    if (!cell) {
        cell = [[MyServiceTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"myServiceCell"];
    }
    
    NSDictionary *dict = _array[indexPath.row];
    [cell setDictionary:dict];
    
    cell.setBtn.tag = indexPath.row;
    [cell.setBtn addTarget:self action:@selector(clickSetBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.delBtn.tag = indexPath.row;
    [cell.delBtn addTarget:self action:@selector(clickDelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = _array[indexPath.row];
    if ([dict[@"type_one"] isEqualToString:@"5"]){
        
        TrafficViewController *trafficVC = [[TrafficViewController alloc] init];
        trafficVC.type_one = dict[@"type_one"];
        trafficVC.serve_id = dict[@"serve_id"];
        trafficVC.action_type = @"update";
        [self.navigationController pushViewController:trafficVC animated:YES];
        
    } else if( [dict[@"type_one"] isEqualToString:@"294"]) {
        //人才超市:294
        SendResumeViewController *sendVC = [[SendResumeViewController alloc] init];
        sendVC.type_id = dict[@"type_one"];
        sendVC.title = dict[@"state"];
        sendVC.actionType = @"update";
        sendVC.serve_id = dict[@"serve_id"];
        [self.navigationController pushViewController:sendVC animated:YES];
    } else {
        MyProductViewController *productVC = [[MyProductViewController alloc] init];
        productVC.serve_id = dict[@"serve_id"];
        productVC.type_two = dict[@"type_two"];
        [self.navigationController pushViewController:productVC animated:YES];
    }
}

- (void)clickSetBtn:(UIButton *)button{
    NSLog(@"修改");
    NSDictionary *dict = _array[button.tag];
    if ([dict[@"type_one"] isEqualToString:@"5"]){
        
        TrafficViewController *trafficVC = [[TrafficViewController alloc] init];
        trafficVC.type_one = dict[@"type_one"];
        trafficVC.serve_id = dict[@"serve_id"];
        trafficVC.action_type = @"update";
        [self.navigationController pushViewController:trafficVC animated:YES];
        
    } else if( [dict[@"type_one"] isEqualToString:@"294"]) {
        //人才超市:294
        SendResumeViewController *sendVC = [[SendResumeViewController alloc] init];
        sendVC.type_id = dict[@"type_one"];
        sendVC.title = dict[@"state"];
        sendVC.actionType = @"update";
        sendVC.serve_id = dict[@"serve_id"];
        [self.navigationController pushViewController:sendVC animated:YES];
    }else {
        CommonReleaseViewController *commonVC = [[CommonReleaseViewController alloc] init];
        commonVC.serve_id = dict[@"serve_id"];
        commonVC.type_one = dict[@"type_one"];
        commonVC.type_two = dict[@"type_two"];
        commonVC.actionType = @"update";
        [self.navigationController pushViewController:commonVC animated:YES];
    }
    
    
}

- (void)clickDelBtn:(UIButton *)button{
    NSLog(@"删除服务");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要删除该服务吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        //删除服务
        //http://api.swktcx.com/A1/serve.php?token=removeServe&serve_id=22
        
        NSDictionary *dict = _array[button.tag];
        NSDictionary *paramDict = @{@"token":@"removeServe",
                                    @"uid":USER_UID,
                                    @"serve_id":dict[@"serve_id"],};
        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:SERVEURL params:paramDict andSuccessBlock:^(id responseObj) {
            if ([responseObj[@"data"] isEqualToString:@"操作成功"]) {
                [PublicMethod showAlert:self message:@"已删除"];
                [self initializeDataSource];
            } else {
                [PublicMethod showAlert:self message:@"删除失败，请稍后重试"];
            }
        } andFailedBlock:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"删除失败error");
        } andIsHUD:NO];
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:delAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
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
