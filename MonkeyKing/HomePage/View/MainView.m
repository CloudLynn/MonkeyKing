//
//  MainView.m
//  MainDemo
//
//  Created by XienaShen on 17/2/8.
//  Copyright © 2017年 XienaShen. All rights reserved.
//

#import "MainView.h"
//cell
#import "MainHeaderCell.h"
#import "MainBottomCell.h"

@interface MainView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MainBottomDelegate>
@property (nonatomic,strong) UICollectionView *headerCollection;
@end

@implementation MainView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    [self.headerCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0)).equalTo(self);
    }];
}

#pragma -mark =========== MainBottomDelegate
-(void)returnLeft:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(returnLeft:)]) {
        [self.delegate returnLeft:index];
    }
}

-(void)returnRight:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(returnRight:)]) {
        [self.delegate returnRight:index];
    }
}

#pragma -mark =========== UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    switch (indexPath.section) {
            
        case 0:
        {
            MainHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainHeaderCell" forIndexPath:indexPath];
            [cell showData:nil selectCellBlock:^(NSInteger index) {
                if ([self.delegate respondsToSelector:@selector(returnHeader:)]) {
                    [self.delegate returnHeader:index];
                }
            }];
            return cell;
        }
            break;
        case 1:
        {
            MainBottomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainBottomCell" forIndexPath:indexPath];
            cell.delegate = self;
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, 215);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


#pragma -mark ========== getter

-(UICollectionView *)headerCollection{
    if (!_headerCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _headerCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _headerCollection.delegate = self;
        _headerCollection.dataSource = self;
        _headerCollection.backgroundColor = [UIColor whiteColor];
        [_headerCollection registerClass:[MainHeaderCell class] forCellWithReuseIdentifier:@"MainHeaderCell"];
        [_headerCollection registerClass:[MainBottomCell class] forCellWithReuseIdentifier:@"MainBottomCell"];
        [self addSubview:_headerCollection];
    }
    return _headerCollection;
}

@end
