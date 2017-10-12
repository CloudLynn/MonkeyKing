//
//  OrderDetailTableViewCell.h
//  MonkeyKing
//
//  Created by Apple on 2017/4/12.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailTableViewCell : UITableViewCell

///图片
@property (nonatomic, strong) UIImageView *proImgView;
///名称
@property (nonatomic, strong) UILabel *nameLbl;
///单价
@property (nonatomic, strong) UILabel *costLbl;
///数量
@property (nonatomic, strong) UILabel *countLbl;
///时间
@property (nonatomic, strong) UILabel *addtimeLbl;

@property (nonatomic, strong) NSDictionary *detailDict;

@end
