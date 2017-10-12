//
//  MyServiceTableViewCell.h
//  MonkeyKing
//
//  Created by Apple on 2017/3/2.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyServiceTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *typeLbl;
@property (nonatomic, strong) UILabel *uptimeLbl;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UIButton *setBtn;
@property (nonatomic, strong) UIImageView *nextImgView;

//@property (nonatomic, strong) UILabel *areaLbl;
//@property (nonatomic, strong) UILabel *priceLbl;
//@property (nonatomic, strong) UILabel *nameLbl;
//@property (nonatomic, strong) UILabel *notesLbl;

@property (nonatomic, strong) NSDictionary *dictionary;

@end
