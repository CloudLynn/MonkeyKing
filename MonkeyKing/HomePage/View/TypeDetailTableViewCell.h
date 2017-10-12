//
//  TypeDetailTableViewCell.h
//  MonkeyKing
//
//  Created by Apple on 2017/2/17.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfoModel;

typedef void(^selectBlcok)(UIButton *btn);

@interface TypeDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *proImgView;
@property (nonatomic, strong) UILabel *proNameLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UITextField *countTxt;
@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UIButton *plusBtn;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UITextView *noteView;

@property (nonatomic, strong) InfoModel *info;
@property (nonatomic, strong) NSDictionary *contentDict;

-(void)clickSelectBlock:(selectBlcok)block;
@end
