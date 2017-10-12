//
//  NSObject+Common.h
//  xianchangji
//
//  Created by 徐天宇 on 15/9/16.
//  Copyright (c) 2015年 TianLan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)

#pragma mark Tip M
- (NSString *)tipFromError:(NSError *)error;
- (BOOL)showError:(NSError *)error;
- (void)showHudTipStr:(NSString *)tipStr;
- (void)showHudTip;
- (void)dismissHudTip;
#pragma mark NetError
-(id)handleResponse:(id)responseJSON;
-(id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError;

@end
