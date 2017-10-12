//
//  InfoModel.h
//  MonkeyKing
//
//  Created by Apple on 2017/2/21.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoModel : NSObject
/*
 " info_id ":21		" product_count ":2
 " product_name ":21	" product_cost ":100 单价
 */
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, assign) CGFloat product_count;
@property (nonatomic, strong) NSString *product_name;
@property (nonatomic, strong) NSString *product_cost;
@end
