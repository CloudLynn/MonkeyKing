//
//  HLCheckInternet.h
//  yaotongkeji
//
//  Created by 徐天宇 on 15/7/24.
//  Copyright (c) 2015年 TianLan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface HLCheckInternet : NSObject
{
    Reachability *_internetReach;
}

+ (HLCheckInternet *)shareCheckInternet;
@property (nonatomic, strong) Reachability *internetReach;

- (BOOL) usingWiFi;
- (BOOL) usingWWAN;
- (BOOL) canConnect;


@end
