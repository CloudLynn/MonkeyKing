//
//  HLRequestManager.h
//  yaotongkeji
//
//  Created by 徐天宇 on 15/7/24.
//  Copyright (c) 2015年 TianLan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLRequestManager : NSObject


+ (HLRequestManager *)changeJsonClient;

typedef void(^CompletionBlock)(id responseObj);

- (void)requestWithIsPost:(BOOL)isPost url:(NSString *)url params:(NSDictionary *)params andSuccessBlock:(CompletionBlock)successBlock andFailedBlock:(CompletionBlock)failedBlock andIsHUD:(BOOL)hud;

@end
