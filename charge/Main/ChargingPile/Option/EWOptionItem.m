//
//  EWOptionItem.m
//  EasyWork
//
//  Created by Ryan on 16/4/25.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "EWOptionItem.h"




@implementation EWOptionItem

+ (instancetype)itemWithTitle:(NSString *)title
                  detailTitle:(NSString *)detailTitle
                didClickBlock:(VoidBlock)didClickBlock {
    return [self itemWithIcon:nil
                        title:title
                  detailTitle:detailTitle
                accessoryIcon:nil
                didClickBlock:didClickBlock
               accessoryBlock:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title
                accessoryType:(UITableViewCellAccessoryType)accessoryType
                didClickBlock:(VoidBlock)didClickBlock {
    EWOptionItem *item = [self itemWithIcon:nil
                                      title:title
                                detailTitle:nil
                              accessoryIcon:nil
                              didClickBlock:didClickBlock
                             accessoryBlock:nil];
    item.accessoryType = accessoryType;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title
                  detailTitle:(NSString *)detailTitle {
    return [self itemWithIcon:nil
                        title:title
                  detailTitle:detailTitle
                accessoryIcon:nil
                didClickBlock:nil
               accessoryBlock:nil];
}

+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
               didClickBlock:(VoidBlock)didClickBlock {
    return [self itemWithIcon:icon
                        title:title
                  detailTitle:nil
                accessoryIcon:nil
                didClickBlock:didClickBlock
               accessoryBlock:nil];
}

+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                 detailTitle:(NSString *)detailTitle
               accessoryIcon:(NSString *)accessoryIcon
               didClickBlock:(VoidBlock)didClickBlock {
    return [self itemWithIcon:icon
                        title:title
                  detailTitle:detailTitle
                accessoryIcon:accessoryIcon
                didClickBlock:didClickBlock
               accessoryBlock:nil];
}

+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                 detailTitle:(NSString *)detailTitle
               accessoryIcon:(NSString *)accessoryIcon {
    return [self itemWithIcon:icon
                        title:title
                  detailTitle:detailTitle
                accessoryIcon:accessoryIcon
                didClickBlock:nil
               accessoryBlock:nil];
}

+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                 detailTitle:(NSString *)detailTitle {
    return [self itemWithIcon:icon
                        title:title
                  detailTitle:detailTitle
                accessoryIcon:nil
                didClickBlock:nil
               accessoryBlock:nil];
}

+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                 detailTitle:(NSString *)detailTitle
               accessoryIcon:(NSString *)accessoryIcon
              accessoryBlock:(VoidBlock)accessoryBlock {
    return [self itemWithIcon:icon
                        title:title
                  detailTitle:detailTitle
                accessoryIcon:accessoryIcon
                didClickBlock:nil
               accessoryBlock:accessoryBlock];
}

+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                 detailTitle:(NSString *)detailTitle
               accessoryIcon:(NSString *)accessoryIcon
               didClickBlock:(VoidBlock)didClickBlock
              accessoryBlock:(VoidBlock)accessoryBlock {
//	EWOptionItem *model = [[EWOptionItem alloc] init];
    EWOptionItem *model = [[[self class] alloc] init];
    model.icon = icon;
    model.title = title;
    model.detailTitle = detailTitle;
    model.accessoryIcon = accessoryIcon;
    model.didClickBlock = didClickBlock;
    model.accessoryBlock = accessoryBlock;
    return model;
}
@end
