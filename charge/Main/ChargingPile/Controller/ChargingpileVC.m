//
//  ChargingpileVC.m
//  ShinePhone
//
//  Created by mac on 2018/6/2.
//  Copyright © 2018年 qwl. All rights reserved.
//

#import "ChargingpileVC.h"
#import "ChooseChargingPileVC.h"
#import "AuthorizationVC.h"
#import "AddChargingPileVC.h"
#import "ChargeRecordVC.h"
#import "EquipmentCollectionViewCell.h"
#import "DeviceManager.h"
#import "BluetoothConnectVC.h"
#import "GRTChargingPileModel.h"
#import "ChargingpileSettingVC.h"
#import "ChargingPileSettingOptionVC.h"
#import "ChargingStateView.h"
#import "EBDropdownListView.h"
#import "PresetChargeViewController.h"
#import "TimingListViewController.h"
#import "ChargingpileInfoModel.h"
#import "PickerViewAlert.h"
#import "SolarTipsAlert.h"
//#import "HSWiFiChargeListVC.h"
#import "HSWiFiChargeTipsVC.h"

@interface ChargingpileVC ()<ChargingStateDelegate>
{
    NSInteger currentDevIndex;      // 当前选择的充电枪
    NSInteger num;
    __block NSInteger currentConnectorId; // 当前选择的充电枪号
    __block NSString *setValue1; // 设定值1, 用来记录预定金额，电量时长等设定值
    __block NSString *setValue2; // 设定值2
    __block BOOL isRefreshOrder; // 是否刷新预约状态UI
    
    __block NSString *orderType; // 指令类型
}

@property (nonatomic, strong) GRTChargingPileModel* deviceModel;// 充电桩列表的model

@property (nonatomic, strong) ChargingpileInfoModel* InfoModel;// 设备详细状态

@property (nonatomic, strong) NSArray *ReserveNowArray;//预定信息
@property (nonatomic, strong) NSDictionary *LastActionDict;// 最后一次操作

@property (nonatomic, assign) BOOL isBLE;
@property (nonatomic, strong) UIButton *connectBtn;
@property (nonatomic, strong) UIButton *solarButton;

@property (nonatomic, strong) UIImageView *stateImageView;// 旋转动画图片
@property (nonatomic, strong) UIImageView *chargeImageView;// 图片

@property (nonatomic, strong) UILabel *modelLabel;// 模式
@property (nonatomic, strong) UILabel *statusLB;// 状态

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) __block dispatch_source_t distimer;

@property (nonatomic, strong) EBDropdownListView *dropdownListView; // 切换A，B枪

@property (nonatomic, strong) ChargingStateView *stateView;// 状态

@end

@implementation ChargingpileVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = HEM_chongdianzhuang;
    
    self.isBLE = NO;
    isRefreshOrder = YES; // 默认允许刷新
    
    [self creatView];
    [self creatButton];
    [self getChargingpileList];
    [self addNotification];

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"link_wifi_set"] style:UIBarButtonItemStyleDone target:self action:@selector(goToWiFiSetting)];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)goToWiFiSetting{
    
    if(self.dataSource.count == 0){
        [self showToastViewWithTitle:HEM_meiyoushebei];
        return;
    }
    HSWiFiChargeTipsVC *vc = [[HSWiFiChargeTipsVC alloc]init];
    vc.ChargeId = [NSString stringWithFormat:@"%@", self->_deviceModel.chargeId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)creatView{
    
    self.scrollView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self getChargingpileList];
        [self getChargingPileInfomation:self->_deviceModel];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scrollView.mj_header endRefreshing];
        });
    }];

    [self.devCollectView registerClass:[EquipmentCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([EquipmentCollectionViewCell class])];
    
    CircelView *circleView = [[CircelView alloc] initWithFrame:CGRectMake(ScreenWidth/2-(215*XLscaleH)/2, 8, 215*XLscaleH, 215*XLscaleH)];
    [self.scrollView addSubview:circleView];
    // 旋转动画的图片
    UIImageView *stateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-(215*XLscaleH)/2, 8, 215*XLscaleH, 215*XLscaleH)];
    [self.scrollView addSubview:stateImageView];
    _stateImageView = stateImageView;
    // 充电中状态图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((215*XLscaleH-49*XLscaleH)/2.0, 20*XLscaleH, 49*XLscaleH, 47*XLscaleH)];
    imageView.image = IMAGE(@"Charging_norm");
    [circleView addSubview:imageView];
    _chargeImageView = imageView;
    imageView.userInteractionEnabled = YES;
    
    // 电桩模式
    UILabel *modelLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(imageView.frame)+5*XLscaleH, circleView.xmg_width-60, 14*XLscaleH)];
    modelLabel.textColor = colorblack_154;
    modelLabel.font  = FontSize(14*XLscaleH);
    modelLabel.textAlignment = NSTextAlignmentCenter;
    [circleView addSubview:modelLabel];
    _modelLabel = modelLabel;
    
    // 选择充电枪
    EBDropdownListItem *item1 = [[EBDropdownListItem alloc] initWithItem:@"1" itemName:HEM_A_qiang];
    EBDropdownListItem *item2 = [[EBDropdownListItem alloc] initWithItem:@"2" itemName:HEM_B_qiang];
    
    EBDropdownListView *dropdownListView = [[EBDropdownListView alloc] initWithDataSource:@[item1, item2] andImage:@"gun_drop"];
    dropdownListView.frame = CGRectMake(circleView.xmg_width/2 - 40*XLscaleW, CGRectGetMaxY(modelLabel.frame)+20*XLscaleH, 80*XLscaleW, 26*XLscaleH);
    dropdownListView.selectedIndex = 0;
    dropdownListView.textColor = COLOR(0, 156, 255, 1);
    XLViewBorderRadius(dropdownListView, 13*XLscaleH, 1, COLOR(0, 156, 255, 1));
    [circleView addSubview:dropdownListView];
    _dropdownListView = dropdownListView;
    __weak typeof(self) weakSelf = self;
    [dropdownListView setDropdownListViewSelectedBlock:^(EBDropdownListView *dropdownListView) {// 切换枪
        self->currentConnectorId = dropdownListView.selectedIndex+1;
        [weakSelf getChargingPileInfomation:self->_deviceModel];
    }];
    
    // 状态
    UILabel *statusLB = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dropdownListView.frame)+15*XLscaleH, circleView.xmg_width, 26*XLscaleH)];
    statusLB.textAlignment = NSTextAlignmentCenter;
    statusLB.textColor = COLOR(48, 229, 120, 1);
    statusLB.font = [UIFont systemFontOfSize:24*XLscaleH];
    statusLB.text = HEM_Available;
    [circleView addSubview:statusLB];
    _statusLB = statusLB;
    
    // 实时充电数据
    float viewHeight = self.view.xmg_height-kNavBarHeight-kBottomBarHeight-90*XLscaleH-circleView.xmg_height-self.bgImgView.xmg_height-20,
    viewY = CGRectGetMaxY(circleView.frame)+5;
    _stateView = [[ChargingStateView alloc]initWithFrame:CGRectMake(0, viewY, ScreenWidth, viewHeight) Type:@"0"];
    _stateView.delegate = self;
    [self.scrollView addSubview:_stateView];
    
    float solarW = 80*XLscaleW, solarH = 25*XLscaleH, paddingLF = 10*XLscaleW;
    UIButton *solarButton = [[UIButton alloc]initWithFrame:CGRectMake(paddingLF, paddingLF, solarW, solarH)];
    [solarButton setImage:IMAGE(@"limit_charge_off") forState:UIControlStateNormal];
    [solarButton setImage:IMAGE(@"limit_charge_on") forState:UIControlStateSelected];
    [solarButton setTitle:@"Solar" forState:UIControlStateNormal];
    [solarButton setTitleColor:mainColor forState:UIControlStateNormal];
    [solarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [solarButton setImageEdgeInsets:UIEdgeInsetsMake(5*XLscaleH, 0, 5*XLscaleH, 10*XLscaleW)];
    solarButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    solarButton.titleLabel.font = FontSize(14*XLscaleH);
    [solarButton setBackgroundColor:[UIColor whiteColor]];
    [solarButton addTarget:self action:@selector(setSolar:) forControlEvents:UIControlEventTouchUpInside];
    XLViewBorderRadius(solarButton, solarH/2, 0, kClearColor);
    [self.scrollView addSubview:solarButton];
    _solarButton = solarButton;
    
}
- (void)creatButton{
    
    self.setBtn = [TabButton buttonWithType:UIButtonTypeCustom];
    self.setBtn.frame = CGRectMake(0, 22*XLscaleH, ScreenWidth/3, 52*XLscaleH);
    [self.setBtn setTitleColor:colorblack_51 forState:UIControlStateNormal];
    self.setBtn.titleLabel.font = [UIFont systemFontOfSize:15*XLscaleH];
    [self.setBtn setImage:IMAGE(@"setting") forState:UIControlStateNormal];
    [self.setBtn addTarget:self action:@selector(authorizationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.setBtn setTitle:HEM_zhuangtishezhi forState:UIControlStateNormal];
    [self.bgImgView addSubview:self.setBtn];
    
    self.openBtn = [TabCenterButton buttonWithType:UIButtonTypeCustom];
    self.openBtn.frame = CGRectMake(ScreenWidth/3, 10*XLscaleH, ScreenWidth/3, 39*XLscaleH+14*XLscaleH);
    [self.openBtn setImage:IMAGE(@"Charging_on") forState:UIControlStateNormal];
    [self.openBtn setImage:IMAGE(@"Charging_on_click") forState:UIControlStateHighlighted];
    [self.openBtn setImage:IMAGE(@"Charging_stop") forState:UIControlStateSelected];
    [self.openBtn addTarget:self action:@selector(chargeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.openBtn setTitle:HEM_chongdian forState:UIControlStateNormal];
    [self.openBtn setTitle:HEM_tingzhichongdian forState:UIControlStateSelected];
    [self.openBtn setTitleColor:colorblack_51 forState:UIControlStateNormal];
    [self.openBtn setTitleColor:colorblack_51 forState:UIControlStateNormal];
    self.openBtn.titleLabel.font = [UIFont systemFontOfSize:14*XLscaleH];
    self.openBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.bgImgView addSubview:self.openBtn];
    
    self.deleteBtn = [TabButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.frame = CGRectMake(ScreenWidth-ScreenWidth/3, 22*XLscaleH, ScreenWidth/3, 52*XLscaleH);
    [self.deleteBtn setTitleColor:colorblack_51 forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15*XLscaleH];
    [self.deleteBtn setImage:IMAGE(@"record") forState:UIControlStateNormal];
    [self.deleteBtn setTitle:HEM_chongdianjilu forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImgView addSubview:self.deleteBtn];
}

// 添加通知
- (void)addNotification{
    // 刷新充电枪列表
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadWithChargeList:) name:@"RELOAD_CHARGE" object:nil];
    // 刷新充电枪接口
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadWithCharginConnectorNumInfo:) name:@"RELOAD_CONNECTOR_NUM" object:nil];
    // 刷新充电枪接口
}

// 设置solar值
- (void)setSolar:(UIButton *)button{
    button.selected = !button.isSelected;
    if (button.isSelected) {
        [_solarButton setBackgroundColor:mainColor];
    }else{
        [_solarButton setBackgroundColor:[UIColor whiteColor]];
    }
    
    SolarTipsAlert *solarAlert = [[SolarTipsAlert alloc]initWithButtonFrame:[self.scrollView convertRect:button.frame toView:KEYWINDOW]];
    solarAlert.state = button.isSelected;
    solarAlert.deviceModel = self.deviceModel;
    [solarAlert show];
    __weak typeof(self) weakSelf = self;
    solarAlert.touchAlertEnter = ^{// 确定
        [weakSelf setChargeSolar:button.isSelected ? @1 : @0];
    };
    // 切换模式
    solarAlert.touchAlertSwitchSolarModel = ^(NSNumber * _Nonnull model) {
        [weakSelf setChargeSolar:model];
    };
    solarAlert.touchAlertCancel = ^{// 取消
        [weakSelf setButtonBackgroundColor];
    };
}
// 更换按键颜色
- (void)setButtonBackgroundColor{
    // FAST 模式为关闭， 其他则为开启
    NSString *solarModel = [NSString stringWithFormat:@"%@", self.deviceModel.G_SolarMode];
    if ([solarModel isEqualToString:@"0"]) { // FAST模式
        self.solarButton.selected = NO;
    }else{ // ECO
        self.solarButton.selected = YES;
    }
    
    if (self.solarButton.isSelected) {
        [_solarButton setBackgroundColor:mainColor];
    }else{
        [_solarButton setBackgroundColor:[UIColor whiteColor]];
    }
}

#pragma mark---添加充电桩
- (void)addBtnClick{
    AddChargingPileVC *authVC = [[AddChargingPileVC alloc] init];
    [self.navigationController pushViewController:authVC animated:YES];
}
#pragma mark---充电桩设置
- (void)authorizationClick{
    
    NSNumber *auth = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth"];
    NSString *userName = [UserInfo defaultUserInfo].userName;
    if ([_deviceModel.type isEqualToNumber:@0] && !([auth isEqualToNumber:@1] && [userName isEqualToString:@"ceshi00701"])) {// 桩主预定, 非浏览账户
        ChargingPileSettingOptionVC *vc = [[ChargingPileSettingOptionVC alloc] init];
        vc.sn = self.deviceModel.chargeId;
        vc.priceConf = self.deviceModel.priceConf;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self showToastViewWithTitle:root_zhanghu_meiyou_quanxian];
    }
    
}
#pragma mark---充电
- (void)chargeClick:(UIButton *)btn{
    
    if([_InfoModel.status isEqualToString:@"Reserved"] || [_InfoModel.status isEqualToString:@"Accepted"] || [_InfoModel.status isEqualToString:@"ReserveNow"]){// 预约
        [self updateChargeTiming]; // 处于预约状态则发送取消预约指令
        return;
    }
    
    if ([_InfoModel.status isEqualToString:@"Faulted"]) {// 故障
        [self showToastViewWithTitle:root_charge_state_faulted];
        return;
    }else if ([_InfoModel.status isEqualToString:@"Unavailable"]){// 通讯异常
        [self showToastViewWithTitle:root_charge_state_unavailable];
        return;
    }else if ([_InfoModel.status isEqualToString:@"SuspendedEV"]){ // 车拒绝充电
        [self showToastViewWithTitle:root_charge_state_SuspendedEV];
        return;
    }else if ([_InfoModel.status isEqualToString:@"SuspendedEVSE"]){ // 桩拒绝充电
        [self showToastViewWithTitle:root_charge_state_SuspendedEVSE];
        return;
    }
    
    // 正在充电中,充电结束，暂停充电 允许发送停充指令
    if ([_InfoModel.status isEqualToString:@"Charging"] || [_InfoModel.status isEqualToString:@"Finishing"]) {
        NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
        [parms setObject:@"remoteStopTransaction" forKey:@"action"];
        [parms setObject:@(currentConnectorId) forKey:@"connectorId"];
        [parms setObject:_deviceModel.chargeId forKey:@"chargeId"];
        [parms setObject:[UserInfo defaultUserInfo].userName forKey:@"userId"];
        [parms setObject:_InfoModel.transactionId forKey:@"transactionId"];
        [self controlCharge:parms action:YES];
        orderType = @"stop";// 停冲
        return ;
    }
    // 时段预约
    if ([_stateView.currentPrograme isEqualToString:@"Time"] && _stateView.switchButton.isOn) {
        UIAlertController *removeAlert = [UIAlertController alertControllerWithTitle:root_Alet_user message:HEM_chongdian_tip1 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *enter = [UIAlertAction actionWithTitle:root_OK style:UIAlertActionStyleCancel handler:nil];
        [removeAlert addAction:enter];
        [self presentViewController:removeAlert animated:YES completion:nil];
        return ;
    }
    
    NSString *timeButtonTitle = _stateView.timeButton.titleLabel.text; // 获取预订定时时间
    if (_stateView.switchButton.isOn && [_deviceModel.type isEqualToNumber:@0]) {// 桩主预定
        if (timeButtonTitle.length < 7 && ![timeButtonTitle isEqualToString:@""] && ![timeButtonTitle isEqualToString:@"--"]) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"HH:mm"];
            NSString *dateStr = [formatter stringFromDate:[NSDate date]];
            NSArray *setTimeArray = [timeButtonTitle componentsSeparatedByString:@":"];
            NSArray *currentTimeArray = [dateStr componentsSeparatedByString:@":"];
            
            NSInteger setTime = [setTimeArray[0] integerValue]*60 + [setTimeArray[1] integerValue];
            NSInteger currentTime = [currentTimeArray[0] integerValue]*60 + [currentTimeArray[1] integerValue];
            
            if (!_stateView.looptypeBtn.isSelected && setTime <= currentTime) {// 开始时间不能小于当前时间
                [self showToastViewWithTitle:root_time_set_Error2];
                return;
            }
            
            if ([_stateView.currentPrograme isEqualToString:@"Amount"]) {// 金额定时
                
                if (![setValue1 isEqualToString:@"0"] && ![setValue1 isEqualToString:@""] && (setValue1 != nil))
                {
                    [self setTimingCkey:@"G_SetAmount" action:@"ReserveNow" cValue:setValue1 Time:timeButtonTitle isLoopType:YES];
                }else{
                    [self showToastViewWithTitle:HEM_setAmount_buweiling];
                    return;
                }
                
            }else if([_stateView.currentPrograme isEqualToString:@"Electricity"]) {// 电量定时
                
                if (![setValue1 isEqualToString:@"0"] && ![setValue1 isEqualToString:@""] && (setValue1 != nil) )
                {
                    [self setTimingCkey:@"G_SetEnergy" action:@"ReserveNow" cValue:setValue1 Time:timeButtonTitle isLoopType:YES];
                }else{
                    [self showToastViewWithTitle:HEM_setEnergy_buweiling];
                    return;
                }
                
            }else if([_stateView.currentPrograme isEqualToString:@"Time"]) {// 时长定时
                
                if (setValue1 == nil || setValue2 == nil || [setValue1 isEqualToString:@""] || [setValue2 isEqualToString:@""]) {
                    [self showToastViewWithTitle:HEM_time_buweiling];
                    return;
                }
                
                NSInteger hour = [setValue1 integerValue];
                NSInteger min = [setValue2 integerValue];
                [self setTimingCkey:@"G_SetTime" action:@"ReserveNow" cValue:[NSString stringWithFormat:@"%ld", hour*60+min] Time:timeButtonTitle isLoopType:NO];
                
            }else if([_stateView.currentPrograme isEqualToString:@""]) {// 普通定时
                
                [self setTimingCkey:@"" action:@"ReserveNow" cValue:@"0" Time:timeButtonTitle isLoopType:YES];
            }
        }else{
            [self showToastViewWithTitle:HEM_weishezhi_kaishishijian];
            return;
        }
    }else{// 不预定(立即开始充电, 达到设置条件后停止)
        
        if ([_InfoModel.status isEqualToString:@"Available"]) {// 空闲
//            [self showToastViewWithTitle:HEM_wufachongdian];
            [self showAlertViewWithTitle:@"" message:HEM_wufachongdian cancelButtonTitle:root_OK];
            return;
        }
        
        if ([_stateView.currentPrograme isEqualToString:@"Amount"]) {// 金额
            
            if (![setValue1 isEqualToString:@"0"] && ![setValue1 isEqualToString:@""] && (setValue1 != nil) )
            {
                [self setTimingCkey:@"G_SetAmount" action:@"remoteStartTransaction" cValue:setValue1 Time:@"" isLoopType:NO];
            }else{
                [self showToastViewWithTitle:HEM_setAmount_buweiling];
                return;
            }
            
        }else if([_stateView.currentPrograme isEqualToString:@"Electricity"]) {// 电量
            
            if (![setValue1 isEqualToString:@"0"] && ![setValue1 isEqualToString:@""] && (setValue1 != nil) )
            {
                [self setTimingCkey:@"G_SetEnergy" action:@"remoteStartTransaction" cValue:setValue1 Time:@"" isLoopType:NO];
            }else{
                [self showToastViewWithTitle:HEM_setEnergy_buweiling];
                return;
            }
            
        }else if([_stateView.currentPrograme isEqualToString:@"Time"]) {// 时长
            
            if (setValue1 == nil || setValue2 == nil || [setValue1 isEqualToString:@""] || [setValue2 isEqualToString:@""]) {
                [self showToastViewWithTitle:HEM_time_buweiling];
                return;
            }
            
            NSInteger hour = [setValue1 integerValue];
            NSInteger min = [setValue2 integerValue];
            [self setTimingCkey:@"G_SetTime" action:@"remoteStartTransaction" cValue:[NSString stringWithFormat:@"%ld", hour*60+min] Time:@"" isLoopType:NO];
            
        }else if([_stateView.currentPrograme isEqualToString:@""]) {// 普通
            
            [self setTimingCkey:@"" action:@"remoteStartTransaction" cValue:@"0" Time:@"" isLoopType:NO];
        }
        orderType = @"start"; // 立即开始充电
    }

}
// 预设充电
- (void)setTimingCkey:(NSString *)cKey action:(NSString *)action cValue:(NSString *)cValue Time:(NSString *)time isLoopType:(BOOL)isLoopType{
    // 获取日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [formatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setObject:cKey forKey:@"cKey"];
    [parms setObject:@(currentConnectorId) forKey:@"connectorId"];
    [parms setObject:_deviceModel.chargeId forKey:@"chargeId"];
    [parms setObject:[UserInfo defaultUserInfo].userName forKey:@"userId"];
    [parms setObject:action forKey:@"action"];

    if (_stateView.looptypeBtn.isSelected) {
        [parms setObject:@(0) forKey:@"loopType"]; // 0 循环
        [parms setObject:time forKey:@"loopValue"]; // 0 循环
    }else{
        [parms setObject:@(-1) forKey:@"loopType"];// -1不循环
    }

    if (![cValue isEqualToString:@"0"] && !kStringIsEmpty(cValue)) {
        [parms setObject:[NSString stringWithFormat:@"%@", cValue] forKey:@"cValue"];
    }
    
    if (![time isEqualToString:@""]) {// 不设置定时就会立即开始
        [parms setObject:[NSString stringWithFormat:@"%@T%@:00.000Z",currentDate,time] forKey:@"expiryDate"];
    }
    
    if ([time isEqualToString:@""]) {
        [self controlCharge:parms action:YES];// 立即充电
    }else{
        [self controlCharge:parms action:NO];// 预约充电
    }
}

#pragma mark---充电记录
- (void)recordClick{
    NSNumber *auth = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth"];
    NSString *userName = [UserInfo defaultUserInfo].userName;
    if([auth isEqualToNumber:@1] && [userName isEqualToString:@"ceshi00701"]){// 浏览账户
        
        [self showToastViewWithTitle:root_zhanghu_meiyou_quanxian];
    }else{
        ChargeRecordVC *recordVC = [[ChargeRecordVC alloc]init];
        recordVC.sn = _deviceModel.chargeId;
        [self.navigationController pushViewController:recordVC animated:YES];
    }
}
#pragma mark---连接电桩
- (void)connectBtnClick{
    BluetoothConnectVC *blueboothVC = [[BluetoothConnectVC alloc]init];
    [self.navigationController pushViewController:blueboothVC animated:YES];
}


#pragma mark -- collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"EquipmentCollectionViewCell" forIndexPath:indexPath];
}
/// configure cell data
- (void)configureCell:(EquipmentCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    GRTChargingPileModel *model = object;
    if(indexPath.row < self.dataSource.count){
        if(!self.isBLE){
            [cell setCellTitle:[model.name isEqualToString:@""]||model.name == NULL ? model.chargeId : model.name withImage:@"charger_rukouye_icon" BgColor:COLOR(255, 255, 255, 0.1)];
            // cell点击变色
            UIView* selectedBGView = [[UIView alloc] initWithFrame:cell.bounds];
            selectedBGView.backgroundColor = COLOR(255, 255, 255, 0.4);
            cell.selectedBackgroundView = selectedBGView;
            if (indexPath.row == currentDevIndex) {// 根据之前的记录值，选中cell
                cell.selected = YES;
            }
        }
    }else{// 添加按键
        if(self.isBLE){// 蓝牙模式
            [cell setCellTitle:root_MAX_300 withImage:@"Bluetoothmode_switch" BgColor:COLOR(255, 255, 255, 0.1)];
        }else{
            [cell setCellTitle:HEM_tianjia withImage:@"add" BgColor:COLOR(255, 255, 255, 0.1)];
        }
    }
    cell.sn = model.chargeId;
    // 长按删除充电桩
    cell.longTouchDeleteWithCharge = ^(NSString *sn) {
        [self removeAlert:sn];
    };
}
// did cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.dataSource.count){
        if (!self.isBLE) {
            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:currentDevIndex inSection:0];
            EquipmentCollectionViewCell *oldCell = (EquipmentCollectionViewCell *)[collectionView cellForItemAtIndexPath:oldIndexPath];
            oldCell.selected = NO;// 手动清除上一次选中的cell状态
            
            currentDevIndex = indexPath.row;
            self.deviceModel = self.dataSource[indexPath.row];
            currentConnectorId = 1;// 切换充电桩时,获取的充电枪编码默认为1
            _dropdownListView.selectedIndex = 0; // 默认第一个枪
            [self getChargingPileInfomation:self.deviceModel];
            [self setButtonBackgroundColor];
        }
    }else{
        if (self.isBLE) {
            [self connectBtnClick];// 连接，切换充电桩
        }else{
            [self addBtnClick];// 添加设备
        }
    }
}


// 删除提示
- (void)removeAlert:(NSString *)sn{
    UIAlertController *removeAlert = [UIAlertController alertControllerWithTitle:root_shifou_shanchu_shebei message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *enter = [UIAlertAction actionWithTitle:root_OK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteCharging:sn];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:root_cancel style:UIAlertActionStyleCancel handler:nil];
    [removeAlert addAction:enter];
    [removeAlert addAction:cancel];
    [self presentViewController:removeAlert animated:YES completion:nil];
}

#pragma mark -- Http request
// 获取充电桩列表
- (void)getChargingpileList{
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced] GetChargingPileListWithUserId:[UserInfo defaultUserInfo].userName success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideProgressView];
            if ([obj[@"code"] isEqualToNumber:@0]) {
                [self.scrollView.mj_header endRefreshing];
                NSDictionary *dict = [obj[@"data"] mutableCopy];
                weakSelf.dataSource = [GRTChargingPileModel objectArrayWithKeyValuesArray:dict];
                [weakSelf.devCollectView reloadData];
                if (weakSelf.dataSource.count != 0) {// 获取当前设备获取详细信息
                    weakSelf.deviceModel = weakSelf.dataSource[self->currentDevIndex];
                    self->currentConnectorId = 1;// 获取的充电枪编码默认为1
                    [weakSelf getChargingPileInfomation:weakSelf.dataSource[self->currentDevIndex]];
                    [weakSelf setButtonBackgroundColor];
                }
            }
        });
    } failure:^(id error) {
        [weakSelf hideProgressView];
    }];
}
// 获取充电桩详细信息
- (void)getChargingPileInfomation:(GRTChargingPileModel *)model{
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced] GetChargingPileInfoWithSn:model.chargeId connectorId:@(currentConnectorId) userId:model.userId success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideProgressView];
            if ([obj[@"code"] isEqualToNumber:@0]) {
                [weakSelf reloadUIView:obj];
                
                // 由于新增预约状态，不需要通过上次操作进行其他判断了
//                if (self->isRefreshOrder && [weakSelf.InfoModel.LastAction[@"action"] isEqualToString:@"ReserveNow"] && ([obj[@"data"][@"status"] isEqualToString:@"Available"] || [obj[@"data"][@"status"] isEqualToString:@"Preparing"] || [obj[@"data"][@"status"] isEqualToString:@"Reserved"]) ) {// 判断是否允许刷新,并且上次操作为预定操作
//                    [weakSelf getChargingPileReserveNow:model type:@"ReserveNow"];// 获取预设信息
//                }
                
                if (![weakSelf.InfoModel.LastAction isKindOfClass:[NSDictionary class]] || weakSelf.InfoModel.LastAction == NULL) {
                    [weakSelf getChargingPileReserveNow:model type:@"ReserveNow"];// 在第一次登陆的时候缺少操作记录，获取预设信息
                }
                
                // 由于新增预约状态，不需要通过上次操作进行其他判断了
//                [weakSelf getChargingPileReserveNow:model type:@"LastAction"];// 获取最后一次操作信息
            }
        });
    } failure:^(NSError *error) {
        [weakSelf hideProgressView];
    }];
}
// 获取充电预订信息， 获取充电最后一次操作信息信息
- (void)getChargingPileReserveNow:(GRTChargingPileModel *)model type:(NSString *)type{
    __weak typeof(self) weakSelf = self;
    [[DeviceManager shareInstenced] getChargeReserveNowAndLastActionWithSn:model.chargeId userId:model.userId ConnectorId:@(currentConnectorId) type:type success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([obj[@"code"] isEqualToNumber:@0]) {
                if ([type isEqualToString:@"ReserveNow"]) {
                    weakSelf.ReserveNowArray = obj[@"data"];
                    if ([weakSelf.ReserveNowArray isKindOfClass:[NSArray class]]) {
                        if(weakSelf.ReserveNowArray.count > 0){
                            weakSelf.InfoModel.ReserveNow = weakSelf.ReserveNowArray;
                            weakSelf.stateView.model = weakSelf.InfoModel;
                        }
                    }
                }else if ([type isEqualToString:@"LastAction"]){
                    weakSelf.LastActionDict = obj[@"data"];
                    if ([weakSelf.LastActionDict isKindOfClass:[NSDictionary class]]) { // 保护判断
                        if(weakSelf.LastActionDict.allKeys.count > 0){
                            weakSelf.InfoModel.LastAction = weakSelf.LastActionDict;
                            weakSelf.stateView.model = weakSelf.InfoModel;
                        }
                    }
                }
            }
        });
    } failure:^(NSError *error) {
    }];
}
// 添加方案预订,开始充电
- (void)controlCharge:(NSDictionary *)parms action:(BOOL)isRemote{
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced] addChargeTimingWithParms:parms success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([obj[@"code"] isEqualToNumber:@0] || [obj[@"code"] isEqualToNumber:@15] || [obj[@"code"] isEqualToNumber:@16]) {
                if(isRemote){
                    [weakSelf Refresh_frequency_Times_Action:isRemote];
                }else{
                    [weakSelf getChargingPileInfomation:self->_deviceModel];
                }
            }else{
                [weakSelf hideProgressView];
            }
            [weakSelf showToastViewWithTitle:obj[@"data"]];
        });
    } failure:^(id error) {
        [weakSelf hideProgressView];
    }];
}
// 删除充电桩
- (void)deleteCharging:(NSString *)sn{
    
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced] DeleteAuthorChargingPileWithSn:sn userId:[UserInfo defaultUserInfo].userName success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideProgressView];
            if ([obj[@"code"] isEqualToNumber:@0]) {
                [weakSelf getChargingpileList];
                [weakSelf showToastViewWithTitle:root_shanchu_chenggong];
            }else{
                [weakSelf showToastViewWithTitle:obj[@"data"]];
            }
        });
    } failure:^(NSError *error) {
        [weakSelf hideProgressView];
    }];
}
// 设置充电桩solar值
- (void)setChargeSolar:(NSNumber *)state{
    
    __weak typeof(self) weakSelf = self;
//    [self showProgressView];
//    [[DeviceManager shareInstenced] setChargeSolarWithSn:_deviceModel.chargeId userId:[UserInfo defaultUserInfo].userName solar:state success:^(id obj) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf hideProgressView];
//            if ([obj[@"code"] isEqualToNumber:@0]) {
//                [weakSelf showToastViewWithTitle:root_shezhi_chenggong];
//                weakSelf.deviceModel.solar = @(![weakSelf.deviceModel.solar integerValue]);
//            }else{
//                [weakSelf showToastViewWithTitle:obj[@"data"]];
//                [weakSelf setButtonBackgroundColor];
//            }
//        });
//    } failure:^(NSError *error) {
//        [weakSelf hideProgressView];
//        [weakSelf showToastViewWithTitle:root_shezhi_shibai];
//    }];
    
    NSMutableDictionary *setInfoDict = [[NSMutableDictionary alloc]init];
    [setInfoDict setObject:[UserInfo defaultUserInfo].userName forKey:@"userId"];
    [setInfoDict setObject:self.deviceModel.chargeId forKey:@"chargeId"];
    [setInfoDict setObject:[NSString stringWithFormat:@"%ld", (long)[state integerValue]] forKey:@"G_SolarMode"];
    
    NSLog(@"_setInfoDict： %@", setInfoDict);
    [self showProgressView];
    [[DeviceManager shareInstenced] setChargeoConfigInfomationWithParms:setInfoDict success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideProgressView];
            if ([obj[@"code"] isEqualToNumber:@0]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 刷新电桩列表
                    [weakSelf getChargingpileList];
                });
            }else{
                // 设置失败,还原按键状态
                [self setButtonBackgroundColor];
            }
            [weakSelf showToastViewWithTitle:obj[@"data"]];
        });
    } failure:^(NSError *error) {
        [weakSelf hideProgressView];
        [self setButtonBackgroundColor]; // 还原按键状态
    }];
}

// 更新预约、注销、删除预约
- (void)updateChargeTiming{
    
    NSArray *ReserveNow = _InfoModel.ReserveNow;
    if ([ReserveNow isKindOfClass:[NSArray class]]) { // 考虑到有多条定时的情况，每条都要关闭
        for (int i = 0; i < ReserveNow.count; i++) {
            NSDictionary *dict = ReserveNow[i];
            
            NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
            parms[@"sn"] = dict[@"chargeId"];
            parms[@"userId"] = dict[@"userId"];
            parms[@"reservationId"] = dict[@"reservationId"];
            parms[@"connectorId"] = dict[@"connectorId"];
            parms[@"cKey"] = dict[@"cKey"];
            parms[@"cValue"] = dict[@"cValue"];
            
            // 更新日期
            NSString *expiryDate = dict[@"expiryDate"];
            NSDateFormatter *dateformat = [[NSDateFormatter alloc]init];
            [dateformat setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [dateformat stringFromDate:[NSDate date]];
            parms[@"expiryDate"] = [NSString stringWithFormat:@"%@%@",dateString, [expiryDate substringWithRange:NSMakeRange(10, expiryDate.length-10)]];
            parms[@"ctype"] = @"2";// 关闭
            parms[@"loopValue"] = @(-1); // 取消每天
            
            __weak typeof(self) weakSelf = self;
            [self showProgressView];
            [[DeviceManager shareInstenced] updateChargeTimingWithParms:parms success:^(id obj) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf hideProgressView];
                    if ([obj[@"code"] isEqualToNumber:@0]) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    [weakSelf showToastViewWithTitle:obj[@"data"]];
                    // 更新当前充电枪
                    [weakSelf getChargingPileInfomation:self->_deviceModel];
                });
            } failure:^(id error) {
                [weakSelf hideProgressView];
            }];
        }
    }
}

#pragma mark -- 刷新控件操作
- (void)reloadUIView:(NSDictionary *)dict0{
    NSDictionary *dict = [dict0[@"data"] mutableCopy];
    ChargingpileInfoModel *model = [ChargingpileInfoModel objectWithKeyValues:dict];
    if(!model)return;
    if ([self.LastActionDict isKindOfClass:[NSDictionary class]]) { // 最后一次操作
        if(self.LastActionDict.allKeys.count > 0){
            model.LastAction = self.LastActionDict;
        }
    } else{
        model.LastAction = NULL;
    }
    if ([self.ReserveNowArray isKindOfClass:[NSArray class]]) { // 预约信息
        if(self.ReserveNowArray.count > 0){
            model.ReserveNow = self.ReserveNowArray;
        }
    } else{
        model.ReserveNow = NULL;
    }
    self.InfoModel = model;
    
    _modelLabel.text = [NSString stringWithFormat:@"%@ | %@",[_deviceModel getmodel], [_deviceModel getConnectors]];// 类型
    _statusLB.text = [model getCurrentStatus];// 状态
    self.openBtn.selected = NO; // 切换充电桩时默认按键状态
    // 图片,状态
    if ([model.status isEqualToString:@"Faulted"]) {// 故障
        
        _chargeImageView.image = IMAGE(@"Charging_fault");
        _statusLB.textColor = COLOR(245, 50, 50, 1);
    }else if([model.status isEqualToString:@"Unavailable"] || [model.status isEqualToString:@"SuspendedEV"] || [model.status isEqualToString:@"SuspendedEVSE"]){// 不可用
        
        _chargeImageView.image = IMAGE(@"Charging_no_use");
        _statusLB.textColor = COLOR(136, 136, 136, 1);
    }else{// 其他
        
        _chargeImageView.image = IMAGE(@"Charging_norm");
        _statusLB.textColor = COLOR(48, 229, 120, 1);
    }
    
    
    // 转动图片
    if([model.status isEqualToString:@"Charging"]){// 充电中
        
        _stateImageView.image = IMAGE(@"Charging_roll");
        if (![_stateImageView.layer.animationKeys[0] isEqualToString:@"rotate"]) {// 判断是否存在动画
            [self rotate];
        }
        [self.openBtn setTitle:HEM_tingzhichongdian forState:UIControlStateSelected];
        self.openBtn.selected = YES;// 按键变为停止充电状态
    }else if([model.status isEqualToString:@"Finishing"]){// 充电结束
        
        _stateImageView.image = IMAGE(@"Charging_roll_finish");
        [_stateImageView.layer removeAllAnimations];// 移除动画
        [self.openBtn setTitle:HEM_tingzhichongdian forState:UIControlStateSelected];
        self.openBtn.selected = YES;// 按键变为停止充电状态
        
    }else if([model.status isEqualToString:@"Reserved"] || [model.status isEqualToString:@"Accepted"] || [model.status isEqualToString:@"ReserveNow"]){// 预约状态
        // 变为取消预约按键
        [self.openBtn setTitle:root_quxiaoyuyue forState:UIControlStateSelected];
        self.openBtn.selected = YES;
    }else{
        
        _stateImageView.image = IMAGE(@"隐藏图片");
        [_stateImageView.layer removeAllAnimations];
    }
    
    _stateView.userType = _deviceModel.type;// 判断电桩权限  0-桩主, 1-授权用户
    
    if([model.status isEqualToString:@"Available"] || [model.status isEqualToString:@"Preparing"]){// 空闲或者准备中  || [model.status isEqualToString:@"Reserved"]
        
        [self removeTimedRefresh];//移除定时刷新
        if (isRefreshOrder) {
            _stateView.model = self.InfoModel;// 赋值状态
        }
        
        if ([orderType isEqualToString:@"stop"]) {// 判断当前发送控制指令的类型
            [self hideProgressView];
            orderType = @""; // 清空
        }
    }else{
        if(_distimer){
            dispatch_source_cancel(_distimer);// 停止快速刷新
            _distimer = NULL;
        }

        if (!self.timer) {
            [self addTimedRefresh];// 添加定时刷新
        }
        
        if ([orderType isEqualToString:@"start"] || ([orderType isEqualToString:@"stop"] && [model.status isEqualToString:@"Charging"]) || ([orderType isEqualToString:@"stop"] && [model.status isEqualToString:@"Finishing"]) ) {// 判断当前发送控制指令的类型
            [self hideProgressView];
            orderType = @""; // 清空
        }
        
        _stateView.model = self.InfoModel;// 赋值状态
    }
    // 电枪数
    NSMutableArray *items = [NSMutableArray array];
    NSArray *nameArray = [_deviceModel getConnectorsNameArray];
    for (int i = 0; i < nameArray.count; i++) {
        EBDropdownListItem *item = [[EBDropdownListItem alloc]initWithItem:@"" itemName:nameArray[i]];
        [items addObject:item];
    }
    _dropdownListView.dataSource = items;
    
    setValue1 = [NSString stringWithFormat:@"%@", dict[@"ReserveNow"][0][@"cValue"]];
}

// 切换 蓝牙<-->远程
- (void)barButtonPress:(UIButton *)button{
    
    button.selected = !button.isSelected;
    self.isBLE = !self.isBLE;
    if (!self.isBLE) {
        [self animationWithView:self.view WithAnimationTransition:UIViewAnimationTransitionFlipFromRight];// 右翻转
    }else{
        [self animationWithView:self.view WithAnimationTransition:UIViewAnimationTransitionFlipFromLeft];// 左翻转
    }
}

#pragma UIView动画实现
- (void) animationWithView:(UIView *)view WithAnimationTransition:(UIViewAnimationTransition)transition
{
    [UIView animateWithDuration:1.0f animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:transition forView:view cache:YES];
        [self.devCollectView reloadData];
        if (self.isBLE) {

            self.deleteBtn.hidden = YES;
            self.connectBtn.hidden = NO;
        }else{

            self.deleteBtn.hidden = NO;
            self.connectBtn.hidden = YES;
        }
    }];
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
    [_stateImageView.layer addAnimation:animation forKey:@"rotate"];
}


#pragma mark -- ChargingStateDelegate
// 选择预设方案设置数值回调
- (void)ChargingStatePresetValueWithProgramme:(NSString *)programme{
    
    PresetChargeViewController *presetVC = [[PresetChargeViewController alloc]init];
    presetVC.programme = programme;
    [self.navigationController pushViewController:presetVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    // 返回预设值
    presetVC.returnPresetValueAndprogramme = ^(NSString * _Nonnull value, NSString * _Nonnull vluae2, NSString * _Nonnull programme) {
        // 设置方案预设值
        [weakSelf.stateView setProgrammeWithValue:value Value2:vluae2 programme:programme];
        self->setValue1 = value; // 记录预设值
        self->setValue2 = vluae2;
    };
}

// 点击预约充电的按键回调 - type-0 时间列表按键   type-1 switch按键
- (void)ChargingTimingList:(NSString *)type{
    
    if ([_stateView.currentPrograme isEqualToString:@"Time"] && (_stateView.switchButton.isOn || [type isEqualToString:@"0"])) {// 当勾选了时长的时候，点击点击switch将跳转到定时列表页面
        
        TimingListViewController *TimingVC = [[TimingListViewController alloc]init];
        TimingVC.sn = self.deviceModel.chargeId;
        TimingVC.connectorId = @(currentConnectorId);
        [self.navigationController pushViewController:TimingVC animated:YES];
    }else if (!_stateView.switchButton.isOn){
        
    }else{
        
        PickerViewAlert *palert = [[PickerViewAlert alloc]init];
        [palert show];
        __weak typeof(self) weakSelf = self;
        palert.touchEnterBlock = ^(NSString *value, NSString *value2) {// 更改显示
            [weakSelf.stateView setTimeButtonWithTitle:[NSString stringWithFormat:@"%@:%@",value,value2]];
        };
    }
    
}

// 切换三种方案时回调
- (void)SelectChargingProgramme:(NSString *)programme{
    
    setValue1 = @""; // 清空记录预设值
    setValue2 = @"";
}

#pragma mark -- 通知notification
// 从 添加充电桩页面 返回时去刷新列表
- (void)reloadWithChargeList:(NSNotification *)notification{
    
    [self getChargingpileList];
}

// 从 定时列表 返回时刷新当前充电枪的定时数据
- (void)reloadWithCharginConnectorNumInfo:(NSNotification *)notification{
    
    if (_deviceModel) {
        // 更新当前充电枪
        [self getChargingPileInfomation:_deviceModel];
    }
}

#pragma mark -- 定时刷新

// 添加定时刷新
- (void)addTimedRefresh{
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        weakSelf.timer = [NSTimer timerWithTimeInterval:10.0f       // 10秒刷新
                                                 target:weakSelf
                                               selector:@selector(TimeredRefresh) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:weakSelf.timer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
    });
}
// 定时刷新
- (void)TimeredRefresh{
    if (_deviceModel) {
        // 更新当前充电枪
        __weak typeof(self) weakSelf = self;
        [[DeviceManager shareInstenced] GetChargingPileInfoWithSn:_deviceModel.chargeId connectorId:@(currentConnectorId) userId:_deviceModel.userId success:^(id obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([obj[@"code"] isEqualToNumber:@0]) {
                    NSLog(@"定时刷新中...");
                    
                    [weakSelf reloadUIView:obj];
                    // 处于预约状态，定时刷新也需要获取预约信息
                    if ([weakSelf.InfoModel.status isEqualToString:@"Reserved"] || [weakSelf.InfoModel.status isEqualToString:@"Accepted"] || [weakSelf.InfoModel.status isEqualToString:@"ReserveNow"]) {
                        [weakSelf getChargingPileReserveNow:self->_deviceModel type:@"ReserveNow"];// 获取预设信息
                    }
                    self->isRefreshOrder = YES;
                }
            });
        } failure:^(NSError *error) {
        }];
    }
}

// 移除定时刷新
- (void)removeTimedRefresh{
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
// 定时快速刷新,刷出状态后会停止
- (void)Refresh_frequency_Times_Action:(BOOL)isRemote{
    
    __weak typeof(self) weakSelf = self;
    __block int num = 0 ;
    NSTimeInterval period = 1.0; //设置时间间隔
    int frequency = 30; // 刷新次数
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _distimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_distimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_distimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"第%d次刷新", num+1) ;
            self->isRefreshOrder = !isRemote;// 根据是否远程充电的指令判断，下次刷新时能不能刷出定时数据
            [weakSelf TimeredRefresh];
            num ++ ;
            if(num == 15){
                [self hideProgressView];
                self->orderType = @""; // 清除指令
            }
            
            if (num == frequency) {
                dispatch_source_cancel(self->_distimer);
                self->_distimer = NULL;
            }
        }) ;
    });
    dispatch_resume(_distimer);
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    // 取消定时
    [self removeTimedRefresh];    

}

@end
