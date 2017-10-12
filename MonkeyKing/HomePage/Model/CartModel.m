//
//  CartModel.m
//  KFShop
//
//  Created by libin on 16/4/11.
//  Copyright © 2016年 libin. All rights reserved.
//

#import "CartModel.h"


static CartModel * _defaultModel;

@implementation CartModel

#define infosArrInCartKey @"infosArrKey"


+(CartModel *)sharedInstance
{
    if (!_defaultModel) {
        _defaultModel = [[CartModel alloc]init];
        
        [_defaultModel loadLocalData];
    
    }
    return _defaultModel;
}

// 读取本地存储的商品
- (void)loadLocalData{
    NSArray * infoArr = [[NSUserDefaults standardUserDefaults]objectForKey:infosArrInCartKey];
    if(_defaultModel.infosArr){
        [_defaultModel.infosArr removeAllObjects];
    }else{
        _defaultModel.infosArr = [NSMutableArray array];
    }
    for (NSData * data in infoArr) {
        InfoModel *info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [_defaultModel.infosArr addObject:info];
    }
}

// ------对外方法-------
- (void)addInfo:(InfoModel *)info{
    __block BOOL  exitGood = NO;
    
    for (InfoModel *i in _defaultModel.infosArr) {
        if ([i.info_id isEqualToString:info.info_id]) {
            i.product_count += 1;
            exitGood = YES;
        }
    }
    if (!exitGood) {
        // 未加入购物车的商品
        info.product_count = 1;
        [_defaultModel.infosArr addObject:info];
    }
    // 更新本地存储
    NSMutableArray * tempListArr = [NSMutableArray array];
    for (InfoModel *tempInfo in _defaultModel.infosArr) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tempInfo];
        [tempListArr addObject:data];
    }
    [[NSUserDefaults standardUserDefaults]setObject:tempListArr forKey:infosArrInCartKey];
    
    double count =  _defaultModel.currentInfosCount;
    NSString *countStr = [NSString stringWithFormat:@"%.2f",count];
    if ([countStr isEqualToString:@"0"]) {
        countStr = @"";
    }
    
}
- (void)addInfo:(InfoModel *)info andCount:(double)count{
    __block BOOL  exitGood = NO;
    
    for (InfoModel *i in _defaultModel.infosArr) {
        if ([i.info_id isEqualToString:info.info_id]) {
            i.product_count = count;
            exitGood = YES;
        }
    }
    if (!exitGood) {
        // 未加入购物车的商品
        info.product_count = count;
        [_defaultModel.infosArr addObject:info];
    }
    // 更新本地存储
    NSMutableArray * tempListArr = [NSMutableArray array];
    for (InfoModel *tempInfo in _defaultModel.infosArr) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tempInfo];
        [tempListArr addObject:data];
    }
    [[NSUserDefaults standardUserDefaults]setObject:tempListArr forKey:infosArrInCartKey];
    
    double ifcount =  _defaultModel.currentInfosCount;
    NSString *countStr = [NSString stringWithFormat:@"%.2f",ifcount];
    if ([countStr isEqualToString:@"0"]) {
        countStr = @"";
    }
}
//清空
- (void)clearCart
{
    [_defaultModel.infosArr removeAllObjects];
    [[NSUserDefaults standardUserDefaults]setObject:[NSMutableArray array] forKey:infosArrInCartKey];
   
}

// 商品购买的总数量
- (int)currentInfosCount{
    int _count = 0;
    for (InfoModel *info in _defaultModel.infosArr) {
        _count += info.product_count;
    }
    
    return _count;
}

// 价格
- (NSString*)currentInfosAmount{
    CGFloat amount = 0.0;
    for (InfoModel *info in _defaultModel.infosArr) {
        amount += info.product_cost.doubleValue*info.product_count;
    }
    NSString *amountStr = [NSString stringWithFormat:@"%.2f",amount];
    return amountStr;
}

// 查询一个商品所加入购物车的数量
- (double)infoAddCartNum:(NSString *)info_id{
    double count = 0.00;
    for (InfoModel *info in _defaultModel.infosArr) {
        if ([info_id isEqualToString:info.info_id]) {
            count = info.product_count;
        }
    }
    return count;
}


// 减去一个商品
- (void)reduceInfo:(InfoModel *)info{
    BOOL exit = NO;
    NSArray *tempClean0Arr = [NSArray arrayWithArray:_defaultModel.infosArr]; // 临时中间
    for (int i = 0 ;i < (int)tempClean0Arr.count;i++) {
        InfoModel *im  = tempClean0Arr[i];
        if ([im.info_id isEqualToString:info.info_id]) {
            exit = YES;
            im.product_count -= 1;
            if (im.product_count < 1) {
                [_defaultModel.infosArr removeObjectAtIndex:i];
            }
        }
    }
    
    if (!exit) {
        return;
    }
    
    // 更新本地存储
    NSMutableArray * tempListArr = [NSMutableArray array];
    for (GoodModel *tempgood in _defaultModel.infosArr) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tempgood];
        [tempListArr addObject:data];
    }
    [[NSUserDefaults standardUserDefaults]setObject:tempListArr forKey:infosArrInCartKey];
    
    int count =  _defaultModel.currentInfosCount;
    NSString *countStr = [NSString stringWithFormat:@"%i",count];
    if ([countStr isEqualToString:@"0"]) {
        countStr = @"";
    }
}

// 减去该类商品
- (void)reduceAllWithInfo:(InfoModel *)info{
    BOOL exit = NO;
    NSArray *tempClean0Arr = [NSArray arrayWithArray:_defaultModel.infosArr]; // 临时中间
    for (int i = 0 ;i < (int)tempClean0Arr.count;i++) {
        InfoModel *im  = tempClean0Arr[i];
        if ([im.info_id isEqualToString:info.info_id]) {
            exit = YES;
            [_defaultModel.infosArr removeObjectAtIndex:i];
        }
    }
    
    if (!exit) {
        return;
    }
    
    // 更新本地存储
    NSMutableArray * tempListArr = [NSMutableArray array];
    for (InfoModel *tempgood in _defaultModel.infosArr) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tempgood];
        [tempListArr addObject:data];
    }
    [[NSUserDefaults standardUserDefaults]setObject:tempListArr forKey:infosArrInCartKey];
    
    
    int count =  _defaultModel.currentInfosCount;
    NSString *countStr = [NSString stringWithFormat:@"%i",count];
    if ([countStr isEqualToString:@"0"]) {
        countStr = @"";
    }
}


@end
