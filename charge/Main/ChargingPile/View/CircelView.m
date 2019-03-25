//
//  CircelView.m
//  ShinePhone
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 qwl. All rights reserved.
//

#import "CircelView.h"

@implementation CircelView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowColor = COLOR(174, 217, 241, 1).CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0 );
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 20;
    self.layer.cornerRadius = 215*XLscaleH/2;
    self.clipsToBounds = NO;
    
    return self;
}
@end
