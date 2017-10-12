//
//  MyProductTableViewCell.h
//  MonkeyKing
//
//  Created by Apple on 2017/3/10.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProductTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *moneyLbl;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UIButton *changeBtn;

@end
