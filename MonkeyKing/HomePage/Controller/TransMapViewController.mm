//
//  TransMapViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/3/16.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "TransMapViewController.h"
#import "RouteSearchViewController.h"
//#import "PaymentViewController.h"
#import "TransOrderViewController.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>             //引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>   //引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>       //引入检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>         //引入计算工具所有的头文件

#import "SearchModel.h"

#import "ChatViewController.h"
#import "UserProfileManager.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]


@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end
@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end



@interface TransMapViewController ()<UITextFieldDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate>{
    
    BMKRouteSearch *_searcher;
    
    BMKLocationService *_locService;  //定位
    
    BMKGeoCodeSearch *_geocodesearch; //地理编码主类，用来查询、返回结果信息
    
    CLLocationCoordinate2D _beginLocation;
    CLLocationCoordinate2D _endLocation;
}
///起步价
@property (nonatomic, strong) UILabel *startLbl;
///乘运价
@property (nonatomic, strong) UILabel *transLbl;
///起点位置
@property (nonatomic, strong) UITextField *beginTxt;
///终点位置
@property (nonatomic, strong) UITextField *endTxt;
///距离
@property (nonatomic, strong) UILabel *distanceLbl;
///总价
@property (nonatomic, strong) UILabel *priceLbl;
///立即下单
@property (nonatomic, strong) UIButton *orderBtn;
///联系商家
@property (nonatomic, strong) UIButton *callBtn;

@property (nonatomic,strong) NSString *city;

///map
@property (nonatomic, strong) BMKMapView *mapView;

@end

@implementation TransMapViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _geocodesearch.delegate = self;
    _searcher.delegate = self;
    // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _geocodesearch.delegate = nil;
    _searcher.delegate = nil;
    // 不用时，置nil
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    
    [self initializeDataSource];
    
}

- (void)initializeDataSource{
    
    self.startLbl.text = [NSString stringWithFormat:@"%@ 元",_startStr];
    self.transLbl.text = [NSString stringWithFormat:@"%@ 元/公里*小时",_transStr];
    
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    
    [self startLocation];//开始定位方法
    
}

//开始定位
-(void)startLocation {
    
    //初始化BMKLocationService
    
    _locService = [[BMKLocationService alloc]init];
    
    _locService.delegate = self;
    
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    //启动LocationService
    
    [_locService startUserLocationService];
    
}
#pragma mark =====实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    NSLog(@"heading is %@",userLocation.heading);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    //普通态
    //以下_mapView为BMKMapView对象
    [_mapView updateLocationData:userLocation]; //更新地图上的位置
    
    _mapView.centerCoordinate = userLocation.location.coordinate; //更新当前位置到地图中间
    
    //地理反编码
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    
    if(flag){
        
        NSLog(@"反geo检索发送成功");
        
        [_locService stopUserLocationService];
        
    }else{
        
        NSLog(@"反geo检索发送失败");
    }
    
}

#pragma mark -------------地理反编码的delegate---------------
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    NSLog(@"address:%@----%@",result.addressDetail,result.address);
    //addressDetail:     层次化地址信息
    //address:    地址名称
    //businessCircle:  商圈名称
    // location:  地址坐标
    //  poiList:   地址周边POI信息，成员类型为BMKPoiInfo
    self.beginTxt.text = result.address;
    _beginLocation = result.location;
    
}
//定位失败
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"error:%@",error);
}

#pragma mark - UITextFieldDelegate -
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    RouteSearchViewController *searchVC = [[RouteSearchViewController alloc] init];
    searchVC.title = @"地址检索";
    if (textField.tag == 100) {
        searchVC.type = @"begin";
    } else {
        searchVC.type = @"end";
    }
    
    [searchVC finishBlock:^(SearchModel *model) {
        
        if ([searchVC.type isEqualToString:@"begin"]) {
            
            NSLog(@"qidian======%@",model.name);
            self.beginTxt.text = [NSString stringWithFormat:@"%@%@",model.city,model.name];
            [self.beginTxt resignFirstResponder];
            _beginLocation = model.pt;
            
        } else if ([searchVC.type isEqualToString:@"end"]){
            
            NSLog(@"zhongdian======%@",model.name);
            self.endTxt.text = [NSString stringWithFormat:@"%@%@",model.city,model.name];
            [self.endTxt resignFirstResponder];
            _endLocation = model.pt;
        }
        
        //得到终点位置，路径规划
        [self startRouteSearch];
        
    }];
    
    [self.navigationController pushViewController:searchVC animated:YES];
    
    return YES;
}

#pragma mark -------路径规划----
- (void)startRouteSearch{
    
    _searcher = [[BMKRouteSearch alloc]init];
    
    
    
    //发起检索
    BMKPlanNode* start = [[BMKPlanNode alloc]init] ;
    start.pt = _beginLocation;
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    
    end.pt = _endLocation;
    
    start.cityName = @"重庆市";//self.city;
    
    end.cityName = @"重庆市";//self.city;
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    //BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE==不获取路况信息
    drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE;//获取
    
    BOOL flag = [_searcher drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
    
}

/**
 *  驾车路径规划
 *
 *  @param fromPoint 出发位置
 *  @param toPoint   到点
 */
-(void)driveSearchFrom:(CLLocationCoordinate2D)fromPoint to:(CLLocationCoordinate2D)toPoint
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = fromPoint;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = toPoint;
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;//不获取路况信息
    
    BOOL flag = [_searcher drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
    
}


#pragma mark -- BMKRouteSearchDelegate
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
    [self.mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:self.mapView.overlays];
    [self.mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        //计算路线长度
        NSInteger distance = 0;
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            distance += transitStep.distance;
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [self.mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [self.mapView addAnnotation:item]; // 添加起点标注
            }
            
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        //路线长度
        self.distanceLbl.text = [NSString stringWithFormat:@"%.3f",(long)distance*0.001];
        CGFloat price = [self.startStr doubleValue]+[self.transStr doubleValue]*distance*0.001;
        self.priceLbl.text = [NSString stringWithFormat:@"%.2f",price];
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [self.mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        
        [PublicMethod showAlert:self message:@"起点或终点有歧义"];
        
    }
}
//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [self.mapView setVisibleMapRect:rect];
    self.mapView.zoomLevel = self.mapView.zoomLevel - 0.3;
}

#pragma mark - BMKMapViewDelegate
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapview viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation.title isEqualToString:@"起点"]) {
        NSLog(@"起点标注");
    } else if ([annotation.title isEqualToString:@"终点"]) {
        NSLog(@"终点标注");
    }
    
    if ([annotation isMemberOfClass:[RouteAnnotation class]]) {
             return [self getRouteAnnotationView:self.mapView viewForAnnotation:(RouteAnnotation*)annotation];
    } else  if ([annotation isMemberOfClass:[BMKPointAnnotation class]]) {
    
    
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.annotation=annotation;
        newAnnotationView.image = [UIImage imageNamed:@"zuobiaotubiao"];   //把大头针换成别的图片
        
        UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
        //设置弹出气泡图片
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wenzi"]];
        image.frame = CGRectMake(0, 0, 100, 60);
        [popView addSubview:image];

        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
        pView.frame = CGRectMake(0, 0, 100, 60);
        ((BMKPinAnnotationView*)newAnnotationView).paopaoView = nil;
        ((BMKPinAnnotationView*)newAnnotationView).paopaoView = pView;
    
        return newAnnotationView;
        
    }
    
    
    return nil;
}
#pragma mark -- 获取起始、终点的标注View
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

#pragma mark - 获取图片路径

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

#pragma mark - BMKRouteSearchDelegate

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}




#pragma mark - clickAction -
- (void)clickOrderBtn{
//    NSLog(@"立即下单");
//    //http://api.swktcx.com/A1/order.php?token=addOrderTour&uid=10000&serve_id=244&buyer_address=重庆渝北&pay_moeny=100&seller_address=重庆渝中&distance=100
//    if (ISLOGIN) {
//        NSDictionary *paramDict = @{@"token":@"addOrderTour",
//                                    @"uid":USER_UID,
//                                    @"serve_id":_serve_id,
//                                    @"buyer_address":self.beginTxt.text,
//                                    @"pay_moeny":self.priceLbl.text,
//                                    @"seller_address":self.endTxt.text,
//                                    @"distance":self.distanceLbl.text};
//        [[HLRequestManager changeJsonClient] requestWithIsPost:YES url:ORDERURL params:paramDict andSuccessBlock:^(id responseObj) {
//            NSLog(@"%@",responseObj);
//            if (kStringIsEmpty(responseObj[@"error"])) {
//                PaymentViewController *paymentVC = [[PaymentViewController alloc] init];
//                paymentVC.order_id = responseObj[@"data"][@"order_id"];
//                [self.navigationController pushViewController:paymentVC animated:YES];
//                
//            } else {
//                
//                [PublicMethod showAlert:self message:responseObj[@"error"]];
//                
//            }
//            
//        } andFailedBlock:^(id responseObj) {
//            NSLog(@"%@",responseObj);
//            NSLog(@"旅游交通下单");
//        } andIsHUD:NO];
//        
//    } else {
//        [PublicMethod showAlert:self message:@"您还未登录，请先登录"];
//    }
    
    TransOrderViewController *transOrderVC = [[TransOrderViewController alloc] init];
    transOrderVC.serve_id = self.serve_id;
    transOrderVC.transStr = self.transStr;
    transOrderVC.startStr = self.startStr;
    transOrderVC.beginStr = self.beginTxt.text;
    transOrderVC.endStr = self.endTxt.text;
    transOrderVC.moneyStr = self.priceLbl.text;
    transOrderVC.distanceStr = self.distanceLbl.text;
    [self.navigationController pushViewController:transOrderVC animated:YES];
    
}

- (void)clickCallBtn{
    //直接拨打电话
//    NSMutableString *strPhone = [[NSMutableString alloc]initWithFormat:@"tel:%@",_phoneStr];
//    UIWebView *callWebView = [[UIWebView alloc]init];
//    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strPhone]]];
//    [self .view addSubview:callWebView];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"联系商家" message:@"选择联系方式" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *telAction = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //直接拨打电话
        
        NSMutableString *strPhone = [[NSMutableString alloc]initWithFormat:@"tel:%@",self.phoneStr];
        UIWebView *callWebView = [[UIWebView alloc]init];
        [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strPhone]]];
        [self .view addSubview:callWebView];
    }];
    
    UIAlertAction *msgAction = [UIAlertAction actionWithTitle:@"发送消息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *urlStr = [NSString stringWithFormat:@"%@ue14&user_name=%@",MESSAGEURL,self.phoneStr];
        [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:urlStr params:nil andSuccessBlock:^(id responseObj) {
            
            if (!kStringIsEmpty(responseObj[@"error"])){
                [PublicMethod showAlert:self message:responseObj[@"error"]];
            } else  {
                EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:responseObj[@"data"][@"username"]];
                model.nickname = responseObj[@"data"][@"nickname"];
                model.avatarURLPath = [NSString stringWithFormat:@"http://%@",responseObj[@"data"][@"image"]];
                UIViewController *chatController = nil;
                chatController = [[ChatViewController alloc] initWithConversationChatter:model.buddy conversationType:EMConversationTypeChat];
                NSString *nickName = model.nickname.length > 0 ? model.nickname : model.buddy;
                
                chatController.title = [[UserProfileManager sharedInstance] getNickNameWithUsername:nickName];
                [self.navigationController pushViewController:chatController animated:YES];
            }
            
            
            
        } andFailedBlock:^(id responseObj) {
            
        } andIsHUD:NO];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:telAction];
    [alertController addAction:msgAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

#pragma mark - initUI -
- (void)initializeUserInterface{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *startT = [UILabel new];
    startT.font = FONT_15;
    startT.text = @"起步价：";
    [self.view addSubview:startT];
    [startT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(8);
        make.top.equalTo(self.view.mas_top).offset(72);
        make.size.sizeOffset(CGSizeMake(70, 30));
    }];
    
    UILabel *transT = [UILabel new];
    transT.font = FONT_15;
    transT.text = @"乘运价：";
    [self.view addSubview:transT];
    [transT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startLbl.mas_right).offset(10);
        make.top.equalTo(self.view.mas_top).offset(72);
        make.size.sizeOffset(CGSizeMake(70, 30));
    }];
    
    UILabel *beginT = [UILabel new];
    beginT.font = FONT_15;
    beginT.text = @"起点位置";
    [self.view addSubview:beginT];
    [beginT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(8);
        make.top.equalTo(startT.mas_bottom).offset(8);
        make.size.sizeOffset(CGSizeMake(80, 30));
    }];
    
    UILabel *endT = [UILabel new];
    endT.font = FONT_15;
    endT.text = @"您要去哪儿";
    [self.view addSubview:endT];
    [endT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(8);
        make.top.equalTo(beginT.mas_bottom).offset(8);
        make.size.sizeOffset(CGSizeMake(80, 30));
    }];
    
    UILabel *distanT = [UILabel new];
    distanT.font = [UIFont systemFontOfSize:14];
    distanT.text = @"起点位置到终点位置距离共计 （公里）";
    [self.view addSubview:distanT];
    [distanT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(8);
        make.top.equalTo(self.mapView.mas_bottom).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-100);
        make.height.mas_offset(@30);
    }];
    
    UILabel *payT = [UILabel new];
    payT.font = [UIFont systemFontOfSize:14];
    payT.text = @"需支付金额(起步价+乘运价x距离)（元）";
    [self.view addSubview:payT];
    [payT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(8);
        make.top.equalTo(distanT.mas_bottom).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-100);
        make.height.mas_offset(@30);
    }];
    
    [self.startLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startT.mas_right).offset(-2);
        make.top.equalTo(self.view.mas_top).offset(72);
        make.height.mas_offset(@30);
        make.width.mas_offset(SCREEN_WIDTH/2-100);
    }];
    
    [self.transLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(transT.mas_right).offset(-2);
        make.top.equalTo(self.view.mas_top).offset(72);
        make.height.mas_offset(@30);
        make.right.equalTo(self.view.mas_right).offset(-8);
    }];
    
    [self.beginTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beginT.mas_right).offset(8);
        make.centerY.equalTo(beginT.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-8);
    }];
    
    [self.endTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endT.mas_right).offset(8);
        make.centerY.equalTo(endT.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-8);
    }];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.endTxt.mas_bottom).offset(8);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-170);
    }];
    
    [self.distanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(distanT.mas_right).offset(8);
        make.centerY.equalTo(distanT.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_offset(@30);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payT.mas_right).offset(8);
        make.centerY.equalTo(payT.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_offset(@30);
    }];
    
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-55);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-55);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    [self.orderBtn addTarget:self action:@selector(clickOrderBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.callBtn addTarget:self action:@selector(clickCallBtn) forControlEvents:UIControlEventTouchUpInside];
    
}
- (UILabel *)startLbl{
    if (!_startLbl) {
        _startLbl = [UILabel new];
        _startLbl.font = FONT_15;
        [self.view addSubview:_startLbl];
    }
    return _startLbl;
}

- (UILabel *)transLbl{
    if (!_transLbl) {
        _transLbl = [UILabel new];
        _transLbl.font = FONT_15;
        [self.view addSubview:_transLbl];
    }
    return _transLbl;
}

- (UITextField *)beginTxt{
    if (!_beginTxt) {
        _beginTxt = [UITextField new];
        _beginTxt.textColor = [UIColor orangeColor];
        _beginTxt.font = FONT_15;
        _beginTxt.delegate = self;
        _beginTxt.tag = 100;
        [self.view addSubview:_beginTxt];
    }
    return _beginTxt;
}

- (UITextField *)endTxt{
    if (!_endTxt) {
        _endTxt = [UITextField new];
        _endTxt.placeholder = @"请输入终点位置";
        _endTxt.textColor = [UIColor orangeColor];
        _endTxt.font = FONT_15;
        _endTxt.delegate = self;
        _endTxt.tag = 200;
        [self.view addSubview:_endTxt];
    }
    return _endTxt;
}

- (BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] init];
        _mapView.showsUserLocation = YES; //是否显示定位图层（即我的位置的小圆点）
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

- (UILabel *)distanceLbl{
    if (!_distanceLbl) {
        _distanceLbl = [UILabel new];
        _distanceLbl.font = FONT_15;
        _distanceLbl.textColor = [UIColor orangeColor];
        [self.view addSubview:_distanceLbl];
    }
    return _distanceLbl;
}

- (UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [UILabel new];
        _priceLbl.font = FONT_15;
        _priceLbl.textColor = [UIColor orangeColor];
        [self.view addSubview:_priceLbl];
    }
    return _priceLbl;
}

- (UIButton *)orderBtn{
    if (!_orderBtn) {
        _orderBtn = [UIButton new];
        [_orderBtn setTitle:@"立即下单" forState:UIControlStateNormal];
        _orderBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
        [_orderBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _orderBtn.layer.borderWidth = 1.0f;
        _orderBtn.layer.cornerRadius = 8.0f;
        _orderBtn.layer.masksToBounds = YES;
        [self.view addSubview:_orderBtn];
    }
    return _orderBtn;
}

- (UIButton *)callBtn{
    if (!_callBtn) {
        _callBtn = [UIButton new];
        [_callBtn setImage:[UIImage imageNamed:@"callImg"] forState:UIControlStateNormal];
        _callBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
        _callBtn.layer.borderWidth = 1.0f;
        _callBtn.layer.cornerRadius = 8.0f;
        _callBtn.layer.masksToBounds = YES;
        [self.view addSubview:_callBtn];
    }
    return _callBtn;
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
