//
//  MainViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/6.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "MainDataModel.h"
#import "ClassViewController.h"
#import "TalentMarketViewController.h"

@interface MainViewController ()<UIScrollViewDelegate,MainDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) NSMutableArray *headerArray;
@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) NSMutableArray *rightArray;

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma -mark ======= initUI
-(void)initializeUserInterface{
    
    UIImageView *topImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topImg"]];
    [self.scrollView addSubview:topImgView];
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).offset(0);
        make.left.equalTo(self.scrollView.mas_left).offset(0);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH, 130));
    }];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.height.mas_equalTo(@(SCREEN_HEIGHT-130));
        make.right.equalTo(self.view.mas_right).offset(0);
    }];
    
    UIImageView *bottomImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomImg"]];
    [self.scrollView addSubview:bottomImgView];
    [bottomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(0);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH, 90));
        make.top.equalTo(self.mainView.mas_bottom).offset(-100);
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
        NSLog(@"顶级服务类MainVC error====%@",responseObj);
    } andIsHUD:NO];
    
    
}

#pragma -mark =========== MainDelegate
///上部分四个
-(void)returnHeader:(NSInteger)index{
    NSLog(@"HeaderIndex:%zi",index);
    NSLog(@"index:%@",_headerArray[index][@"state"]);
    ClassViewController *classVC = [[ClassViewController alloc] init];
    classVC.type_id = _headerArray[index][@"id"];
    classVC.classTitle = [NSString stringWithFormat:@"%@",_headerArray[index][@"state"]];
    [self.navigationController pushViewController:classVC animated:YES];
}

///左边两个
-(void)returnLeft:(NSInteger)index{
    NSLog(@"LeftIndex:%zi",index);
    NSLog(@"index:%@",_leftArray[index][@"state"]);
    if (index == 0) {
        //人才超市
        TalentMarketViewController *talentMarketVC = [[TalentMarketViewController alloc] init];
        talentMarketVC.type_id = _leftArray[index][@"id"];
        talentMarketVC.title = [NSString stringWithFormat:@"%@",_leftArray[index][@"state"]];
        [self.navigationController pushViewController:talentMarketVC animated:YES];
    } else {
        
        ClassViewController *classVC = [[ClassViewController alloc] init];
        classVC.type_id = _leftArray[index][@"id"];
        classVC.classTitle = [NSString stringWithFormat:@"%@",_leftArray[index][@"state"]];
        [self.navigationController pushViewController:classVC animated:YES];
        
    }
    
    
}

///右边两个
-(void)returnRight:(NSInteger)index{
    NSLog(@"RightIndex:%zi",index);
    NSLog(@"index:%@",_rightArray[index][@"state"]);
    
    ClassViewController *classVC = [[ClassViewController alloc] init];
    classVC.type_id = _rightArray[index][@"id"];
    classVC.classTitle = [NSString stringWithFormat:@"%@",_rightArray[index][@"state"]];
    [self.navigationController pushViewController:classVC animated:YES];
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.contentOffset = CGPointMake(0, 0);
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.userInteractionEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}
-(MainView *)mainView{
    if (!_mainView) {
        _mainView = [[MainView alloc]initWithFrame:CGRectZero];
        _mainView.delegate = self;
        [self.scrollView addSubview:_mainView];
    }
    return _mainView;
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
