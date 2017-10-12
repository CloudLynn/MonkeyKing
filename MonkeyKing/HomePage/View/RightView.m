//
//  RightView.m
//  MainDemo
//
//  Created by XienaShen on 17/2/9.
//  Copyright © 2017年 XienaShen. All rights reserved.
//

#import "RightView.h"

#import "ServiceCell.h"

@interface RightView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *headerCollection;
@end

@implementation RightView

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
    NSArray *bgArray = @[@"blue2",@"blue3"];
    NSArray *serviceArray = @[@"xuexi",@"lvyou"];
    NSArray *titleArray = @[@"学习辅导",@"旅游交通运输服务"];
    cell.bgIcon.image = [UIImage imageNamed:bgArray[indexPath.row]];
    cell.serviceIcon.image = [UIImage imageNamed:serviceArray[indexPath.row]];
    cell.serviceLabel.text = titleArray[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(returnRight:)]) {
        [self.delegate returnRight:indexPath.item];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.bounds.size.width-7.5, 100);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 2.5, 5, 5);
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
