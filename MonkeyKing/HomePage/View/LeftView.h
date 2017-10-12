//
//  LeftView.h
//  MainDemo
//
//  Created by XienaShen on 17/2/9.
//  Copyright © 2017年 XienaShen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftDelegate <NSObject>
-(void)returnLeft:(NSInteger)index;
@end

@interface LeftView : UIView
@property (nonatomic,assign) id<LeftDelegate> delegate;
-(void)showData:(id)data;
@end
