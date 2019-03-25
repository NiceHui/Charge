//
//  EWOptionSwitchItem.m
//  EasyWork
//
//  Created by Ryan on 16/8/7.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "EWOptionSwitchItem.h"



@implementation EWOptionSwitchItem

+ (instancetype)itemWithTitle:(NSString *)title switchOn:(BOOL)switchOn switchItemBlock:(SwitchItemBlock)switchItemBlock {
    EWOptionSwitchItem *item = [[EWOptionSwitchItem alloc] init];
    item.title = title;
    item.on = switchOn;
    item.switchItemBlock = switchItemBlock;
    return item;
}


+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title switchOn:(BOOL)switchOn switchItemBlock:(SwitchItemBlock)switchItemBlock {
    EWOptionSwitchItem *item = [[EWOptionSwitchItem alloc] init];
    item.title = title;
    item.on = switchOn;
    item.icon = icon;
    item.switchItemBlock = switchItemBlock;
    return item;

}

@end
