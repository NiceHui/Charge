//
//  UIView+Frame.h
//  BuDeJie
//
//  Created by xiaomage on 16/3/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 
    写分类:避免跟其他开发者产生冲突,加前缀
 
 */
@interface UIView (Frame)

@property (assign, nonatomic) CGFloat xmg_width;
@property (assign, nonatomic) CGFloat xmg_height;
@property (assign, nonatomic) CGFloat xmg_x;
@property (assign, nonatomic) CGFloat xmg_y;
@property (assign, nonatomic) CGFloat xmg_centerX;
@property (assign, nonatomic) CGFloat xmg_centerY;
@property (assign, nonatomic) CGSize  xmg_size;
@end
