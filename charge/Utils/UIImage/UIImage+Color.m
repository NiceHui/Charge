//
//  UIImage+Color.m
//  UMCommunityDemo
//
//  Created by 王庆 on 16/9/7.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)
+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



@end
