//
//  EWOptionItem.h
//  EasyWork
//
//  Created by Ryan on 16/4/25.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

// 空操作Block
typedef void(^VoidBlock)();

@interface EWOptionItem : NSObject
/** 模型的ID */
@property(nonatomic, assign) NSInteger modelID;
/** accessoryType样式 */
@property(nonatomic, assign) UITableViewCellAccessoryType accessoryType;
/** 左边的icon */
@property(nonatomic, copy) NSString *icon;
/** 右边的icon */
@property(nonatomic, copy) NSString *accessoryIcon;
/** 右边第二个的icon */
@property(nonatomic, copy) NSString *accessoryLeftIcon;
/** 左边的title */
@property(nonatomic, copy) NSString *title;
/** 右边的title */
@property(nonatomic, copy) NSString *detailTitle;
/** 点击操作block */
@property(nonatomic, copy) VoidBlock didClickBlock;
/** 点击右边第一个Icon时的操作,可空 */
@property(nonatomic, copy) VoidBlock accessoryBlock;
/** 点击右边第二个Icon时的操作,可空 */
@property(nonatomic, copy) VoidBlock accessoryLeftBlock;
/** 扩展字段,可用可不用 */
@property(nonatomic, strong) id extra;
/** 扩展字段2,可用可不用 */
@property(nonatomic, strong) id extra2;

@property(nonatomic, assign, getter=isSelected) BOOL selected;
/** 是否不可点，默认为NO */
@property (nonatomic, assign, getter=isDisable) BOOL disable;

/**
 *  便利构造器
 *
 *  @param title       左边的title
 *  @param detailTitle 右边的title
 *  @param vc          需要跳转的控制器
 *  @param clikBlock   点击处理的事件
 *
 *  @return OptionModel
 */
+ (instancetype)itemWithTitle:(NSString *)title
                  detailTitle:(NSString *)detailTitle
                didClickBlock:(VoidBlock)didClickBlock;

/** 只呈现title和点击事件 */
+ (instancetype)itemWithTitle:(NSString *)title
                accessoryType:(UITableViewCellAccessoryType)accessoryType
                didClickBlock:(VoidBlock)didClickBlock;

/** 只呈现title和detailTitle,无交互 */
+ (instancetype)itemWithTitle:(NSString *)title
                  detailTitle:(NSString *)detailTitle;

/** 呈现图标和title,有交互 */
+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
               didClickBlock:(VoidBlock)didClickBlock;

+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                 detailTitle:(NSString *)detailTitle;

+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                 detailTitle:(NSString *)detailTitle
               accessoryIcon:(NSString *)accessoryIcon
               didClickBlock:(VoidBlock)didClickBlock;

+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                 detailTitle:(NSString *)detailTitle
               accessoryIcon:(NSString *)accessoryIcon;

+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                 detailTitle:(NSString *)detailTitle
               accessoryIcon:(NSString *)accessoryIcon
              accessoryBlock:(VoidBlock)accessoryBlock;
@end
