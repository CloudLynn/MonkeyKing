//
//  ContactTopTableViewCell.h
//  MonkeyKing
//
//  Created by Apple on 2017/2/8.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTopTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *introduceLbl;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *numberLbl;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, assign) BOOL islogin;

@end
