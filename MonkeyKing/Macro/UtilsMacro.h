//
//  UtilsMacro.h
//  MonkeyKing
//
//  Created by Apple on 2017/2/6.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

//弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))


//屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//颜色
#define COLOR_RGB(_R,_G,_B,_A) [UIColor colorWithRed:_R/255.0 green:_G/255.0 blue:_B/255.0 alpha:_A]
#define COLOR_APP(_A) [UIColor colorWithRed:0/255.0 green:220/255.0 blue:214/255.0 alpha:_A]

//字体
#define FONT_15 [UIFont systemFontOfSize:15.0f]
#endif /* UtilsMacro_h */
