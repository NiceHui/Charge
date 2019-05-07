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

//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    return rect.size.width;
}

//根据高度宽度返回适合大小的字体  text 输入内容内容  ui大小
+ (CGFloat)getFontWithText:(NSString *)text size:(CGSize)size currentFont:(CGFloat)currentFont{
    
    CGFloat width = 10000;
    CGFloat currentWidth = size.width;
    
    if(text.length > 0 && currentWidth > 0){
        while (width > currentWidth) {
            CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, size.height)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:currentFont]}
                                             context:nil];
            width = rect.size.width;
            currentFont = currentFont-1;
        }
    }
    
    return currentFont;
}

// 判断是否为纯数字, 包括小数
+ (BOOL)isNum:(NSString *)checkedNumString {
    NSString *str = [checkedNumString substringWithRange:NSMakeRange(checkedNumString.length-1, 1)];
    if([str isEqualToString:@"."]) {// 最后一位不能为小数点
        return NO;
    }
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];// 过滤数字字符
    if([checkedNumString isEqualToString:@"."]) {// 剩下小数点则表明是个带小数的数字
        return YES;
    }
    if(checkedNumString.length > 0) {// 如果全部都不剩，则是整数
        return NO;
    }
    return YES;
}

// 判断是否为纯数字, 只判断是否为整数
+ (BOOL)isNum2:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];// 过滤数字字符
    if(checkedNumString.length > 0) {// 如果全部都不剩，则是整数
        return NO;
    }
    return YES;
}

//  判断输入的字符串是否有中文
+(BOOL)IsChinese:(NSString*)str{
    
    for(int i = 0;i<[str length];i++){
        
        int a = [str characterAtIndex:i];
        if(a>0x4e00&&a<0x9fff){//判断输入的是否是中文
            return YES;
        }
    }
    return NO;
}

@end
