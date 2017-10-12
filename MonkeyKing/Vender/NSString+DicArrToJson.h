//
//  NSString+DicArrToJson.h
//  KFShop
//
//  Created by libin on 16/4/12.
//  Copyright © 2016年 libin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DicArrToJson)

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

+(NSString *) jsonStringWithArray:(NSArray *)array;

+(NSString *) jsonStringWithString:(NSString *) string;

+(NSString *) jsonStringWithObject:(id) object;

+(void) jsonTest;

@end
