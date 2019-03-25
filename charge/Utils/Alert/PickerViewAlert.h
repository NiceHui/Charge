//
//  PickerViewAlert.h
//  ShinePhone
//
//  Created by growatt007 on 2018/7/6.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerViewAlert : UIView

@property (nonatomic, copy) void (^touchEnterBlock)(NSString *value, NSString *value2);

-(void)show;


@end
