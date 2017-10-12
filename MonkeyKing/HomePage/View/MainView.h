//
//  MainView.h
//  MainDemo
//
//  Created by XienaShen on 17/2/8.
//  Copyright © 2017年 XienaShen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainDelegate <NSObject>
-(void)returnHeader:(NSInteger)index;
-(void)returnLeft:(NSInteger)index;
-(void)returnRight:(NSInteger)index;
@end

@interface MainView : UIView
@property (nonatomic,strong) id<MainDelegate> delegate;
@end
