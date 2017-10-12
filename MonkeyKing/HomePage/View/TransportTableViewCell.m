//
//  TransportTableViewCell.m
//  MonkeyKing
//
//  Created by Apple on 2017/3/15.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "TransportTableViewCell.h"

@interface TransportTableViewCell()

@end

@implementation TransportTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    UILabel *startP = [UILabel new];
    startP.font = FONT_15;
    startP.text = @"起始价";
    [self addSubview:startP];
    UILabel *transP = [UILabel new];
    transP.font = FONT_15;
    transP.text = @"乘运价";
    [self addSubview:transP];
    UILabel *workN = [UILabel new];
    workN.font = FONT_15;
    workN.text = @"工号";
    [self addSubview:workN];
    UILabel *distance = [UILabel new];
    distance.font = FONT_15;
    distance.text = @"距离";
    [self addSubview:distance];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.equalTo(self.mas_top).offset(8);
        make.size.sizeOffset(CGSizeMake(60, 60));
    }];
    
    
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.top.equalTo(self.headImgView.mas_bottom).offset(3);
        make.right.equalTo(self.headImgView.mas_right);
        make.height.mas_offset(@30);
    }];
    
    [self.starImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).offset(8);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(3);
        make.right.equalTo(self.nameLbl.mas_right);
        make.height.mas_offset(@25);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.top.equalTo(self.mas_top).offset(8);
        make.right.equalTo(self.mas_right).offset(-8);
        make.height.mas_offset(@25);
    }];
    
    [startP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(3);
        make.size.sizeOffset(CGSizeMake(50, 25));
    }];
    CGFloat width = SCREEN_WIDTH-60-8-5;
    [self.startPLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startP.mas_right).offset(0);
        make.centerY.equalTo(startP.mas_centerY);
        make.size.sizeOffset(CGSizeMake(width/2-70, 25));
    }];
    
    [transP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startPLbl.mas_right).offset(8);
        make.centerY.equalTo(startP.mas_centerY);
        make.size.sizeOffset(CGSizeMake(50, 25));
    }];
    [self.transPLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(transP.mas_right).offset(0);
        make.centerY.equalTo(startP.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-3);
        make.height.mas_offset(@25);
    }];
    
    [workN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.top.equalTo(self.startPLbl.mas_bottom).offset(3);
        make.size.sizeOffset(CGSizeMake(50, 25));
    }];
    [self.workNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workN.mas_right).offset(0);
        make.centerY.equalTo(workN.mas_centerY);
        make.size.sizeOffset(CGSizeMake(width/2-70, 25));
    }];
    
    [distance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startPLbl.mas_right).offset(8);
        make.centerY.equalTo(workN.mas_centerY);
        make.size.sizeOffset(CGSizeMake(50, 25));
    }];
    [self.distanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(distance.mas_right).offset(0);
        make.centerY.equalTo(workN.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-3);
        make.height.mas_offset(@25);
    }];
}

- (void)setTransDict:(NSDictionary *)transDict{
    NSLog(@"%@",transDict);
    [self.headImgView sd_setImageWithURLString:transDict[@"image"] placeholderImage:[UIImage imageNamed:@"user_headImg"]];
    self.nameLbl.text = [NSString stringWithFormat:@"%@",transDict[@"realname"]];
    self.titleLbl.text = [NSString stringWithFormat:@"%@",transDict[@"name"]];
    self.startPLbl.text = [NSString stringWithFormat:@"￥%@",transDict[@"start"]];
    self.transPLbl.text = [NSString stringWithFormat:@"￥%@",transDict[@"course"]];
    self.workNumLbl.text = [NSString stringWithFormat:@"%@",transDict[@"worknumber"]];
    self.distanceLbl.text = [NSString stringWithFormat:@"%@",transDict[@"distance"]];
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
        _nameLbl.font = [UIFont systemFontOfSize:14];
        [self addSubview:_nameLbl];
    }
    return _nameLbl;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.font = FONT_15;
        [self addSubview:_titleLbl];
    }
    return _titleLbl;
}

- (UILabel *)startPLbl{
    if (!_startPLbl) {
        _startPLbl = [UILabel new];
        _startPLbl.font = FONT_15;
        [self addSubview:_startPLbl];
    }
    return _startPLbl;
}

- (UILabel *)transPLbl{
    if (!_transPLbl) {
        _transPLbl = [UILabel new];
        _transPLbl.font = FONT_15;
        [self addSubview:_transPLbl];
    }
    return _transPLbl;
}

- (UILabel *)workNumLbl{
    if (!_workNumLbl) {
        _workNumLbl = [UILabel new];
        _workNumLbl.font = FONT_15;
        [self addSubview:_workNumLbl];
    }
    return _workNumLbl;
}

- (UILabel *)distanceLbl{
    if (!_distanceLbl) {
        _distanceLbl = [UILabel new];
        _distanceLbl.font = FONT_15;
        [self addSubview:_distanceLbl];
    }
    return _distanceLbl;
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
