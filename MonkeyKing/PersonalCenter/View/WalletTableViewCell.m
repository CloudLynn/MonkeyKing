//
//  WalletTableViewCell.m
//  MonkeyKing
//
//  Created by Apple on 2017/4/21.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "WalletTableViewCell.h"

@implementation WalletTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.size.sizeOffset(CGSizeMake(60, 60));
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-100);
        make.height.mas_offset(@30);
    }];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.right.equalTo(self.mas_right).offset(-100);
        make.height.mas_offset(@30);
    }];
    
    [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_offset(@70);
    }];
}

- (void)setWalletDict:(NSDictionary *)walletDict{
    [self.headImgView sd_setImageWithURLString:walletDict[@"image"] placeholderImage:[UIImage imageNamed:@"appImg"]];
    self.titleLbl.text = [NSString stringWithFormat:@"%@",walletDict[@"source"]];
    self.timeLbl.text = [NSString stringWithFormat:@"%@",walletDict[@"addtime"]];
    self.moneyLbl.text = [NSString stringWithFormat:@"%@",walletDict[@"bmikece"]];
}

- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [UIImageView new];
        _headImgView.layer.cornerRadius = 30.0;
        _headImgView.layer.masksToBounds = YES;
        [self addSubview:_headImgView];
    }
    return _headImgView;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.font = FONT_15;
        [self addSubview:_titleLbl];
    }
    return _titleLbl;
}

- (UILabel *)timeLbl{
    if (!_timeLbl) {
        _timeLbl = [UILabel new];
        _timeLbl.font = [UIFont systemFontOfSize:14.0f];
        _timeLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:_timeLbl];
    }
    return _timeLbl;
}

- (UILabel *)moneyLbl{
    if (!_moneyLbl) {
        _moneyLbl = [UILabel new];
        _moneyLbl.font = [UIFont systemFontOfSize:16.0 weight:2];
        _moneyLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:_moneyLbl];
    }
    return _moneyLbl;
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
