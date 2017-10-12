//
//  ServiceCell.h
//  MainDemo
//
//  Created by XienaShen on 17/2/8.
//  Copyright © 2017年 XienaShen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceCell : UICollectionViewCell
///背景图片
@property (nonatomic,strong) UIImageView *bgIcon;
///服务图标
@property (nonatomic,strong) UIImageView *serviceIcon;
///服务类型名称
@property (nonatomic,strong) UILabel *serviceLabel;
@end
