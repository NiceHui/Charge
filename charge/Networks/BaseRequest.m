//
//  BaseRequest.m
//  shinelink
//
//  Created by sky on 16/2/26.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "BaseRequest.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "sys/utsname.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CommonCrypto/CommonDigest.h>

#define  isShowUrl  @"NO"

float Time=25.f;
@implementation BaseRequest
+ (void)requestWithMethod:(NSString *)method paramars:(NSDictionary *)paramars paramarsSite:(NSString *)site sucessBlock:(successBlock)successBlock failure:(void (^)(NSError *))failure {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval=Time;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/html", nil];
    //text/html是以html的形式输出，比如<input type="text"/>就会在页面上显示一个文本框，而以plain形式就会在页面上原样显示这段代码
    NSString *url = [NSString stringWithFormat:@"%@%@",method,site];
    NSLog(@"%@", url);
    [UserInfo defaultUserInfo].R_timer.fireDate=[NSDate distantPast];
    [manager POST:url parameters:paramars success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([isShowUrl isEqualToString:@"YES"]) {
            [self showAlertViewWithTitle:url message:nil cancelButtonTitle:@"确定"];
        }
        
        successBlock(responseObject[@"back"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        failure(error);
        
        NSString *lostLogin=[[NSUserDefaults standardUserDefaults] objectForKey:@"lostLogin"];
        if ([lostLogin isEqualToString:@"Y"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:@"lostLogin"];
        }else{
            [self netRequest];
        }
    }];
}


+ (void)requestWithMethodResponseStringResult:(NSString *)method paramars:(NSDictionary *)paramars paramarsSite:(NSString *)site sucessBlock:(successBlock)successBlock failure:(void (^)(NSError *))failure {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=Time;
    
    //特殊时间处理
    if ([site isEqualToString:@"/api/v2/login"]) {
        manager.requestSerializer.timeoutInterval=10.f;
    }
    if ([site isEqualToString:@"/QXnewLoginAPI.do?op=getUrlByuidAndType"]) {
        manager.requestSerializer.timeoutInterval=6.f;
    }
    if ([site isEqualToString:@"/newPlantAPI.do?op=getAllPlantList"]) {
        manager.requestSerializer.timeoutInterval=45.f;
    }
   
    
    NSString *url = [NSString stringWithFormat:@"%@%@",method,site];
    NSLog(@"%@", url);
    [UserInfo defaultUserInfo].R_timer.fireDate=[NSDate distantPast];
    
    [manager POST:url parameters:paramars success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([isShowUrl isEqualToString:@"YES"]) {
            [self showAlertViewWithTitle:url message:nil cancelButtonTitle:@"确定"];
        }
        if ([method isEqualToString:OSS_HEAD_URL]) {
              id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *allDic=[NSDictionary dictionaryWithDictionary:jsonObj];
                if ([allDic.allKeys containsObject:@"result"]) {
                    if ([allDic[@"result"] intValue]==22) {                  //22
                        
                        NSString *lostLogin=[[NSUserDefaults standardUserDefaults] objectForKey:@"loginOssEnable"];
                        if ([lostLogin isEqualToString:@"Y"]) {
                            [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:@"loginOssEnable"];
                        }else{
                          [self netRequestOss];
                        }
                    }
                }
                
            }
        }

        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        failure(error);
        if ([method isEqualToString:HEAD_URL]) {
            NSString *lostLogin=[[NSUserDefaults standardUserDefaults] objectForKey:@"lostLogin"];
            if ([lostLogin isEqualToString:@"Y"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:@"lostLogin"];
            }else{
                [self netRequest];
            }
        }

    }];
}



+ (void)requestWithJsonAndMethodResponseStringResult:(NSString *)method paramars:(NSDictionary *)paramars paramarsSite:(NSString *)site sucessBlock:(successBlock)successBlock failure:(void (^)(NSError *))failure {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
      manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval=Time;
  
    
    NSString *url = [NSString stringWithFormat:@"%@%@",method,site];
    NSLog(@"%@", url);
    [UserInfo defaultUserInfo].R_timer.fireDate=[NSDate distantPast];
    
    [manager POST:url parameters:paramars success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([isShowUrl isEqualToString:@"YES"]) {
            [self showAlertViewWithTitle:url message:nil cancelButtonTitle:@"确定"];
        }
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        failure(error);
    
        
    }];
}



+ (void)requestWithMethodByGet:(NSString *)method paramars:(NSDictionary *)paramars paramarsSite:(NSString *)site sucessBlock:(successBlock)successBlock failure:(void (^)(NSError *))failure {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
     manager.requestSerializer.timeoutInterval=Time;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/html",@"text/javascript",  nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",method,site];
    NSLog(@"%@", url);
    [UserInfo defaultUserInfo].R_timer.fireDate=[NSDate distantPast];
    [manager GET:url parameters:paramars success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([isShowUrl isEqualToString:@"YES"]) {
            [self showAlertViewWithTitle:url message:nil cancelButtonTitle:@"确定"];
        }
        
        successBlock(responseObject[@"back"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        failure(error);
        
        NSString *lostLogin=[[NSUserDefaults standardUserDefaults] objectForKey:@"lostLogin"];
        if ([lostLogin isEqualToString:@"Y"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:@"lostLogin"];
        }else{
            [self netRequest];
        }
    }];
}

+ (void)requestWithMethodResponseJsonByGet:(NSString *)method paramars:(NSDictionary *)paramars paramarsSite:(NSString *)site sucessBlock:(successBlock)successBlock failure:(void (^)(NSError *))failure {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=Time;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/html",@"text/javascript", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",method,site];
    NSLog(@"%@", url);
    
    [UserInfo defaultUserInfo].R_timer.fireDate=[NSDate distantPast];
    
    [manager GET:url parameters:paramars success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([isShowUrl isEqualToString:@"YES"]) {
            [self showAlertViewWithTitle:url message:nil cancelButtonTitle:@"确定"];
        }
        
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        failure(error);
        
        NSString *lostLogin=[[NSUserDefaults standardUserDefaults] objectForKey:@"lostLogin"];
        if ([lostLogin isEqualToString:@"Y"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:@"lostLogin"];
        }else{
            [self netRequest];
        }
    }];
}

+ (void)requestImageWithMethodByGet:(NSString *)method paramars:(NSDictionary *)paramars paramarsSite:(NSString *)site sucessBlock:(successBlock)successBlock failure:(void (^)(NSError *))failure {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
     manager.requestSerializer.timeoutInterval=Time;
    NSString *url = [NSString stringWithFormat:@"%@%@",method,site];
    NSLog(@"%@", url);
    [UserInfo defaultUserInfo].R_timer.fireDate=[NSDate distantPast];
    
    [manager GET:url parameters:paramars success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([isShowUrl isEqualToString:@"YES"]) {
            [self showAlertViewWithTitle:url message:nil cancelButtonTitle:@"确定"];
        }
        
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        failure(error);
        
        NSString *lostLogin=[[NSUserDefaults standardUserDefaults] objectForKey:@"lostLogin"];
        if ([lostLogin isEqualToString:@"Y"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:@"lostLogin"];
        }else{
            [self netRequest];
        }
    }];
}

+ (void)requestWithMethod:(NSString *)method paramars:(NSDictionary *)paramars paramarsSite:(NSString *)site dataImage:(NSData *)data sucessBlock:(successBlock)successBlock failure:(void (^)(NSError *))failure {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
     manager.requestSerializer.timeoutInterval=Time;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/html",@"image/png", nil];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:paramars];
    [dictionary setObject:data forKey:@"user_img"];
    NSString *url = [NSString stringWithFormat:@"%@%@",method,site];
    NSLog(@"%@", url);
    [UserInfo defaultUserInfo].R_timer.fireDate=[NSDate distantPast];
    
    [manager POST:url parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([isShowUrl isEqualToString:@"YES"]) {
            [self showAlertViewWithTitle:url message:nil cancelButtonTitle:@"确定"];
        }
        
        successBlock(responseObject[@""]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        failure(error);
        
        NSString *lostLogin=[[NSUserDefaults standardUserDefaults] objectForKey:@"lostLogin"];
        if ([lostLogin isEqualToString:@"Y"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:@"lostLogin"];
        }else{
            [self netRequest];
        }
        
    }];
}

+ (void)uplodImageWithMethod:(NSString *)method paramars:(NSDictionary *)paramars paramarsSite:(NSString *)site dataImageDict:(NSMutableDictionary *)dataDict sucessBlock:(successBlock)successBlock failure:(void (^)(NSError *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=50.f;
    NSString *url = [NSString stringWithFormat:@"%@%@",method,site];
    NSLog(@"%@", url);
    
    [UserInfo defaultUserInfo].R_timer.fireDate=[NSDate distantPast];
    
    [manager POST:url parameters:paramars constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if ([isShowUrl isEqualToString:@"YES"]) {
            [self showAlertViewWithTitle:url message:nil cancelButtonTitle:@"确定"];
        }
        
        NSArray *keys = dataDict.allKeys;
        for (NSString *key in keys) {

                NSData *data = [[NSData alloc] initWithData:dataDict[key]];
                [formData appendPartWithFileData:data name:key fileName:key mimeType:@"image/png"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        failure(error);
        
        NSString *lostLogin=[[NSUserDefaults standardUserDefaults] objectForKey:@"lostLogin"];
        if ([lostLogin isEqualToString:@"Y"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:@"lostLogin"];
        }else{
            [self netRequest];
        }
        
    }];
    
}




+(void)getAppError:(NSString*)msg useName:(NSString*)useName{

    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *dataString1=[NSString stringWithString:dateString];
    
    NSString *SystemType=@"SystemType:2";
    NSString *version=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *AppVersion=[NSString stringWithFormat:@"AppVersion:%@",version];
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSString *SystemVersion=[NSString stringWithFormat:@"SystemVersion:%@",phoneVersion];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    NSString *PhoneModel=[NSString stringWithFormat:@"PhoneModel:%@",platform];
  //  NSString *reUsername=[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString *UserName=[NSString stringWithFormat:@"UserName:%@",useName];
    NSString *MSG=[NSString stringWithFormat:@"msg:%@",msg];
    
    NSString *errorMsg=[NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@",SystemType,AppVersion,SystemVersion,PhoneModel,UserName,MSG];
    
    
    NSMutableDictionary *dicO=[NSMutableDictionary new];
    [dicO setObject:dataString1 forKey:@"time"];
    [dicO setObject:errorMsg forKey:@"msg"];
    [BaseRequest requestWithMethodResponseStringResult:HEAD_URL paramars:dicO paramarsSite:@"/newLoginAPI.do?op=saveAppErrorMsg" sucessBlock:^(id content) {
        NSLog(@"saveAppErrorMsg: %@", content);
               id jsonObj = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingAllowFragments error:nil];
        if (jsonObj) {
          
        }
        
    } failure:^(NSError *error) {
  

        
    }];
    
}



+(void)netRequest{
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *reUsername=[ud objectForKey:@"userName"];
    NSString *rePassword=[ud objectForKey:@"userPassword"];
    
    if (rePassword==nil) {
        rePassword=@"";
    }
     [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:@"lostLogin"];
    
    
    if (!(reUsername==nil || reUsername==NULL||([reUsername isEqual:@""] ))){
        
        [BaseRequest requestWithMethod:HEAD_URL paramars:@{@"userName":reUsername, @"password":[self MD5:rePassword]} paramarsSite:@"/newLoginAPI.do" sucessBlock:^(id content) {
            
            NSLog(@"loginIn:%@",content);
            if (content) {
                if ([content[@"success"] integerValue] == 0) {
  
                    
                    
                }
                
            }
            
        } failure:^(NSError *error) {
          
            
        }];
    }
}


+(void)netRequestOss{
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *reUsername=[ud objectForKey:@"OssName"];
    NSString *rePassword=[ud objectForKey:@"OssPassword"];
    NSString *searchDeviceAddress=[ud objectForKey:@"searchDeviceAddress"];
    
    if (searchDeviceAddress==nil) {
        searchDeviceAddress=@"";
    }
    if (reUsername==nil) {
        reUsername=@"";
    }
    if (rePassword==nil) {
        rePassword=@"";
    }
//    int loginOssTimeNum=(int)[[NSUserDefaults standardUserDefaults] objectForKey:@"loginOssTime"];
    
   [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:@"loginOssEnable"];
    
    if (!(reUsername==nil || reUsername==NULL||([reUsername isEqual:@""] ))){
        
        [BaseRequest requestWithMethod:OSS_HEAD_URL_Demo paramars:@{@"userName":reUsername, @"serverUrl":searchDeviceAddress, @"password":[self MD5:rePassword]} paramarsSite:@"/api/v2/login" sucessBlock:^(id content) {
            
            NSLog(@"/api/v1/login/userResetLogin:%@",content);
            if (content) {
    
            }
            
        } failure:^(NSError *error) {
            
            
        }];
    }
}


+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil];
    [alertView show];
}


+ (NSString *)MD5:(NSString *)str {
    if (str==nil) {
        str=@"";
    }
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        NSString *tStr = [NSString stringWithFormat:@"%x", digest[i]];
        if (tStr.length == 1) {
            [result appendString:@"c"];
        }
        [result appendFormat:@"%@", tStr];
    }
    return result;
}


+(NSString*)getValidCode:(NSString*)serialNum{
    if (serialNum==NULL||serialNum==nil) {
        return @"";
    }
    NSData *testData = [serialNum dataUsingEncoding: NSUTF8StringEncoding];
    int sum=0;
    Byte *snBytes=(Byte*)[testData bytes];
    for(int i=0;i<[testData length];i++)
    {
        sum+=snBytes[i];
    }
    NSInteger B=sum%8;
    NSString *B1= [NSString stringWithFormat: @"%ld", (long)B];
    int C=sum*sum;
    NSString *text = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",C]];
    int length = [text length];
    NSString *resultTemp;
    NSString *resultTemp3;
    NSString *resultTemp1=[text substringWithRange:NSMakeRange(0, 2)];
    NSString *resultTemp2=[text substringWithRange:NSMakeRange(length - 2, 2)];
    resultTemp3= [resultTemp1 stringByAppendingString:resultTemp2];
    resultTemp=[resultTemp3 stringByAppendingString:B1];
    NSString *result = @"";
    char *charArray = [resultTemp cStringUsingEncoding:NSASCIIStringEncoding];
    for (int i=0; i<[resultTemp length]; i++) {
        if (charArray[i]==0x30||charArray[i]==0x4F||charArray[i]==0x4F) {
            charArray[i]++;
        }
        result=[result stringByAppendingFormat:@"%c",charArray[i]];
    }
    return [result uppercaseString];
}


// 传json格式
+ (void)myJsonPost:(NSString *)URLString
        parameters:(id)param
            Method:(NSString *)method
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=30.f;
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" , @"text/plain", nil];

    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSString *languageType = @"0";
    if ([currentLanguage hasPrefix:@"zh-Hans"]) {
        languageType=@"0";
    }else if ([currentLanguage hasPrefix:@"en"]) {
        languageType=@"1";
    }else{
        languageType=@"2";
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithDictionary:param];
    parameters[@"lan"] = languageType;
    
    if ([URLString isEqualToString:@"/ocpp/user/glanceUser"]) {
        parameters = [[NSMutableDictionary alloc]init];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",method,URLString];
    NSLog(@"%@ \n%@",url, parameters);
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

// 传普通http格式
+ (void)myHttpPost:(NSString *)URLString
        parameters:(id)param
            Method:(NSString *)method
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=30.f;
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" , @"text/plain", nil];
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSString *languageType = @"0";
    if ([currentLanguage hasPrefix:@"zh-Hans"]) {
        languageType=@"0";
    }else if ([currentLanguage hasPrefix:@"en"]) {
        languageType=@"1";
    }else{
        languageType=@"2";
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithDictionary:param];
    parameters[@"lan"] = languageType;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",method,URLString];
    NSLog(@"%@ \n%@",url, parameters);
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


@end
