//
//  MapShowViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/4/19.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "MapShowViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>


@interface MapShowViewController ()<BMKMapViewDelegate>

@property (nonatomic, strong) BMKMapView *mapView;

@end

@implementation MapShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"位置";
    
    //创建MapView
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.view = _mapView;
    //    [self.view addSubview:_mapView];
    [_mapView setMapType:BMKMapTypeStandard];
    
    //    [self initGUI];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [self initGUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate = self;//此处不使用时置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;//不用时，置空nil
}

#pragma mark 添加地图控件
-(void)initGUI{
    
    CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake([USER_LAT doubleValue],[USER_LNG doubleValue]);
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.title=@"当前位置";
    
    //        annotation.subtitle=@"南理工科技园";
    annotation.coordinate=coordinate;
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = coordinate;//中心点
    region.span.latitudeDelta = 0.1;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.1;//纬度范围
    [_mapView setRegion:region animated:YES];
    [self.mapView addAnnotation:annotation];
    
    CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake(_latitude, _longitude);
    BMKPointAnnotation *annotation2 = [[BMKPointAnnotation alloc]init];
    annotation2.coordinate = coordinate2;
    annotation2.title = @"商家位置";
    //        annotation2.subtitle = _address;
    BMKCoordinateRegion region2 ;//表示范围的结构体
    region2.center = coordinate2;//中心点
    region2.span.latitudeDelta = 0.1;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region2.span.longitudeDelta = 0.1;//纬度范围
    [_mapView setRegion:region2 animated:YES];
    [self.mapView addAnnotation:annotation2];
    
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        if ([annotation.title isEqualToString:@"商家位置"]) {
            
            newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        } else {
            
            newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
        }
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        
        return newAnnotationView;
    }
    return nil;
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
    BMKAnnotationView *piview = (BMKAnnotationView *)[views objectAtIndex:0];
    //标题和子标题自动显示
    [_mapView selectAnnotation:piview.annotation animated:YES];
}

- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
