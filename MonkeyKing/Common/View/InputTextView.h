//
//  InputTextView.h
//  MonkeyKing
//
//  Created by Apple on 2017/2/8.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnTextBlock)(NSString *contentText);

@interface InputTextView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UITextField *contentTxt;

@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

//初始化方法
- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title;

- (void)returnText:(ReturnTextBlock)block;

@end
