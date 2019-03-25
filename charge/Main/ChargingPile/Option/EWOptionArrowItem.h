//
//  EWOptionArrowItem.h
//  EasyWork
//
//  Created by Ryan on 16/8/7.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "EWOptionItem.h"



@interface EWOptionArrowItem : EWOptionItem

/**
 *  需要push的控制器
 */
@property(nonatomic, assign) Class destinationVC;

/**
 *  便利构造器
 *
 *  @param title         左边的标签
 *  @param didClickBlock 点击的block
 *
 *  @return EWOptionArrowItem
 */
+ (instancetype)arrowItemWithTitle:(NSString *)title didClickBlock:(VoidBlock)didClickBlock;

/**
 *  便利构造器
 *
 *  @param title         左边的标签
 *  @param detailTitle   右边的标签
 *  @param didClickBlock 点击的block
 *
 *  @return EWOptionArrowItem
 */
+ (instancetype)arrowItemWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle didClickBlock:(VoidBlock)didClickBlock;

/**
 *  便利构造器
 *
 *  @param title         左边的标签
 *  @param detailTitle   右边的标签
 *  @param destinationVC 目标控制器
 *
 *  @return EWOptionArrowItem
 */
+ (instancetype)arrowItemWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle destinationVC:(Class)destinationVC;

/**
 *  便利构造器
 *
 *  @param icon          左边的iCon
 *  @param title         左边的标签
 *  @param destinationVC 目标控制器
 *
 *  @return EWOptionArrowItem
 */
+ (instancetype)arrowItemWithIcon:(NSString *)icon title:(NSString *)title destinationVC:(Class)destinationVC;


/**
 便利构造器

 @param icon 左边的Icon
 @param title 左边的Title
 @param detailTitle 右边的Title
 @param didClickBlock 点击的block
 @return EWOptionArrowItem
 */
+ (instancetype)arrowItemWithIcon:(NSString *)icon title:(NSString *)title detailTitle:(NSString *)detailTitle didClickBlock:(VoidBlock)didClickBlock;

@end
