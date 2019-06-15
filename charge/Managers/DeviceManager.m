//
//  DeviceManager.m
//  ShinePhone
//
//  Created by growatt007 on 2018/6/26.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "DeviceManager.h"
#import "AFNetworking.h"

#define char_method

@implementation DeviceManager


+ (DeviceManager *)shareInstenced{
    
    static DeviceManager *this = nil;
    
    static dispatch_once_t onesToken;
    
    dispatch_once(&onesToken, ^{
        
        this = [[self alloc]init];
    });
    
    return this;
}


/**
 1.获取用户所有家庭能源设备数据总接口
 
 @param userid 用户id
 @param success 成功
 @param failure 失败
 */
- (void)getTotalListWithUserId:(NSString *)userid
                       success:(void (^)(id obj))success
                       failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"userId":[NSString stringWithFormat:@"%@",userid]};
    
    [BaseRequest myJsonPost:@"/eic_web/tuya/totalList" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {

            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

            NSLog(@"%@/eic_web/tuya/totalList:%@",formal_Method ,jsonObj);

            success(jsonObj);
        }
    } failure:^(NSError *error) {

        NSLog(@"error: %@", error);
        failure(error);

    }];
    
}


/**
 2.获取设备列表 插座/温控/shineBoost
 
 @param userid 用户id
 @param devType 设备类型
 @param success 成功
 @param failure 失败
 */
- (void)getDeviceListWithUserId:(NSString *)userid
                        devType:(NSString *)devType
                        success:(void (^)(id obj))success
                        failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"uid":[NSString stringWithFormat:@"%@",userid],
                            @"devType":devType};
    
    [BaseRequest myJsonPost:@"/eic_web/tuya/devList" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/eic_web/tuya/devList:%@",formal_Method ,jsonObj);
            
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);

        failure(error);
    }];
    
}


/**
 3.获取单个插座设备详细数据
 
 @param devId 设备id
 @param success 成功
 @param failure 失败
 */
- (void)getSocketInfoWithDevId:(NSString *)devId
                       success:(void (^)(id obj))success
                       failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"devId":devId};
    
    [BaseRequest myJsonPost:@"/eic_web/tuya/socketInfo" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/eic_web/tuya/socketInfo:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
    
}


/**
 4.获取单个温控器设备详细数据
 
 @param devId 设备id
 @param success 成功
 @param failure 失败
 */
- (void)getThermostatInfoWithDevId:(NSString *)devId
                           success:(void (^)(id obj))success
                           failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"devId":devId};
    
    [BaseRequest myJsonPost:@"/eic_web/tuya/thermostatInfo" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/eic_web/tuya/thermostatInfo:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
    
}



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
                        failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"devId":devId, @"devType":devType, @"dps":dps};
    
    [BaseRequest myJsonPost:@"/eic_web/tuya/setting" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/eic_web/tuya/setting:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
    
}



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
                 failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"uid":uid, @"devId":devId, @"devType":devType};
    
    [BaseRequest myJsonPost:@"/eic_web/tuya/addDevice" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/eic_web/tuya/addDevice:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
    
}


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
                      failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"devId":devId, @"devType":devType};
    
    [BaseRequest myJsonPost:@"/eic_web/tuya/removeDevice" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/eic_web/tuya/removeDevice:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
    
}


/**
 8.注册成为涂鸦用户
 
 @param uid 用户id
 @param success 成功
 @param failure 失败
 */
- (void)registTuyaWithUid:(NSString *)uid
                  success:(void (^)(id obj))success
                  failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"uid": uid};
    
    [BaseRequest myJsonPost:@"/eic_web/tuya/regist" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            NSLog(@"%@/eic_web/tuya/regist: %@",formal_Method ,responseObject);
            
            success(responseObject);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
    
}





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
                  failure:(void (^)(NSError *error))failure{

    NSDictionary *parms = @{@"userId": userId,
                            @"sn": sn};
    [BaseRequest myJsonPost:@"/ocpp/api/add" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/api/add:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {

        NSLog(@"error: %@", error);
        failure(error);
    }];
}


/**
 12.获取用户自己添加的充电桩列表
 
 @param userId 用户id
 @param success 成功
 @param failure 失败
 */
- (void)GetChargingPileListWithUserId:(NSString *)userId
                              success:(void (^)(id obj))success
                              failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"userId": userId};
    [BaseRequest myJsonPost:@"/ocpp/api/list" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/api/list:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}


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
                              failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"sn": sn,
                            @"connectorId": connectorId,
                            @"userId": userId
                            };
    [BaseRequest myJsonPost:@"/ocpp/charge/info" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/charge/info:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}


/**
 15.获取用户当前充电桩已授权的用户列表
 
 @param sn 电桩号
 @param success 成功
 @param failure 失败
 */
- (void)GetChargingPileUseListWithSn:(NSString *)sn
                          success:(void (^)(id obj))success
                          failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"sn": sn};
    [BaseRequest myJsonPost:@"/ocpp/api/userList" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/api/userList:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}


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
                             failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"userId": userId,
                            @"ownerId": ownerId,
                            @"sn": sn,
                            @"userName": userName
                            };
    [BaseRequest myJsonPost:@"/ocpp/api/author" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/api/author:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}


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
                             failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"sn": sn,
                            @"userName": userName,
                            @"password": password};
    [BaseRequest myJsonPost:@"/ocpp/api/registerAuthor" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/api/registerAuthor:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}


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
                             failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"sn": sn,
                            @"userId": userId};
    [BaseRequest myJsonPost:@"/ocpp/api/deleteAuthor" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/api/deleteAuthor:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}


/**
 19.获取用户充电桩当电充电量
 
 @param userId 用户id
 @param success 成功
 @param failure 失败
 */
- (void)ChargeDayEleChargingPileWithUserId:(NSString *)userId
                               success:(void (^)(id obj))success
                               failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"userId": userId};
    [BaseRequest myJsonPost:@"/ocpp/api/chargeDayEle" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/api/chargeDayEle:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}

/**
 20.获取通过用户名获取用户id
 
 @param userAccount 用户名
 @param success 成功
 @param failure 失败
 */
- (void)GetUserIdWithUserAccount:(NSString *)userAccount
                                   success:(void (^)(id obj))success
                                   failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"userAccount": userAccount};
    [BaseRequest myHttpPost:@"/QXRegisterAPI.do?op=getUserIdByID" parameters:parms Method:HEAD_URL success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

            NSLog(@"%@/QXRegisterAPI.do?op=getUserIdByID: %@",HEAD_URL ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {

        NSLog(@"error: %@", error);
        failure(error);
    }];

}


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
                                   failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"userId": userId,
                            @"sn": sn
//                            @"page": page
                            };
    [BaseRequest myJsonPost:@"/ocpp/api/chargeRecord" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/api/chargeRecord:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}


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
                                      failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"userId": userId,
                            @"sn":sn};
    [BaseRequest myJsonPost:@"/ocpp/api/offRecord" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/api/offRecord:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}

/**
 23.请求充电桩设置
 
 @param sn 充电桩号
 @param success 成功
 @param failure 失败
 */
- (void)ChargeoConfigInfomationWithSn:(NSString *)sn
                                      success:(void (^)(id obj))success
                                      failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms = @{@"sn":sn};
    [BaseRequest myJsonPost:@"/ocpp/api/configInfo" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/api/configInfo:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}

/**
 24.更新充电桩设置
 
 @param parms 设置的信息
 @param success 成功
 @param failure 失败
 */
- (void)setChargeoConfigInfomationWithParms:(NSDictionary *)parms
                              success:(void (^)(id obj))success
                              failure:(void (^)(NSError *error))failure{
    
    [BaseRequest myJsonPost:@"/ocpp/api/config" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/api/config:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}

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
                                    failure:(void (^)(NSError *error))failure{
    NSDictionary *parms = @{@"sn": sn,
                            @"userid": userid,
                            @"connectorId": connectorId,
                            @"cKey": cKey
                            };
    [BaseRequest myJsonPost:@"/ocpp/api/reserveList" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/api/reserveList:%@",formal_Method ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}

/**
 26.更新预约、注销、删除预约
 
 @param parms parms
 @param success 成功
 @param failure 失败
 */
- (void)updateChargeTimingWithParms:(NSDictionary *)parms
                              success:(void (^)(id obj))success
                              failure:(void (^)(NSError *error))failure{

    [BaseRequest myJsonPost:@"/ocpp/api/updateReserve" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/api/updateReserve:%@",formal_Method, jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}

/**
 27.预约充电
 
 @param parms parms
 @param success 成功
 @param failure 失败
 */
- (void)addChargeTimingWithParms:(NSDictionary *)parms
                            success:(void (^)(id obj))success
                            failure:(void (^)(NSError *error))failure{
    
    [BaseRequest myJsonPost:@"/ocpp/cmd/" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/cmd: %@",formal_Method,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}

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
                         failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parms;
    if ([type isEqualToString:@"ReserveNow"]) {
        
        parms = @{@"chargeId": sn,@"connectorId": connectorId};
        
    }else if([type isEqualToString:@"LastAction"]){
        
        parms = @{@"chargeId": sn,@"connectorId": connectorId, @"userId": userId};
        
    }
    
    [BaseRequest myJsonPost:[NSString stringWithFormat:@"/ocpp/api/%@",type] parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@%@: %@",formal_Method, [NSString stringWithFormat:@"/ocpp/api/%@",type] ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}

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
                          failure:(void (^)(NSError *error))failure{
    NSDictionary *parms = @{
                            @"chargeId": sn,
                            @"userId": userId,
                            @"solar": solar
                            };
    
    [BaseRequest myJsonPost:@"/ocpp/api/setSolar" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/api/setSolar: %@",formal_Method,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}

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
                   failure:(void (^)(NSError *error))failure{
    NSDictionary *parms = @{
                            @"chargeId": sn,
                            @"userId": userId
                            };
    
    [BaseRequest myJsonPost:@"/ocpp/user/appMode" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/user/appMode: %@",formal_Method,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}


/**
 31.api
 
 @param parms 指令参数
 @param success 成功
 @param failure 失败
 */
- (void)sendCommandWithParms:(NSDictionary *)parms
                     success:(void (^)(id obj))success
                     failure:(void (^)(NSError *error))failure{
    
    [BaseRequest myJsonPost:@"/ocpp/api" parameters:parms Method:formal_Method success:^(id responseObject) {
        if (responseObject) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@/ocpp/api/%@: %@",formal_Method, [NSString stringWithFormat:@"%@", parms[@"cmd"]] ,jsonObj);
            success(jsonObj);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error: %@", error);
        failure(error);
    }];
}


@end
