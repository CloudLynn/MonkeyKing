//
//  CommentTableViewCell.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/15.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "CommentTableViewCell.h"

@interface CommentTableViewCell ()
///头像
@property (nonatomic, strong) UIImageView *headImgView;
///昵称
@property (nonatomic, strong) UILabel *nicknameLbl;
///内容
@property (nonatomic, strong) UILabel *contentLbl;
///添加时间
@property (nonatomic, strong) UILabel *addTimeLbl;
///分割线
@property (nonatomic, strong) UILabel *lineLbl;

@end

@implementation CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(5);
        make.size.sizeOffset(CGSizeMake(50, 50));
    }];
    
    [self.nicknameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(8);
        make.top.equalTo(self.mas_top).offset(5);
        make.height.mas_offset(@30);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(8);
        make.top.equalTo(self.nicknameLbl.mas_bottom).offset(5);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_offset(@25);
    }];
    
    [self.addTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-8);
        make.bottom.equalTo(self.mas_bottom).offset(-2);
        make.size.sizeOffset(CGSizeMake(150, 20));
    }];
    
    [self.lineLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_offset(@1);
    }];
}
//60
- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [UIImageView new];
        _headImgView.layer.cornerRadius = 25;
        _headImgView.layer.masksToBounds = YES;
        [self addSubview:_headImgView];
    }
    return _headImgView;
}

- (UILabel *)nicknameLbl{
    if (!_nicknameLbl) {
        _nicknameLbl = [UILabel new];
        _nicknameLbl.font = FONT_15;
        _nicknameLbl.textColor = [UIColor orangeColor];
        [self addSubview:_nicknameLbl];
    }
    return _nicknameLbl;
}

- (UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [UILabel new];
        _contentLbl.font = FONT_15;
        [self addSubview:_contentLbl];
    }
    return _contentLbl;
}

- (UILabel *)addTimeLbl{
    if (!_addTimeLbl) {
        _addTimeLbl = [UILabel new];
        _addTimeLbl.font = [UIFont systemFontOfSize:13.0f];
        _addTimeLbl.textColor = [UIColor darkTextColor];
        [self addSubview:_addTimeLbl];
    }
    return _addTimeLbl;
}

- (UILabel *)lineLbl{
    if (!_lineLbl) {
        _lineLbl = [UILabel new];
        _lineLbl.backgroundColor = [UIColor grayColor];
        [self addSubview:_lineLbl];
    }
    return _lineLbl;
}
/*"id": "1",
 "text": "ok",
 "level": "1",
 "addtime": "2017-02-24 08:48",
 "image": ‘’,
 "nickname": "昵称123"
*/
- (void)setCommentDict:(NSDictionary *)commentDict{
    
    [self.headImgView sd_setImageWithURLString:commentDict[@"image"] placeholderImage:[UIImage imageNamed:@"appImg"]];
    self.nicknameLbl.text = commentDict[@"nickname"];
    self.contentLbl.text = [NSString stringWithFormat:@"%@",commentDict[@"text"]];
    self.addTimeLbl.text = commentDict[@"addtime"];
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
