//
//  SolarTipsAlert.h
//  charge
//
//  Created by growatt007 on 2018/11/21.
//  Copyright © 2018 hshao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRTChargingPileModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SolarTipsAlert : UIView

@property (nonatomic, copy) void (^touchAlertEnter)();

@property (nonatomic, copy) void (^touchAlertCancel)();

@property (nonatomic, copy) void (^touchAlertSwitchSolarModel)(NSNumber *model);

@property (nonatomic, assign) BOOL state;

@property (nonatomic, strong) GRTChargingPileModel* deviceModel;// 充电桩列表的model

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
