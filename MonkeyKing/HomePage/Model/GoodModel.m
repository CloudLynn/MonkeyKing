//
//  GoodModel.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/21.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "GoodModel.h"
#import "InfoModel.h"
@implementation GoodModel
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.serve_id forKey:@"serve_id"];
    [aCoder encodeObject:self.buyer_address forKey:@"buyer_address"];
    [aCoder encodeObject:self.buyer_name forKey:@"buyer_name"];
    [aCoder encodeObject:self.serve_notes forKey:@"serve_notes"];
    [aCoder encodeObject:self.pay_moeny forKey:@"pay_moeny"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.discount] forKey:@"discount"];
    [aCoder encodeObject:self.info forKey:@"info"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super init]) {
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.serve_id = [aDecoder decodeObjectForKey:@"serve_id"];
        self.buyer_address = [aDecoder decodeObjectForKey:@"buyer_address"];
        self.buyer_name = [aDecoder decodeObjectForKey:@"buyer_name"];
        self.serve_notes = [aDecoder decodeObjectForKey:@"serve_notes"];
        self.pay_moeny = [aDecoder decodeObjectForKey:@"pay_moeny"];
        self.discount = [[aDecoder decodeObjectForKey:@"discount"] doubleValue];
        self.info = [aDecoder decodeObjectForKey:@"info"];
    }
    return self;
}
@end
