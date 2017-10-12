//
//  GoodModel.h
//  MonkeyKing
//
//  Created by Apple on 2017/2/21.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InfoModel;
/*
 " uid ":10000
 " serve_id ":242
 " buyer_address ":a服务地址
 " buyer_name ":买家名称
 " serve_notes ":暂时不管的描述
 " pay_moeny ":200
 " discount ":1.0
 " info ":{
 " info_id ":21		" product_count ":2
 " product_name ":21	" product_cost ":100
 }
 
 */
@interface GoodModel : NSObject
/*用户ID，服务ID，服务地址，买家名称，备注，价格，折扣，产品info*/
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *serve_id;
@property (nonatomic, strong) NSString *buyer_address;
@property (nonatomic, strong) NSString *buyer_name;
@property (nonatomic, strong) NSString *serve_notes;
@property (nonatomic, strong) NSString *pay_moeny;
@property (nonatomic, assign) double discount;
@property (nonatomic, strong) InfoModel *infoM;
@property (nonatomic, strong) NSMutableArray *info;

@end
