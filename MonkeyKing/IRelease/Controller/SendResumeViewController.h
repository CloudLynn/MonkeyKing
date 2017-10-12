//
//  SendResumeViewController.h
//  MonkeyKing2
//
//  Created by Apple on 2017/1/13.
//  Copyright © 2017年 zuoBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendResumeViewController : UIViewController

///滚动视图(覆盖整个CV)
@property (nonatomic, strong) UIScrollView *mainScrollView;
///姓名
@property (nonatomic, strong) UITextField *nameTxt;
///性别:男(Button)
@property (nonatomic, strong) UIButton *manBtn;
///性别:女(Button)
@property (nonatomic, strong) UIButton *womanBtn;
///年龄
@property (nonatomic, strong) UITextField *ageTxt;
///户籍
@property (nonatomic, strong) UITextField *householdTxt;
///现居地址
@property (nonatomic, strong) UITextField *addressTxt;
///学历
@property (nonatomic, strong) UITextField *schoolingTxt;
///期望薪资
@property (nonatomic, strong) UITextField *salaryatxt;
///职位类别
@property (nonatomic, strong) UITextField *jobCategoryTxt;
///工作年限
@property (nonatomic, strong) UITextField *workingYearsTxt;
///工作经历
@property (nonatomic, strong) UITextView *workExperienceTxt;
///技能专长
@property (nonatomic, strong) UITextField *expertiseTxt;
///所受奖惩
@property (nonatomic, strong) UITextField *rewardOrPunishmentTxt;
///自我评价
@property (nonatomic, strong) UITextView *assessmentTxt;
///提交按钮
@property (nonatomic, strong) UIButton *submitBtn;


@property (nonatomic, strong) NSString *type_id;

@property (nonatomic, strong) NSString *actionType;

@property (nonatomic, strong) NSString *serve_id;

@end
