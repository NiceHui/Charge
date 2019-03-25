//
//  SNLocationManager.m
//  wrongTopic
//
//  Created by wangsen on 16/1/16.
//  Copyright © 2016年 wangsen. All rights reserved.
//

#import "SNLocationManager.h"

static SNLocationManager * _manager = nil;

@interface SNLocationManager () <CLLocationManagerDelegate>
{
    UpdateLocationSuccessBlock _successBlock;
    UpdateLocationErrorBlock _errorBlock;
}
@property (nonatomic, strong) CLLocationManager * locationManager;//定位管理器
@property (nonatomic, strong) UIAlertView *Alert1;

@end
@implementation SNLocationManager
+ (instancetype)shareLocationManager {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _manager = [[self alloc] init];
//    });
    if (_manager) {
        _manager=nil;
    }
      _manager = [[self alloc] init];
    return _manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isAlwaysUse = YES;
        _isRealTime = NO;
        _distanceFilter = 1000.f;
        _desiredAccuracy = kCLLocationAccuracyKilometer;
    }
    return self;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}


- (void)startUpdatingLocationWithSuccess:(UpdateLocationSuccessBlock)success andFailure:(UpdateLocationErrorBlock)error {
    
    _successBlock = [success copy];
    _errorBlock = [error copy];
    
    
    CLAuthorizationStatus type = [CLLocationManager authorizationStatus];
    if (![CLLocationManager locationServicesEnabled] || type == kCLAuthorizationStatusDenied  || type == kCLAuthorizationStatusRestricted){
    
        
        _Alert1 = [[UIAlertView alloc] initWithTitle:root_542_dingwei_tishi message:root_543_dingwei_tishi_2 delegate:self cancelButtonTitle:nil otherButtonTitles:root_OK,nil];
        [_Alert1 show];
        
   
        
    }
        
       self.locationManager.delegate = self;
    
    
    //定位服务是否可用
//    BOOL isLocationEnabled = [CLLocationManager locationServicesEnabled];
//    
//    if (!isLocationEnabled) {
//        NSLog(@"请打开定位服务");
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请打开定位服务，才能使用定位功能" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//        [alertView show];
//        return;
//    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
    }else if (buttonIndex==1){
  

    }
    
}




#pragma mark - 状态改变时调用
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    //是否具有定位权限
    if (status == kCLAuthorizationStatusNotDetermined ||
        status == kCLAuthorizationStatusRestricted ||
        status == kCLAuthorizationStatusDenied ) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            if (!_isAlwaysUse) {
                [manager requestWhenInUseAuthorization];
            } else {
                [manager requestAlwaysAuthorization];
            }
        }
//        if (_isAlwaysUse) {
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
//                manager.allowsBackgroundLocationUpdates = YES;
//            }
//        }
           [manager startUpdatingLocation];
        
    } else {
        //精度
        manager.desiredAccuracy = _desiredAccuracy;
        //更新距离
        manager.distanceFilter = _distanceFilter;
        //定位开始
        [manager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation * location = locations.firstObject;
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark * placemark = placemarks.firstObject;
        _successBlock(location,placemark);
    }];
    //关闭定位
    if (!_isRealTime) {
        [manager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    _errorBlock(region,error);
}

@end
