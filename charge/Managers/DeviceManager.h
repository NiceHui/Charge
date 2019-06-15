//
//  DeviceManager.h
//  ShinePhone
//
//  Created by growatt007 on 2018/6/26.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceManager : NSObject


+ (DeviceManager *)shareInstenced;


/**
 1.获取用户所有家庭能源设备数据总接口
 
 @param userid 用户id
 @param success 成功
 @param failure 失败
 */
- (void)getTotalListWithUserId:(NSString *)userid
                       success:(void (^)(id obj))success
                       failure:(void (^)(NSError *error))failure;


/**
 2.获取设备列表
 
 @param userid 用户id
 @param devType 设备类型
 @param success 成功
 @param failure 失败
 */
- (void)getDeviceListWithUserId:(NSString *)userid
                        devType:(NSString *)devType
                        success:(void (^)(id obj))success
                        failure:(void (^)(NSError *error))failure;


/**
 3.获取单个插座设备详细数据
 
 @param devId 设备id
 @param success 成功
 @param failure 失败
 */
- (void)getSocketInfoWithDevId:(NSString *)devId
                       success:(void (^)(id obj))success
                       failure:(void (^)(NSError *error))failure;


/**
 4.获取单个温控器设备详细数据
 
 @param devId 设备id
 @param success 成功
 @param failure 失败
 */
- (void)getThermostatInfoWithDevId:(NSString *)devId
                           success:(void (^)(id obj))success
                           failure:(void (^)(NSError *error))failure;



/**
 5.设备指令下发
 
 @param devId 设备id
 @param devType 设备类型
 @param dps 设备的所有信息
 @param success 成功
 @param failure 失败
 */
- (void)controlSettingWithDevId:(NSString *)devId
                        devType:(NSString *)devType
                            dps:(NSDictionary *)dps
                        success:(void (^)(id obj))success
                        failure:(void (^)(NSError *error))failure;

/**
 6.添加涂鸦设备
 
 @param uid 用户id
 @param devId 设备id
 @param devType 设备类型
 @param success 成功
 @param failure 失败
 */
- (void)addDeviceWithUid:(NSString *)uid
                   devId:(NSString *)devId
                 devType:(NSString *)devType
                 success:(void (^)(id obj))success
                 failure:(void (^)(NSError *error))failure;

/**
 7.删除涂鸦设备
 
 @param devId 设备id
 @param devType 设备类型
 @param success 成功
 @param failure 失败
 */
- (void)removeDeviceWithdevId:(NSString *)devId
                      devType:(NSString *)devType
                      success:(void (^)(id obj))success
                      failure:(void (^)(NSError *error))failure;

/**
 8.注册成为涂鸦用户
 
 @param uid 用户id
 @param success 成功
 @param failure 失败
 */
- (void)registTuyaWithUid:(NSString *)uid
                  success:(void (^)(id obj))success
                  failure:(void (^)(NSError *error))failure;



/// ******************     以下为充电桩接口     *******************/

/**
 11.添加充电桩
 
 @param userId 用户id
 @param sn 电桩号
 @param success 成功
 @param failure 失败
 */
- (void)AddChargingPileWithUserId:(NSString *)userId
                               sn:(NSString *)sn
                          success:(void (^)(id obj))success
                          failure:(void (^)(NSError *error))failure;


/**
 12.获取用户自己添加的充电桩列表
 
 @param userId 用户id
 @param success 成功
 @param failure 失败
 */
- (void)GetChargingPileListWithUserId:(NSString *)userId
                              success:(void (^)(id obj))success
                              failure:(void (^)(NSError *error))failure;


/**
 13.获取用户单个充电桩详情数据
 
 @param sn 电桩号
 @param connectorId 充电枪编码
 @param userId 用户ID
 @param success 成功
 @param failure 失败
 */
- (void)GetChargingPileInfoWithSn:(NSString *)sn
                      connectorId:(NSNumber *)connectorId
                           userId:(NSString *)userId
                          success:(void (^)(id obj))success
                          failure:(void (^)(NSError *error))failure;


/**
 15.获取用户当前充电桩已授权的用户列表
 
 @param sn 电桩号
 @param success 成功
 @param failure 失败
 */
- (void)GetChargingPileUseListWithSn:(NSString *)sn
                             success:(void (^)(id obj))success
                             failure:(void (^)(NSError *error))failure;

/**
 16.添加授权
 
 @param userId 用户id
 @param ownerId 桩主id
 @param sn 电桩号
 @param userName 用户名
 @param success 成功
 @param failure 失败
 */
- (void)AddAuthorChargingPileWithUserId:(NSString *)userId
                                ownerId:(NSString *)ownerId
                                     sn:(NSString *)sn
                               userName:(NSString *)userName
                                success:(void (^)(id obj))success
                                failure:(void (^)(NSError *error))failure;


/**
 17.注册新用户并授权
 
 @param sn 电桩号
 @param userName 用户名
 @param password 密码
 @param success 成功
 @param failure 失败
 */
- (void)RegisterAuthorChargingPileWithSn:(NSString *)sn
                                userName:(NSString *)userName
                                password:(NSString *)password
                                 success:(void (^)(id obj))success
                                 failure:(void (^)(NSError *error))failure;


/**
 18.删除已授权用户
 
 @param sn 电桩号
 @param userId 用户id
 @param success 成功
 @param failure 失败
 */
- (void)DeleteAuthorChargingPileWithSn:(NSString *)sn
                                userId:(NSString *)userId
                               success:(void (^)(id obj))success
                               failure:(void (^)(NSError *error))failure;


/**
 19.获取用户充电桩当电充电量
 
 @param userId 用户id
 @param success 成功
 @param failure 失败
 */
- (void)ChargeDayEleChargingPileWithUserId:(NSString *)userId
                                   success:(void (^)(id obj))success
                                   failure:(void (^)(NSError *error))failure;


/**
 20.获取通过用户名获取用户id
 
 @param userAccount 用户名
 @param success 成功
 @param failure 失败
 */
- (void)GetUserIdWithUserAccount:(NSString *)userAccount
                         success:(void (^)(id obj))success
                         failure:(void (^)(NSError *error))failure;

/**
 21.获取充电历史记录
 
 @param userId 用户id
 @param sn 充电桩号
 @param page 页码
 @param success 成功
 @param failure 失败
 */
- (void)ChargeRecordChargingPileWithUserId:(NSString *)userId
                                        Sn:(NSString *)sn
                                      page:(NSNumber *)page
                                   success:(void (^)(id obj))success
                                   failure:(void (^)(NSError *error))failure;

/**
 22.电桩的离线记录
 
 @param userId 用户id
 @param sn 充电桩号
 @param success 成功
 @param failure 失败
 */
- (void)ChargeoffRecordChargingPileWithUserId:(NSString *)userId
                                           Sn:(NSString *)sn
                                      success:(void (^)(id obj))success
                                      failure:(void (^)(NSError *error))failure;


/**
 23.请求充电桩设置
 
 @param sn 充电桩号
 @param success 成功
 @param failure 失败
 */
- (void)ChargeoConfigInfomationWithSn:(NSString *)sn
                              success:(void (^)(id obj))success
                              failure:(void (^)(NSError *error))failure;


/**
 24.更新充电桩设置
 
 @param parms 设置的信息
 @param success 成功
 @param failure 失败
 */
- (void)setChargeoConfigInfomationWithParms:(NSDictionary *)parms
                                   success:(void (^)(id obj))success
                                   failure:(void (^)(NSError *error))failure;


/**
 25.获取预约列表
 
 @param userid 用户ID
 @param sn 充电桩id
 @param connectorId 充电枪号
 @param cKey 预约类型
 @param success 成功
 @param failure 失败
 */
- (void)getChargeTimingListWithUserId:(NSString *)userid
                                   Sn:(NSString *)sn
                          ConnectorId:(NSNumber *)connectorId
                                 cKey:(NSString *)cKey
                              success:(void (^)(id obj))success
                              failure:(void (^)(NSError *error))failure;


/**
 26.更新预约、注销、删除预约
 
 @param parms parms
 @param success 成功
 @param failure 失败
 */
- (void)updateChargeTimingWithParms:(NSDictionary *)parms
                            success:(void (^)(id obj))success
                            failure:(void (^)(NSError *error))failure;


/**
 27.预约充电
 
 @param parms parms
 @param success 成功
 @param failure 失败
 */
- (void)addChargeTimingWithParms:(NSDictionary *)parms
                         success:(void (^)(id obj))success
                         failure:(void (^)(NSError *error))failure;


/**
 28.获取预约充电信息, 最后一次操作信息
 
 @param sn 电桩id
 @param connectorId 电桩枪号
 @param success 成功
 @param failure 失败
 */
- (void)getChargeReserveNowAndLastActionWithSn:(NSString *)sn
                                        userId:(NSString *)userId
                                   ConnectorId:(NSNumber *)connectorId
                                          type:(NSString *)type
                                       success:(void (^)(id obj))success
                                       failure:(void (^)(NSError *error))failure;


/**
 29.设置电站solar限制
 
 @param sn 电桩id
 @param userId 用户id
 @param solar solar值
 @param success 成功
 @param failure 失败
 */
- (void)setChargeSolarWithSn:(NSString *)sn
                      userId:(NSString *)userId
                       solar:(NSNumber *)solar
                     success:(void (^)(id obj))success
                     failure:(void (^)(NSError *error))failure;


/**
 30.电桩切换AP模式
 
 @param sn 电桩id
 @param userId 用户id
 @param success 成功
 @param failure 失败
 */
- (void)switchAPModeWithSn:(NSString *)sn
                    userId:(NSString *)userId
                   success:(void (^)(id obj))success
                   failure:(void (^)(NSError *error))failure;


/**
 31.api
 
 @param parms 指令参数
 @param success 成功
 @param failure 失败
 */
- (void)sendCommandWithParms:(NSDictionary *)parms
                     success:(void (^)(id obj))success
                     failure:(void (^)(NSError *error))failure;


@end
