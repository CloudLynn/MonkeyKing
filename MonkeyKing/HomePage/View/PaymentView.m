//
//  PaymentView.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/24.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "PaymentView.h"

@implementation PaymentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self.typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.centerY.equalTo(self.mas_centerY);
        make.size.sizeOffset(CGSizeMake(50, 50));
    }];
    [self.typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeImgView.mas_right).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-40);
    }];
    
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(40, 40));
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-8);
    }];
    
}

- (UIImageView *)typeImgView{
    if (!_typeImgView) {
        _typeImgView = [UIImageView new];
        [self addSubview:_typeImgView];
    }
    return _typeImgView;
}

- (UILabel *)typeLbl{
    if (!_typeLbl) {
        _typeLbl = [UILabel new];
        [self addSubview:_typeLbl];
    }
    return _typeLbl;
}

- (UIButton *)checkBtn{
    if (!_checkBtn) {
        _checkBtn = [UIButton new];
        [self addSubview:_checkBtn];
    }
    return _checkBtn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
