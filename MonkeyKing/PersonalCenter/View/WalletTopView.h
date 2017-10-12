//
//  WalletTopView.h
//  MonkeyKing
//
//  Created by Apple on 2017/4/18.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletTopView : UIView
///账号
@property (nonatomic, strong) UILabel *accountLbl;
///余额
@property (nonatomic, strong) UILabel *balanceLbl;
///可提现金额
@property (nonatomic, strong) UILabel *withdrawalLbl;

- (instancetype)initWithFrame:(CGRect)frame;

@end
