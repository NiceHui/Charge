//
//  ChargingpileInfoModel.h
//  charge
//
//  Created by growatt007 on 2018/10/19.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChargingpileInfoModel : NSObject

@property (nonatomic, copy) NSString *cKey; // 状态
@property (nonatomic, strong) NSNumber *cValue; // 预设值
@property (nonatomic, copy) NSString *order_status; // 充电桩ID
@property (nonatomic, strong) NSNumber *current; // 电流
@property (nonatomic, strong) NSNumber *cost; // 花费
@property (nonatomic, strong) NSNumber *ctype; //
@property (nonatomic, strong) NSNumber *rate; //费率
@property (nonatomic, strong) NSNumber *ctime; // 已充时长
@property (nonatomic, strong) NSNumber *transactionId; //
@property (nonatomic, copy) NSString *status; // 状态
@property (nonatomic, strong) NSNumber *energy; // 已充电量
@property (nonatomic, strong) NSNumber *voltage; // 电压
@property (nonatomic, strong) NSArray *ReserveNow; // 预定
@property (nonatomic, strong) NSDictionary *LastAction; // 最后一次操作
@property (nonatomic, strong) NSString *symbol; // 单位


- (NSString *)getCurrentStatus; // 获取当前状态

- (NSDictionary *)getReserveNow;  // 获取准备中状态的预设信息

- (NSDictionary *)getChargingData; // 获取充电中的数据

- (NSArray *)getSupendData; // 获取充电结束状态下的数据

- (NSDictionary *)getReserveNow2;  // 获取准备中状态的预设信息

@end

NS_ASSUME_NONNULL_END
