//
//  ServiceCell.m
//  MainDemo
//
//  Created by XienaShen on 17/2/8.
//  Copyright © 2017年 XienaShen. All rights reserved.
//

#import "ServiceCell.h"

@implementation ServiceCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    [self.bgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0)).equalTo(self.contentView);
    }];
    
    [self.serviceIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.mas_equalTo(-10);
        make.width.height.mas_equalTo(55);
    }];
    
    [self.serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.serviceIcon.mas_bottom).offset(8);
        make.width.equalTo(self.contentView);
    }];
}


#pragma -mark =========== getter
-(UIImageView *)bgIcon{
    if (!_bgIcon) {
        _bgIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        _bgIcon.image = [UIImage imageNamed:@"green1"];
        [self addSubview:_bgIcon];
    }
    return _bgIcon;
}
-(UIImageView *)serviceIcon{
    if (!_serviceIcon) {
        _serviceIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        _serviceIcon.image = [UIImage imageNamed:@"jz"];
        [self addSubview:_serviceIcon];
    }
    return _serviceIcon;
}

-(UILabel *)serviceLabel{
    if (!_serviceLabel) {
        _serviceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _serviceLabel.text = @"家政服务";
        _serviceLabel.textColor = [UIColor whiteColor];
        _serviceLabel.font = [UIFont systemFontOfSize:14.0];
        _serviceLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_serviceLabel];
    }
    return _serviceLabel;
}
@end
