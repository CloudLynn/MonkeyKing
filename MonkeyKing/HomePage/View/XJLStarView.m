//
//  XJLStarView.m
//  MonkeyKing
//
//  Created by Apple on 2017/4/19.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "XJLStarView.h"

#define XJLStarFont [UIFont systemFontOfSize:14]  // 星星size宏定义Copperplate
#define XJLFontName @"Copperplate"

@implementation XJLStarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        //默认的星星的大小是 13.0f
        self.starSize = 14.0f;
        //未点亮时的颜色是 灰色的
        self.emptyColor = RGBACOLOR(246, 246, 246, 0.5);
        
        //点亮时的颜色是 亮黄色的
        self.fullColor = [UIColor orangeColor];
        
        //默认的长度设置为100
        self.maxStar = 100;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSString* stars = @"★★★★★";
    
    rect = self.bounds;
    CGSize starSize = [stars sizeWithAttributes: @{NSFontAttributeName: [UIFont fontWithName:XJLFontName size:14]}];
    rect.size=starSize;
    [_emptyColor set];
//    [stars drawInRect:rect withFont:XJLStarFont];
    [stars drawInRect:rect withAttributes:@{NSFontAttributeName: [UIFont fontWithName:XJLFontName size:14]}];
    
    CGRect clip = rect;
    clip.size.width = clip.size.width * _showStar / _maxStar;
    CGContextClipToRect(context,clip);
    [_fullColor set];
//    [stars drawInRect:rect withFont:XJLStarFont]
    [stars drawInRect:rect withAttributes:@{NSFontAttributeName: [UIFont fontWithName:XJLFontName size:14]}];
    
}


@end
