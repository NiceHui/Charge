//
//  HSUDPWiFiManager.m
//  charge
//
//  Created by growatt007 on 2019/3/28.
//  Copyright © 2019 hshao. All rights reserved.
//

#import "HSUDPWiFiManager.h"
#import "GCDAsyncUdpSocket.h"
#import "HSWiFiManager.h"

#define udpPort 48899

@interface HSUDPWiFiManager () <GCDAsyncUdpSocketDelegate>

@property (strong, nonatomic)GCDAsyncUdpSocket * udpSocket;

@end

static HSUDPWiFiManager *myUDPManage = nil;

@implementation HSUDPWiFiManager


+(instancetype)shareUDPManage{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myUDPManage = [[HSUDPWiFiManager alloc]init];
        [myUDPManage createClientUdpSocket];
    });
    return myUDPManage;
}

-(void)createClientUdpSocket{
    //创建udp socket
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    //banding一个端口(可选),如果不绑定端口,那么就会随机产生一个随机的电脑唯一的端口
    NSError * error = nil;
    [self.udpSocket bindToPort:udpPort error:&error];
    
    //启用广播
    [self.udpSocket enableBroadcast:YES error:&error];
    
    if (error) {//监听错误打印错误信息
        NSLog(@"error:%@",error);
    }else {//监听成功则开始接收信息
        [self.udpSocket beginReceiving:&error];
        if ([self.delegate respondsToSelector:@selector(serverSocketError:)]) {
            [self.delegate serverSocketError:@"UDP创建失败"];
        }
    }
}

//广播
-(void)broadcast:(NSString *)msg{
    
    NSString *str = msg;
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    //此处如果写成固定的IP就是对特定的server监测
    NSString *host = @"255.255.255.255";
    //    NSString *host = @"192.168.0.255";
    
    NSError * error = nil;
    [self.udpSocket bindToPort:udpPort error:&error];
    //启用广播
    [self.udpSocket enableBroadcast:YES error:&error];
    
    //发送数据（tag: 消息标记）
    [self.udpSocket sendData:data toHost:host port:udpPort withTimeout:-1 tag:100];
    [self.udpSocket beginReceiving:&error];
}

#pragma mark GCDAsyncUdpSocketDelegate
//发送数据成功
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    if (tag == 100) {
        NSLog(@"标记为100的数据发送完成了");
    }
    NSLog(@"%s", __func__);
}

//发送数据失败
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"标记为%ld的数据发送失败，失败原因：%@",tag, error);
    if ([self.delegate respondsToSelector:@selector(serverSocketError:)]) {
        [self.delegate serverSocketError:@"发送广播失败"];
    }
    NSLog(@"%s", __func__);
}

//接收到数据
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"收到服务端的响应 [%@:%d] %@", ip, port, str);
    
    // 过滤掉自己发送广播
    if ([self isValidatIP:ip] && ![ip isEqualToString:[HSWiFiManager getIPAddress:YES]]) {
        if(![str isEqualToString:@"www.usr.cn"]){
            if ([self.delegate respondsToSelector:@selector(serverSocketDidReceiveMessage:)]) {
                [self.delegate serverSocketDidReceiveMessage:str];
                NSLog(@"充电桩： %@ %d %@", ip, port, str);
            }
        }
    }
    
    NSLog(@"%s", __func__);
}

// 判断ip地址格式是否正确
- (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}


@end
