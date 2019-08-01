//
//  GRTChargingPileModel.h
//  ShinePhone
//
//  Created by growatt007 on 2018/7/13.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRTChargingPileModel : NSObject

@property (nonatomic, strong) NSNumber *connectors; // 充电桩枪数量
@property (nonatomic, copy) NSString *chargeId; // 充电桩ID
@property (nonatomic, copy) NSString *userPhone; // 用户电话
@property (nonatomic, copy) NSString *name; // 充电桩名字
@property (nonatomic, copy) NSString *model; // 充电桩模式
@property (nonatomic, copy) NSString *time; // 时间戳
@property (nonatomic, copy) NSString *userName; // 用户名
@property (nonatomic, strong) NSNumber *type; // 类型
@property (nonatomic, copy) NSString *userId; // 用户ID
@property (nonatomic, strong) NSArray *status; // 充电桩枪状态列表
@property (nonatomic, strong) NSNumber *solar; // solar值
@property (nonatomic, strong) NSArray *priceConf; // 费率数组
@property (nonatomic, strong) NSString *G_SolarMode; // solar模式
@property (nonatomic, strong) NSString *G_SolarLimitPower; // solar的ECO+光伏充电限制

- (NSString *)getmodel;// 获取充电桩枪模式名称

- (NSString *)getConnectors; // 获取充电桩枪数量名称

- (NSArray *)getConnectorsNameArray; // 获取充电枪名字数组


@end
