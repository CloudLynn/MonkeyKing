//
//  PublicMethod.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/10.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "PublicMethod.h"

@implementation PublicMethod

+ (void)showAlert:(UIViewController *)controller message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [controller presentViewController:alert animated:YES completion:nil];
}
+ (void)buttonSetCountDownWithCount:(NSInteger)count andButton:(UIButton *)button{
    __block NSInteger time = count; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [button setTitle:@"重新发送" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [button setTitle:[NSString stringWithFormat:@"(%.2ds)", seconds] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

// alert自动消失
+ (void)autoDisappearAlert:(UIViewController *)vc time:(CGFloat)time msg:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [vc presentViewController:alert animated:YES completion:^{
        //延时执行
        dispatch_queue_t q = dispatch_get_main_queue();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC), q, ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}
@end
