//
//  OrderDetailTableViewCell.m
//  MonkeyKing
//
//  Created by Apple on 2017/4/12.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "OrderDetailTableViewCell.h"

@interface OrderDetailTableViewCell ()


@end

@implementation OrderDetailTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    [self.proImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.equalTo(self.mas_top).offset(8);
        make.size.sizeOffset(CGSizeMake(60, 60));
    }];
    
    CGFloat width = (SCREEN_WIDTH-90)/2;
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.proImgView.mas_right).offset(8);
        make.top.equalTo(self.mas_top).offset(5);
        make.size.sizeOffset(CGSizeMake(width, 30));
    }];
    
    [self.costLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLbl.mas_right).offset(5);
        make.centerY.equalTo(self.nameLbl.mas_centerY);
        make.size.sizeOffset(CGSizeMake(width, 30));
    }];
    
    [self.countLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(5);
        make.size.sizeOffset(CGSizeMake(width/2+50, 30));
    }];
    
    [self.addtimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countLbl.mas_right).offset(5);
        make.centerY.equalTo(self.countLbl.mas_centerY);
        make.size.sizeOffset(CGSizeMake(width, 30));
    }];
}

- (UIImageView *)proImgView{
    if (!_proImgView) {
        _proImgView = [UIImageView new];
        [self addSubview:_proImgView];
    }
    return _proImgView;
}

- (UILabel *)nameLbl{
    if (!_nameLbl) {
        _nameLbl = [UILabel new];
        _nameLbl.font = FONT_15;
        [self addSubview:_nameLbl];
    }
    return _nameLbl;
}

- (UILabel *)costLbl{
    if (!_costLbl) {
        _costLbl = [UILabel new];
        _costLbl.font = FONT_15;
        [self addSubview:_costLbl];
    }
    return _costLbl;
}

- (UILabel *)countLbl{
    if (!_countLbl) {
        _countLbl = [UILabel new];
        _countLbl.font = FONT_15;
        [self addSubview:_countLbl];
    }
    return _countLbl;
}

- (UILabel *)addtimeLbl{
    if (!_addtimeLbl) {
        _addtimeLbl = [UILabel new];
        _addtimeLbl.font = [UIFont systemFontOfSize:14.0f];
//        _addtimeLbl.textColor = [UIColor orangeColor];
        [self addSubview:_addtimeLbl];
    }
    return _addtimeLbl;
}

- (void)setDetailDict:(NSDictionary *)detailDict{
    [self.proImgView sd_setImageWithURLString:detailDict[@"image"] placeholderImage:[UIImage imageNamed:@"appImg"]];
    self.nameLbl.text = [NSString stringWithFormat:@"名称：%@",detailDict[@"product_name"]];
    self.costLbl.text = [NSString stringWithFormat:@"单价：￥%@",detailDict[@"product_cost"]];
    self.countLbl.text = [NSString stringWithFormat:@"数量：%@",detailDict[@"product_count"]];
    self.addtimeLbl.text = [NSString stringWithFormat:@"金额：￥%@",detailDict[@"money"]];
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
