//
//  PaymentMethod.h
//  MonkeyKing
//
//  Created by Apple on 2017/3/30.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentMethod : NSObject

+ (void)paymentByAlipay:(NSString *)orderId;

@end
