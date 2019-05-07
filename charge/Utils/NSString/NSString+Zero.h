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

/**
 根据高度度求宽度
 
 @param text text 计算的内容
 @param height 高度
 @param font 字体大小
 @return 足够的宽度
 */
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font;



/**
 根据高度宽度判断字体是否适合，如果不合适则返回适合大小的字体
 
 @param text 输入内容
 @param size ui的大小
 @param currentFont 当前默认字体大小
 @return 返回适合大小的字体
 */
+ (CGFloat)getFontWithText:(NSString *)text size:(CGSize)size currentFont:(CGFloat)currentFont;


// 判断是否为纯数字, 包括小数
+ (BOOL)isNum:(NSString *)checkedNumString;

// 判断是否为纯数字, 只判断是否为整数
+ (BOOL)isNum2:(NSString *)checkedNumString;


//  判断输入的字符串是否有中文
+(BOOL)IsChinese:(NSString*)str;


@end

NS_ASSUME_NONNULL_END
