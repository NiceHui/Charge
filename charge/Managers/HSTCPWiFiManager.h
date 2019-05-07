//
//  HSTCPWiFiManager.h
//  charge
//
//  Created by growatt007 on 2019/3/29.
//  Copyright © 2019 hshao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HSTCPWiFiManagerDelegate <NSObject>

@optional

- (void)SocketConnectIsSucces:(BOOL)isSucces;

- (void)TCPSocketReadData:(NSDictionary *)dataDic;// 获取设置

- (void)TCPSocketActionSuccess:(BOOL)isSuccess data:(NSDictionary *)dataDic;// 是否操作成功

@end

@interface HSTCPWiFiManager : NSObject

@property (nonatomic, weak) id <HSTCPWiFiManagerDelegate> delegate;
/**
 单例
 
 @return instance
 */
+ (HSTCPWiFiManager *)instance;

/**
 开始连接

 @param ip 连接的ip
 */
- (void)connectToHost:(NSString *)ip;

/** 断开连接 */
- (void)disConnection;


#pragma mark -- 连接指令
- (void)connectToDev:(NSData *)devId_data;

#pragma mark -- 退出命令 2
- (void)disConnectToDev;

#pragma mark -- 获取设备信息参数 3
- (void)getDeviceInfo;

#pragma mark -- 获取设备以太网参数 5
- (void)getDeviceNetWorkInfo;

#pragma mark -- 获取设备账号密码参数 7
- (void)getDevicePassInfo;

#pragma mark -- 获取服务器参数 9
- (void)getDeviceServerInfo;

#pragma mark -- 获取充电参数 11
- (void)getDeviceChargeInfo;

#pragma mark -- 设置设备基本信息参数 4
- (void)setDeviceBaseInfo:(NSDictionary *)dicInfo;

#pragma mark -- 设置设备以太网参数 6
- (void)setDeviceNetWorkInfo:(NSDictionary *)dicInfo;

#pragma mark -- 设置设备账号密码参数 8
- (void)setDevicePassInfo:(NSDictionary *)dicInfo;

#pragma mark -- 设置服务器参数 10
- (void)setDeviceServerInfo:(NSDictionary *)dicInfo;

#pragma mark -- 设置充电参数 12
- (void)setDeviceChargeInfo:(NSDictionary *)dicInfo;

@end

NS_ASSUME_NONNULL_END
