//
//  HLCheckInternet.m
//  yaotongkeji
//
//  Created by 徐天宇 on 15/7/24.
//  Copyright (c) 2015年 TianLan. All rights reserved.
//

#import "HLCheckInternet.h"
#import "AFNetworkReachabilityManager.h"

@interface HLCheckInternet()

@end

@implementation HLCheckInternet

+ (HLCheckInternet *)shareCheckInternet
{
    static HLCheckInternet *HL = nil;
    if (!HL) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            HL = [[HLCheckInternet alloc] init];
        });
    }
    
    return HL;
}

- (id)init
{
    if (self = [super init])
    {
        self.internetReach = [Reachability reachabilityForInternetConnection];
        [self.internetReach startNotifier];
    }
    
    return self;
}

- (BOOL) usingWiFi
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi)
    {
        return YES;
    }
    return NO;
}

- (BOOL) usingWWAN
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN)
    {
        return YES;
    }
    return NO;
}

- (BOOL) canConnect
{
    if ([self usingWiFi] || [self usingWWAN])
    {
        return YES;
    }
    
    return NO;
}

@end
