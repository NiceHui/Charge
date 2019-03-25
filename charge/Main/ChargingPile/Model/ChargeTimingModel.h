//
//  ChargeTimingModel.h
//  charge
//
//  Created by growatt007 on 2018/10/22.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChargeTimingModel : NSObject

@property (nonatomic, copy) NSString *endDate; // 结束时间
@property (nonatomic, strong) NSNumber *connectorId; // 充电枪号
@property (nonatomic, copy) NSString *msgId; // 信息标号
@property (nonatomic, copy) NSString *userId; // 用户id
@property (nonatomic, strong) NSNumber *transactionId; //
@property (nonatomic, copy) NSString *expiryDate; // 开始时间
@property (nonatomic, strong) NSNumber *loopType; // 是否每天循环
@property (nonatomic, copy) NSString *loopValue; // 循环值
@property (nonatomic, copy) NSString *cKey; // 预定方案类型
@property (nonatomic, strong) NSNumber *reservationId; // 电量
@property (nonatomic, copy) NSString *chargeId; // 充电桩id
@property (nonatomic, strong) NSNumber *cValue; // 预定值
@property (nonatomic, strong) NSNumber *ctime; // 时间
@property (nonatomic, strong) NSNumber *cid; //
@property (nonatomic, copy) NSString *status; // 状态

@end

NS_ASSUME_NONNULL_END
