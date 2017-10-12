//
//  InfoModel.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/21.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "InfoModel.h"

@implementation InfoModel
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.info_id forKey:@"info_id"];
    [aCoder encodeObject:self.product_name forKey:@"product_name"];
    [aCoder encodeObject:self.product_cost forKey:@"product_cost"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.product_count] forKey:@"product_count"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super init]) {
        self.info_id = [aDecoder decodeObjectForKey:@"info_id"];
        self.product_name = [aDecoder decodeObjectForKey:@"product_name"];
        self.product_cost = [aDecoder decodeObjectForKey:@"product_cost"];
        self.product_count = [[aDecoder decodeObjectForKey:@"product_count"] intValue];
    }
    return self;
}
@end
