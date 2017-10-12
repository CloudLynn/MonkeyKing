//
//  ContactTopTableViewCell.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/8.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "ContactTopTableViewCell.h"

@implementation ContactTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeUserInterface];
    }
    return self;
}


- (void)initializeUserInterface{
    
    _headImgView = [UIImageView new];
    if (ISLOGIN) {
        [_headImgView setImage:[UIImage imageNamed:@"user_headImg"]];
    } else {
        [_headImgView setImage:[UIImage imageNamed:@"user_headImg"]];
    }
    [self addSubview:_headImgView];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(10, 10, 10, self.bounds.size.width-(self.bounds.size.height-20)-10));
    }];
    
    _introduceLbl = [UILabel new];
    _introduceLbl.text = @"介绍";
    _introduceLbl.font = FONT_15;
    [self addSubview:_introduceLbl];
    [self.introduceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(15);
        make.top.equalTo(self.mas_top).offset(0);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.mas_offset(@30);
    }];
    
    _nameLbl = [UILabel new];
    _nameLbl.text = @"名字";
    _nameLbl.font = FONT_15;
    [self addSubview:_nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(15);
        make.top.equalTo(self.introduceLbl.mas_bottom).offset(5);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.mas_offset(@30);
    }];
    
    _numberLbl = [UILabel new];
    _numberLbl.text = @"工号";
    _numberLbl.font = FONT_15;
    [self addSubview:_numberLbl];
    [self.numberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(15);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(5);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.mas_offset(@30);
    }];
    
    _loginBtn = [UIButton new];
    _loginBtn.titleLabel.font = FONT_15;
    [_loginBtn setBackgroundColor:COLOR_APP(0.3)];
    [self addSubview:_loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(30);
        make.size.sizeOffset(CGSizeMake(100, 30));
        make.centerY.mas_equalTo(self.headImgView.mas_centerY);
    }];
    
}

- (void)setIslogin:(BOOL)islogin{
    
    if (islogin) {
        self.introduceLbl.hidden = NO;
        self.nameLbl.hidden = NO;
        self.numberLbl.hidden = NO;
        self.loginBtn.hidden = YES;
        _introduceLbl.text = @"个人";
        _nameLbl.text = USER_NICKNAME;
        _numberLbl.text = USER_WORKNUMBER;
        
    } else {
        self.introduceLbl.hidden = YES;
        self.nameLbl.hidden = YES;
        self.numberLbl.hidden = YES;
        self.loginBtn.hidden = NO;
        [_loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
