//
//  ClassTypeTableViewCell.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/14.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "ClassTypeTableViewCell.h"

@interface ClassTypeTableViewCell()

@end

@implementation ClassTypeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.equalTo(self.mas_top).offset(8);
        make.size.sizeOffset(CGSizeMake(50, 50));
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.equalTo(self.headImgView.mas_bottom).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.width.mas_offset(@150);
    }];
    
    [self.serviceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(5);
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-50);
        make.height.mas_offset(@30);
    }];
    [self.numberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(8);
        make.bottom.equalTo(self.nameLbl.mas_top);
        make.right.equalTo(self.mas_right).offset(-50);
        make.height.mas_offset(@25);
    }];
    
    [self.distanceImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-130);
        make.centerY.equalTo(self.mas_centerY);
        make.size.sizeOffset(CGSizeMake(17, 20));
    }];
    
    [self.distanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.distanceImgView.mas_right).offset(0);
        make.height.mas_offset(@30);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-66);
    
    }];
    
    [self.nextImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-8);
        make.centerY.equalTo(self.mas_centerY);
        make.size.sizeOffset(CGSizeMake(20, 20));
    }];
    
}

- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [UIImageView new];
        [self addSubview:_headImgView];
    }
    return _headImgView;
}

- (UILabel *)nameLbl{
    if (!_nameLbl) {
        _nameLbl = [UILabel new];
        _nameLbl.font = FONT_15;
        _nameLbl.textColor = [UIColor orangeColor];
        [self addSubview:_nameLbl];
    }
    return _nameLbl;
}

-(UILabel *)serviceLbl{
    if (!_serviceLbl) {
        _serviceLbl = [UILabel new];
        [self addSubview:_serviceLbl];
    }
    return _serviceLbl;
}

- (UILabel *)numberLbl{
    if (!_numberLbl) {
        _numberLbl = [UILabel new];
        _numberLbl.font = FONT_15;
        [self addSubview:_numberLbl];
    }
    return _numberLbl;
}

- (UIImageView *)distanceImgView{
    if (!_distanceImgView) {
        _distanceImgView = [UIImageView new];
        [_distanceImgView setImage:[UIImage imageNamed:@"distance"]];
        [self addSubview:_distanceImgView];
    }
    return _distanceImgView;
}

- (UILabel *)distanceLbl{
    if (!_distanceLbl) {
        _distanceLbl = [UILabel new];
        _distanceLbl.font = [UIFont systemFontOfSize:14];
        [self addSubview:_distanceLbl];
    }
    return _distanceLbl;
}

- (UIImageView *)nextImgView{
    if (!_nextImgView) {
        _nextImgView = [UIImageView new];
        [_nextImgView setImage:[UIImage imageNamed:@"next"]];
        [self addSubview:_nextImgView];
    }
    return _nextImgView;
}

- (void)setContentDictionary:(NSDictionary *)contentDictionary{
    [self.headImgView sd_setImageWithURLString:contentDictionary[@"image"] placeholderImage:[UIImage imageNamed:@"appImg"]];
    self.nameLbl.text = contentDictionary[@"user_name"];
    self.serviceLbl.text = contentDictionary[@"name"];
    self.distanceLbl.text = [NSString stringWithFormat:@"%@",contentDictionary[@"distance"]];
    self.numberLbl.text = [NSString stringWithFormat:@"工号：%@",contentDictionary[@"worknumber"]];
    
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
