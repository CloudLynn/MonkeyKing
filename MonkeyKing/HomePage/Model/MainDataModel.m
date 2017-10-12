//
//  MainDataModel.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/13.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "MainDataModel.h"

@implementation MainDataModel

+ (NSDictionary *)returnTopSort{
    __block NSDictionary *dictionary;
    NSString *strUrl = [NSString stringWithFormat:@"%@token=topSort",SORTURL];
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:strUrl params:nil andSuccessBlock:^(id responseObj) {
        
        dictionary = responseObj;
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"顶级服务类error====%@",responseObj);
    } andIsHUD:NO];
    return dictionary;
}
+ (NSDictionary *)returnNowSortWithTypeId:(NSString *)typeId{
    __block NSDictionary *dictionary;
    NSString *strUrl = [NSString stringWithFormat:@"%@token=getNowSort&id=%@",SORTURL,typeId];
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:strUrl params:nil andSuccessBlock:^(id responseObj) {
        
        dictionary = responseObj;
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"顶级服务类error====%@",responseObj);
    } andIsHUD:NO];
    return dictionary;
}
+ (NSDictionary *)returnPromptText:(NSString *)typeId{
    //http://api.swktcx.com/A1/global.php?token=getText&id=2
    __block NSDictionary *dictionary;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",PROMPTURL,typeId];
    [[HLRequestManager changeJsonClient] requestWithIsPost:NO url:strUrl params:nil andSuccessBlock:^(id responseObj) {
        
        dictionary = responseObj;
        
    } andFailedBlock:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"顶级服务类error====%@",responseObj);
    } andIsHUD:NO];
    return dictionary;
    
}

@end
