//
//  ClassTableViewCell.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/14.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "ClassTableViewCell.h"

@implementation ClassTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (UIImageView *)classImgView{
    if (!_classImgView) {
        _classImgView = [UIImageView new];
        [_classImgView setImage:[UIImage imageNamed:@"classImg"]];
        [self addSubview:_classImgView];
    }
    return _classImgView;
}
- (UILabel *)classLbl{
    if (!_classLbl) {
        _classLbl = [UILabel new];
        [self addSubview:_classLbl];
    }
    return _classLbl;
}
- (UIImageView *)nextImgView{
    if (!_nextImgView) {
        _nextImgView = [UIImageView new];
        [_nextImgView setImage:[UIImage imageNamed:@"next"]];
        [self addSubview:_nextImgView];
    }
    return _nextImgView;
}
- (void)initUI{
    [self.classImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.centerY.equalTo(self.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    
    [self.classLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.classImgView.mas_right).offset(8);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.nextImgView.mas_left).offset(8);
        make.height.mas_offset(@30);
    }];
    
    [self.nextImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-8);
        make.centerY.equalTo(self.mas_centerY);
        make.size.sizeOffset(CGSizeMake(20, 20));
    }];
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
