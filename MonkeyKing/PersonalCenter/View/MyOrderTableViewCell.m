//
//  MyOrderTableViewCell.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/10.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI{
    
    _nameLbl = [UILabel new];
    _nameLbl.font = FONT_15;
    [self addSubview:_nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.top.equalTo(self.mas_top).offset(5);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    _callSellerBtn = [UIButton new];
    [_callSellerBtn.titleLabel setFont:FONT_15];
    [_callSellerBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
    [_callSellerBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _callSellerBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
    _callSellerBtn.layer.borderWidth = 1.0f;
    _callSellerBtn.layer.cornerRadius = 8;
    _callSellerBtn.layer.masksToBounds = YES;
//    _callSellerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:_callSellerBtn];
    [self.callSellerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.size.sizeOffset(CGSizeMake(100, 30));
    }];
    
    _proImgView = [UIImageView new];
    _proImgView.layer.cornerRadius = 5;
    _proImgView.layer.masksToBounds = YES;
    [self addSubview:_proImgView];
    [self.proImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(8);
        make.size.sizeOffset(CGSizeMake(50, 50));
    }];
    
    _countLbl = [UILabel new];
    _countLbl.font = [UIFont systemFontOfSize:14];
    [self addSubview:_countLbl];
    [self.countLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.proImgView.mas_right).offset(12);
        make.top.equalTo(self.proImgView.mas_top).offset(0);
        make.right.equalTo(self.mas_right).offset(-100);
        make.height.mas_offset(@25);
    }];
    
    _priceLbl = [UILabel new];
    _priceLbl.font = [UIFont systemFontOfSize:14];
    [self addSubview:_priceLbl];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.proImgView.mas_right).offset(12);
        make.bottom.equalTo(self.proImgView.mas_bottom).offset(0);
        make.right.equalTo(self.mas_right).offset(-100);
        make.height.mas_offset(@25);
    }];
    
    _statusLbl = [UILabel new];
    _statusLbl.font = [UIFont systemFontOfSize:14];
    _statusLbl.textColor = [UIColor orangeColor];
    [self addSubview:_statusLbl];
    [self.statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.proImgView.mas_bottom).offset(8);
        make.height.mas_offset(@30);
        make.width.mas_offset(@120);
    }];
    
//    _paymentBtn = [UIButton new];
////    [_paymentBtn setTitle:@"确认付款" forState:UIControlStateNormal];
//    _paymentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_paymentBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    _paymentBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
//    _paymentBtn.layer.borderWidth = 1.0f;
//    _paymentBtn.layer.cornerRadius = 8;
//    _paymentBtn.layer.masksToBounds = YES;
//    [self addSubview:_paymentBtn];
//    [self.paymentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.callSellerBtn.mas_right);
//        make.centerY.equalTo(self.statusLbl.mas_centerY);
//        make.size.sizeOffset(CGSizeMake(80, 25));
//    }];
//    
//    _refundBtn = [UIButton new];
////    [_refundBtn setTitle:@"申请退款" forState:UIControlStateNormal];
//    _refundBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_refundBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    _refundBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
//    _refundBtn.layer.borderWidth = 1.0f;
//    _refundBtn.layer.cornerRadius = 8;
//    _refundBtn.layer.masksToBounds = YES;
//    [self addSubview:_refundBtn];
//    [self.refundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.paymentBtn.mas_left).offset(-5);
//        make.centerY.equalTo(self.statusLbl.mas_centerY);
//        make.size.sizeOffset(CGSizeMake(80, 25));
//    }];
    _firstBtn = [UIButton new];
    _firstBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_firstBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _firstBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
    _firstBtn.layer.borderWidth = 1.0f;
    _firstBtn.layer.cornerRadius = 8;
    _firstBtn.layer.masksToBounds = YES;
    [self addSubview:_firstBtn];
    [self.firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.callSellerBtn.mas_right);
        make.centerY.equalTo(self.statusLbl.mas_centerY);
        make.size.sizeOffset(CGSizeMake(80, 25));
    }];
    
    _secondBtn = [UIButton new];
    //    [_refundBtn setTitle:@"申请退款" forState:UIControlStateNormal];
    _secondBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_secondBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _secondBtn.layer.borderColor = [[UIColor orangeColor] CGColor];
    _secondBtn.layer.borderWidth = 1.0f;
    _secondBtn.layer.cornerRadius = 8;
    _secondBtn.layer.masksToBounds = YES;
    [self addSubview:_secondBtn];
    [self.secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.firstBtn.mas_left).offset(-5);
        make.centerY.equalTo(self.statusLbl.mas_centerY);
        make.size.sizeOffset(CGSizeMake(80, 25));
    }];
    
    _orderTimeLbl = [UILabel new];
    [_orderTimeLbl setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    _orderTimeLbl.textColor = [UIColor orangeColor];
    _orderTimeLbl.font = [UIFont systemFontOfSize:14];
    [self addSubview:_orderTimeLbl];
    [self.orderTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.size.sizeOffset(CGSizeMake(SCREEN_WIDTH, 30));
    }];
    
    _nextImgView = [UIImageView new];
    [_nextImgView setImage:[UIImage imageNamed:@"next"]];
    [self addSubview:_nextImgView];
    [self.nextImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5);
        make.size.sizeOffset(CGSizeMake(20, 20));
        make.centerY.equalTo(self.proImgView.mas_centerY);
    }];
    
    UILabel *nextLbl = [UILabel new];
    nextLbl.text = @"查看订单";
    nextLbl.textColor = [UIColor lightGrayColor];
    nextLbl.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:nextLbl];
    [nextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nextImgView.mas_left).offset(5);
        make.centerY.equalTo(self.nextImgView.mas_centerY);
        make.size.sizeOffset(CGSizeMake(60, 25));
    }];
}

- (void)setDetailDict:(NSDictionary *)detailDict{
    self.nameLbl.text = [NSString stringWithFormat:@"%@",detailDict[@"name"]];
    [self.proImgView sd_setImageWithURLString:detailDict[@"image"] placeholderImage:[UIImage imageNamed:@"appImg"]];
    self.countLbl.text = [NSString stringWithFormat:@"共%@件商品",detailDict[@"product_amount"]];
    self.priceLbl.text = [NSString stringWithFormat:@"合计：￥%@",detailDict[@"pay_moeny"]];
    self.statusLbl.text = detailDict[@"sale_type_state"];
    self.orderTimeLbl.text = [NSString stringWithFormat:@"下单时间：%@",detailDict[@"addtime"]];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
