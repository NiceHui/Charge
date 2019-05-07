//
//  HSWiFiChargeSettingVC.m
//  charge
//
//  Created by growatt007 on 2019/3/29.
//  Copyright © 2019 hshao. All rights reserved.
//

#import "HSWiFiChargeSettingVC.h"
#import "HSTCPWiFiManager.h"
#import "EWOptionItem.h"
#import "EWOptionArrowItem.h"
#import "InputSettingAlert.h"
#import "HSBluetoochHelper.h"
#import "SelectTimeAlert.h"

@interface HSWiFiChargeSettingVC ()<InputSettingDelegate, HSTCPWiFiManagerDelegate>{
    NSInteger tryNum; // 尝试重连次数
    BOOL isSucc;
}

@property (nonatomic, strong) HSTCPWiFiManager *wifiManager;

@property (nonatomic, strong) EWOptionItem *IDItem;
// 设备信息参数
@property (nonatomic, strong) EWOptionArrowItem *name_item; // 设备名称
@property (nonatomic, strong) EWOptionArrowItem *lan_item; // 语言
@property (nonatomic, strong) EWOptionArrowItem *secret_item; // 读卡器秘钥
@property (nonatomic, strong) EWOptionArrowItem *rcd_item; // RCD保护值 mA
// 设备以太网参数
@property (nonatomic, strong) EWOptionArrowItem *ip_item; // IP地址
@property (nonatomic, strong) EWOptionArrowItem *gateway_item; // 网关
@property (nonatomic, strong) EWOptionArrowItem *mask_item; // 掩码
@property (nonatomic, strong) EWOptionArrowItem *mac_item; // MAC
@property (nonatomic, strong) EWOptionArrowItem *dns_item; // DNS
// 设备账号密码参数
@property (nonatomic, strong) EWOptionArrowItem *ssid_item; // WIFI SSID
@property (nonatomic, strong) EWOptionArrowItem *key_item; // WIFI key
@property (nonatomic, strong) EWOptionArrowItem *buletouch_ssid_item; // 蓝牙名称
@property (nonatomic, strong) EWOptionArrowItem *buletouch_key_item; // 蓝牙密码
@property (nonatomic, strong) EWOptionArrowItem *fourG_ssid_item; // 4G用户名
@property (nonatomic, strong) EWOptionArrowItem *fourG_key_item; // 4G密码
@property (nonatomic, strong) EWOptionArrowItem *fourG_apn_item; // 4G APN
// 设备服务器参数
@property (nonatomic, strong) EWOptionArrowItem *url_item; // URL地址
@property (nonatomic, strong) EWOptionArrowItem *login_key_item; // 握手登录授权秘钥
@property (nonatomic, strong) EWOptionArrowItem *heartbeat_time_item; // 心跳间隔时间   单位秒
@property (nonatomic, strong) EWOptionArrowItem *ping_time_item; // PING间隔时间   单位秒
@property (nonatomic, strong) EWOptionArrowItem *upload_time_item; // 表计上传间隔时间    单位秒
// 设备充电参数
@property (nonatomic, strong) EWOptionArrowItem *mode_item; // 充电模式
@property (nonatomic, strong) EWOptionArrowItem *max_current_item; // 电桩最大输出电流，A
@property (nonatomic, strong) EWOptionArrowItem *rate_item; // 充电费率，10.5（0~5000）
@property (nonatomic, strong) EWOptionArrowItem *protection_temp_item; // 保护温度，℃
@property (nonatomic, strong) EWOptionArrowItem *max_input_power_item; // 外部监测最大输入功率，KW
@property (nonatomic, strong) EWOptionArrowItem *allow_time_item; // 允许充电时间“22:00-03:30”

@property (nonatomic, strong) InputSettingAlert *inputAlert;
@property (nonatomic, strong) SelectTimeAlert *timeAlert;

@property (nonatomic, strong) NSMutableDictionary *baseInfo; // 电桩基本参数
@property (nonatomic, strong) NSMutableDictionary *netWorkInfo; // 以太网
@property (nonatomic, strong) NSMutableDictionary *accountInfo; // 账户密码
@property (nonatomic, strong) NSMutableDictionary *serverInfo; // 服务器
@property (nonatomic, strong) NSMutableDictionary *chargeInfo; // 充电参数

@end

@implementation HSWiFiChargeSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = HEM_zhuangtishezhi;
    
    // 建立连接
//    [[HSTCPWiFiManager instance] connectToHost:self.devData[@"ip"]];
    [HSTCPWiFiManager instance].delegate = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showProgressView];
        self->isSucc = NO;
        [[HSTCPWiFiManager instance] connectToDev:[HSBluetoochHelper dataWithString:self.devData[@"devName"] length:20]];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 硬件在刚建立通信指令发送可能无效，时间大概是3秒
        if (self->isSucc) {
            return ;
        }
        [self showProgressView];
        [[HSTCPWiFiManager instance] connectToDev:[HSBluetoochHelper dataWithString:self.devData[@"devName"] length:20]];
    });
    
    [self setupAlert];
    [self createUIView];
    
    tryNum = 0;
    
}

// alert
- (void)setupAlert{
    
    self.inputAlert = [[InputSettingAlert alloc] init];
    self.inputAlert.delegate = self;
    
    self.timeAlert = [[SelectTimeAlert alloc]init];
    __weak typeof(self) weakSelf = self;
    self.timeAlert.touchAlertEnter = ^(NSString * _Nonnull text) {
        [weakSelf.chargeInfo setObject:text forKey:@"allow_time"];
        [[HSTCPWiFiManager instance] setDeviceChargeInfo:weakSelf.chargeInfo];
    };
}

- (void)createUIView{
    
    __weak typeof(self) weakSelf = self;
    MJRefreshHeader *header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self showProgressView];
        self->isSucc = NO;
        [[HSTCPWiFiManager instance] connectToDev:[HSBluetoochHelper dataWithString:self.devData[@"devName"] length:20]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideProgressView];
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
    self.tableView.mj_header = header;
    
    EWOptionGroup *group1 = [[EWOptionGroup alloc]init];// 设备信息参数
    EWOptionGroup *group2 = [[EWOptionGroup alloc]init];// 设备以太网参数
    EWOptionGroup *group3 = [[EWOptionGroup alloc]init];// 设备账号密码参数
    EWOptionGroup *group4 = [[EWOptionGroup alloc]init];// 设备服务器参数
    EWOptionGroup *group5 = [[EWOptionGroup alloc]init];// 设备充电参数
    
#pragma mark -- 设备信息参数设置
    // ID
    EWOptionItem *IDItem = [EWOptionItem itemWithTitle:HEM_charge_id detailTitle:self.devData[@"devName"]];
    _IDItem = IDItem;
    
    EWOptionArrowItem *name_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_mingcheng detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.baseInfo[@"name"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.baseInfo[@"name"]];
        }
        weakSelf.inputAlert.itemText = @"name";
        weakSelf.inputAlert.titleText = HEM_charge_mingcheng;
    }];
    _name_item = name_item;
    // 语言
    EWOptionArrowItem *lan_item = [EWOptionArrowItem arrowItemWithTitle:root_yuyan detailTitle:@"--" didClickBlock:^{
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:root_zhongwen style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self->isSucc == NO) { // 连接命令失败， 获取值失败，不让用户进行设置
                [self showToastViewWithTitle:root_shezhi_shibai];
                return;
            }
            [self.baseInfo setObject:@"1" forKey:@"lan"];
            [[HSTCPWiFiManager instance] setDeviceBaseInfo:self.baseInfo];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:root_taiwen style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self->isSucc == NO) { // 连接命令失败， 获取值失败，不让用户进行设置
                [self showToastViewWithTitle:root_shezhi_shibai];
                return;
            }
            [self.baseInfo setObject:@"2" forKey:@"lan"];
            [[HSTCPWiFiManager instance] setDeviceBaseInfo:self.baseInfo];
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:root_yingwen style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self->isSucc == NO) { // 连接命令失败， 获取值失败，不让用户进行设置
                [self showToastViewWithTitle:root_shezhi_shibai];
                return;
            }
            [self.baseInfo setObject:@"3" forKey:@"lan"];
            [[HSTCPWiFiManager instance] setDeviceBaseInfo:self.baseInfo];
        }];
        UIAlertAction *action4 = [UIAlertAction actionWithTitle:root_cancel style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:root_yuyan message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        [actionSheet addAction:action3];
        [actionSheet addAction:action4];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }];
    _lan_item = lan_item;
    // 读卡器秘钥
    EWOptionArrowItem *secret_item = [EWOptionArrowItem arrowItemWithTitle:root_dukaiqi_miyao detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.baseInfo[@"secret"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.baseInfo[@"secret"]];
        }
        weakSelf.inputAlert.itemText = @"secret";
        weakSelf.inputAlert.titleText = root_dukaiqi_miyao;
    }];
    _secret_item = secret_item;
    // RCD保护值 mA
    EWOptionArrowItem *rcd_item = [EWOptionArrowItem arrowItemWithTitle:root_rcd_baohuzhi detailTitle:@"--" didClickBlock:^{
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:root_rcd_baohuzhi message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (int i = 1 ; i <= 9; i++) {
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%d %@",i ,root_dengji] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (self->isSucc == NO) { // 连接命令失败， 获取值失败，不让用户进行设置
                    [self showToastViewWithTitle:root_shezhi_shibai];
                    return;
                }
                [self.baseInfo setObject:[NSString stringWithFormat:@"%d",i] forKey:@"rcd"];
                [[HSTCPWiFiManager instance] setDeviceBaseInfo:self.baseInfo];
            }];
            [actionSheet addAction:action1];
        }
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:root_cancel style:UIAlertActionStyleCancel handler:nil];
        [actionSheet addAction:cancel];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }];
    _rcd_item = rcd_item;
    group1.headerTitle = root_canshushezhi_1;
    group1.items = @[IDItem, lan_item, secret_item, rcd_item];
    
    
#pragma mark -- 设备以太网参数设置
    
    EWOptionArrowItem *ip_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_ip detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.netWorkInfo[@"IP"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.netWorkInfo[@"IP"]];
        }
        weakSelf.inputAlert.itemText = @"IP";
        weakSelf.inputAlert.titleText = HEM_charge_ip;
    }];
    _ip_item = ip_item;
    
    EWOptionArrowItem *gateway_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_wangguang detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.netWorkInfo[@"gateway"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.netWorkInfo[@"gateway"]];
        }
        weakSelf.inputAlert.itemText = @"gateway";
        weakSelf.inputAlert.titleText = HEM_charge_wangguang;
        
    }];
    _gateway_item = gateway_item;
    
    EWOptionArrowItem *mask_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_yanma detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.netWorkInfo[@"mask"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.netWorkInfo[@"mask"]];
        }
        weakSelf.inputAlert.itemText = @"mask";
        weakSelf.inputAlert.titleText = HEM_charge_yanma;
        
    }];
    _mask_item = mask_item;
    
    EWOptionArrowItem *mac_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_mac detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.netWorkInfo[@"mac"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.netWorkInfo[@"mac"]];
        }
        weakSelf.inputAlert.itemText = @"mac";
        weakSelf.inputAlert.titleText = HEM_charge_mac;
        
    }];
    _mac_item = mac_item;
    
    EWOptionArrowItem *dns_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_dns detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.netWorkInfo[@"dns"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.netWorkInfo[@"dns"]];
        }
        weakSelf.inputAlert.itemText = @"dns";
        weakSelf.inputAlert.titleText = HEM_charge_dns;
        
    }];
    _dns_item = dns_item;
    
    group2.headerTitle = root_canshushezhi_2;
    group2.items = @[ip_item, gateway_item, mask_item, mac_item, dns_item];
    
    
#pragma mark -- 设备账号密码参数设置
    
    EWOptionArrowItem *ssid_item = [EWOptionArrowItem arrowItemWithTitle:root_wifi_ssid detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.accountInfo[@"wifi_ssid"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.accountInfo[@"wifi_ssid"]];
        }
        weakSelf.inputAlert.itemText = @"wifi_ssid";
        weakSelf.inputAlert.titleText = root_wifi_ssid;
    }];
    _ssid_item = ssid_item;
    
    EWOptionArrowItem *key_item = [EWOptionArrowItem arrowItemWithTitle:root_wifi_key detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.accountInfo[@"wifi_key"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.accountInfo[@"wifi_key"]];
        }
        weakSelf.inputAlert.itemText = @"wifi_key";
        weakSelf.inputAlert.titleText = root_wifi_key;
    }];
    _key_item = key_item;

    EWOptionArrowItem *buletouch_ssid_item = [EWOptionArrowItem arrowItemWithTitle:root_buletouch_ssid detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.accountInfo[@"buletouch_ssid"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.accountInfo[@"buletouch_ssid"]];
        }
        weakSelf.inputAlert.itemText = @"buletouch_ssid";
        weakSelf.inputAlert.titleText = root_buletouch_ssid;
    }];
    _buletouch_ssid_item = buletouch_ssid_item;
    
    EWOptionArrowItem *buletouch_key_item = [EWOptionArrowItem arrowItemWithTitle:root_buletouch_key detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.accountInfo[@"buletouch_key"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.accountInfo[@"buletouch_key"]];
        }
        weakSelf.inputAlert.itemText = @"buletouch_key";
        weakSelf.inputAlert.titleText = root_buletouch_key;
    }];
    _buletouch_key_item = buletouch_key_item;
    
    EWOptionArrowItem *fourG_ssid_item = [EWOptionArrowItem arrowItemWithTitle:root_fourG_ssid detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.accountInfo[@"fourG_ssid"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.accountInfo[@"fourG_ssid"]];
        }
        weakSelf.inputAlert.itemText = @"fourG_ssid";
        weakSelf.inputAlert.titleText = root_fourG_ssid;
    }];
    _fourG_ssid_item = fourG_ssid_item;
    
    EWOptionArrowItem *fourG_key_item = [EWOptionArrowItem arrowItemWithTitle:root_fourG_key detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.accountInfo[@"fourG_key"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.accountInfo[@"fourG_key"]];
        }
        weakSelf.inputAlert.itemText = @"fourG_key";
        weakSelf.inputAlert.titleText = root_fourG_key;
    }];
    _fourG_key_item = fourG_key_item;
    
    EWOptionArrowItem *fourG_apn_item = [EWOptionArrowItem arrowItemWithTitle:root_fourG_apn detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.accountInfo[@"fourG_apn"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.accountInfo[@"fourG_apn"]];
        }
        weakSelf.inputAlert.itemText = @"fourG_apn";
        weakSelf.inputAlert.titleText = root_fourG_apn;
    }];
    _fourG_apn_item = fourG_apn_item;
    
    group3.headerTitle = root_canshushezhi_3;
    group3.items = @[ssid_item, key_item, buletouch_ssid_item, buletouch_key_item, fourG_ssid_item, fourG_key_item, fourG_apn_item];
    
    
#pragma mark -- 设备服务器参数设置
    
    
    EWOptionArrowItem *url_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_url detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.serverInfo[@"url"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.serverInfo[@"url"]];
        }
        weakSelf.inputAlert.itemText = @"url";
        weakSelf.inputAlert.titleText = HEM_charge_url;
    }];
    _url_item = url_item;
    
    EWOptionArrowItem *login_key_item = [EWOptionArrowItem arrowItemWithTitle:root_login_key detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.serverInfo[@"login_key"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.serverInfo[@"login_key"]];
        }
        weakSelf.inputAlert.itemText = @"login_key";
        weakSelf.inputAlert.titleText = root_login_key;
    }];
    _login_key_item = login_key_item;
    
    EWOptionArrowItem *heartbeat_time_item = [EWOptionArrowItem arrowItemWithTitle:root_heartbeat_time detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.serverInfo[@"heartbeat_time"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.serverInfo[@"heartbeat_time"]];
        }
        weakSelf.inputAlert.itemText = @"heartbeat_time";
        weakSelf.inputAlert.titleText = root_heartbeat_time;
        weakSelf.inputAlert.PlaceholderText = @"(5~300)";
    }];
    _heartbeat_time_item = heartbeat_time_item;
    
    EWOptionArrowItem *ping_time_item = [EWOptionArrowItem arrowItemWithTitle:root_ping_time detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.serverInfo[@"ping_time"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.serverInfo[@"ping_time"]];
        }
        weakSelf.inputAlert.itemText = @"ping_time";
        weakSelf.inputAlert.titleText = root_ping_time;
        weakSelf.inputAlert.PlaceholderText = @"(5~300)";
    }];
    _ping_time_item = ping_time_item;
    
    EWOptionArrowItem *upload_time_item = [EWOptionArrowItem arrowItemWithTitle:root_upload_time detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.serverInfo[@"upload_time"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.serverInfo[@"upload_time"]];
        }
        weakSelf.inputAlert.itemText = @"upload_time";
        weakSelf.inputAlert.titleText = root_upload_time;
        weakSelf.inputAlert.PlaceholderText = @"(5~300)";
    }];
    _upload_time_item = upload_time_item;
    
    group4.headerTitle = root_canshushezhi_4;
    group4.items = @[url_item, login_key_item, heartbeat_time_item, ping_time_item, upload_time_item];
    
    
#pragma mark -- 设备充电参数设置
    
    
    EWOptionArrowItem *mode_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_moshi detailTitle:@"--" didClickBlock:^{
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:HEM_charge_model1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self->isSucc == NO) { // 连接命令失败， 获取值失败，不让用户进行设置
                [self showToastViewWithTitle:root_shezhi_shibai];
                return;
            }
            [self.chargeInfo setObject:@"1" forKey:@"mode"];
            [[HSTCPWiFiManager instance] setDeviceChargeInfo:self.chargeInfo];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:HEM_charge_model2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self->isSucc == NO) { // 连接命令失败， 获取值失败，不让用户进行设置
                [self showToastViewWithTitle:root_shezhi_shibai];
                return;
            }
            [self.chargeInfo setObject:@"2" forKey:@"mode"];
            [[HSTCPWiFiManager instance] setDeviceChargeInfo:self.chargeInfo];
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:HEM_charge_model3 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self->isSucc == NO) { // 连接命令失败， 获取值失败，不让用户进行设置
                [self showToastViewWithTitle:root_shezhi_shibai];
                return;
            }
            [self.chargeInfo setObject:@"3" forKey:@"mode"];
            [[HSTCPWiFiManager instance] setDeviceChargeInfo:self.chargeInfo];
        }];
        UIAlertAction *action4 = [UIAlertAction actionWithTitle:root_cancel style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:HEM_charge_moshi message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        [actionSheet addAction:action3];
        [actionSheet addAction:action4];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }];
    _mode_item = mode_item;
    
    EWOptionArrowItem *max_current_item = [EWOptionArrowItem arrowItemWithTitle:root_max_current detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.chargeInfo[@"max_current"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.chargeInfo[@"max_current"]];
        }
        weakSelf.inputAlert.itemText = @"max_current";
        weakSelf.inputAlert.titleText = root_max_current;
        
    }];
    _max_current_item = max_current_item;
    
    EWOptionArrowItem *rate_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_feilv detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.chargeInfo[@"rate"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.chargeInfo[@"rate"]];
        }
        weakSelf.inputAlert.itemText = @"rate";
        weakSelf.inputAlert.titleText = HEM_charge_feilv;
        weakSelf.inputAlert.PlaceholderText = @"(0~5000)";
    }];
    _rate_item = rate_item;
    
    EWOptionArrowItem *protection_temp_item = [EWOptionArrowItem arrowItemWithTitle:root_protection_temp detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.chargeInfo[@"protection_temp"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.chargeInfo[@"protection_temp"]];
        }
        weakSelf.inputAlert.itemText = @"protection_temp";
        weakSelf.inputAlert.titleText = root_protection_temp;
        weakSelf.inputAlert.PlaceholderText = @"(65~85)";
    }];
    _protection_temp_item = protection_temp_item;
    
    EWOptionArrowItem *max_input_power_item = [EWOptionArrowItem arrowItemWithTitle:root_max_input_power detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.chargeInfo[@"max_input_power"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.chargeInfo[@"max_input_power"]];
        }
        weakSelf.inputAlert.itemText = @"max_input_power";
        weakSelf.inputAlert.titleText = root_max_input_power;
    }];
    _max_input_power_item = max_input_power_item;
    
    EWOptionArrowItem *allow_time_item = [EWOptionArrowItem arrowItemWithTitle:root_allow_time detailTitle:@"--" didClickBlock:^{
        [weakSelf.timeAlert show];
        if (self.chargeInfo[@"allow_time"]) {
            weakSelf.timeAlert.selectTime = [NSString stringWithFormat:@"%@", self.chargeInfo[@"allow_time"]];
        }
        weakSelf.timeAlert.titleText = root_allow_time;
    }];
    _allow_time_item = allow_time_item;
    
    group5.headerTitle = root_canshushezhi_5;
    group5.items = @[mode_item, max_current_item, rate_item, protection_temp_item, max_input_power_item, allow_time_item];
    
    
    [self.groups addObject:group1];
    [self.groups addObject:group2];
    [self.groups addObject:group3];
    [self.groups addObject:group4];
    [self.groups addObject:group5];
    
    [self.tableView reloadData];
    
}

#pragma mark -- InputSettingDelegate
- (void)InputSettingWithPrams:(NSDictionary *)prams{
    
    if (self->isSucc == NO) { // 连接命令失败， 获取值失败，不让用户进行设置
        [self showToastViewWithTitle:root_shezhi_shibai];
        return;
    }
    
    NSString *key = prams.allKeys[0];
    NSString *regex = @"^(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|[1-9])\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)$";
    if([key isEqualToString:@"IP"] || [key isEqualToString:@"gateway"] || [key isEqualToString:@"mask"] || [key isEqualToString:@"dns"]){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isValid = [predicate evaluateWithObject:prams[key]];
        if(!isValid){// 判断输入的IP地址格式
            [self showToastViewWithTitle:root_geshi_cuowu];
            return;
        }
    }
    if ([key isEqualToString:@"heartbeat_time"] || [key isEqualToString:@"ping_time"] || [key isEqualToString:@"upload_time"] || [key isEqualToString:@"max_current"] || [key isEqualToString:@"protection_temp"] || [key isEqualToString:@"max_input_power"]) {
        // 判断是否为数字，只能为整数
        if(![NSString isNum2:prams[key]]){
            [self showToastViewWithTitle:root_geshi_cuowu];
            return;
        }
    }
    if ([key isEqualToString:@"rate"]) {
        // 判断是否为数字， 可以为小数
        if(![NSString isNum:prams[key]]){
            [self showToastViewWithTitle:root_geshi_cuowu];
            return;
        }
    }
    // 限制只能输入数字或字母
    NSString *regex2 = @"[a-z,0-9,A-Z]*";
    if([key isEqualToString:@"secret"] || [key isEqualToString:@"wifi_key"] || [key isEqualToString:@"buletouch_key"] ||  [key isEqualToString:@"fourG_key"] || [key isEqualToString:@"fourG_apn"] || [key isEqualToString:@"login_key"]){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
        BOOL isValid = [predicate evaluateWithObject:prams[key]];
        if (!isValid) {
            [self showToastViewWithTitle:root_geshi_cuowu];
            return;
        }
    }
    // 限制只能输入数字或字母和下划线空格
    NSString *regex3 = @"[a-z,0-9,A-Z,_, ,-]*";
    if([key isEqualToString:@"wifi_ssid"]|| [key isEqualToString:@"buletouch_ssid"] || [key isEqualToString:@"fourG_ssid"]){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex3];
        BOOL isValid = [predicate evaluateWithObject:prams[key]];
        if (!isValid) {
            [self showToastViewWithTitle:root_geshi_cuowu];
            return;
        }
    }
    // 超出范围 费率 (0-5000)
    if([key isEqualToString:@"rate"]){
        if ([prams[key] integerValue] < 0 || [prams[key] integerValue] > 5000) {
            [self showToastViewWithTitle:[NSString stringWithFormat:@"%@(0-5000)", root_chaochufanwei]];
            return;
        }
    }
    // 超出范围 时间 (5-300)
    if ([key isEqualToString:@"heartbeat_time"] || [key isEqualToString:@"ping_time"] || [key isEqualToString:@"upload_time"]){
        if ([prams[key] integerValue] < 5 || [prams[key] integerValue] > 300) {
            [self showToastViewWithTitle:[NSString stringWithFormat:@"%@(5-300)", root_chaochufanwei]];
            return;
        }
    }
    // 超出范围  温度（65-85）
    if ([key isEqualToString:@"protection_temp"]){
        if ([prams[key] integerValue] < 65 || [prams[key] integerValue] > 85) {
            [self showToastViewWithTitle:[NSString stringWithFormat:@"%@（65-85）", root_chaochufanwei]];
            return;
        }
    }
    // 超出范围 最大电流，最大功率 不能小于3
    if ([key isEqualToString:@"max_current"] || [key isEqualToString:@"max_input_power"]){
        if ([prams[key] integerValue] < 3) {
            [self showToastViewWithTitle:[NSString stringWithFormat:@"%@ 3", root_bunengxiaoyu]];
            return;
        }
    }
    
    // 设备信息参数设置  4
    if([key isEqualToString:@"name"] || [key isEqualToString:@"secret"] || [key isEqualToString:@"rcd"]){
        [self.baseInfo setObject:prams[key] forKey:key];
        [[HSTCPWiFiManager instance] setDeviceBaseInfo:self.baseInfo];
    }
    
    // 设置设备以太网参数  6
    if([key isEqualToString:@"IP"] || [key isEqualToString:@"gateway"] || [key isEqualToString:@"mask"] || [key isEqualToString:@"mac"] || [key isEqualToString:@"dns"]){
        [self.netWorkInfo setObject:prams[key] forKey:key];
        [[HSTCPWiFiManager instance] setDeviceNetWorkInfo:self.netWorkInfo];
    }
    
    // wifi设置  8
    if([key isEqualToString:@"wifi_ssid"] || [key isEqualToString:@"wifi_key"] || [key isEqualToString:@"buletouch_ssid"] || [key isEqualToString:@"buletouch_key"] || [key isEqualToString:@"fourG_ssid"] || [key isEqualToString:@"fourG_key"] || [key isEqualToString:@"fourG_apn"]){
        [self.accountInfo setObject:prams[key] forKey:key];
        [[HSTCPWiFiManager instance] setDevicePassInfo:self.accountInfo];
    }

    // 服务器参数设置  10
    if([key isEqualToString:@"url"] || [key isEqualToString:@"login_key"] || [key isEqualToString:@"heartbeat_time"] || [key isEqualToString:@"ping_time"] || [key isEqualToString:@"upload_time"]){
        [self.serverInfo setObject:prams[key] forKey:key];
        [[HSTCPWiFiManager instance] setDeviceServerInfo:self.serverInfo];
    }
    
    // 设备充电参数设置  12
    if([key isEqualToString:@"mode"] || [key isEqualToString:@"max_current"] || [key isEqualToString:@"rate"] || [key isEqualToString:@"protection_temp"] || [key isEqualToString:@"max_input_power"] || [key isEqualToString:@"allow_time"]){
        [self.chargeInfo setObject:prams[key] forKey:key];
        [[HSTCPWiFiManager instance] setDeviceChargeInfo:self.chargeInfo];
    }
}



#pragma mark -- HSTCPWiFiManagerDelegate   socket 回调

- (void)SocketConnectIsSucces:(BOOL)isSucces{}

- (void)TCPSocketReadData:(NSDictionary *)dataDic{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSInteger cmd = [[NSString stringWithFormat:@"%@", dataDic[@"cmd"]] integerValue];
        NSLog(@"TCPSocketReadData cmd: **%ld**", (long)cmd);
        
        if (cmd == 0x01) { // 获取设备信息参数 3
            
            self.name_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"name"] ? dataDic[@"name"] : @"--"];
            self.lan_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"lan"] ? dataDic[@"lan"] : @"--"];
            self.secret_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"secret"] ? dataDic[@"secret"] : @"--"];
            self.rcd_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"rcd"] ? dataDic[@"rcd"] : @"--"];
            if (dataDic[@"lan"]) {
                if ([[NSString stringWithFormat:@"%@", dataDic[@"lan"]] isEqualToString:@"1"]) {
                    self.lan_item.detailTitle = root_zhongwen;
                } else if ([[NSString stringWithFormat:@"%@", dataDic[@"lan"]] isEqualToString:@"2"]){
                    self.lan_item.detailTitle = root_taiwen;
                } else if ([[NSString stringWithFormat:@"%@", dataDic[@"lan"]] isEqualToString:@"3"]){
                    self.lan_item.detailTitle = root_yingwen;
                }
            }
            if (dataDic[@"rcd"]) {
                self.rcd_item.detailTitle = [NSString stringWithFormat:@"%d %@", [dataDic[@"rcd"] intValue], root_dengji];
            }

            self.baseInfo = [[NSMutableDictionary alloc]initWithDictionary:dataDic];
            [self.baseInfo removeObjectForKey:@"cmd"];
            
        } else if(cmd == 0x02){// 获取设备以太网参数 5
            
            self.ip_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"IP"] ? dataDic[@"IP"] : @"--"];
            self.gateway_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"gateway"] ? dataDic[@"gateway"] : @"--"];
            self.mask_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"mask"] ? dataDic[@"mask"] : @"--"];
            self.mac_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"mac"] ? dataDic[@"mac"] : @"--"];
            self.dns_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"dns"] ? dataDic[@"dns"] : @"--"];
            
            self.netWorkInfo = [[NSMutableDictionary alloc]initWithDictionary:dataDic];
            [self.netWorkInfo removeObjectForKey:@"cmd"];
            
        } else if(cmd == 0x03){// 获取设备以太网参数 7
            
            self.ssid_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"wifi_ssid"] ? dataDic[@"wifi_ssid"] : @"--"];
            self.key_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"wifi_key"] ? dataDic[@"wifi_key"] : @"--"];
            self.buletouch_ssid_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"buletouch_ssid"] ? dataDic[@"buletouch_ssid"] : @"--"];
            self.buletouch_key_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"buletouch_key"] ? dataDic[@"buletouch_key"] : @"--"];
            self.fourG_ssid_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"fourG_ssid"] ? dataDic[@"fourG_ssid"] : @"--"];
            self.fourG_key_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"fourG_key"] ? dataDic[@"fourG_key"] : @"--"];
            self.fourG_apn_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"fourG_apn"] ? dataDic[@"fourG_apn"] : @"--"];
            
            self.accountInfo = [[NSMutableDictionary alloc]initWithDictionary:dataDic];
            [self.accountInfo removeObjectForKey:@"cmd"];
            
        } else if(cmd == 0x04){// 获取服务器参数 9
            
            self.url_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"url"] ? dataDic[@"url"] : @"--"];
            self.login_key_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"login_key"] ? dataDic[@"login_key"] : @"--"];
            self.heartbeat_time_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"heartbeat_time"] ? dataDic[@"heartbeat_time"] : @"--"];
            self.ping_time_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"ping_time"] ? dataDic[@"ping_time"] : @"--"];
            self.upload_time_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"upload_time"] ? dataDic[@"upload_time"] : @"--"];
            
            self.serverInfo = [[NSMutableDictionary alloc]initWithDictionary:dataDic];
            [self.serverInfo removeObjectForKey:@"cmd"];

        } else if(cmd == 0x05){// 设备充电参数 11
            
            self.mode_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"mode"] ? dataDic[@"mode"] : @"--"];
            self.max_current_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"max_current"] ? dataDic[@"max_current"] : @"--"];
            self.rate_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"rate"] ? dataDic[@"rate"] : @"--"];
            self.protection_temp_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"protection_temp"] ? dataDic[@"protection_temp"] : @"--"];
            self.max_input_power_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"max_input_power"] ? dataDic[@"max_input_power"] : @"--"];
            self.allow_time_item.detailTitle = [NSString stringWithFormat:@"%@", dataDic[@"allow_time"] ? dataDic[@"allow_time"] : @"--"];
            
            if ([[NSString stringWithFormat:@"%@", dataDic[@"mode"]] isEqualToString:@"1"]) {
                self.mode_item.detailTitle = HEM_charge_model1;
            }else if ([[NSString stringWithFormat:@"%@", dataDic[@"mode"]] isEqualToString:@"2"]) {
                self.mode_item.detailTitle = HEM_charge_model2;
            }else if ([[NSString stringWithFormat:@"%@", dataDic[@"mode"]] isEqualToString:@"3"]) {
                self.mode_item.detailTitle = HEM_charge_model3;
            }
            
            self.chargeInfo = [[NSMutableDictionary alloc]initWithDictionary:dataDic];
            [self.chargeInfo removeObjectForKey:@"cmd"];
            
            [self hideProgressView];
            self->isSucc = YES;
            [self.tableView.mj_header endRefreshing];
        }
        [self.tableView reloadData];
    });
}

// 是否操作成功
- (void)TCPSocketActionSuccess:(BOOL)isSuccess data:(NSDictionary *)dataDic{
    
    NSInteger cmd = [[NSString stringWithFormat:@"%@", dataDic[@"cmd"]] integerValue];
    NSLog(@"TCPSocketActionSuccess cmd: **%ld**", (long)cmd);
    
    if (cmd == 160) { // 连接命令
        if (isSuccess) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[HSTCPWiFiManager instance] getDeviceInfo];// 获取设备信息参数 3
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[HSTCPWiFiManager instance] getDeviceNetWorkInfo];// 获取设备以太网参数 5
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[HSTCPWiFiManager instance] getDevicePassInfo];// 获取设备以太网参数 7
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[HSTCPWiFiManager instance] getDeviceServerInfo];// 获取服务器参数 9
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[HSTCPWiFiManager instance] getDeviceChargeInfo];// 获取设备充电参数 11
            });
        } else{
            self->tryNum ++;
            if (self->tryNum > 4) {
                [self showToastViewWithTitle:root_dianzhuang_duankai];
                [self.navigationController popViewControllerAnimated:YES];
                return ;
            }
            // 重连
            [[HSTCPWiFiManager instance] connectToDev:[HSBluetoochHelper dataWithString:self.devData[@"devName"] length:20]];
        }
        
    } else if(cmd == 161){ // 退出命令
        if(isSuccess){
            [self showToastViewWithTitle:root_dianzhuang_duankai];
        }
    } else if (cmd == 0x11){ // 设置设备以太网参数  6
        if(isSuccess){
            [self showToastViewWithTitle:root_shezhi_chenggong];
            [[HSTCPWiFiManager instance] getDeviceInfo];// 获取设备信息参数 3
        } else{
            [self showToastViewWithTitle:root_shezhi_shibai];
        }
    } else if (cmd == 0x12){ // 设置设备以太网参数  6
        if(isSuccess){
            [self showToastViewWithTitle:root_shezhi_chenggong];
            [[HSTCPWiFiManager instance] getDeviceNetWorkInfo];// 获取设备以太网参数 5
        } else{
            [self showToastViewWithTitle:root_shezhi_shibai];
        }
    } else if (cmd == 0x13){ // wifi设置  8
        if(isSuccess){
            [self showToastViewWithTitle:root_shezhi_chenggong];
            [[HSTCPWiFiManager instance] getDevicePassInfo];// 获取设备以太网参数 7
        } else{
            [self showToastViewWithTitle:root_shezhi_shibai];
        }
    } else if (cmd == 0x14){ // 服务器参数设置  10
        if(isSuccess){
            [self showToastViewWithTitle:root_shezhi_chenggong];
            [[HSTCPWiFiManager instance] getDeviceServerInfo];// 获取服务器参数 9
        } else{
            [self showToastViewWithTitle:root_shezhi_shibai];
        }
    } else if (cmd == 0x15){ // 设置充电参数 12
        if(isSuccess){
            [self showToastViewWithTitle:root_shezhi_chenggong];
            [[HSTCPWiFiManager instance] getDeviceChargeInfo];//获取充电参数 11
        } else{
            [self showToastViewWithTitle:root_shezhi_shibai];
        }
    }

    if (cmd == 1000) {
        [self showToastViewWithTitle:root_chaochuchangdu];//输入值超出规定长度
        NSInteger cmd2 = [[NSString stringWithFormat:@"%@", dataDic[@"cmd2"]] integerValue];
        if (cmd2 == 17) {
            [[HSTCPWiFiManager instance] getDeviceInfo];// 获取设备信息参数 3
        } else if (cmd2 == 18){
            [[HSTCPWiFiManager instance] getDeviceNetWorkInfo];// 获取设备以太网参数 5
        } else if (cmd2 == 19){
            [[HSTCPWiFiManager instance] getDevicePassInfo];// 获取设备以太网参数 7
        } else if (cmd2 == 20){
            [[HSTCPWiFiManager instance] getDeviceServerInfo];// 获取服务器参数 9
        } else if (cmd2 == 21){
            [[HSTCPWiFiManager instance] getDeviceChargeInfo];//获取充电参数 11
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // 退出命令
    [[HSTCPWiFiManager instance] disConnectToDev];
}



@end
