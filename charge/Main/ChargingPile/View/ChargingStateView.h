//
//  ChargingStateView.h
//  ShinePhone
//
//  Created by growatt007 on 2018/10/13.
//  Copyright © 2018年 qwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChargingpileInfoModel.h"

@protocol ChargingStateDelegate <NSObject>

- (void)ChargingStatePresetValueWithProgramme:(NSString *)programme;

- (void)ChargingTimingList:(NSString *)type;

- (void)SelectChargingProgramme:(NSString *)programme; // 选择充电方案

@end

NS_ASSUME_NONNULL_BEGIN

@interface ChargingStateView : UIView

@property (nonatomic, strong) NSNumber *userType; // 用户类型  0-桩主  1-分享用户

@property (nonatomic, assign) BOOL isRefreshOrder; // 是否刷新预约状态UI


@property (nonatomic, strong) NSString *currentPrograme;// 当前选择的方案
// 定时
@property (nonatomic, strong) UIButton *timeButton;
// 是否预定
@property (nonatomic, strong) UISwitch *switchButton;
// 是否循环
@property (nonatomic, strong) UIButton *looptypeBtn;

@property (nonatomic, strong) ChargingpileInfoModel *model;// 数据模型

@property (nonatomic, weak) id <ChargingStateDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame Type:(NSString *)type;

/**
 设置方案预设值

 @param value1 值1
 @param value2 值2
 @param programme 类型
 */
- (void)setProgrammeWithValue:(NSString *)value1 Value2:(NSString *)value2 programme:(NSString *)programme;


/**
  刷新定时按键的显示

 @param time 需要显示的时间
 */
- (void)setTimeButtonWithTitle:(NSString *)time;

@end

NS_ASSUME_NONNULL_END
