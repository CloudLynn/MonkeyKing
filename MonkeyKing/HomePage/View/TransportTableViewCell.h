//
//  TransportTableViewCell.h
//  MonkeyKing
//
//  Created by Apple on 2017/3/15.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransportTableViewCell : UITableViewCell

///头像
@property (nonatomic, strong) UIImageView *headImgView;
///名字
@property (nonatomic, strong) UILabel *nameLbl;
///星级
@property (nonatomic, strong) UIImageView *starImgView;
///标题
@property (nonatomic, strong) UILabel *titleLbl;
///起始价
@property (nonatomic, strong) UILabel *startPLbl;
///乘运价
@property (nonatomic, strong) UILabel *transPLbl;
///工号
@property (nonatomic, strong) UILabel *workNumLbl;
///距离
@property (nonatomic, strong) UILabel *distanceLbl;

@property (nonatomic, strong) NSDictionary *transDict;

@end
