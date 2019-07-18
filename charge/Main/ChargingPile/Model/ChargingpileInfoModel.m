//
//  ChargingpileInfoModel.m
//  charge
//
//  Created by growatt007 on 2018/10/19.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "ChargingpileInfoModel.h"

@implementation ChargingpileInfoModel

- (NSString *)getCurrentStatus{
    
    if([_status isEqualToString:@"Available"]){
        
        return HEM_Available;
    }else if([_status isEqualToString:@"Charging"]){
        
        return HEM_Charging;
    }else if([_status isEqualToString:@"Preparing"]){
        
        return HEM_Preparing;
    }else if([_status isEqualToString:@"Reserved"]){// 预约准备中
        
        return root_yuyue;//HEM_Preparing;
    }else if([_status isEqualToString:@"Finishing"]){
        
        return HEM_Finishing;
    }else if ([_status isEqualToString:@"Faulted"]){
        
        return HEM_Faulted;
    }else if ([_status isEqualToString:@"Unavailable"]){
        
        return HEM_Unavailable;
    }else if ([_status isEqualToString:@"SuspendedEV"]){ // 车拒绝充电
        
        return HEM_SuspendedEV;
    }else if ([_status isEqualToString:@"SuspendedEVSE"]){ // 桩拒绝充电
        
        return HEM_SuspendedEVSE;
    } if ([_status isEqualToString:@"expiry"]){
        
        return HEM_expiry;
    }else if ([_status isEqualToString:@"Accepted"]){
        
        return root_yuyue;//HEM_Accepted;
    }else if ([_status isEqualToString:@"work"]){
        
        return HEM_work;
    }else if ([_status isEqualToString:@"ReserveNow"]){// 预约
        
        return root_yuyue;
    }
    return HEM_Unavailable;
}


// 返回值主要分成四种情况  普通定时， 金额定时， 电量定时， 分段定时
- (NSDictionary *)getReserveNow{
    // 因为添加了预约状态，不在准备中页面显示定时有关数据
    return @{@"cKey": @"",
             @"value": @[@"--", @"-- kWh", @"- h - min"],
             @"value2": @"--"
             };
    
    if (_LastAction && [_LastAction isKindOfClass:[NSDictionary class]]) {
        NSString *action = _LastAction[@"action"];
        if([action isEqualToString:@"remoteStopTransaction"]){// 远程控制
            
            return @{@"cKey": @"",
                     @"value": @[@"--", @"-- kWh", @"- h - min"],
                     @"value2": @"--"
                     };
            
        }else if([action isEqualToString:@"ReserveNow"]){// 预订模式
            
            if ([_ReserveNow isKindOfClass:[NSArray class]] && _ReserveNow.count > 0) {
                NSDictionary *dict = _ReserveNow[0];
                
                if ([dict[@"cKey"] isEqualToString:@"G_SetAmount"]) { // 金额
                    
                    NSString *expiryDate = dict[@"expiryDate"];
                    NSArray *expiryArray = [self separateTime:expiryDate];
                    NSString *time = [NSString stringWithFormat:@"%@:%@",expiryArray[1],expiryArray[2]];
                    return @{@"cKey": dict[@"cKey"] ,
                             @"value": @[dict[@"cValue"], @"-- kWh", @"- h - min"] ,
                             @"looptype": dict[@"loopType"] ? dict[@"loopType"] : @(-1),
                             @"value2": time
                             };
                    
                }else if([dict[@"cKey"] isEqualToString:@"G_SetEnergy"]){// 电量
                    
                    NSString *expiryDate = dict[@"expiryDate"];
                    NSArray *expiryArray = [self separateTime:expiryDate];
                    NSString *time = [NSString stringWithFormat:@"%@:%@",expiryArray[1],expiryArray[2]];
                    return @{@"cKey":dict[@"cKey"] ,
                             @"value":@[@"--", [NSString stringWithFormat:@"%@ kWh",dict[@"cValue"]], @"- h - min"],
                             @"looptype": dict[@"loopType"] ? dict[@"loopType"] : @(-1),
                             @"value2": time
                             };
                    
                }else if([dict[@"cKey"] isEqualToString:@"G_SetTime"]){// 时长
                    
                    NSInteger totalTime = 0;
                    NSMutableString *value2 = [[NSMutableString alloc]init];
                    for (int i = 0; i < _ReserveNow.count; i++) {
                        NSDictionary *reserveDic = _ReserveNow[i];
                        NSString *expiryDate = reserveDic[@"expiryDate"];
                        NSArray *expiryArray = [self separateTime:expiryDate];
                        
                        NSInteger cValue = [reserveDic[@"cValue"] integerValue]; // 通过开始时间和时长计算结束时间
                        NSInteger endValue = cValue + [expiryArray[1] integerValue]*60 + [expiryArray[2] integerValue];
                        NSString *end_hour = [NSString SupplementZero:[NSString stringWithFormat:@"%ld",endValue/60]];
                        NSString *end_min = [NSString SupplementZero:[NSString stringWithFormat:@"%ld",endValue%60]];
                        
                        NSString *time = [NSString stringWithFormat:@"%@:%@~%@:%@",expiryArray[1],expiryArray[2],end_hour,end_min];
                        [value2 appendString:time];
                        if (i<_ReserveNow.count-1) {
                            [value2 appendString:@","];
                        }
                        
                        totalTime += cValue;// 总时长
                    }
                    
                    NSString *hour = [NSString stringWithFormat:@"%ld",totalTime/60];
                    NSString *min = [NSString stringWithFormat:@"%ld",totalTime%60];
                    hour = [NSString SupplementZero:hour];
                    min = [NSString SupplementZero:min];
                    
                    return @{@"cKey": dict[@"cKey"] ,
                             @"value": @[@"--", @"-- kWh", [NSString stringWithFormat:@"%@ h %@ min",hour,min]],
                             @"value2": value2
                             };
                }else{// 普通定时
                    
                    NSString *expiryDate = dict[@"expiryDate"];
                    NSArray *expiryArray = [self separateTime:expiryDate];
                    return @{@"cKey":@"" ,
                             @"value": @[@"--", @"-- kWh", @"- h - min"],
                             @"value2": [NSString stringWithFormat:@"%@:%@",expiryArray[1],expiryArray[2]]
                             };
                }
            }
            
        }
    }
    return @{@"cKey": @"",
             @"value": @[@"--", @"-- kWh", @"- h - min"],
             @"value2": @"--"
             };
}

// 分离时间
- (NSArray *)separateTime:(NSString *)time{
    
    NSMutableString *string = [NSMutableString stringWithString:time];
    NSMutableString *string2 = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@"T" withString:@":"]];
    NSString *time1 = [string2 stringByReplacingOccurrencesOfString:@"Z" withString:@""];
    
    NSArray *array = [time1 componentsSeparatedByString:@":"];// @"2018-10-20:11:30:27.666"
    
    return array;
}

- (NSDictionary *)getReserveNow2{
    
    if ([_ReserveNow isKindOfClass:[NSArray class]] && _ReserveNow.count > 0) {
        NSDictionary *dict = _ReserveNow[0];
        
        if ([dict[@"cKey"] isEqualToString:@"G_SetAmount"]) { // 金额
            
            NSString *expiryDate = dict[@"expiryDate"];
            NSArray *expiryArray = [self separateTime:expiryDate];
            NSString *time = [NSString stringWithFormat:@"%@:%@",expiryArray[1],expiryArray[2]];
            return @{@"cKey": [NSString stringWithFormat:@"%@", dict[@"cKey"]] ,
                     @"rate": [NSString stringWithFormat:@"%@",dict[@"rate"]] ,
                     @"value": [NSString stringWithFormat:@"%@",dict[@"cValue"]] ,
                     @"value2": time
                     };
            
        }else if([dict[@"cKey"] isEqualToString:@"G_SetEnergy"]){// 电量
            
            NSString *expiryDate = dict[@"expiryDate"];
            NSArray *expiryArray = [self separateTime:expiryDate];
            NSString *time = [NSString stringWithFormat:@"%@:%@",expiryArray[1],expiryArray[2]];
            return @{@"cKey": [NSString stringWithFormat:@"%@",dict[@"cKey"]] ,
                     @"rate": [NSString stringWithFormat:@"%@",dict[@"rate"]] ,
                     @"value":[NSString stringWithFormat:@"%@ kWh",dict[@"cValue"]],
                     @"value2": time
                     };
            
        }else if([dict[@"cKey"] isEqualToString:@"G_SetTime"]){// 时长
            
            
            NSMutableArray *timeRateArray = [NSMutableArray array];
            for (int i = 0; i < _ReserveNow.count; i++) {
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                
                NSDictionary *reserveDic = _ReserveNow[i];
                NSString *expiryDate = reserveDic[@"expiryDate"];
                NSArray *expiryArray = [self separateTime:expiryDate];
                
                NSInteger cValue = [reserveDic[@"cValue"] integerValue]; // 通过开始时间和时长计算结束时间
                NSInteger endValue = cValue + [expiryArray[1] integerValue]*60 + [expiryArray[2] integerValue];
                NSString *end_hour = [NSString SupplementZero:[NSString stringWithFormat:@"%ld",endValue/60]];
                NSString *end_min = [NSString SupplementZero:[NSString stringWithFormat:@"%ld",endValue%60]];
                NSString *time = [NSString stringWithFormat:@"%@:%@~%@:%@",expiryArray[1],expiryArray[2],end_hour,end_min];
                
                [dict setObject:time forKey:@"time"]; // 时间
                [dict setObject:reserveDic[@"rate"] forKey:@"rate"]; // 费率
                [dict setObject:reserveDic[@"cost"] forKey:@"cost"]; // 花费
                [timeRateArray addObject:dict];
            }
            
            return @{@"cKey": dict[@"cKey"],
                     @"timeRateArray": timeRateArray
                     };
        }else{// 普通定时
            
            NSString *expiryDate = dict[@"expiryDate"];
            NSArray *expiryArray = [self separateTime:expiryDate];
            return @{@"cKey":@"" ,
                     @"rate": [NSString stringWithFormat:@"%@",dict[@"rate"]] ,
                     @"value": @"",
                     @"value2": [NSString stringWithFormat:@"%@:%@",expiryArray[1],expiryArray[2]]
                     };
        }
    }
    
    return @{@"cKey":@"" ,
             @"rate": @"" ,
             @"value": @"",
             @"value2": @"",
             @"timeRateArray":@[]
             };
}

// 获取充电结束状态下的数据
- (NSArray *)getSupendData{
    
    NSString *Electricity = [NSString stringWithFormat:@"%.3f kWh",[_energy floatValue]];// 电量
    NSString *Rate = [NSString stringWithFormat:@"%@",_rate];// 费率
    
    NSInteger chargeTime = [_ctime integerValue];
    NSString *hour = [NSString stringWithFormat:@"%ld",chargeTime/60];
    NSString *min = [NSString stringWithFormat:@"%ld",chargeTime%60];
    min = [NSString SupplementZero:min];
    NSString *Time = [NSString stringWithFormat:@"%@ h %@ min",hour, min];// 时长
    NSString *Cost = [NSString stringWithFormat:@"%.3f",[_cost floatValue]];// 花费
    
    NSArray *array = @[Electricity, Rate, Time, Cost];
    
    return array;
}

// 获取充电中的数据
- (NSDictionary *)getChargingData{
    
    
    NSString *Electricity = [NSString stringWithFormat:@"%.3f kWh",[_energy floatValue]];// 电量
    NSString *Rate = [NSString stringWithFormat:@"%@",_rate];// 费率
    NSString *Current = [NSString stringWithFormat:@"%.3f A",[_current floatValue]];// 电流
    
    NSInteger chargeTime = [_ctime integerValue];
    NSString *hour = [NSString stringWithFormat:@"%ld",chargeTime/60];
    NSString *min = [NSString stringWithFormat:@"%ld",chargeTime%60];
    min = [NSString SupplementZero:min];
    NSString *Time = [NSString stringWithFormat:@"%@ h %@ min",hour, min];// 时长
    NSString *Cost = [NSString stringWithFormat:@"%.3f",[_cost floatValue]];// 花费
    NSString *Voltage = [NSString stringWithFormat:@"%.1f V",[_voltage floatValue]];// 电压
    
    NSString *presetValue = [NSString stringWithFormat:@"%@",_cValue];// 预设值
    
    if([_cKey isEqualToString:@"G_SetAmount"]){// 金额
        
        CGFloat progress = [Cost floatValue] / [presetValue floatValue] * 1.0f;
        return @{@"progress":@(progress), @"value1": @[presetValue, Cost], @"value2": @[Electricity, Time], @"value3": @[Rate, Current, Voltage]};
        
    }else if([_cKey isEqualToString:@"G_SetEnergy"]){// 电量
        
        CGFloat progress = [Electricity floatValue] / [presetValue floatValue] * 1.0f;
        return @{@"progress":@(progress), @"value1": @[[NSString stringWithFormat:@"%@ kWh", presetValue], Electricity], @"value2": @[Cost, Time], @"value3": @[Rate,Current, Voltage]};
        
    }else if([_cKey isEqualToString:@"G_SetTime"]){// 时间
        
        NSInteger presetTime = [_cValue integerValue];
        NSString *hour2 = [NSString stringWithFormat:@"%ld",presetTime/60];
        NSString *min2 = [NSString stringWithFormat:@"%ld",presetTime%60];
        min2 = [NSString SupplementZero:min2];
        NSString *presetTime2 = [NSString stringWithFormat:@"%@ h %@ min",hour2, min2];// 时长
        CGFloat progress = [_ctime floatValue] / [_cValue floatValue] * 1.0f;
        
        return @{@"progress":@(progress), @"value1": @[presetTime2, Time], @"value2": @[Electricity, Cost], @"value3": @[Rate,Current, Voltage]};
        
    }
    
    return @{@"progress":@(0.99), @"value": @[Electricity, Rate, Current, Time, Cost, Voltage]};
}


@end
