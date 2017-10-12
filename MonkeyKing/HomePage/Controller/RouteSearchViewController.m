//
//  RouteSearchViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/3/20.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "RouteSearchViewController.h"
#import "SearchModel.h"
#import <CoreLocation/CoreLocation.h>
#import<BaiduMapAPI_Map/BMKMapView.h>

#import<BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>


@interface RouteSearchViewController ()<UITableViewDelegate,UITableViewDataSource,BMKPoiSearchDelegate>{
    BMKPoiSearch *_poisearch;//poi搜索
    
    BMKGeoCodeSearch *_geocodesearch;//geo搜索服务
}

@property (nonatomic,strong) NSMutableArray *addressArray;//搜索的地址数组

@property (nonatomic,strong) SearchModel *model;

@property (nonatomic, strong) UITextField *addressTxt; //输入地址框

@property (nonatomic, strong) UITableView *displayTableView; //显示的tableView

@property (nonatomic,strong) NSString *placeStr;

@property (nonatomic,strong) NSString *locationCity;//定位城市

@end

@implementation RouteSearchViewController

- (void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    
    
    //自动让输入框成为第一响应者,弹出键盘
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self.addressTxt becomeFirstResponder];
        
    });
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    _poisearch.delegate = nil; // 不用时，置nil
    
    _geocodesearch.delegate = nil;
    
}


- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    _addressTxt = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, 200, 30)];
    
    self.addressTxt.placeholder = @"输入终点位置";
    [self.addressTxt addTarget:self action:@selector(inputAddTFAction:) forControlEvents:UIControlEventEditingChanged];
    
    self.addressTxt.borderStyle =UITextBorderStyleNone;

    self.addressTxt.textAlignment = NSTextAlignmentCenter;
    
    _displayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT-100)];
    [self.view addSubview:_displayTableView];
    
    self.displayTableView.dataSource = self;
    
    self.displayTableView.delegate = self;
    
    self.addressTxt.font = [UIFont boldSystemFontOfSize:18];
    
    self.addressTxt.textColor = [UIColor colorWithWhite:20 alpha:7];
    
    self.navigationItem.titleView = _addressTxt;
    /*[self.view addSubview:_addressTxt];
     [self.addressTxt mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(self.view.mas_left).offset(20);
     make.top.equalTo(self.view.mas_top).offset(70);
     make.right.equalTo(self.view.mas_right).offset(-20);
     make.height.mas_offset(@30);
     }];*/
}


#pragma mark TableViewDelegate
//设置 row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.addressArray.count;
}


//设置 tableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cell_id = @"cell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:3 reuseIdentifier:cell_id];
        
    }
    
    SearchModel *sModel = [[SearchModel alloc] init];
   
    sModel = self.addressArray[indexPath.row];
    
    cell.textLabel.text = sModel.name;
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    cell.detailTextLabel.text = sModel.address;
    
    cell.detailTextLabel.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1];
    
    return cell;
    
}

//设置选中事件

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchModel *model = [[SearchModel alloc] init];
    
    model = self.addressArray[indexPath.row];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //block 传值
    __weak typeof(self) wSelf = self;
    
    wSelf.block(model);
    
}

- (void)finishBlock:(FinishBlock)block{
    self.block = block;
}

#pragma mark ---- 设置高度


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

#pragma mark 监听输入文本信息


-(void)inputAddTFAction:(UITextField *)textField{
    //延时搜索
    [self performSelector:@selector(delay) withObject:self afterDelay:0.5];
}

#pragma mark ----- 延时搜索
- (void)delay {

    [self nameSearch];
}

#pragma mark ---- 输入地点搜索
-(void)nameSearch{
    
    _poisearch = [[BMKPoiSearch alloc]init];
    
    _poisearch.delegate = self;
    
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    
    
    citySearchOption.pageIndex = 0;
    
    
    citySearchOption.pageCapacity = 30;
    
    
    citySearchOption.city= _locationCity;
    
    
    citySearchOption.keyword = self.addressTxt.text;
    
    
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    
    
    if(flag) {
        
        NSLog(@"城市内检索发送成功");
       
    } else {
        NSLog(@"城市内检索发送失败");
        
    }
    
}

#pragma mark --------- poi 代理方法
-(void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    
    if(errorCode == BMK_SEARCH_NO_ERROR) {
        
        
        self.addressArray = [NSMutableArray array];
        
        
        [self.addressArray removeAllObjects];
        
        
        for (BMKPoiInfo *info in poiResult.poiInfoList) {
            
            
            _model = [[SearchModel alloc] init];
            
            
            _model.name = info.name;
            
            
            _model.city = info.city;
            
            
            _model.address = info.address;
            
            
            _model.pt = info.pt;
            
            
            [self.addressArray addObject:_model];
            
            
        }
        
        
        [self.displayTableView reloadData];
        
        
    }
    
    
}

#pragma mark 滑动的时候收起键盘


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    
    
    [self.navigationItem.titleView endEditing:YES];
    
    
}

-(void)dealloc {
    
    
    if (_poisearch != nil) {
        
        _poisearch = nil;
        
    }
    
    if (_geocodesearch != nil) {
        
        _geocodesearch = nil;
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
