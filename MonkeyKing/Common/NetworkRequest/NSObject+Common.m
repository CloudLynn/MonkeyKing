//
//  NSObject+Common.m
//  xianchangji
//
//  Created by 徐天宇 on 15/9/16.
//  Copyright (c) 2015年 TianLan. All rights reserved.
//

#define kKeyWindow [UIApplication sharedApplication].keyWindow


#import "NSObject+Common.h"
#import "MBProgressHUD+Add.h"


@implementation NSObject (Common)
static MBProgressHUD *HUD;

- (void)showHudTipStr:(NSString *)tipStr{
    if (tipStr && tipStr.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.font = [UIFont boldSystemFontOfSize:15.0];
        hud.detailsLabel.text = tipStr;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:1.0];
    }
}

- (void)showHudTip
{
    HUD = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.label.text = @"正在加载";
    [HUD showAnimated:YES];
}

- (void)dismissHudTip
{
    [HUD hideAnimated:YES];
}


#pragma mark Tip M
- (NSString *)tipFromError:(NSError *)error{
    if (error && error.userInfo) {
        NSMutableString *tipStr = [[NSMutableString alloc] init];
        if ([error.userInfo objectForKey:@"msg"]) {
            NSArray *msgArray = [[error.userInfo objectForKey:@"msg"] allValues];
            NSUInteger num = [msgArray count];
            for (int i = 0; i < num; i++) {
                NSString *msgStr = [msgArray objectAtIndex:i];
                if (i+1 < num) {
                    [tipStr appendString:[NSString stringWithFormat:@"%@\n", msgStr]];
                }else{
                    [tipStr appendString:msgStr];
                }
            }
        }else{
            if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                tipStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            }else{
                [tipStr appendFormat:@"ErrorCode%ld", (long)error.code];
            }
        }
        return tipStr;
    }
    return nil;
}


- (BOOL)showError:(NSError *)error{
    
    NSString *tipStr = [self tipFromError:error];
    [self showHudTipStr:tipStr];
    return YES;
}


#pragma mark NetError
-(id)handleResponse:(id)responseJSON{
    return [self handleResponse:responseJSON autoShowError:YES];
}
-(id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError{
    NSError *error = nil;
    //code为非0值时，表示有错
    NSNumber *resultCode = [responseJSON valueForKeyPath:@"code"];
    
    if (resultCode.intValue == 1) {
        if (autoShowError) {
            [self showError:error];
        }
        
        if (resultCode.intValue == 1000 || resultCode.intValue == 3207) {//用户未登录
            NSLog(@"%@", [self tipFromError:error]);
        }
    }
    return error;
}


@end
