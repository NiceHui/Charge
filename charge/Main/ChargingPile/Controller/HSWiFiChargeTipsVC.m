//
//  HSWiFiChargeTipsVC.m
//  charge
//
//  Created by growatt007 on 2019/4/1.
//  Copyright © 2019 hshao. All rights reserved.
//

#import "HSWiFiChargeTipsVC.h"
#import "HSWiFiChargeSettingVC.h"
#import "HSUDPWiFiManager.h"
#import <SystemConfiguration/CaptiveNetwork.h>//获取wifi名称
#import "SelectTimeAlert.h"
#import "CGXPickerView.h"
#import "HSTCPWiFiManager.h"

@interface HSWiFiChargeTipsVC ()<HSUDPWiFiManagerDelegate,HSTCPWiFiManagerDelegate>{
    __block BOOL isSuccess;
}

@property (nonatomic, strong) UIImageView *wifiImageV;

@property (nonatomic, strong) UILabel *lblWiFiName;

@property (nonatomic, strong) UIButton *btnRefresh;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *radarImageView;

@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic,strong) NSTimer *timer ;
@end

@implementation HSWiFiChargeTipsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = root_lianwang;
    
    self.view.backgroundColor = colorblack_222;
    
    // 赋值代理
    [HSUDPWiFiManager shareUDPManage].delegate = self;
    
    [self setUpUIView];
    
}

// set up view
- (void)setUpUIView{
    /// tips1
    UILabel *lblTips1 = [[UILabel alloc]initWithFrame:CGRectMake(10*XLscaleW, 0, ScreenWidth-20*XLscaleW, 70*XLscaleH)];
    lblTips1.text = root_lianwang_tips;
    lblTips1.textColor = colorblack_51;
    lblTips1.textAlignment = NSTextAlignmentCenter;
    lblTips1.font = FontSize(16*XLscaleH);
    lblTips1.numberOfLines = 0;
    [self.view addSubview:lblTips1];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 70*XLscaleH, ScreenWidth, ScreenHeight-kNavBarHeight-kBottomBarHeight-70*XLscaleH)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    /// tips2
    UILabel *lblTips2 = [[UILabel alloc]initWithFrame:CGRectMake(10*XLscaleW, 60*XLscaleH, ScreenWidth-20*XLscaleW, 25*XLscaleH)];
    lblTips2.text = root_shoujilianjie_wifi;
    lblTips2.textColor = colorblack_154;
    lblTips2.textAlignment = NSTextAlignmentCenter;
    lblTips2.font = FontSize([NSString getFontWithText:lblTips2.text size:lblTips2.xmg_size currentFont:17*XLscaleH]);
    [whiteView addSubview:lblTips2];
    // wifi名称
    self.lblWiFiName = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-75*XLscaleW, 90*XLscaleH, 150*XLscaleW, 25*XLscaleH)];
    self.lblWiFiName.textColor = colorblack_51;
    self.lblWiFiName.textAlignment = NSTextAlignmentCenter;
    self.lblWiFiName.font = [UIFont boldSystemFontOfSize:18*XLscaleH];
    self.lblWiFiName.adjustsFontSizeToFitWidth = YES;
    [whiteView addSubview:self.lblWiFiName];
    // 图标
    self.wifiImageV = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-75*XLscaleW-30*XLscaleW, self.lblWiFiName.center.y-7*XLscaleW, 18*XLscaleW, 14*XLscaleW)];
    self.wifiImageV.image = [UIImage imageNamed:@"wifi_icon"];
    [whiteView addSubview:self.wifiImageV];
    /// 刷新
    self.btnRefresh = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2+90*XLscaleW+20*XLscaleW, self.lblWiFiName.frame.origin.y, 50*XLscaleW, 25*XLscaleH)];
    [self.btnRefresh setTitle:root_shuaxin forState:UIControlStateNormal];
    self.btnRefresh.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.btnRefresh setTitleColor:mainColor forState:UIControlStateNormal];
    [self.btnRefresh setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.btnRefresh.titleLabel.font = [UIFont systemFontOfSize:15*XLscaleH];
    [self.btnRefresh addTarget:self action:@selector(getWiFiName) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:self.btnRefresh];
    /// next
    UIButton *btnNext = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2-90*XLscaleW, 350*XLscaleH, 180*XLscaleW, 45*XLscaleH)];
    [btnNext setTitle:root_yilianjie_xiayibu forState:UIControlStateNormal];
    [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CAGradientLayer *gradientLayer0 = [[CAGradientLayer alloc] init];
    gradientLayer0.cornerRadius = 22*XLscaleH;
    gradientLayer0.frame = btnNext.bounds;
    gradientLayer0.colors = @[
                              (id)[UIColor colorWithRed:1.0f/255.0f green:230.0f/255.0f blue:114.0f/255.0f alpha:1.0f].CGColor,
                              (id)[UIColor colorWithRed:0.0f/255.0f green:227.0f/255.0f blue:192.0f/255.0f alpha:1.0f].CGColor];
    gradientLayer0.locations = @[@0, @1];
    [gradientLayer0 setStartPoint:CGPointMake(0, 1)];
    [gradientLayer0 setEndPoint:CGPointMake(1, 1)];
    [btnNext.layer addSublayer:gradientLayer0];
    XLViewBorderRadius(btnNext, 22*XLscaleH, 0, kClearColor);
//    btnNext.titleLabel.font = FontSize(17*XLscaleH);
    btnNext.titleLabel.font = FontSize([NSString getFontWithText:btnNext.titleLabel.text size:btnNext.titleLabel.xmg_size currentFont:17*XLscaleH]);
    [self.view addSubview:btnNext];
    [btnNext addTarget:self action:@selector(getChargeIP) forControlEvents:UIControlEventTouchUpInside];
    
    /// 提示框
    // 背景
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-kNavBarHeight-kBottomBarHeight)];
    bgView.backgroundColor = COLOR(0, 0, 0, 0.8);
    [self.view addSubview:bgView];
    _bgView = bgView;
    bgView.hidden = YES;
    
    float imageH = ScreenWidth*3/5;
    self.radarImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-imageH)/2, 100*XLscaleH ,imageH, imageH)];
    self.radarImageView.image = IMAGE(@"雷达");
    [bgView addSubview:self.radarImageView];
    
    // 进度
    float labelW = 150*XLscaleW, labelH = 70*XLscaleH, labelY = self.radarImageView.center.y-labelH/2;
    UILabel* progressLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-labelW)/2+20*XLscaleW, labelY, labelW, labelH)];
    progressLabel.text = @"100s";
    progressLabel.font = [UIFont boldSystemFontOfSize:50*XLscaleW];
    [progressLabel sizeToFit];
    progressLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:progressLabel];
    _progressLabel = progressLabel;
    // 创建渐变层
    CAGradientLayer* gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = progressLabel.frame;
    gradientLayer.colors = @[
                             (id)[UIColor colorWithRed:18.0f/255.0f green:233.0f/255.0f blue:200.0f/255.0f alpha:1.0f].CGColor,
                             (id)[UIColor colorWithRed:18.0f/255.0f green:233.0f/255.0f blue:124.0f/255.0f alpha:1.0f].CGColor];
    gradientLayer.locations = @[@0, @1];
    [gradientLayer setStartPoint:CGPointMake(0, 1)];
    [gradientLayer setEndPoint:CGPointMake(1, 1)];
    [bgView.layer addSublayer:gradientLayer];
    
    gradientLayer.mask = progressLabel.layer;
    progressLabel.frame = gradientLayer.bounds;
    self.progressLabel.text = @"0 s";
    /// tips3
    UILabel *lblTips3 = [[UILabel alloc]initWithFrame:CGRectMake(10*XLscaleW, CGRectGetMaxY(self.radarImageView.frame)+20*XLscaleH, ScreenWidth-20*XLscaleW, 25*XLscaleH)];
    lblTips3.text = root_lianjiezhong;
    lblTips3.textColor = [UIColor whiteColor];
    lblTips3.textAlignment = NSTextAlignmentCenter;
    lblTips3.font = [UIFont systemFontOfSize:17*XLscaleH];
    [bgView addSubview:lblTips3];
    
    UIButton *btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2-90*XLscaleW, 400*XLscaleH, 180*XLscaleW, 45*XLscaleH)];
    [btnCancel setTitle:root_cancel forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel setBackgroundColor:mainColor];
    [btnCancel addTarget:self action:@selector(stopSendData) forControlEvents:UIControlEventTouchUpInside];
    XLViewBorderRadius(btnCancel, 22*XLscaleH, 0, kClearColor);
    btnCancel.titleLabel.font = FontSize(17*XLscaleH);
    [bgView addSubview:btnCancel];
    
    // 获取wifi名称
    [self getWiFiName];
}

#pragma mark -- 点击事件

- (void)getChargeIP{
//    HSWiFiChargeSettingVC *vc = [[HSWiFiChargeSettingVC alloc]init];
//    vc.devData = @{@"ip": @"192.168.1.1", @"devName": self.ChargeId};
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    // 刷新最新的wifi信息
    [self getWiFiName];
    if([self.lblWiFiName.text isEqualToString:root_weilianjie]){
        [self showToastViewWithTitle:root_weilianjie_wifi];
        return;
    }
    isSuccess = NO;
    self.progressLabel.text = @"0 s";
    // timer 要在主线程中开启才有效
    dispatch_async(dispatch_get_main_queue(), ^{
        __block int sec = 1;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            if (sec % 3 == 0 || sec == 1) { // 每隔2秒发一次tcp连接
                // 建立连接
                [[HSTCPWiFiManager instance] connectToHost:@"192.168.1.1"];
                [HSTCPWiFiManager instance].delegate = self;
            }
            
            self.progressLabel.text = [NSString stringWithFormat:@"%d s", sec];
            sec ++;
            if (sec % 10 == 0) { // 每隔10秒刷新一下wifi
                // 刷新最新的wifi信息
                [self getWiFiName];
            }
            if (sec >60) {
                [self showToastViewWithTitle:root_Networking];
                [self stopSendData];
            }
        }] ;
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    });
    self.bgView.hidden = NO;
    // 开启旋转动画
    [self rotate];
}


// 获取wifi名称
- (void)getWiFiName{
    NSString *SSID = [self fetchSSIDInfo];
    if (kStringIsEmpty(SSID)) {
        self.lblWiFiName.text = root_weilianjie;
        [self showToastViewWithTitle:root_weilianjie_wifi];
        return;
    }
    CGSize size = [SSID boundingRectWithSize:CGSizeMake(MAXFLOAT, 25*XLscaleH) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSMutableDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:18*XLscaleH] forKey:NSFontAttributeName] context:nil].size;
    
    self.lblWiFiName.text = SSID;
    self.lblWiFiName.frame = CGRectMake(ScreenWidth/2-size.width/2, 90*XLscaleH, size.width, 25*XLscaleH);
    self.wifiImageV.frame = CGRectMake(ScreenWidth/2-size.width/2-30*XLscaleW, self.lblWiFiName.center.y-7*XLscaleW, 18*XLscaleW, 14*XLscaleW);
    self.btnRefresh.frame = CGRectMake(ScreenWidth/2+size.width/2+20*XLscaleW, self.lblWiFiName.frame.origin.y, 50*XLscaleW, 25*XLscaleH);
}

// 停止发送udp
- (void)stopSendData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.timer && [self.timer isValid]) {
            [self.timer invalidate] ;
            self.timer = nil ;
        }
        self.bgView.hidden = YES;
    });
}


#pragma mark -- HSTCPWiFiManagerDelegate
- (void)SocketConnectIsSucces:(BOOL)isSucces{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (isSucces) { // socket 连接成功
            // 停止定时
            [self stopSendData];
            
            NSMutableDictionary *devData = [[NSMutableDictionary alloc]init];
            [devData setObject:@"192.168.1.1" forKey:@"ip"];  // 固定连接ip
            [devData setObject:self.lblWiFiName.text forKey:@"devName"]; // 使用wifi名称
            
            // 判断直连SN号是否是自己选中的那个
            if(![self.lblWiFiName.text isEqualToString:self.ChargeId]){
                [self showToastViewWithTitle:root_dianzhuanweixuanze];
                return ;
            }
            
            HSWiFiChargeSettingVC *vc = [[HSWiFiChargeSettingVC alloc]init];
            vc.devData = devData;
            [self.navigationController pushViewController:vc animated:YES];
        }
    });
}

// 旋转
- (void)rotate
{
    // 对Y轴进行旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 2.5;
    animation.repeatCount = 1000;
    animation.fromValue = @(0.0);
    animation.toValue = @(2 * M_PI);
    animation.removedOnCompletion = NO;
    // 添加动画
    [_radarImageView.layer addAnimation:animation forKey:@"rotate"];
}


// 获取wifi名称
- (NSString *)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    //    NSLog(@"<APP> Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        //        NSLog(@"<APP> %@ => %@", ifnam, info);  //sigal data: info[@"SSID"]; info[@"BSSID"];
        if (info && [info count]) {
            break;
        }
    }
    return info[@"SSID"];
}

// 电桩切换至AP模式
- (void)switch_ap_mode{
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced]switchAPModeWithSn:self.ChargeId userId:[UserInfo defaultUserInfo].userName success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideProgressView];
            if ([obj[@"code"] isEqualToNumber:@0]) {
                HSWiFiChargeTipsVC *vc = [[HSWiFiChargeTipsVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            } else{
                [weakSelf showToastViewWithTitle:[NSString stringWithFormat:@"%@", obj[@"data"]]];
            }
        });
    } failure:^(NSError *error) {
        [weakSelf hideProgressView];
    }];
}



- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self stopSendData];
}

- (void)dealloc{
    [HSTCPWiFiManager instance].delegate = nil;
}

@end
