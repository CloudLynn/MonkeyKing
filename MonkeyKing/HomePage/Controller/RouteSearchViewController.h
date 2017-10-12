//
//  RouteSearchViewController.h
//  MonkeyKing
//
//  Created by Apple on 2017/3/20.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class SearchModel;
typedef void(^FinishBlock)(SearchModel *model);//传回地址和百度地图经纬度

@interface RouteSearchViewController : UIViewController

@property (nonatomic,strong) FinishBlock block;//回调的 block
@property (nonatomic,strong) NSString *type;

- (void)finishBlock:(FinishBlock)block;

@end
