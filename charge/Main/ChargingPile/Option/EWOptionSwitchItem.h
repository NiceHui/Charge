//
//  EWOptionSwitchItem.h
//  EasyWork
//
//  Created by Ryan on 16/8/7.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "EWOptionItem.h"



typedef void(^SwitchItemBlock)(BOOL);

@interface EWOptionSwitchItem : EWOptionItem

@property(nonatomic, assign, getter=isOn) BOOL on;

@property(nonatomic, copy) SwitchItemBlock switchItemBlock;

+ (instancetype)itemWithTitle:(NSString *)title switchOn:(BOOL)switchOn switchItemBlock:(SwitchItemBlock)switchItemBlock;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title switchOn:(BOOL)switchOn switchItemBlock:(SwitchItemBlock)switchItemBlock;

@end
