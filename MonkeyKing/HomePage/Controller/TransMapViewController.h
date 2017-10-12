//
//  TransMapViewController.h
//  MonkeyKing
//
//  Created by Apple on 2017/3/16.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransMapViewController : UIViewController
///起步价
@property (nonatomic, strong) NSString *startStr;
///乘运价
@property (nonatomic, strong) NSString *transStr;
///服务ID
@property (nonatomic, strong) NSString *serve_id;
///电话号码
@property (nonatomic, strong) NSString *phoneStr;

@end
