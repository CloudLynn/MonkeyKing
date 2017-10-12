//
//  WalletTableViewCell.h
//  MonkeyKing
//
//  Created by Apple on 2017/4/21.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImgView;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *timeLbl;

@property (nonatomic, strong) UILabel *moneyLbl;

@property (nonatomic, strong) NSDictionary *walletDict;

@end
