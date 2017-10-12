//
//  PublicMethod.h
//  MonkeyKing
//
//  Created by Apple on 2017/2/10.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicMethod : NSObject

+ (void)showAlert:(UIViewController *)controller message:(NSString *)massge;
+ (void)buttonSetCountDownWithCount:(NSInteger)count andButton:(UIButton *)button;
// alert自动消失
+ (void)autoDisappearAlert:(UIViewController *)vc time:(CGFloat)time msg:(NSString *)msg;
@end
