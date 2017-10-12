//
//  EvaluateView.m
//  EvaluateDemo
//
//  Created by 潘振泽 on 2017/2/18.
//  Copyright © 2017年 Panzz. All rights reserved.
//

#import "EvaluateView.h"

@implementation EvaluateView

- (instancetype)initWithFrame:(CGRect)frame count:(int)count
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self createStarsWithCounts:count];
    }
    
    return self;
}

/**
 创建星星的imageview
 */
- (void)createStarsWithCounts:(int)counts
{
    //计算左右间距
    CGFloat left = 20;
    CGFloat width = 13;
    self.imgWidth = width;
    
    for (int i = 0; i < counts; i ++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:UnSelectedImg];
        imgView.tag = i;
        [imgView setFrame:CGRectMake(left+i*width, 0, width, width)];
        [self addSubview:imgView];
    }
}


/**
 创建星星的imageview
 */
- (void)showsStarsWithCounts:(int)counts
{
    for (UIImageView *imgView in self.subviews)
    {
        if (imgView.tag < counts)
        {
            [imgView setImage:SelectedImg];
        }
        else
        {
            [imgView setImage:UnSelectedImg];
        }
    }
}
@end
