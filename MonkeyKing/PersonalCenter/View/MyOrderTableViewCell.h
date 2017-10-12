//
//  MyOrderTableViewCell.h
//  MonkeyKing
//
//  Created by Apple on 2017/2/10.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell
///姓名
@property (nonatomic, strong) UILabel *nameLbl;
///联系卖家
@property (nonatomic, strong) UIButton *callSellerBtn;
///产品图片
@property (nonatomic, strong) UIImageView *proImgView;
///下单数量
@property (nonatomic, strong) UILabel *countLbl;
///合计价格
@property (nonatomic, strong) UILabel *priceLbl;
///行为按钮（确认付款，申请退款，删除订单）
//@property (nonatomic, strong) UIButton *paymentBtn;//first
//@property (nonatomic, strong) UIButton *refundBtn;  //second
@property (nonatomic, strong) UIButton *firstBtn;
@property (nonatomic, strong) UIButton *secondBtn;
///订单状态
@property (nonatomic, strong) UILabel *statusLbl;
///下单时间
@property (nonatomic, strong) UILabel *orderTimeLbl;
///查看详情
@property (nonatomic, strong) UIImageView *nextImgView;

///cell内容
@property (nonatomic, strong) NSDictionary *detailDict;

@end
