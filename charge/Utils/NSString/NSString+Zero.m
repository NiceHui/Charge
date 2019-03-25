//
//  NSString+Zero.m
//  charge
//
//  Created by growatt007 on 2018/10/20.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "NSString+Zero.h"

@implementation NSString (Zero)

// 补零
+ (NSString *)SupplementZero:(NSString *)string{
    
    while (string.length < 2) {
        string = [NSString stringWithFormat:@"0%@",string];
    }
    return string;
}

// 清零 数字型清除字符串最后的零
+ (NSString *)ClearZero:(NSString *)string{
    
    NSMutableString *c_string = [[NSMutableString alloc]initWithString:string];
    
    for (NSInteger i = string.length; i > 1; i--) {
        
        NSRange range = NSMakeRange(i-1, 1);
        NSString *character = [string substringWithRange:range];
        
        if ([character isEqualToString:@"0"] || [character isEqualToString:@"."]) {
            [c_string deleteCharactersInRange:range];
        }else{
            return c_string;
        }
    }
    
    return c_string;
}


@end
