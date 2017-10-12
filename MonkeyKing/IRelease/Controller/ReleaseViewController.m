//
//  ReleaseViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/3/2.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "ReleaseViewController.h"
#import "MainView.h"
#import "SendResumeViewController.h"
#import "CommonReleaseViewController.h"
#import "BusinessServiceViewController.h"
#import "TrafficViewController.h"
#import "LearnViewController.h"

@interface ReleaseViewController ()<MainDelegate>
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) NSMutableArray *headerArray;
@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) NSMutableArray *rightArray;
@end

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    [self initializeDataSource];
}

- (void)initializeUserInterface{
    self.navigationItem.title = @"发布";
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
//    UIImageView *topImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topImg"]];
//    [self.view addSubview:topImgView];
//    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(64);
//        make.left.equalTo(self.view.mas_left).offset(0);
//        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH, 130));
//    }];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.height.mas_equalTo(@(SCREEN_HEIGHT-160));
        make.right.equalTo(self.view.mas_right).offset(0);
    }];
    
    UILabel  *label1 = [UILabel new];
    label1.text = @"1、所以的服务项目按照接单金额的5%收取平台服务费。";
    label1.font = [UIFont systemFontOfSize:14.0f];
    label1.textColor = [UIColor redColor];
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(5);
        make.top.equalTo(self.mainView.mas_bottom).offset(5);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH-10, 30));
    }];
    UILabel *label2 = [UILabel new];
    label2.text = @"2、人才超市订单起额每笔为100人民币以上，生务空平台按接单次数收取中介服务费100元。";
    label2.numberOfLines = 0;
    label2.font = [UIFont systemFontOfSize:14.0f];
    label2.textColor = [UIColor redColor];
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(5);
        make.top.equalTo(label1.mas_bottom).offset(0);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH-10, 60));
    }];
    
}

- (void)initializeDataSource{
    
    _headerArray = [NSMutableArray array];
    _leftArray = [NSMutableArray array];
    _rightArray = [NSMutableArray array];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@token=topSort",SORTURL];
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:strUrl params:nil andSuccessBlock:^(id responseObj) {
        
        if (kStringIsEmpty(responseObj[@"error"])) {
            for (NSDictionary *dic in responseObj[@"data"]) {
                NSString *state = dic[@"state"];
                if ([state isEqualToString:@"家政服务"]) {
                    [_headerArray addObject:dic];
                } else if ([state isEqualToString:@"清洗服务"]){
                    [_headerArray addObject:dic];
                } else if ([state isEqualToString:@"生活配送服务"]){
                    [_headerArray insertObject:dic atIndex:2];
                } else if ([state isEqualToString:@"安装维修服务"]){
                    [_headerArray addObject:dic];
                } else if ([state isEqualToString:@"人才超市"]){
                    [_leftArray insertObject:dic atIndex:0];
                } else if ([state isEqualToString:@"商务服务"]){
                    [_leftArray addObject:dic];
                } else if ([state isEqualToString:@"学习辅读"]){
                    [_rightArray addObject:dic];
                } else if ([state isEqualToString:@"旅游交通运输服务"]){
                    [_rightArray addObject:dic];
                }
            }
        } else {
            [PublicMethod showAlert:self message:responseObj[@"error"]];
        }
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"顶级服务类ReleaseVC error====%@",responseObj);
    } andIsHUD:NO];
    
    
}

-(MainView *)mainView{
    if (!_mainView) {
        _mainView = [[MainView alloc]initWithFrame:CGRectZero];
        _mainView.delegate = self;
        [self.view addSubview:_mainView];
    }
    return _mainView;
}


#pragma mark - MainViewDelegate
-(void)returnHeader:(NSInteger)index{
    NSLog(@"HeaderIndex:%zi",index);
    NSLog(@"index:%@",_headerArray[index][@"state"]);
    
    CommonReleaseViewController *commonVC = [[CommonReleaseViewController alloc] init];
    commonVC.type_one = _headerArray[index][@"id"];
    commonVC.actionType = @"add";
    [self.navigationController pushViewController:commonVC animated:YES];
}

///左边两个
-(void)returnLeft:(NSInteger)index{
    NSLog(@"LeftIndex:%zi",index);
    NSLog(@"index:%@",_leftArray[index][@"state"]);
    if (index == 0) {
        //人才超市
        SendResumeViewController *sendVC = [[SendResumeViewController alloc] init];
        sendVC.type_id = _leftArray[index][@"id"];
        sendVC.title = _leftArray[index][@"state"];
        sendVC.actionType = @"add";
        [self.navigationController pushViewController:sendVC animated:YES];
    } else {
        
        CommonReleaseViewController *commonVC = [[CommonReleaseViewController alloc] init];
        commonVC.type_one = _leftArray[index][@"id"];
        commonVC.actionType = @"add";
        [self.navigationController pushViewController:commonVC animated:YES];
//        BusinessServiceViewController *businessVC = [[BusinessServiceViewController alloc] init];
//        businessVC.type_one = _leftArray[index][@"id"];
//        businessVC.action_type = @"add";
//        [self.navigationController pushViewController:businessVC animated:YES];
    }
    
    
}

///右边两个
-(void)returnRight:(NSInteger)index{
    NSLog(@"RightIndex:%zi",index);
    NSLog(@"index:%@",_rightArray[index][@"state"]);
    
//    CommonReleaseViewController *commonVC = [[CommonReleaseViewController alloc] init];
//    commonVC.type_one = _rightArray[index][@"id"];
//    commonVC.actionType = @"add";
//    [self.navigationController pushViewController:commonVC animated:YES];
    if (index == 0) {
        CommonReleaseViewController *commonVC = [[CommonReleaseViewController alloc] init];
        commonVC.type_one = _rightArray[index][@"id"];
        commonVC.actionType = @"add";
        [self.navigationController pushViewController:commonVC animated:YES];
//        LearnViewController *learnVC = [[LearnViewController alloc] init];
//        learnVC.type_one = _rightArray[index][@"id"];
//        learnVC.action_type = @"add";
//        [self.navigationController pushViewController:learnVC animated:YES];
    } else {
        TrafficViewController *trafficVC = [[TrafficViewController alloc] init];
        trafficVC.type_one = _rightArray[index][@"id"];
        trafficVC.action_type = @"add";
        [self.navigationController pushViewController:trafficVC animated:YES];
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
