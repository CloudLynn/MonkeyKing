//
//  MainDataModel.h
//  MonkeyKing
//
//  Created by Apple on 2017/2/13.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainDataModel : NSObject

+ (NSDictionary *)returnTopSort;
+ (NSDictionary *)returnNowSortWithTypeId:(NSString *)typeId;
+ (NSDictionary *)returnPromptText:(NSString *)typeId;

@end
