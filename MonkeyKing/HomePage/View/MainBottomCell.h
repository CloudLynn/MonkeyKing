//
//  MainBottomCell.h
//  MainDemo
//
//  Created by XienaShen on 17/2/9.
//  Copyright © 2017年 XienaShen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainBottomDelegate <NSObject>
-(void)returnLeft:(NSInteger)index;
-(void)returnRight:(NSInteger)index;
@end

@interface MainBottomCell : UICollectionViewCell
@property (nonatomic,strong) id<MainBottomDelegate> delegate;
-(void)showData:(id)leftData right:(id)rightData;
@end
