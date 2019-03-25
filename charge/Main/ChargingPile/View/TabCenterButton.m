//
//  TabCenterButton.m
//  ShinePhone
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 qwl. All rights reserved.
//

#import "TabCenterButton.h"

@implementation TabCenterButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tintColor = [UIColor clearColor];
    
    CGRect btnFrame = self.bounds;
    
    UIImageView *imageView = self.imageView;
    int imageWidth = 39*XLscaleH;
    int imageHegith = 39*XLscaleH;
    self.imageView.bounds = CGRectMake(0, 0, imageWidth, imageHegith);
    
    
    UILabel *label = self.titleLabel;
    label.textAlignment = NSTextAlignmentCenter;
    
    imageView.xmg_x = btnFrame.origin.x + (btnFrame.size.width - imageView.xmg_size.width)/2.f;
    imageView.xmg_y = (btnFrame.size.height - imageView.xmg_size.width - label.font.lineHeight)/2.f;
    
    label.frame = CGRectMake(btnFrame.origin.x, CGRectGetMaxY(imageView.frame) + 5, btnFrame.size.width, label.font.lineHeight);
}
@end
