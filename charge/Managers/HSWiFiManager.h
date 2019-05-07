//
//  HSWiFiManager.h
//  charge
//
//  Created by growatt007 on 2019/3/26.
//  Copyright © 2019 hshao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSWiFiManager : NSObject

#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;// 是否首选IPV4

/**
 判断热点是否开启
 */
+ (BOOL)flagWithOpenHotSpot;

@end

NS_ASSUME_NONNULL_END
