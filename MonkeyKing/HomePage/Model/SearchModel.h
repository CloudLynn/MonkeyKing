//
//  SearchModel.h
//  MonkeyKing
//
//  Created by Apple on 2017/3/21.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SearchModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) CLLocationCoordinate2D pt;

@end
