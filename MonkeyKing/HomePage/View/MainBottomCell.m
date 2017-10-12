//
//  MainBottomCell.m
//  MainDemo
//
//  Created by XienaShen on 17/2/9.
//  Copyright © 2017年 XienaShen. All rights reserved.
//

#import "MainBottomCell.h"

#import "LeftView.h"
#import "RightView.h"

@interface MainBottomCell()<LeftDelegate,RightDelegate>
@property (nonatomic,strong)LeftView *leftView;
@property (nonatomic,strong)RightView *rightView;
@end

@implementation MainBottomCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(0);
        make.width.mas_equalTo((SCREEN_WIDTH+30)/2);
        make.height.mas_equalTo(210);
    }];
    
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView).offset(0);
        make.width.mas_equalTo((SCREEN_WIDTH-30)/2);
        make.height.mas_equalTo(210);
    }];
}

-(void)showData:(id)leftData right:(id)rightData{
    WS(weakSelf)
    [weakSelf.leftView showData:leftData];
    [weakSelf.rightView showData:rightData];
}

#pragma -mark ========== LeftDelegate,RightDelegate

-(void)returnLeft:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(returnLeft:)]) {
        [self.delegate returnLeft:index];
    }
}

-(void)returnRight:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(returnRight:)]) {
        [self.delegate returnRight:index];
    }
}

#pragma -mark ============ getter
-(LeftView *)leftView{
    if (!_leftView) {
        _leftView = [[LeftView alloc]initWithFrame:CGRectZero];
        _leftView.delegate = self;
        [self.contentView addSubview:_leftView];
    }
    return _leftView;
}

-(RightView *)rightView{
    if (!_rightView) {
        _rightView = [[RightView alloc]initWithFrame:CGRectZero];
        _rightView.delegate = self;
        [self.contentView addSubview:_rightView];
    }
    return _rightView;
}
@end
