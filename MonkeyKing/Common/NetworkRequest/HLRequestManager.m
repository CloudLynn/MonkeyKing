//
//  HLRequestManager.m
//  yaotongkeji
//
//  Created by 徐天宇 on 15/7/24.
//  Copyright (c) 2015年 TianLan. All rights reserved.
//

#import "HLRequestManager.h"
#import "AFNetworking.h"
#import "HLCheckInternet.h"
#import "NSObject+Common.h"

@interface HLRequestManager()<UIAlertViewDelegate>
@end

@implementation HLRequestManager

static HLRequestManager *_sharedClient = nil;

+ (HLRequestManager *)changeJsonClient
{
    _sharedClient = [[HLRequestManager alloc] init];
    return _sharedClient;
}

- (void)requestWithIsPost:(BOOL)isPost url:(NSString *)url params:(NSDictionary *)params andSuccessBlock:(CompletionBlock)successBlock andFailedBlock:(CompletionBlock)failedBlock andIsHUD:(BOOL)hud
{
    if([[HLCheckInternet shareCheckInternet] canConnect])
    {
//        [self showStatusBarSuccessStr:@"网络成功"];
    }else {
        [self showHudTipStr:@"网络连接失败了"];
        NSError *error;
        failedBlock(error);
        return;
    }
    if(hud)
    {
        [self showHudTip];
    }
    [self requestWithIsPost:isPost url:url params:params andBlock:^(id data, NSError *error) {
     
        if(data)
        {
            if(successBlock)
            {
//                [self showStatusBarSuccessStr:@"成功啦"];
                successBlock(data);
            }
        }else{
            if(failedBlock)
            {
//                [self showStatusBarError:error];
                [self showHudTipStr:[self tipFromError:error]];
                failedBlock(error);
            }
        }
        if(hud)
        {
            [self dismissHudTip];
        }
    }];
   
}

- (void)requestWithIsPost:(BOOL)isPost url:(NSString *)url params:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",nil];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer=[AFHTTPRequestSerializer serializer];

//    manager.requestSerializer.timeoutInterval = 10;

    if(isPost)
    {
        [manager     POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id error = [self handleResponse:responseObject];
            if (error) {
                block(nil, error);
            }else{
                block(responseObject,nil);
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            block(nil,error);
        }];
        

    }else{
        [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id error = [self handleResponse:responseObject];
            if(error)
            {
                block(nil,error);
            }else{
                block(responseObject,nil);
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            block(nil,error);
        }];
    }
}

@end
