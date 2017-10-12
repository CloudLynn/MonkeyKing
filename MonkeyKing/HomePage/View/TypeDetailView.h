//
//  TypeDetailView.h
//  MonkeyKing
//
//  Created by Apple on 2017/2/17.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class XJLStarView;
@class EvaluateView;
@protocol TypeDetailViewDelegate <NSObject>

- (void)clickCommentBtn;

@end

@interface TypeDetailView : UIView

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) EvaluateView *starView;
@property (nonatomic, strong) UILabel *workNumLbl;
@property (nonatomic, strong) UILabel *distanceLbl;

@property (nonatomic, strong) NSDictionary *detailDictionary;

@property (nonatomic, weak) id<TypeDetailViewDelegate> delegate;

@end
