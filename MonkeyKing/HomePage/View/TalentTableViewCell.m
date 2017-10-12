//
//  TalentTableViewCell.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/28.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "TalentTableViewCell.h"

@implementation TalentTableViewCell

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
        make.size.sizeOffset(CGSizeMake(70, 70));
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.size.sizeOffset(CGSizeMake(75, 30));
    }];
    
    [self.educationLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(12);
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.mas_offset(@25);
    }];
    
    [self.jobTypeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(12);
        make.top.equalTo(self.educationLbl.mas_bottom).offset(0);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.mas_offset(@25);
    }];
    
    [self.workYearLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(12);
        make.top.equalTo(self.jobTypeLbl.mas_bottom).offset(0);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.mas_offset(@25);
    }];
    
    [self.upTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(12);
        make.top.equalTo(self.workYearLbl.mas_bottom).offset(0);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.mas_offset(@25);
    }];
    
    [self.nextImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(25, 25));
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-8);
    }];
    
}


- (void)setMarketDict:(NSDictionary *)marketDict{
    [self.headImgView sd_setImageWithURLString:[marketDict objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"appImg"]];
    self.nameLbl.text = marketDict[@"realname"];
    self.educationLbl.text = [NSString stringWithFormat:@"学    历：%@",marketDict[@"education"]];
    self.jobTypeLbl.text = [NSString stringWithFormat:@"工作类型：%@",marketDict[@"type"]];
    self.workYearLbl.text = [NSString stringWithFormat:@"工作年限：%@",marketDict[@"job_year"]];
    self.upTimeLbl.text = [NSString stringWithFormat:@"更新时间：%@",marketDict[@"refresh_time"]];
}


- (UILabel *)nameLbl{
    if (!_nameLbl) {
        _nameLbl = [UILabel new];
        _nameLbl.font = [UIFont systemFontOfSize:13];
        [self addSubview:_nameLbl];
    }
    return _nameLbl;
}
- (UILabel *)educationLbl{
    if (!_educationLbl) {
        _educationLbl = [UILabel new];
        _educationLbl.font = [UIFont systemFontOfSize:13];
        [self addSubview:_educationLbl];
    }
    return _educationLbl;
}
- (UILabel *)jobTypeLbl{
    if (!_jobTypeLbl) {
        _jobTypeLbl = [UILabel new];
        _jobTypeLbl.font = [UIFont systemFontOfSize:13];
        [self addSubview:_jobTypeLbl];
    }
    return _jobTypeLbl;
}
- (UILabel *)workYearLbl{
    if (!_workYearLbl) {
        _workYearLbl  =[UILabel new];
        _workYearLbl.font = [UIFont systemFontOfSize:13];
        [self addSubview:_workYearLbl];
    }
    return _workYearLbl;
}
- (UILabel *)upTimeLbl{
    if (!_upTimeLbl) {
        _upTimeLbl = [UILabel new];
        _upTimeLbl.font = [UIFont systemFontOfSize:13];
        [self addSubview:_upTimeLbl];
    }
    return _upTimeLbl;
}
- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [UIImageView new];
//        [_headImgView setImage:[UIImage imageNamed:@"appImg"]];
        [self addSubview:_headImgView];
    }
    return _headImgView;
}
- (UIImageView *)nextImgView{
    if (!_nextImgView) {
        _nextImgView = [UIImageView new];
        [_nextImgView setImage:[UIImage imageNamed:@"next"]];
        [self addSubview:_nextImgView];
    }
    return _nextImgView;
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
