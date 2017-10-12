//
//  XJLStarView.h
//  MonkeyKing
//
//  Created by Apple on 2017/4/19.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJLStarView : UIView
@property (nonatomic, assign) NSInteger maxStar;        // 最大值
@property (nonatomic, assign) NSInteger showStar;       // 显示值
@property (nonatomic, strong) UIColor *emptyColor;      // 空颜色
@property (nonatomic, strong) UIColor *fullColor;       // 满颜色
@property (nonatomic, assign) CGFloat starSize;

@end
