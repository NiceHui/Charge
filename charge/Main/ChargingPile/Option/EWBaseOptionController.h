//
//  EWBaseOptionController.h
//  EasyWork
//
//  Created by Ryan on 16/8/7.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EWOptionGroup.h"



@interface EWBaseOptionController : UITableViewController

/**
 *  所有组
 */
@property(nonatomic, strong, readonly) NSMutableArray <EWOptionGroup *> *groups;

- (void)showToastViewWithTitle:(NSString *)title;

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle;

- (void)showProgressView;

- (void)hideProgressView;

@end
