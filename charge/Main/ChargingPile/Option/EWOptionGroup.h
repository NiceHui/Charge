//
//  EWOptionGroup.h
//  EasyWork
//
//  Created by Ryan on 16/8/7.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWOptionItem.h"



@interface EWOptionGroup : NSObject

/**
 *  所有的items
 */
@property(nonatomic, strong) NSArray <EWOptionItem *> *items;

/**
 *  头部文本
 */
@property(nonatomic, copy) NSString *headerTitle;

/**
 *  尾部文本
 */
@property(nonatomic, copy) NSString *footerTitle;

@end
