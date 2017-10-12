//
//  PaymentMethod.m
//  MonkeyKing
//
//  Created by Apple on 2017/3/30.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "PaymentMethod.h"
#import <AFNetworking.h>

@implementation PaymentMethod

+ (void)paymentByAlipay:(NSString *)orderId{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",nil];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    
    //    manager.requestSerializer.timeoutInterval = 10;
    NSDictionary *paramDict = @{@"order_id":orderId};
    
    [manager     POST:ALIPAYURL parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",str);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
