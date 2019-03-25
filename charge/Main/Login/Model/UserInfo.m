//
//  UserInfo.m
//  shinelink
//
//  Created by sky on 16/2/25.
//  Copyright © 2016年 sky. All rights reserved.
//


#import "UserInfo.h"

static UserInfo *userInfo = nil;
static int timerNumber=0;

@implementation UserInfo

+ (UserInfo *)defaultUserInfo {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[UserInfo alloc]init];
    });
    return userInfo;
}

- (instancetype)init {
    if (self = [super init]) {
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        if (![ud objectForKey:@"isAutoLogin"]) {
            [ud setBool:NO forKey:@"isAutoLogin"];
            _isAutoLogin = NO;
        } else {
            _isAutoLogin = [ud boolForKey:@"isAutoLogin"];
        }
        
        if (![ud objectForKey:@"userName"]) {
            [ud setObject:@"" forKey:@"userName"];
            _userName = @"";
        } else {
            _userName = [ud objectForKey:@"userName"];
        }
        
        if (![ud objectForKey:@"coreDataEnable"]) {
            [ud setObject:@"" forKey:@"coreDataEnable"];
            _coreDataEnable = @"";
        } else {
            _coreDataEnable = [ud objectForKey:@"coreDataEnable"];
        }
        
        
        if (![ud objectForKey:@"agentCode"]) {
            [ud setObject:@"" forKey:@"agentCode"];
            _agentCode = @"";
        } else {
            _agentCode = [ud objectForKey:@"agentCode"];
        }
      
        if (![ud objectForKey:@"firstPic"]) {
            [ud setObject:@"" forKey:@"firstPic"];
            _firstPic = @"";
        } else {
            _firstPic = [ud objectForKey:@"firstPic"];
        }
        
        
        if (![ud objectForKey:@"userPassword"]) {
            [ud setObject:@"" forKey:@"userPassword"];
            _userPassword = @"";
        } else {
            _userPassword = [ud objectForKey:@"userPassword"];
        }
        
        if (![ud objectForKey:@"userID"]) {
            [ud setObject:@"" forKey:@"userID"];
            _userID = @"";
        } else {
            _userID = [ud objectForKey:@"userID"];
        }
       
        
        if (![ud objectForKey:@"plantNum"]) {
            [ud setObject:@"" forKey:@"plantNum"];
            _plantNum= nil;
        } else {
            _plantNum =[ud objectForKey:@"plantNum"];
        }
        
        if (![ud objectForKey:@"plantID"]) {
            [ud setObject:@"" forKey:@"plantID"];
            _plantID= @"";
        } else {
            _plantID = [ud objectForKey:@"userID"];
        }
        
        if (![ud objectForKey:@"TelNumber"]) {
            [ud setObject:@"" forKey:@"TelNumber"];
            _TelNumber = @"";
        } else {
            _TelNumber= [ud objectForKey:@"TelNumber"];
        }
        
        if (![ud objectForKey:@"userPic"]) {
            [ud setObject:@"" forKey:@"userPic"];
            _TelNumber = @"";
        } else {
            _TelNumber= [ud objectForKey:@"userPic"];
        }
        
        if (![ud objectForKey:@"email"]) {
            [ud setObject:@"" forKey:@"email"];
            _email= @"";
        } else {
            _email= [ud objectForKey:@"email"];
        }
        
        if (![ud objectForKey:@"server"]) {
            [ud setObject:@"" forKey:@"server"];
            _server = @"";
        } else {
            _server = [ud objectForKey:@"server"];
        }
        
        if (![ud objectForKey:@"OSSserver"]) {
            [ud setObject:@"" forKey:@"OSSserver"];
            _OSSserver = @"";
        } else {
            _OSSserver = [ud objectForKey:@"OSSserver"];
        }
        
        [ud synchronize];
        
    }
    return self;
}

- (void)setIsAutoLogin:(BOOL)isAutoLogin {
    _isAutoLogin = isAutoLogin;
    
    [[NSUserDefaults standardUserDefaults] setBool:_isAutoLogin forKey:@"isAutoLogin"];
}

- (void)setCoreDataEnable:(NSString *)coreDataEnable{
    _coreDataEnable = coreDataEnable;
    
    [[NSUserDefaults standardUserDefaults] setObject:_coreDataEnable forKey:@"coreDataEnable"];
}


- (void)setAgentCode:(NSString *)agentCode {
    _agentCode = agentCode;
    
    [[NSUserDefaults standardUserDefaults] setObject:_agentCode forKey:@"agentCode"];
}

- (void)setFirstPic:(NSString *)firstPic{
    _firstPic = firstPic;
    
    [[NSUserDefaults standardUserDefaults] setObject:_firstPic forKey:@"firstPic"];
}

- (void)setUserPic:(NSData *)userPic{
    _userPic= userPic;
    
    [[NSUserDefaults standardUserDefaults] setObject:_userPic forKey:@"userPic"];
}

- (void)setUserPassword:(NSString *)userPassword {
    _userPassword = userPassword;
    
    [[NSUserDefaults standardUserDefaults] setObject:_userPassword forKey:@"userPassword"];
}

-(void)setPlantNum:(NSString *)plantNum{
    _plantNum=plantNum;
    [[NSUserDefaults standardUserDefaults] setObject:_plantNum forKey:@"plantNum"];
}

-(void)setPlantID:(NSString *)plantID{
    _plantID=plantID;
     [[NSUserDefaults standardUserDefaults] setObject:_plantID forKey:@"plantID"];
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    
    [[NSUserDefaults standardUserDefaults] setObject:_userName forKey:@"userName"];
}

-(void)setUserID:(NSString *)userID{
    _userID=userID;
      [[NSUserDefaults standardUserDefaults] setObject:_userID forKey:@"userID"];
}

-(void)setTelNumber:(NSString *)TelNumber{

    _TelNumber=TelNumber;
      [[NSUserDefaults standardUserDefaults] setObject:_TelNumber forKey:@"TelNumber"];
}

-(void)setEmail:(NSString *)email{
    
    _email=email;
    [[NSUserDefaults standardUserDefaults] setObject:_email forKey:@"email"];
}

- (void)setServer:(NSString *)server{
    _server = server;
    
    [[NSUserDefaults standardUserDefaults] setObject:_server forKey:@"server"];
}


- (void)setOssServer:(NSString *)server{
    _OSSserver = server;
    
    [[NSUserDefaults standardUserDefaults] setObject:_server forKey:@"OSSserver"];
}


#pragma mark - Tool Method

-(NSTimer *)R_timer{
    timerNumber=0;
    if (!_R_timer) {
        _R_timer=[NSTimer scheduledTimerWithTimeInterval:3540 target:self selector:@selector(stopDownload) userInfo:nil repeats:true];
    }
    return _R_timer;
}

-(void)stopDownload{
    if (timerNumber==1) {
        NSLog(@"test1111");
        self.R_timer.fireDate=[NSDate distantFuture];
        [[UserInfo defaultUserInfo] setIsAutoLogin:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KNOTIFICATION_LOGINCHANGE" object:nil];
    }
    timerNumber=timerNumber+1;
}

@end
