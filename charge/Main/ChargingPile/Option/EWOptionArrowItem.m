//
//  EWOptionArrowItem.m
//  EasyWork
//
//  Created by Ryan on 16/8/7.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "EWOptionArrowItem.h"



@implementation EWOptionArrowItem

+ (instancetype)arrowItemWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle destinationVC:(Class)destinationVC {
    EWOptionArrowItem *item = [[EWOptionArrowItem alloc] init];
    item.title = title;
    item.detailTitle = detailTitle;
    item.destinationVC = destinationVC;
    return item;
}

+ (instancetype)arrowItemWithIcon:(NSString *)icon title:(NSString *)title destinationVC:(Class)destinationVC {
    EWOptionArrowItem *item = [[EWOptionArrowItem alloc] init];
    item.icon = icon;
    item.title = title;
    item.destinationVC = destinationVC;
    return item;
}

+ (instancetype)arrowItemWithIcon:(NSString *)icon title:(NSString *)title detailTitle:(NSString *)detailTitle didClickBlock:(VoidBlock)didClickBlock {
    EWOptionArrowItem *item = [[EWOptionArrowItem alloc] init];
    item.icon = icon;
    item.title = title;
    item.detailTitle = detailTitle;
    item.didClickBlock = didClickBlock;
    return item;
}

+ (instancetype)arrowItemWithTitle:(NSString *)title didClickBlock:(VoidBlock)didClickBlock {
	return [self arrowItemWithIcon:nil title:title detailTitle:nil didClickBlock:didClickBlock];
}

+ (instancetype)arrowItemWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle didClickBlock:(VoidBlock)didClickBlock {
	return [self arrowItemWithIcon:nil title:title detailTitle:detailTitle didClickBlock:didClickBlock];
}

@end
