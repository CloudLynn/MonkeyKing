//
//  InputTextView.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/8.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "InputTextView.h"

@implementation InputTextView

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeInterfaceAndTitle:title];
    }
    return self;
}

- (void)initializeInterfaceAndTitle:(NSString *)title{
    _titleLbl = [UILabel new];
    _titleLbl.text = title;
    _titleLbl.font = FONT_15;
    [self addSubview:_titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(8);
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.width.mas_offset(@80);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
    }];
    
    _contentTxt = [UITextField new];
    _contentTxt.placeholder = [NSString stringWithFormat:@"请输入%@",title];
    _contentTxt.font = FONT_15;
    _contentTxt.delegate = self;
    [self addSubview:_contentTxt];
    [self.contentTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLbl.mas_right).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-8);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = COLOR_APP(0.3);
    [self.contentTxt addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(self.contentTxt.text);
    }
}

#pragma mark - UITextFieldDelegate -
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(self.contentTxt.text);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
