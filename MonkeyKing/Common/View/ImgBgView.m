//
//  ImgBgView.m
//  MonkeyKing
//
//  Created by Apple on 2017/4/17.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "ImgBgView.h"
@interface ImgBgView()

@property (nonatomic, strong)UIImageView *imgView;

@end
@implementation ImgBgView

- (instancetype)initWithFrame:(CGRect)frame andImgUrl:(NSString *)url{
    if (self == [super initWithFrame:frame]) {
        [self clickSingleImgView:url];
    }
    return self;
}

- (void)clickSingleImgView:(NSString *)url{
    
    //创建一个黑色视图做背景
//    UIView *bgView = [[UIView alloc]initWithFrame:self.view.bounds];
//    background = bgView;
    self.backgroundColor = [UIColor colorWithRed:41.0/255 green:36.0/255 blue:33.0/255 alpha:0.8];
//    [self.view addSubview:bgView];
    
    //创建要显示图像的视图
    //初始化要显示的图片内容的imageView
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 50.0, SCREEN_WIDTH, SCREEN_HEIGHT-100)];
    [_imgView sd_setImageWithURLString:url placeholderImage:[UIImage imageNamed:@"appImg"]];
    [self addSubview:_imgView];
    
    //添加手势，点击背景后退出全屏
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [self addGestureRecognizer:tapGesture];
    
    //添加捏合手势识别器，changeImageSize:方法实现图片的放大与缩小
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(changeImageSize:)];
    [self addGestureRecognizer:pinchRecognizer];
    
    
    
    //放大过程中的动画
    [self shakeToShow:self];
}

-(void)changeImageSize:(UIPinchGestureRecognizer *)recognizer
{
    CGRect frame = self.imgView.frame;
    
    //监听两手指滑动的距离，改变imageView的frame
    frame.size.width = recognizer.scale*128;
    frame.size.height = recognizer.scale*128;
    self.imgView.frame = frame;
    
    //保证imageView中心不动
    self.imgView.center =CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

//放大过程中出现的缓慢动画
- (void)shakeToShow:(UIView *)aView{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

//点击图片后退出大图模式
- (void)closeView{
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
