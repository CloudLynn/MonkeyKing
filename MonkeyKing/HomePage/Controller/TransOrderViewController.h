//
//  TransOrderViewController.h
//  MonkeyKing
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransOrderViewController : UIViewController
///起步价
@property (nonatomic, strong) NSString *startStr;
///乘运价
@property (nonatomic, strong) NSString *transStr;
///金额
@property (nonatomic, strong) NSString *moneyStr;
///起点
@property (nonatomic, strong) NSString *beginStr;
///终点
@property (nonatomic, strong) NSString *endStr;
///里程
@property (nonatomic, strong) NSString *distanceStr;
///服务ID
@property (nonatomic, strong) NSString *serve_id;
@end
