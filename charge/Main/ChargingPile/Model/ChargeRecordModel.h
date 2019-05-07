//
//  ChargeRecordModel.h
//  charge
//
//  Created by growatt007 on 2018/10/20.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChargeRecordModel : NSObject

@property (nonatomic, strong) NSNumber *sysEndTime; // 结束时间
@property (nonatomic, strong) NSNumber *cost; // 花费
@property (nonatomic, strong) NSNumber *rate; // 费率
@property (nonatomic, strong) NSNumber *connectorId; // 枪号
@property (nonatomic, copy) NSString *chargeId; // 充电桩ID
@property (nonatomic, strong) NSNumber *sysStartTime; // 开始时间
@property (nonatomic, strong) NSNumber *ctime; // 时长
@property (nonatomic, copy) NSString *userName; // 用户名
@property (nonatomic, copy) NSString *chargeName; // 电桩名
@property (nonatomic, strong) NSNumber *energy; // 电量
@property (nonatomic, strong) NSString *status; // 状态


// 获取枪标号名
- (NSString *)getConnectorIdName;

@end

NS_ASSUME_NONNULL_END
