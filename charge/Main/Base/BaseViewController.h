//
//  BaseViewController.h
//  charge
//
//  Created by growatt007 on 2018/10/16.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController


- (void)showToastViewWithTitle:(NSString *)title;

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle;

- (void)showProgressView;

- (void)hideProgressView;

- (NSString *)MD5:(NSString *)str ;

@property (nonatomic, strong)  NSString *languageType;

@end

NS_ASSUME_NONNULL_END
