//
//  TalentTableViewCell.h
//  MonkeyKing
//
//  Created by Apple on 2017/2/28.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalentTableViewCell : UITableViewCell
///姓名
@property (nonatomic, strong) UILabel *nameLbl;
///学历
@property (nonatomic, strong) UILabel *educationLbl;
///工作类型
@property (nonatomic, strong) UILabel *jobTypeLbl;
///工作年限
@property (nonatomic, strong) UILabel *workYearLbl;
///更新时间
@property (nonatomic, strong) UILabel *upTimeLbl;
///头像
@property (nonatomic, strong) UIImageView *headImgView;
///右箭头
@property (nonatomic, strong) UIImageView *nextImgView;
///height:116;

@property (nonatomic, strong) NSDictionary *marketDict;

@end
