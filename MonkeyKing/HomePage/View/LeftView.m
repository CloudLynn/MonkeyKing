//
//  LeftView.m
//  MainDemo
//
//  Created by XienaShen on 17/2/9.
//  Copyright © 2017年 XienaShen. All rights reserved.
//

#import "LeftView.h"

#import "ServiceCell.h"

@interface LeftView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *headerCollection;
@end

@implementation LeftView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    [self.headerCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self).offset(0);
        make.height.mas_equalTo(210);
    }];
}

-(void)showData:(id)data{
    
}

#pragma -mark =========== UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ServiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceCell" forIndexPath:indexPath];
    NSArray *bgArray = @[@"red1",@"orange1"];
    NSArray *serviceArray = @[@"rencai",@"shangwu"];
    NSArray *titleArray = @[@"人才超市",@"商务服务"];
    cell.bgIcon.image = [UIImage imageNamed:bgArray[indexPath.row]];
    cell.serviceIcon.image = [UIImage imageNamed:serviceArray[indexPath.row]];
    cell.serviceLabel.text = titleArray[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(returnLeft:)]) {
        [self.delegate returnLeft:indexPath.item];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.bounds.size.width-12.5)/2, 205);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 5, 2.5);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

#pragma -mark ========== getter

-(UICollectionView *)headerCollection{
    if (!_headerCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _headerCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _headerCollection.delegate = self;
        _headerCollection.dataSource = self;
//        _headerCollection.backgroundColor = [UIColor blueColor];
        _headerCollection.backgroundColor = [UIColor whiteColor];
        [_headerCollection registerClass:[ServiceCell class] forCellWithReuseIdentifier:@"ServiceCell"];
        [self addSubview:_headerCollection];
    }
    return _headerCollection;
}

@end
