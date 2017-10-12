//
//  RightView.h
//  MainDemo
//
//  Created by XienaShen on 17/2/9.
//  Copyright © 2017年 XienaShen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RightDelegate <NSObject>
-(void)returnRight:(NSInteger)index;
@end

@interface RightView : UIView
@property (nonatomic,assign) id<RightDelegate> delegate;
-(void)showData:(id)data;
@end
