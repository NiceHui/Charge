//
//  NSString+Zero.h
//  charge
//
//  Created by growatt007 on 2018/10/20.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Zero)

// 不足两位补零
+ (NSString *)SupplementZero:(NSString *)string;


// 清零 数字型清除字符串最后的零
+ (NSString *)ClearZero:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
