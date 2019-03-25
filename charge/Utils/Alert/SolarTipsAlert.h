//
//  SolarTipsAlert.h
//  charge
//
//  Created by growatt007 on 2018/11/21.
//  Copyright © 2018 hshao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SolarTipsAlert : UIView

@property (nonatomic, copy) void (^touchAlertEnter)();

@property (nonatomic, copy) void (^touchAlertCancel)();

@property (nonatomic, assign) BOOL state;

- (instancetype)initWithButtonFrame:(CGRect)rect;

/**
 弹出
 */
- (void)show;

/**
 关闭
 */
- (void)hide;

@end

NS_ASSUME_NONNULL_END
