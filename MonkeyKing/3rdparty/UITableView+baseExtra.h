//
//  UITableView+baseExtra.h
//  SCH
//
//  Created by XienaShen on 17/1/6.
//  Copyright © 2017年 SCH_YUH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (baseExtra)

#pragma -mark 获取 NSIndexPath
-(NSIndexPath *)indexPathForView:(UIView *)view andTabelView:(UITableView *) tabelview;

@end
