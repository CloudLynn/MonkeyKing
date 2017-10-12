//
//  MainHeaderCell.h
//  MainDemo
//
//  Created by XienaShen on 17/2/8.
//  Copyright © 2017年 XienaShen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainHeaderCell : UICollectionViewCell
-(void)showData:(id)data selectCellBlock:(void(^)(NSInteger index))block;
@end
