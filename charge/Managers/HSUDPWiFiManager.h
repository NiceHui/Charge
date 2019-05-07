//
//  HSUDPWiFiManager.h
//  charge
//
//  Created by growatt007 on 2019/3/28.
//  Copyright © 2019 hshao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HSUDPWiFiManagerDelegate <NSObject>

- (void)serverSocketDidReceiveMessage:(NSString *)message;

- (void)serverSocketError:(NSString *)error;

@end

@interface HSUDPWiFiManager : NSObject

+(instancetype)shareUDPManage;

@property (nonatomic, weak)id <HSUDPWiFiManagerDelegate>delegate;

//广播
-(void)broadcast:(NSString *)msg;


@end

NS_ASSUME_NONNULL_END
