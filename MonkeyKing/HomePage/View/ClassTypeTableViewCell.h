//
//  ClassTypeTableViewCell.h
//  MonkeyKing
//
//  Created by Apple on 2017/2/14.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassTypeTableViewCell : UITableViewCell

///用户头像
@property (nonatomic, strong) UIImageView *headImgView;
///姓名
@property (nonatomic, strong) UILabel *nameLbl;
///服务内容
@property (nonatomic, strong) UILabel *serviceLbl;
///工号
@property (nonatomic, strong) UILabel *numberLbl;
///距离图标
@property (nonatomic, strong) UIImageView *distanceImgView;
///距离
@property (nonatomic, strong) UILabel *distanceLbl;
///查看详情图标
@property (nonatomic, strong) UIImageView *nextImgView;

@property (nonatomic, strong) NSDictionary *contentDictionary;

@end
