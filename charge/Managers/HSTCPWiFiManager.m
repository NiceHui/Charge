//
//  HSTCPWiFiManager.m
//  charge
//
//  Created by growatt007 on 2019/3/29.
//  Copyright © 2019 hshao. All rights reserved.
//

#import "HSTCPWiFiManager.h"
#import "GCDAsyncSocket.h"
//#import "HSWiFiManager.h"
#import "HSBluetoochHelper.h"

#define udpPort 8888
@interface HSTCPWiFiManager ()<GCDAsyncSocketDelegate>{
    int tryNum;// 尝试次数
}

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) dispatch_queue_t socketQueue;     // 发数据的串行队列
@property (nonatomic, assign) BOOL isConnecting;
@property (nonatomic, assign) BOOL normalCancelled;      // 是否正常取消连接
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *devType;
@end

Byte loginMask2[4] = {0x5a, 0xa5, 0x5a, 0xa5}; // 登录掩码
Byte randomMask2[4] = {}; // 随机掩码

@implementation HSTCPWiFiManager

static HSTCPWiFiManager *instance = nil;

+ (HSTCPWiFiManager *)instance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HSTCPWiFiManager alloc]init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.isConnecting = false;
        [self resetSocket];
        randomMask2[0] = strtoul([[HSBluetoochHelper ToHex:arc4random() % 256] UTF8String], 0, 16);
        randomMask2[1] = strtoul([[HSBluetoochHelper ToHex:arc4random() % 256] UTF8String], 0, 16);
        randomMask2[2] = strtoul([[HSBluetoochHelper ToHex:arc4random() % 256] UTF8String], 0, 16);
        randomMask2[3] = strtoul([[HSBluetoochHelper ToHex:arc4random() % 256] UTF8String], 0, 16);
    }
    return self;
}

- (void)resetSocket {
    if ([self.socket isConnected]) {// 已连接
        [self disConnect];
    }
    if(![self.socket isDisconnected])//已连接
    {
        [self disConnect];
    }
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
    self.socket.IPv6Enabled = true;
    self.socket.IPv4Enabled = true;
    self.socket.IPv4PreferredOverIPv6 = false;     // 4 优先
    tryNum = 0;
}

- (dispatch_queue_t)socketQueue {
    if (_socketQueue == nil) {
        _socketQueue = dispatch_queue_create("com.charge.sendSocket", DISPATCH_QUEUE_SERIAL);
    }
    return _socketQueue;
}

// 发起连接
- (void)connectToHost:(NSString *)ip{
    
    if ([self.socket isConnected]) {// 已连接
        [self.socket disconnect];
    }
    if(![self.socket isDisconnected])//已连接
    {
        [self.socket disconnect];
    }
    
    NSLog(@"开始连接  ip: %@, Port: %d" ,ip, udpPort);
    
    self.devType = @"0x10";// 电桩类型
    
    self.ip = ip;
    
    [self abnormalCancelled];
    
    //开始连接
    NSError *error = nil;
    [self.socket connectToHost:ip onPort:udpPort error:&error];
    if(error) {
        NSLog(@"连接错误:%@", error);
        if ([self.delegate respondsToSelector:@selector(SocketConnectIsSucces:)]) {
            [self.delegate SocketConnectIsSucces:NO];
        }
    }
}

// 断开连接
- (void)disConnect {
    [self.socket disconnect];
    self.socket = nil;
    self.socketQueue = nil;
    tryNum = 0;
}


#pragma mark -socket的代理

#pragma mark 连接成功

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    //连接成功
    NSLog(@"%s 连接成功",__func__);
    if ([self.delegate respondsToSelector:@selector(SocketConnectIsSucces:)]) {
        [self.delegate SocketConnectIsSucces:YES];
    }
}

#pragma mark 断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if (err) {
        NSLog(@"连接失败");
    }else{
        NSLog(@"断开连接");
    }
    // 判读断开连接原因
    if ([self p_isShouldNotNormalCancelledWithError:err]) {
        self.normalCancelled = NO;
    }
    if ([self p_isShouldNormalCancelledWithError:err]) {
        self.normalCancelled = YES;
    }
    
    if (!self.normalCancelled) {
//        NSLog(@"socket 重连中...");
        tryNum ++;
        if (tryNum < 5) {
            [self connectToHost:self.ip];// 重连
        }
    } else {
        [self disConnection];// 关闭连接
    }
}

#pragma mark 数据发送成功
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"%s  数据发送成功",__func__);
    //发送完数据手动读取
    [sock readDataWithTimeout:-1 tag:tag];
}

#pragma mark 读取数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"读取数据 data: %@", data);
//    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self analysis:data];
    });
    
    // 数据手动读取
    [sock readDataWithTimeout:-1 tag:tag];
}

/**
 *  正常取消, IM Socket 不会重连。
 */
- (void)NormalCancelled {
    self.normalCancelled = YES;
}

/**
 *  非正常取消，IM Socket 会自动重连。
 */
- (void)abnormalCancelled {
    self.normalCancelled = NO;
}

/** 断开连接 */
- (void)disConnection {
    
    [self NormalCancelled];
    [self.socket disconnect];
}

/**
 *  只要是YES 就重新连接IM。
 */
- (BOOL)p_isShouldNotNormalCancelledWithError:(NSError *)error {
    return [self p_isPOSIXErrorDomainWithError:error]
    && ([self p_isResetConnectionWithCode:error.code]
        || [self p_isTimeoutConnectionWithCode:error.code]
        || [self p_isRefusedConnectionWithCode:error.code]);
}

/**
 *  目前没有网络的情况下就不需要重连了。
 *  比如主动断开网络。
 */
- (BOOL)p_isShouldNormalCancelledWithError:(NSError *)error {
    return [self p_isPOSIXErrorDomainWithError:error]
    && ([self p_isClosedConnectionWithCode:error.code] || [self p_isNetworkUnreachableWithCode:error.code]);
}

- (BOOL)p_isPOSIXErrorDomainWithError:(NSError *)error {
    return [error.domain isEqualToString:NSPOSIXErrorDomain];
}

- (BOOL)p_isResetConnectionWithCode:(UInt64)code {// 连接被重置
    return code == ECONNRESET;
}

- (BOOL)p_isTimeoutConnectionWithCode:(UInt64)code {// 超时
    return code == ETIMEDOUT;
}

- (BOOL)p_isRefusedConnectionWithCode:(UInt64)code {// 连接被拒
    return code == ECONNREFUSED;
}

- (BOOL)p_isClosedConnectionWithCode:(UInt64)code {// 没有连接
    return code == ENOTCONN;
}

- (BOOL)p_isNetworkUnreachableWithCode:(UInt64)code {// 网络不可用
    return code == ENETUNREACH;
}


#pragma mark -- 连接指令 1
- (void)connectToDev:(NSData *)devId_data{
    NSLog(@"连接指令 1");
    
    NSData *TimeData = [HSBluetoochHelper getCurrentTimeType:@"1"];// 时间 14
    Byte *TimeByte = (Byte *)[TimeData bytes];
    NSMutableData *bytesData = [[NSMutableData alloc]initWithBytes:TimeByte length:14];
    [bytesData appendData:devId_data];// 设备名称 20
    NSMutableData *randomData = [[NSMutableData alloc]initWithBytes:randomMask2 length:4];
    [bytesData appendData:randomData];// 加密ID 4
    
    Byte *Payload = (Byte *)[bytesData bytes];// 有效数据
    NSData *sendData = [HSBluetoochHelper wifiSendDataProtocol:self.devType Cmd:@"0xA0" DataLenght:38 Payload:Payload Mask:loginMask2
                                                       Useless:nil];
    [_socket writeData:sendData withTimeout:-1 tag:201];
}

#pragma mark -- 退出命令 2
- (void)disConnectToDev{
    NSLog(@"退出命令 2");
    NSData *TimeData = [HSBluetoochHelper getCurrentTimeType:@"1"];// 时间 14
    Byte *Payload = (Byte *)[TimeData bytes];
    NSData *sendData = [HSBluetoochHelper wifiSendDataProtocol:self.devType Cmd:@"0xA1" DataLenght:14 Payload:Payload Mask:randomMask2
                                                       Useless:nil];
    [_socket writeData:sendData withTimeout:-1 tag:201];
}

#pragma mark -- 获取设备信息参数 3
- (void)getDeviceInfo{
    NSLog(@"获取设备信息参数 3");
    Byte Payload[] = {0x01};
    NSData *sendData = [HSBluetoochHelper wifiSendDataProtocol:self.devType Cmd:@"0x01" DataLenght:1 Payload:Payload Mask:randomMask2
                                                       Useless:nil];
    [_socket writeData:sendData withTimeout:-1 tag:201];
}

#pragma mark -- 获取设备以太网参数 5
- (void)getDeviceNetWorkInfo{
    NSLog(@"获取设备以太网参数 5");
    Byte Payload[] = {0x01};
    NSData *sendData = [HSBluetoochHelper wifiSendDataProtocol:self.devType Cmd:@"0x02" DataLenght:1 Payload:Payload Mask:randomMask2
                                                       Useless:nil];
    [_socket writeData:sendData withTimeout:-1 tag:201];
}

#pragma mark -- 获取设备账号密码参数 7
- (void)getDevicePassInfo{
    NSLog(@"获取设备账号密码参数 7");
    Byte Payload[] = {0x01};
    NSData *sendData = [HSBluetoochHelper wifiSendDataProtocol:self.devType Cmd:@"0x03" DataLenght:1 Payload:Payload Mask:randomMask2
                                                       Useless:nil];
    [_socket writeData:sendData withTimeout:-1 tag:201];
}

#pragma mark -- 获取服务器参数 9
- (void)getDeviceServerInfo{
    NSLog(@"获取服务器参数 9");
    Byte Payload[] = {0x01};
    NSData *sendData = [HSBluetoochHelper wifiSendDataProtocol:self.devType Cmd:@"0x04" DataLenght:1 Payload:Payload Mask:randomMask2
                                                       Useless:nil];
    [_socket writeData:sendData withTimeout:-1 tag:201];
}

#pragma mark -- 获取设备充电参数 11
- (void)getDeviceChargeInfo{
    NSLog(@"获取设备充电参数 11");
    Byte Payload[] = {0x01};
    NSData *sendData = [HSBluetoochHelper wifiSendDataProtocol:self.devType Cmd:@"0x05" DataLenght:1 Payload:Payload Mask:randomMask2
                                                       Useless:nil];
    [_socket writeData:sendData withTimeout:-1 tag:201];
}

#pragma mark -- 设置设备基本信息参数 4
- (void)setDeviceBaseInfo:(NSDictionary *)dicInfo{
    NSLog(@"设置设备基本信息参数 4");
    
    NSMutableData *name_data = [[NSMutableData alloc] initWithData:[HSBluetoochHelper dataWithString:dicInfo[@"name"] length:20]];// 充电桩name
    NSData *lan_data = [HSBluetoochHelper dataWithString:dicInfo[@"lan"] length:1];// 语言
    NSData *secret_data = [HSBluetoochHelper dataWithString:dicInfo[@"secret"] length:6];// 读卡器秘钥
    NSData *rcd_data = [HSBluetoochHelper dataWithString:dicInfo[@"rcd"] length:1];// RCD保护值 mA
    
    if ([name_data isEqualToData:[NSData data]] || [lan_data isEqualToData:[NSData data]] || [secret_data isEqualToData:[NSData data]] || [rcd_data isEqualToData:[NSData data]]) {
        if ([self.delegate respondsToSelector:@selector(TCPSocketActionSuccess:data:)]) {
            [self.delegate TCPSocketActionSuccess:NO data:@{@"cmd": @(1000), @"cmd2": @(17)}];
        }
        return;
    }
    
    [name_data appendData:lan_data];
    [name_data appendData:secret_data];
    [name_data appendData:rcd_data];
    
    Byte *Payload = (Byte *)[name_data bytes];
    NSData *sendData = [HSBluetoochHelper wifiSendDataProtocol:self.devType Cmd:@"0x11" DataLenght:28 Payload:Payload Mask:randomMask2
                                                       Useless:nil];
    [_socket writeData:sendData withTimeout:-1 tag:201];
}

#pragma mark -- 设置设备以太网参数 6
- (void)setDeviceNetWorkInfo:(NSDictionary *)dicInfo{
    NSLog(@"设置设备以太网参数 6");
    
    NSMutableData *ip_data = [[NSMutableData alloc] initWithData:[HSBluetoochHelper dataWithString:dicInfo[@"IP"] length:15]];// 充电桩IP
    NSData *gateway_data = [HSBluetoochHelper dataWithString:dicInfo[@"gateway"] length:15];// 网关
    NSData *mask_data = [HSBluetoochHelper dataWithString:dicInfo[@"mask"] length:15];// 掩码
    NSData *mac_data = [HSBluetoochHelper dataWithString:dicInfo[@"mac"] length:17];// MAC
    NSData *dns_data = [HSBluetoochHelper dataWithString:dicInfo[@"dns"] length:15];// DNS
    
    if ([ip_data isEqualToData:[NSData data]] || [gateway_data isEqualToData:[NSData data]] || [mask_data isEqualToData:[NSData data]] || [mac_data isEqualToData:[NSData data]] || [dns_data isEqualToData:[NSData data]]) {
        if ([self.delegate respondsToSelector:@selector(TCPSocketActionSuccess:data:)]) {
            [self.delegate TCPSocketActionSuccess:NO data:@{@"cmd": @(1000), @"cmd2": @(18)}];
        }
        return;
    }
    
    [ip_data appendData:gateway_data];
    [ip_data appendData:mask_data];
    [ip_data appendData:mac_data];
    [ip_data appendData:dns_data];
    
    Byte *Payload = (Byte *)[ip_data bytes];
    NSData *sendData = [HSBluetoochHelper wifiSendDataProtocol:self.devType Cmd:@"0x12" DataLenght:77 Payload:Payload Mask:randomMask2
                                                       Useless:nil];
    [_socket writeData:sendData withTimeout:-1 tag:201];
}

#pragma mark -- 设置设备账号密码参数 8
- (void)setDevicePassInfo:(NSDictionary *)dicInfo{
    NSLog(@"设置设备账号密码参数 8");
    
    NSMutableData *wifi_ssid_data = [[NSMutableData alloc] initWithData:[HSBluetoochHelper dataWithString:dicInfo[@"wifi_ssid"] length:16]];// 充电桩wifi_ssid
    NSData *wifi_key_data = [HSBluetoochHelper dataWithString:dicInfo[@"wifi_key"] length:16];// wifi_key: wifi密码
    NSData *buletouch_ssid_data = [HSBluetoochHelper dataWithString:dicInfo[@"buletouch_ssid"] length:16];// 蓝牙名称
    NSData *buletouch_key_data = [HSBluetoochHelper dataWithString:dicInfo[@"buletouch_key"] length:16];// 蓝牙密码
    NSData *fourG_ssid_data = [HSBluetoochHelper dataWithString:dicInfo[@"fourG_ssid"] length:16];// 4G用户名
    NSData *fourG_key_data = [HSBluetoochHelper dataWithString:dicInfo[@"fourG_key"] length:16];// 4G密码
    NSData *fourG_apn_data = [HSBluetoochHelper dataWithString:dicInfo[@"fourG_apn"] length:16];// 4G APN
    
    if ([wifi_ssid_data isEqualToData:[NSData data]] || [wifi_key_data isEqualToData:[NSData data]] || [buletouch_ssid_data isEqualToData:[NSData data]] || [buletouch_key_data isEqualToData:[NSData data]] || [fourG_ssid_data isEqualToData:[NSData data]] || [fourG_key_data isEqualToData:[NSData data]] || [fourG_apn_data isEqualToData:[NSData data]]) {
        if ([self.delegate respondsToSelector:@selector(TCPSocketActionSuccess:data:)]) {
            [self.delegate TCPSocketActionSuccess:NO data:@{@"cmd": @(1000), @"cmd2": @(19)}];
        }
        return;
    }
    
    [wifi_ssid_data appendData:wifi_key_data];
    [wifi_ssid_data appendData:buletouch_ssid_data];
    [wifi_ssid_data appendData:buletouch_key_data];
    [wifi_ssid_data appendData:fourG_ssid_data];
    [wifi_ssid_data appendData:fourG_key_data];
    [wifi_ssid_data appendData:fourG_apn_data];
    
    Byte *Payload = (Byte *)[wifi_ssid_data bytes];
    NSData *sendData = [HSBluetoochHelper wifiSendDataProtocol:self.devType Cmd:@"0x13" DataLenght:112 Payload:Payload Mask:randomMask2
                                                       Useless:nil];
    [_socket writeData:sendData withTimeout:-1 tag:201];
}

#pragma mark -- 设置服务器参数 10
- (void)setDeviceServerInfo:(NSDictionary *)dicInfo{
    NSLog(@"设置服务器参数 10");
    
    NSMutableData *url_data = [[NSMutableData alloc] initWithData:[HSBluetoochHelper dataWithString:dicInfo[@"url"] length:70]];// 充电桩url
    NSData *login_key_data = [HSBluetoochHelper dataWithString:dicInfo[@"login_key"] length:20];// 握手登录授权秘钥
    NSData *heartbeat_time_data = [HSBluetoochHelper dataWithString:dicInfo[@"heartbeat_time"] length:4];// 心跳间隔时间   单位秒
    NSData *ping_time_data = [HSBluetoochHelper dataWithString:dicInfo[@"ping_time"] length:4];// PING间隔时间   单位秒
    NSData *upload_time_data = [HSBluetoochHelper dataWithString:dicInfo[@"upload_time"] length:4];// 表计上传间隔时间    单位秒
    
    if ([url_data isEqualToData:[NSData data]] || [login_key_data isEqualToData:[NSData data]] || [heartbeat_time_data isEqualToData:[NSData data]] || [ping_time_data isEqualToData:[NSData data]] || [upload_time_data isEqualToData:[NSData data]]) {
        if ([self.delegate respondsToSelector:@selector(TCPSocketActionSuccess:data:)]) {
            [self.delegate TCPSocketActionSuccess:NO data:@{@"cmd": @(1000), @"cmd2": @(20)}];
        }
        return;
    }
    
    [url_data appendData:login_key_data];
    [url_data appendData:heartbeat_time_data];
    [url_data appendData:ping_time_data];
    [url_data appendData:upload_time_data];
    
    Byte *Payload = (Byte *)[url_data bytes];
    NSData *sendData = [HSBluetoochHelper wifiSendDataProtocol:self.devType Cmd:@"0x14" DataLenght:102 Payload:Payload Mask:randomMask2
                                                       Useless:nil];
    [_socket writeData:sendData withTimeout:-1 tag:201];
}

#pragma mark -- 设置充电参数 12
- (void)setDeviceChargeInfo:(NSDictionary *)dicInfo{
    NSLog(@"设置充电参数 12");
    
    NSMutableData *mode_data = [[NSMutableData alloc] initWithData:[HSBluetoochHelper dataWithString:dicInfo[@"mode"] length:1]];// 充电模式
    NSData *max_current_data = [HSBluetoochHelper dataWithString:dicInfo[@"max_current"] length:2];// 电桩最大输出电流，A
    NSData *rate_data = [HSBluetoochHelper dataWithString:dicInfo[@"rate"] length:5];// 充电费率，10.5（0~5000）
    NSData *protection_temp_data = [HSBluetoochHelper dataWithString:dicInfo[@"protection_temp"] length:3];// 保护温度，℃
    NSData *max_input_power_data = [HSBluetoochHelper dataWithString:dicInfo[@"max_input_power"] length:2];// 外部监测最大输入功率，KW
    NSData *allow_time_data = [HSBluetoochHelper dataWithString:dicInfo[@"allow_time"] length:11];// 允许充电时间“22:00-03:30”
    
    if ([mode_data isEqualToData:[NSData data]] || [max_current_data isEqualToData:[NSData data]] || [rate_data isEqualToData:[NSData data]] || [protection_temp_data isEqualToData:[NSData data]] || [max_input_power_data isEqualToData:[NSData data]] || [allow_time_data isEqualToData:[NSData data]]) {
        if ([self.delegate respondsToSelector:@selector(TCPSocketActionSuccess:data:)]) {
            [self.delegate TCPSocketActionSuccess:NO data:@{@"cmd": @(1000), @"cmd2": @(21)}];
        }
        return;
    }
    
    [mode_data appendData:max_current_data];
    [mode_data appendData:rate_data];
    [mode_data appendData:protection_temp_data];
    [mode_data appendData:max_input_power_data];
    [mode_data appendData:allow_time_data];

    Byte *Payload = (Byte *)[mode_data bytes];
    NSData *sendData = [HSBluetoochHelper wifiSendDataProtocol:self.devType Cmd:@"0x15" DataLenght:24 Payload:Payload Mask:randomMask2
                                                       Useless:nil];
    [_socket writeData:sendData withTimeout:-1 tag:201];
}

#pragma mark -- 收到的socket数据进行解析
- (void)analysis:(NSData *)NotifiData{
    
    if (!NotifiData || NotifiData == nil || NotifiData == NULL) return;
    
    NSData *headData = [self safe_subData:NotifiData withRange:NSMakeRange(0, 2)];// 判断指令头
    if (headData == nil) return;
    int head1 = ((Byte *)[headData bytes])[0];
    int head2 = ((Byte *)[headData bytes])[1];
    if (head1 != 0x5a || head2 != 0x5a) {
        return;
    }

    NSData *footData = [self safe_subData:NotifiData withRange:NSMakeRange(NotifiData.length-1, 1)];// 判读结束位
    if (footData == nil) return;
    int foot = ((Byte *)[footData bytes])[0];
    if (foot != 0x88) {
        return;
    }
    
    NSData *sumData = [self safe_subData:NotifiData withRange:NSMakeRange(NotifiData.length - 2, 1)];
    if (sumData == nil) return;
    int sum = ((Byte *)[sumData bytes])[0]; // 传进来的校验值
    NSData *sumData2 = [self safe_subData:NotifiData withRange:NSMakeRange(0, NotifiData.length - 2)];
    if (sumData2 == nil) return;
    Byte *bytes = (Byte *)[sumData2 bytes];
    long int sum2 = [HSBluetoochHelper checkSumWithData:bytes length:(int)sumData2.length];// 计算出来的校验值
    if (sum != sum2) return; // 判断校验值是否一致
    
    NSData *CmdData = [self safe_subData:NotifiData withRange:NSMakeRange(4, 1)];// 消息类型
    if (CmdData == nil) return;
    int cmd = ((Byte *)[CmdData bytes])[0];
    
    if (cmd == 0xA0) {
        NSData *typeData = [self safe_subData:NotifiData withRange:NSMakeRange(2, 1)];
        if (typeData == nil) return;
        self.devType = [self getDevType:((Byte *)[typeData bytes])[0]];
    }
    
    NSData *LengthData = [self safe_subData:NotifiData withRange:NSMakeRange(5, 1)];// 截取有效数据长度
    if (LengthData == nil) return;
    int Length = ((Byte *)[LengthData bytes])[0];
    
    NSData *PayloadData = [self safe_subData:NotifiData withRange:NSMakeRange(6, Length)];// 截取有效数据
    if (PayloadData == nil) return;
    
    NSData *analysisData;// 解密有效数据
    if (cmd == 0xA0)// 是否为连接包
    {
        analysisData= [HSBluetoochHelper MaskEncryption:(Byte *)[PayloadData bytes] length:Length Mask:loginMask2];
    } else {
        analysisData= [HSBluetoochHelper MaskEncryption:(Byte *)[PayloadData bytes] length:Length Mask:randomMask2];
    }
    
    [self RestoreData:analysisData andCmd:cmd];
}

// data-有效数据
- (void)RestoreData:(NSData *)data andCmd:(int)cmd{
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
    [dataDict setObject:@(cmd) forKey:@"cmd"];
    BOOL isSuccess = NO;
    if (cmd == 0xA0) {// 连接指令 1
        int status = ((Byte *)[data bytes])[0];
        if (status == 1) {
            NSLog(@"连接进入成功");
        } else{
            NSLog(@"连接进入失败");
        }
    } else if(cmd == 0xA1) { // 退出命令 2
        int status = ((Byte *)[data bytes])[0];
        if (status == 1) {
            NSLog(@"退出成功");
        } else{
            NSLog(@"退出失败");
        }
        [self disConnection];// 断开socket连接
        
    } else if (cmd == 0x01){// 获取设备信息参数 3
        
        NSString *name = [self getNSStringWithData:data Range:NSMakeRange(0, 20)];// 充电桩name
        NSString *lan = [self getNSStringWithData:data Range:NSMakeRange(20, 1)];// 语言
        NSString *secret = [self getNSStringWithData:data Range:NSMakeRange(21, 6)];// 读卡器秘钥
        NSString *rcd = [self getNSStringWithData:data Range:NSMakeRange(27, 1)];// RCD保护值 mA
        
        NSLog(@"充电桩 name: %@, lan: %@, secret: %@, rcd: %@", name, lan, secret, rcd);
        [dataDict setObject:[NSString stringWithFormat:@"%@", name] forKey:@"name"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", lan] forKey:@"lan"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", secret] forKey:@"secret"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", rcd] forKey:@"rcd"];
        
    } else if(cmd == 0x02){ // 获取设备以太网参数 5
        
        NSString *IP = [self getNSStringWithData:data Range:NSMakeRange(0, 15)];// 充电桩IP
        NSString *gateway = [self getNSStringWithData:data Range:NSMakeRange(15, 15)];// 网关
        NSString *mask = [self getNSStringWithData:data Range:NSMakeRange(30, 15)];// 掩码
        NSString *mac = [self getNSStringWithData:data Range:NSMakeRange(45, 17)];// MAC
        NSString *dns = [self getNSStringWithData:data Range:NSMakeRange(62, 15)];// DNS
        
        [dataDict setObject:[NSString stringWithFormat:@"%@", IP] forKey:@"IP"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", gateway] forKey:@"gateway"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", mask] forKey:@"mask"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", mac] forKey:@"mac"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", dns] forKey:@"dns"];
        
        NSLog(@"充电桩IP:%@  ,gataway:%@,  mask:%@,  mac:%@,  dns:%@",IP, gateway, mask, mac, dns);
        
    } else if (cmd == 0x03){// 获取设备以太网参数 7
        
        NSString *wifi_ssid = [self getNSStringWithData:data Range:NSMakeRange(0, 16)];// 充电桩联网 wifi名称
        NSString *wifi_key = [self getNSStringWithData:data Range:NSMakeRange(16, 16)];// 充电桩联网 wifi密码
        NSString *buletouch_ssid = [self getNSStringWithData:data Range:NSMakeRange(32, 16)];// 蓝牙名称
        NSString *buletouch_key = [self getNSStringWithData:data Range:NSMakeRange(48, 16)];// 蓝牙密码
        NSString *fourG_ssid = [self getNSStringWithData:data Range:NSMakeRange(64, 16)];// 4G用户名
        NSString *fourG_key = [self getNSStringWithData:data Range:NSMakeRange(80, 16)];// 4G密码
        NSString *fourG_apn = [self getNSStringWithData:data Range:NSMakeRange(96, 16)];// 4G APN
        
        [dataDict setObject:[NSString stringWithFormat:@"%@", wifi_ssid] forKey:@"wifi_ssid"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", wifi_key] forKey:@"wifi_key"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", buletouch_ssid] forKey:@"buletouch_ssid"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", buletouch_key] forKey:@"buletouch_key"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", fourG_ssid] forKey:@"fourG_ssid"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", fourG_key] forKey:@"fourG_key"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", fourG_apn] forKey:@"fourG_apn"];
        
        NSLog(@"充电桩联网 wifi名称: %@, wifi密码: %@, buletouch_ssid:%@, buletouch_key:%@, fourG_ssid:%@, fourG_key:%@, fourG_apn:%@", wifi_ssid, wifi_key, buletouch_ssid, buletouch_key, fourG_ssid, fourG_key, fourG_apn);
        
    } else if (cmd == 0x04){// 获取服务器参数 9
        
        NSString *url = [self getNSStringWithData:data Range:NSMakeRange(0, 70)];// 充电桩连接服务器的 url
        NSString *login_key = [self getNSStringWithData:data Range:NSMakeRange(70, 20)];// 握手登录授权秘钥
        NSString *heartbeat_time = [self getNSStringWithData:data Range:NSMakeRange(90, 4)];// 心跳间隔时间   单位秒
        NSString *ping_time = [self getNSStringWithData:data Range:NSMakeRange(94, 4)];// PING间隔时间   单位秒
        NSString *upload_time = [self getNSStringWithData:data Range:NSMakeRange(98, 4)];// 表计上传间隔时间    单位秒
        
        [dataDict setObject:[NSString stringWithFormat:@"%@", url] forKey:@"url"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", login_key] forKey:@"login_key"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", heartbeat_time] forKey:@"heartbeat_time"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", ping_time] forKey:@"ping_time"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", upload_time] forKey:@"upload_time"];
        NSLog(@"充电桩连接服务器的 url: %@, login_key: %@, heartbeat_time: %@, ping_time: %@, upload_time: %@", url, login_key, heartbeat_time, ping_time, upload_time);
    } else if (cmd == 0x05){// 获取设备充电参数 11
        
        NSString *mode = [self getNSStringWithData:data Range:NSMakeRange(0, 1)];// 充电模式
        NSString *max_current = [self getNSStringWithData:data Range:NSMakeRange(1, 2)];// 电桩最大输出电流，A
        NSString *rate = [self getNSStringWithData:data Range:NSMakeRange(3, 5)];// 充电费率，10.5（0~5000）
        NSString *protection_temp = [self getNSStringWithData:data Range:NSMakeRange(8, 3)];// 保护温度，℃
        NSString *max_input_power = [self getNSStringWithData:data Range:NSMakeRange(11, 2)];// 外部监测最大输入功率，KW
        NSString *allow_time = [self getNSStringWithData:data Range:NSMakeRange(13, 11)];// 允许充电时间“22:00-03:30”
        
        [dataDict setObject:[NSString stringWithFormat:@"%@", mode] forKey:@"mode"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", max_current] forKey:@"max_current"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", rate] forKey:@"rate"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", protection_temp] forKey:@"protection_temp"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", max_input_power] forKey:@"max_input_power"];
        [dataDict setObject:[NSString stringWithFormat:@"%@", allow_time] forKey:@"allow_time"];
        NSLog(@"充电桩 mode: %@, max_current: %@, rate: %@, protection_temp: %@, max_input_power: %@,  allow_time: %@", mode, max_current, rate, protection_temp, max_input_power, allow_time);
    }
    
    if(cmd == 0x01 || cmd == 0x02 || cmd == 0x03 || cmd == 0x04 || cmd == 0x05){ // 获取设置信息命令
        if ([self.delegate respondsToSelector:@selector(TCPSocketReadData:)]) {
            [self.delegate TCPSocketReadData:dataDict];
        }
    }
    
    if (cmd == 0xA0 || cmd == 0xA1 || cmd == 0x11 || cmd == 0x12 || cmd == 0x13 || cmd == 0x14 || cmd == 0x15) { // 连接， 退出
        int status = ((Byte *)[data bytes])[0];
        if (status == 1) {
            isSuccess = YES;
        } else{
            isSuccess = NO;
        }
        if ([self.delegate respondsToSelector:@selector(TCPSocketActionSuccess:data:)]) {
            [self.delegate TCPSocketActionSuccess:isSuccess data:dataDict];
        }
    }
    
}

// 截取data 装换成 NSString
- (NSString *)getNSStringWithData:(NSData *)data Range:(NSRange)range{
    NSData *strData = [self dataDeleteString:[self safe_subData:data withRange:range]];
    NSString *string = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    return string;
}

- (NSNumber *)getNSNumberWithData:(NSData *)data Range:(NSRange)range{
    NSData *strData = [self dataDeleteString:[self safe_subData:data withRange:range]];
    int num = ((Byte *)[strData bytes])[0];
    return @(num);
}


// 获取电桩类型
- (NSString *)getDevType:(int)type{
    if (type == 0x10) {
        return @"0x10";
    } else if (type == 0x20){
        return @"0x20";
    } else if (type == 0x30){
        return @"0x30";
    } else if (type == 0x40){
        return @"0x40";
    } else if (type == 0x50){
        return @"0x50";
    } else if (type == 0x60){
        return @"0x60";
    }
    return @"0x10";
}

// 把多余的00去掉
-(NSData *)dataDeleteString:(NSData *)data
{
    NSMutableData *newData = [[NSMutableData alloc]initWithData:data];
    NSData *charData = [self safe_subData:newData withRange:NSMakeRange(newData.length-1, 1)];
    while ([charData isEqualToData:[NSData dataWithBytes:[@"" UTF8String] length:1]]) { // 判断截取位是否为00,是就继续截取下去
        if (newData.length == 0 || newData == nil) { // newData.length == 1
            break; // data已经全部截取，跳出循环
            return [NSData data]; //[NSData dataWithBytes:[@"" UTF8String] length:1];
        }
        newData = [[NSMutableData alloc]initWithData:[self safe_subData:newData withRange:NSMakeRange(0, newData.length-1)]];//减一位
        charData = [self safe_subData:newData withRange:NSMakeRange(newData.length-1, 1)]; //从尾部开始截取,用作判断
    }
    
    return newData;
}

// 判读截取长度是否超出范围
- (NSData *)safe_subData:(NSData *)data withRange:(NSRange)range{
    if (data.length != 0 && data.length >= (range.location+range.length)) {
        return [data subdataWithRange:range];
    } else {
        NSLog(@"超出data截取长度");
    }
    
    return nil; //[NSData data];//[NSData dataWithBytes:[@"" UTF8String] length:1];
}

@end
