//
//  UITableView+baseExtra.m
//  SCH
//
//  Created by XienaShen on 17/1/6.
//  Copyright © 2017年 SCH_YUH. All rights reserved.
//

#import "UITableView+baseExtra.h"

@implementation UITableView (baseExtra)

#pragma -mark 获取 NSIndexPath
-(NSIndexPath *)indexPathForView:(UIView *)view andTabelView:(UITableView *) tabelview{
    UIView *parentView=[view superview];
    while (![parentView isKindOfClass:[UITableViewCell class]] && parentView!=nil) {
        parentView=parentView.superview;
    }
    return [tabelview indexPathForCell:(UITableViewCell *)parentView];
}

@end
