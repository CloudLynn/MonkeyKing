//
//  TalentHeaderView.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/28.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "TalentHeaderView.h"

@implementation TalentHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (UIImageView *)classImgView{
    if (!_classImgView) {
        _classImgView = [UIImageView new];
        [_classImgView setImage:[UIImage imageNamed:@"classImg"]];
        [self addSubview:_classImgView];
    }
    return _classImgView;
}
- (UILabel *)classLbl{
    if (!_classLbl) {
        _classLbl = [UILabel new];
        [self addSubview:_classLbl];
    }
    return _classLbl;
}
- (UIImageView *)nextImgView{
    if (!_nextImgView) {
        _nextImgView = [UIImageView new];
        [_nextImgView setImage:[UIImage imageNamed:@"next"]];
        [self addSubview:_nextImgView];
    }
    return _nextImgView;
}
- (void)initUI{
    [self.classImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.centerY.equalTo(self.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    
    [self.classLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.classImgView.mas_right).offset(8);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.nextImgView.mas_left).offset(8);
        make.height.mas_offset(@30);
    }];
    
    [self.nextImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-8);
        make.centerY.equalTo(self.mas_centerY);
        make.size.sizeOffset(CGSizeMake(20, 20));
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
