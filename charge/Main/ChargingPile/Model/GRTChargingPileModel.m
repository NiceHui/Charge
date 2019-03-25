//
//  GRTChargingPileModel.m
//  ShinePhone
//
//  Created by growatt007 on 2018/7/13.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "GRTChargingPileModel.h"

@implementation GRTChargingPileModel



- (NSString *)getmodel{
    
    if ([_model isEqualToString:@"ACChargingPoint"]) {
        return HEM_jiaoliu;
    }else{
        return HEM_zhiliu;
    }
    
    return HEM_wu;
}

- (NSString *)getConnectors{
    
    if ([_connectors integerValue] == 1) {
        return HEM_danqiang;
    }else if([_connectors integerValue] == 2){
        return HEM_shuangqiang;
    }
    return HEM_wu;
}

- (NSArray *)getConnectorsNameArray{
    
    if ([_connectors integerValue] == 1) {
        return @[HEM_A_qiang];
    }else if([_connectors integerValue] == 2){
        return @[HEM_A_qiang, HEM_B_qiang];
    }
    return @[];
}


@end
