//
//  UIImage+Size.m
//  HyacinthBean
//
//  Created by liu on 2017/8/4.
//  Copyright © 2017年 Hye. All rights reserved.
//

#import "UIImage+Size.h"


@implementation UIImage (Size)

+(UIImage*)imageNamed:(NSString*)imageName size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* circularImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return circularImage;
    
}


@end
