//
//  CartModel.h
//  KFShop
//
//  Created by libin on 16/4/11.
//  Copyright © 2016年 libin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodModel.h"
#import "InfoModel.h"

@interface CartModel : NSObject

@property (nonatomic,strong) NSMutableArray *infosArr;


// ------对外方法-------


- (int)currentInfosCount;
- (NSString*)currentInfosAmount;

// 商品意向购买数量
- (double)infoAddCartNum:(NSString *)info_id;

// 加入一个商品
- (void)addInfo:(InfoModel *)info;
//输入添加商品修改数量
- (void)addInfo:(InfoModel *)info andCount:(double)count;

// 减去该类商品
- (void)reduceAllWithInfo:(InfoModel *)info;

// 减去一个商品
- (void)reduceInfo:(InfoModel *)info;


- (void)clearCart;

+ (CartModel*)sharedInstance;

@end
