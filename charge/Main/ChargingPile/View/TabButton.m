//
//  TabButton.m
//  ShinePhone
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 qwl. All rights reserved.
//

#import "TabButton.h"

@implementation TabButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tintColor = [UIColor clearColor];
    CGRect btnFrame = self.bounds;

    int imageWidth = 14*XLscaleW;
    int imageHegith = 15*XLscaleH;
    self.imageView.bounds = CGRectMake(0, 0, imageWidth, imageHegith);
    
    
    UILabel *label = self.titleLabel;
    label.textAlignment = NSTextAlignmentCenter;

    label.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+8, 0, label.xmg_width, btnFrame.size.height);
}
@end
