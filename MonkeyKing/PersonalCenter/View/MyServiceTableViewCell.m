//
//  MyServiceTableViewCell.m
//  MonkeyKing
//
//  Created by Apple on 2017/3/2.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "MyServiceTableViewCell.h"



@implementation MyServiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.centerY.equalTo(self.mas_centerY);
        make.size.sizeOffset(CGSizeMake(50, 50));
    }];
    
    
    [self.typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(8);
        make.top.equalTo(self.mas_top).offset(3);
        make.right.equalTo(self.mas_right).offset(-100);
        make.height.mas_offset(@30);
    }];
    
    [self.uptimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(8);
        make.bottom.equalTo(self.mas_bottom).offset(-3);
        make.right.equalTo(self.mas_right).offset(-100);
        make.height.mas_offset(@30);
    }];

    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-28);
        make.centerY.equalTo(self.uptimeLbl.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    
    
    [self.setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-28);
        make.centerY.equalTo(self.typeLbl.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    
    [self.nextImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-2);
        make.size.sizeOffset(CGSizeMake(15, 15));
    }];
    
    
    //    [self.areaLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.mas_left).offset(8);
    //        make.top.equalTo(self.typeLbl.mas_bottom).offset(8);
    //        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH/2-16, 25));
    //    }];
    //
    //    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.areaLbl.mas_right).offset(8);
    //        make.top.equalTo(self.typeLbl.mas_bottom).offset(8);
    //        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH/2-16, 25));
    //    }];
    //
    //    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.mas_left).offset(8);
    //        make.top.equalTo(self.typeLbl.mas_bottom).offset(8);
    //        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH/2-16, 25));
    //    }];
    //
    //    [self.notesLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.nameLbl.mas_right).offset(8);
    //        make.top.equalTo(self.priceLbl.mas_bottom).offset(8);
    //        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH/2-16, 25));
    //    }];
    
}

- (void)setDictionary:(NSDictionary *)dictionary{
    /*"image": null,				     // 图片
     "serve_type": "1",	// 服务类型 （1 普通类型 、2 招聘类型 、3 乘运类型）
     "type": "家政服务-水果配送",	// 服务类型
     "refresh_time": "2017-02-10 07:52",	// 最近更新时间
     "serve_id": "203"
*/
    [self.headImgView sd_setImageWithURLString:dictionary[@"image"] placeholderImage:[UIImage imageNamed:@"appImg"]];
    self.typeLbl.text = [NSString stringWithFormat:@"服务类型：%@",dictionary[@"type"]];
    self.uptimeLbl.text = [NSString stringWithFormat:@"更新时间：%@",dictionary[@"refresh_time"]];
    
}

- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [UIImageView new];
        [self addSubview:_headImgView];
    }
    return _headImgView;
}


- (UILabel *)typeLbl{
    if (!_typeLbl) {
        _typeLbl = [UILabel new];
        _typeLbl.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_typeLbl];
    }
    return _typeLbl;
}

/*/- (UILabel *)areaLbl{
//    if (!_areaLbl) {
//        _areaLbl = [UILabel new];
//        _areaLbl.font = [UIFont systemFontOfSize:14.0f];
//        [self addSubview:_areaLbl];
//    }
//    return _areaLbl;
//}
//
//- (UILabel *)nameLbl{
//    if (!_nameLbl) {
//        _nameLbl = [UILabel new];
//        _nameLbl.font = [UIFont systemFontOfSize:14.0f];
//        [self addSubview:_nameLbl];
//    }
//    return _nameLbl;
//}

//- (UILabel *)priceLbl{
//    if (!_priceLbl) {
//        _priceLbl = [UILabel new];
//        _priceLbl.font = [UIFont systemFontOfSize:14.0f];
//        [self addSubview:_priceLbl];
//    }
//    return _priceLbl;
//}
//
//- (UILabel *)notesLbl{
//    if (!_notesLbl) {
//        _notesLbl = [UILabel new];
//        _notesLbl.font = [UIFont systemFontOfSize:14.0f];
//        [self addSubview:_notesLbl];
//    }
//    return _notesLbl;
//}*/

- (UILabel *)uptimeLbl{
    if (!_uptimeLbl) {
        _uptimeLbl = [UILabel new];
        _uptimeLbl.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_uptimeLbl];
    }
    return _uptimeLbl;
}

- (UIButton *)delBtn{
    if (!_delBtn) {
        _delBtn = [UIButton new];
        [_delBtn setImage:[UIImage imageNamed:@"delImg"] forState:UIControlStateNormal];
        [self addSubview:_delBtn];
    }
    return _delBtn;
}

- (UIButton *)setBtn{
    if (!_setBtn) {
        _setBtn = [UIButton new];
        [_setBtn setImage:[UIImage imageNamed:@"setImg"] forState:UIControlStateNormal];
        [self addSubview:_setBtn];
    }
    return _setBtn;
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
