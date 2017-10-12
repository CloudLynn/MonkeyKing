//
//  MyProductTableViewCell.m
//  MonkeyKing
//
//  Created by Apple on 2017/3/10.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "MyProductTableViewCell.h"

@implementation MyProductTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.centerY.equalTo(self.mas_centerY);
        make.size.sizeOffset(CGSizeMake(50, 50));
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(12);
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-50);
        make.height.mas_offset(@30);
    }];
    
    [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(12);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.right.equalTo(self.mas_right).offset(-50);
        make.height.mas_offset(@30);
    }];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-40);
        make.centerY.equalTo(self.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
}

- (UILabel *)nameLbl{
    if (!_nameLbl) {
        _nameLbl = [UILabel new];
        _nameLbl.font = FONT_15;
        [self addSubview:_nameLbl];
    }
    return _nameLbl;
}

- (UILabel *)moneyLbl{
    if (!_moneyLbl) {
        _moneyLbl = [UILabel new];
        _moneyLbl.font = FONT_15;
        [self addSubview:_moneyLbl];
    }
    return _moneyLbl;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.layer.borderColor = [[UIColor orangeColor] CGColor];
        _imgView.layer.borderWidth = 1.0f;
        _imgView.layer.cornerRadius = 8.0f;
        _imgView.layer.masksToBounds = YES;
        [self addSubview:_imgView];
    }
    return _imgView;
}

- (UIButton *)delBtn{
    if (!_delBtn) {
        _delBtn = [UIButton new];
        [_delBtn setImage:[UIImage imageNamed:@"delImg"] forState:UIControlStateNormal];
        [self addSubview:_delBtn];
    }
    return _delBtn;
}

- (UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [UIButton new];
        [_changeBtn setImage:[UIImage imageNamed:@"setImg"] forState:UIControlStateNormal];
        [self addSubview:_changeBtn];
    }
    return _changeBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
