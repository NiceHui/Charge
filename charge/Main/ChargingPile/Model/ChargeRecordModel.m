//
//  ChargeRecordModel.m
//  charge
//
//  Created by growatt007 on 2018/10/20.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "ChargeRecordModel.h"

@implementation ChargeRecordModel



- (NSString *)getConnectorIdName{
    
    if ([_connectorId integerValue] == 1) {
        return HEM_A_qiang;
    }else if([_connectorId integerValue] == 2){
        return HEM_B_qiang;
    }else if([_connectorId integerValue] == 3){
        return HEM_C_qiang;
    }
    return @"";
}

@end
