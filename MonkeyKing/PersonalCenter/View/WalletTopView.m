//
//  WalletTopView.m
//  MonkeyKing
//
//  Created by Apple on 2017/4/18.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "WalletTopView.h"

@implementation WalletTopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    [self.accountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.equalTo(self.mas_top).offset(10);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH-20, 30));
    }];
    
    UILabel *titleOne = [UILabel new];
    titleOne.text = @"余额:";
    titleOne.textColor = [UIColor darkGrayColor];
    titleOne.font = FONT_15;
    [self addSubview:titleOne];
    
    UILabel *titleTwo = [UILabel new];
    titleTwo.text = @"可提现金额:";
    titleTwo.textColor = [UIColor darkGrayColor];
    titleTwo.font = FONT_15;
    [self addSubview:titleTwo];
    
    [titleOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.equalTo(self.accountLbl.mas_bottom).offset(5);
        make.size.sizeOffset(CGSizeMake(60, 30));
    }];
    
    [self.balanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleOne.mas_right).offset(0);
        make.centerY.equalTo(titleOne.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_offset(@30);
    }];
    
    [titleTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.equalTo(self.balanceLbl.mas_bottom).offset(0);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    [self.withdrawalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleTwo.mas_right).offset(5);
        make.centerY.equalTo(titleTwo.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_offset(@30);
    }];
    
}

#pragma mark - initUI -

- (UILabel *)accountLbl{
    if (!_accountLbl) {
        _accountLbl = [UILabel new];
        _accountLbl.text = [NSString stringWithFormat:@"账号:%@",USER_USER];
        [self addSubview:_accountLbl];
    }
    return _accountLbl;
}

- (UILabel *)balanceLbl{
    if (!_balanceLbl) {
        _balanceLbl = [UILabel new];
        _balanceLbl.font = FONT_15;
        _balanceLbl.textColor = [UIColor redColor];
        [self addSubview:_balanceLbl];
    }
    return _balanceLbl;
}

- (UILabel *)withdrawalLbl{
    if (!_withdrawalLbl) {
        _withdrawalLbl = [UILabel new];
        _withdrawalLbl.font = FONT_15;
        _withdrawalLbl.textColor = [UIColor redColor];
        [self addSubview:_withdrawalLbl];
    }
    return _withdrawalLbl;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
