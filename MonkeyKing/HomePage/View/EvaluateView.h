//
//  EvaluateView.h
//  EvaluateDemo
//
//  Created by 潘振泽 on 2017/2/18.
//  Copyright © 2017年 Panzz. All rights reserved.
//

#import <UIKit/UIKit.h>

#define     UnSelectedImg   [UIImage imageNamed:@"Store_GoodsInfoComStar2"]  //未选中时图片
#define     SelectedImg     [UIImage imageNamed:@"Store_GoodsInfoComStar"]    //选中时图片

#define     ScreenWidth     [UIScreen mainScreen].bounds.size.width     //屏幕宽度
#define     ScreenHeight    [UIScreen mainScreen].bounds.size.height    //屏幕高度

@protocol EvaDelegate;

@interface EvaluateView : UIView

- (instancetype)initWithFrame:(CGRect)frame count:(int)count;

@property (nonatomic,assign) CGFloat imgWidth;

- (void)showsStarsWithCounts:(int)counts;

@end

