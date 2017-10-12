//
//  MainHeaderCell.m
//  MainDemo
//
//  Created by XienaShen on 17/2/8.
//  Copyright © 2017年 XienaShen. All rights reserved.
//

#import "MainHeaderCell.h"

#import "ServiceCell.h"


@interface MainHeaderCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    void(^selectBlock)(NSInteger index);
}
@property (nonatomic,strong) UICollectionView *headerCollection;
@end

@implementation MainHeaderCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    [self.headerCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(215);
    }];
}

-(void)showData:(id)data selectCellBlock:(void (^)(NSInteger))block{
    selectBlock = block;
}

#pragma -mark =========== UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ServiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceCell" forIndexPath:indexPath];
    NSArray *bgArray = @[@"green1",@"blue1",@"green3",@"green2"];
    NSArray *serviceArray = @[@"jiazheng",@"qingxi",@"peisong",@"anzhuang"];
    NSArray *titleArray = @[@"家政服务",@"清洗服务",@"生活配送服务",@"安装维修服务"];
    cell.bgIcon.image = [UIImage imageNamed:bgArray[indexPath.row]];
    cell.serviceIcon.image = [UIImage imageNamed:serviceArray[indexPath.row]];
    cell.serviceLabel.text = titleArray[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (selectBlock!=nil) {
        selectBlock(indexPath.item);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2==0) {
        return CGSizeMake((SCREEN_WIDTH+15)/2, 100);
    }else{
        return CGSizeMake((SCREEN_WIDTH-45)/2, 100);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 0, 5);
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
        [self.contentView addSubview:_headerCollection];
    }
    return _headerCollection;
}
@end
