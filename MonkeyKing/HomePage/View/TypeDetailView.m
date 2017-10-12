//
//  TypeDetailView.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/17.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "TypeDetailView.h"
//#import "XJLStarView.h"
#import "EvaluateView.h"

@implementation TypeDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(@50);
    }];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImgView.mas_centerY);
        make.left.equalTo(self.mas_left).offset(10);
        make.height.equalTo(@(60));
        make.width.equalTo(@(60));
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(5);
        make.top.equalTo(self.bgImgView.mas_bottom).offset(0);
        make.size.sizeOffset(CGSizeMake(150, 30));
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLbl.mas_centerY).offset(3);
        make.right.equalTo(self.mas_right).offset(-15);
        make.size.sizeOffset(CGSizeMake(100, 20));
    }];
    
    [self.commentBtn addTarget:self action:@selector(clickCommentButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentBtn.mas_left).offset(10);
        make.top.equalTo(self.commentBtn.mas_bottom).offset(0);
        make.right.equalTo(self.commentBtn.mas_right).offset(-10);
        make.height.mas_equalTo(@20);
    }];
    
    [self.workNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.headImgView.mas_bottom).offset(10);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH, 30));
    }];
    
    [self.distanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.workNumLbl.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH, 30));
    }];
}

- (void)clickCommentButton{
    [self.delegate clickCommentBtn];
}

- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        [_bgImgView setImage:[UIImage imageNamed:@"topBgImg"]];
        [self addSubview:_bgImgView];
    }
    return _bgImgView;
}

- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [UIImageView new];
        _headImgView.userInteractionEnabled = YES;
        [self addSubview:_headImgView];
    }
    return _headImgView;
}

- (UILabel *)nameLbl{
    if (!_nameLbl) {
        _nameLbl = [UILabel new];
        [self addSubview:_nameLbl];
    }
    return _nameLbl;
}

//- (UIImageView *)commentImgView{
//    if (!_commentImgView) {
//        _commentImgView = [UIImageView new];
//        [self addSubview:_commentImgView];
//    }
//    return _commentImgView;
//}

- (UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [UIButton new];
        [_commentBtn setTitle:@"查看评论" forState:UIControlStateNormal];
        _commentBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
        _commentBtn.layer.borderWidth = 1.0f;
        _commentBtn.layer.cornerRadius = 5.0f;
        _commentBtn.layer.masksToBounds = YES;
        [_commentBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self addSubview:_commentBtn];
    }
    return _commentBtn;
}

- (UILabel *)distanceLbl{
    if (!_distanceLbl) {
        _distanceLbl = [UILabel new];
        [self addSubview:_distanceLbl];
    }
    return _distanceLbl;
}

- (UILabel *)workNumLbl{
    if (!_workNumLbl) {
        _workNumLbl = [UILabel new];
        [self addSubview:_workNumLbl];
    }
    return _workNumLbl;
}

- (EvaluateView *)starView{
    if (!_starView) {
        _starView = [[EvaluateView alloc]initWithFrame:CGRectZero count:5];
        [self addSubview:_starView];
    }
    return _starView;
}

- (void)setDetailDictionary:(NSDictionary *)detailDictionary{
    [_headImgView sd_setImageWithURLString:detailDictionary[@"image"] placeholderImage:[UIImage imageNamed:@"appImg"]];
    _nameLbl.text = detailDictionary[@"realname"];
    _distanceLbl.text = [NSString stringWithFormat:@"当前距离：%@",detailDictionary[@"distance"]];
    _workNumLbl.text = [NSString stringWithFormat:@"工号：%@",detailDictionary[@"worknumber"]];
    double level = [detailDictionary[@"level"] doubleValue];
    [_starView showsStarsWithCounts:level];
//    _starView.showStar = (level+1)*20;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
