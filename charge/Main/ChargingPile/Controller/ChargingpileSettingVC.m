//
//  ChargingpileSettingVC.m
//  ShinePhone
//
//  Created by growatt007 on 2018/8/7.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "ChargingpileSettingVC.h"
#import "HSBluetoochManager.h"
#import "EWOptionItem.h"
#import "EWOptionArrowItem.h"
#import "InputSettingAlert.h"
#import "HSWiFiChargeTipsVC.h"

@interface ChargingpileSettingVC ()<InputSettingDelegate>

@property (nonatomic, strong) EWOptionItem *IDItem;
@property (nonatomic, strong) EWOptionItem *SercetItem;

@property (nonatomic, strong) EWOptionArrowItem *name_item;
@property (nonatomic, strong) EWOptionArrowItem *city_item;
@property (nonatomic, strong) EWOptionArrowItem *station_item;
@property (nonatomic, strong) EWOptionArrowItem *rate_item;
@property (nonatomic, strong) EWOptionArrowItem *power_item;
@property (nonatomic, strong) EWOptionArrowItem *mode_item;

@property (nonatomic, strong) EWOptionArrowItem *ip_item;
@property (nonatomic, strong) EWOptionArrowItem *gateway_item;
@property (nonatomic, strong) EWOptionArrowItem *mask_item;
@property (nonatomic, strong) EWOptionArrowItem *mac_item;
@property (nonatomic, strong) EWOptionArrowItem *url_item;
@property (nonatomic, strong) EWOptionArrowItem *dns_item;

@property (nonatomic, strong) NSMutableDictionary *dataDict;

@property (nonatomic, strong) InputSettingAlert *inputAlert;

@end

@implementation ChargingpileSettingVC

- (NSMutableDictionary *)dataDict{
    
    if (!_dataDict) {
        _dataDict = [[NSMutableDictionary alloc]init];
    }
    return _dataDict;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    
    [self setupAlert];
    [self createUIView];
    // 获取设置信息
    [self getChargeoConfigInfomation];
}

- (void)setupAlert{
    
    self.inputAlert = [[InputSettingAlert alloc] init];
    self.inputAlert.delegate = self;
    
}

- (void)createUIView{
    
    __weak typeof(self) weakSelf = self;
    MJRefreshHeader *header = [MJRefreshHeader headerWithRefreshingBlock:^{
       
        [weakSelf getChargeoConfigInfomation];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
    self.tableView.mj_header = header;
    
    EWOptionGroup *group1 = [[EWOptionGroup alloc]init];
    EWOptionGroup *group2 = [[EWOptionGroup alloc]init];
    EWOptionGroup *group3 = [[EWOptionGroup alloc]init];
    EWOptionGroup *group4 = [[EWOptionGroup alloc]init];
    
    // ID
    EWOptionItem *IDItem = [EWOptionItem itemWithTitle:HEM_charge_id detailTitle:@"--"];
    _IDItem = IDItem;
    
    EWOptionItem *SercetItem = [EWOptionItem itemWithTitle:HEM_charge_miyao detailTitle:@"--"];
    _SercetItem = SercetItem;
    group1.items = @[IDItem, SercetItem];
    
    
    EWOptionArrowItem *name_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_mingcheng detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.dataDict[@"name"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.dataDict[@"name"]];
        }
        weakSelf.inputAlert.itemText = @"name";
        weakSelf.inputAlert.titleText = HEM_charge_mingcheng;
        
    }];
    _name_item = name_item;
    
    
    EWOptionArrowItem *city_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_guojia detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.dataDict[@"address"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.dataDict[@"address"]];
        }
        weakSelf.inputAlert.itemText = @"address";
        weakSelf.inputAlert.titleText = HEM_charge_guojia;
    }];
    _city_item = city_item;
    
    
    EWOptionArrowItem *station_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_zhandian detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.dataDict[@"site"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.dataDict[@"site"]];
        }
        weakSelf.inputAlert.itemText = @"site";
        weakSelf.inputAlert.titleText = HEM_charge_zhandian;
    }];
    _station_item = station_item;
    
    
    EWOptionArrowItem *rate_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_feilv detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.dataDict[@"rate"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.dataDict[@"rate"]];
        }
        weakSelf.inputAlert.itemText = @"rate";
        weakSelf.inputAlert.titleText = HEM_charge_feilv;
    }];
    _rate_item = rate_item;
    
    
    EWOptionArrowItem *power_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_gonglv detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.dataDict[@"power"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.dataDict[@"power"]];
        }
        weakSelf.inputAlert.itemText = @"power";
        weakSelf.inputAlert.titleText = HEM_charge_gonglv;
    }];
    _power_item = power_item;
    
    
    EWOptionArrowItem *mode_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_moshi detailTitle:@"--" didClickBlock:^{

        UIAlertAction *action1 = [UIAlertAction actionWithTitle:HEM_charge_model1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selectModel:1];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:HEM_charge_model2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selectModel:2];
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:HEM_charge_model3 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selectModel:3];
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
    
    group2.headerTitle = HEM_charge_jichucanshu;
    group2.items = @[name_item, city_item,station_item, rate_item, power_item, mode_item];
    
    
    EWOptionArrowItem *ip_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_ip detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.dataDict[@"ip"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.dataDict[@"ip"]];
        }
        weakSelf.inputAlert.itemText = @"ip";
        weakSelf.inputAlert.titleText = HEM_charge_ip;
    }];
    _ip_item = ip_item;
    
    
    EWOptionArrowItem *gateway_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_wangguang detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.dataDict[@"gateway"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.dataDict[@"gateway"]];
        }
        weakSelf.inputAlert.itemText = @"gateway";
        weakSelf.inputAlert.titleText = HEM_charge_wangguang;
    }];
    _gateway_item = gateway_item;
    
    
    EWOptionArrowItem *mask_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_yanma detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.dataDict[@"mask"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.dataDict[@"mask"]];
        }
        weakSelf.inputAlert.itemText = @"mask";
        weakSelf.inputAlert.titleText = HEM_charge_yanma;
    }];
    _mask_item = mask_item;
    
    
    EWOptionArrowItem *mac_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_mac detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.dataDict[@"mac"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.dataDict[@"mac"]];
        }
        weakSelf.inputAlert.itemText = @"mac";
        weakSelf.inputAlert.titleText = HEM_charge_mac;
    }];
    _mac_item = mac_item;
    
    
    EWOptionArrowItem *url_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_url detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.dataDict[@"host"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.dataDict[@"host"]];
        }
        weakSelf.inputAlert.itemText = @"host";
        weakSelf.inputAlert.titleText = HEM_charge_url;
    }];
    _url_item = url_item;
    
    
    EWOptionArrowItem *dns_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_dns detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (self.dataDict[@"dns"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.dataDict[@"dns"]];
        }
        weakSelf.inputAlert.itemText = @"dns";
        weakSelf.inputAlert.titleText = HEM_charge_dns;
    }];
    _dns_item = dns_item;
    
    group3.headerTitle = HEM_charge_gaojishezhi;
    group3.items = @[ip_item, gateway_item, mask_item, mac_item, url_item, dns_item];
    
    // 切换ap模式
    EWOptionArrowItem *switch_ap_item = [EWOptionArrowItem arrowItemWithTitle:root_qiehuan_ap detailTitle:@"" didClickBlock:^{
        [weakSelf switch_ap_mode];
    }];
    group4.items = @[switch_ap_item];
    
    [self.groups addObject:group1];
    [self.groups addObject:group2];
    [self.groups addObject:group3];
    [self.groups addObject:group4];
    
    [self.tableView reloadData];
    
}

#pragma mark -- Http request
// 获取设置信息
- (void)getChargeoConfigInfomation{
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced] ChargeoConfigInfomationWithSn:self.sn success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideProgressView];
            [weakSelf.tableView.mj_header endRefreshing];
            if ([obj[@"code"] isEqualToNumber:@0]) {
                [weakSelf reloadWithUITabelView:obj[@"data"]];
            }else{
                [weakSelf showToastViewWithTitle:obj[@"data"]];
            }
        });
    } failure:^(NSError *error) {
        [weakSelf hideProgressView];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
// 设置充电桩信息
- (void)setChargeoConfigInfomation:(NSDictionary *)parms{
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced] setChargeoConfigInfomationWithParms:parms success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideProgressView];
            if ([obj[@"code"] isEqualToNumber:@0]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [weakSelf getChargeoConfigInfomation];
                });
            }
            [weakSelf showToastViewWithTitle:obj[@"data"]];
        });
    } failure:^(NSError *error) {
        [weakSelf hideProgressView];
    }];
}

// 刷新
- (void)reloadWithUITabelView:(NSDictionary *)data{
    
    [self.dataDict setDictionary:data];
    
    self.IDItem.detailTitle = [NSString stringWithFormat:@"%@", data[@"chargeId"] ? data[@"chargeId"] : @"--"];
    self.SercetItem.detailTitle = [NSString stringWithFormat:@"%@", data[@"G_Authentication"] ? data[@"G_Authentication"] : @"--"];
    
    self.name_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"name"] ? data[@"name"] : @"--"];
    self.city_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"address"] ? data[@"address"] : @"--"];
    self.station_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"site"] ? data[@"site"] : @"--"];
    self.rate_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"rate"] ? data[@"rate"] : @"--"];
    self.power_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"power"] ? data[@"power"] : @"--"];
    
    if ([data[@"G_ChargerMode"] integerValue] == 1) {
        self.mode_item.detailTitle = HEM_charge_model1;
    }else if ([data[@"G_ChargerMode"] integerValue] == 2) {
        self.mode_item.detailTitle = HEM_charge_model2;
    }else if ([data[@"G_ChargerMode"] integerValue] == 3) {
        self.mode_item.detailTitle = HEM_charge_model3;
    }else{
        self.mode_item.detailTitle = @"--";
    }

    self.ip_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"ip"] ? data[@"ip"] : @"--"];
    self.gateway_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"gateway"] ? data[@"gateway"] : @"--"];
    self.mask_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"mask"] ? data[@"mask"] : @"--"];
    self.mac_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"mac"] ? data[@"mac"] : @"--"];
    self.url_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"host"] ? data[@"host"] : @"--"];
    self.dns_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"dns"] ? data[@"dns"] : @"--"];
    
    [self.tableView reloadData];
}


#pragma mark -- InputSettingDelegate
- (void)InputSettingWithPrams:(NSDictionary *)prams{
    
    NSString *key = prams.allKeys[0];
    NSString *regex = @"^(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|[1-9])\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)$";
    if([key isEqualToString:@"ip"] || [key isEqualToString:@"gateway"] || [key isEqualToString:@"mask"] || [key isEqualToString:@"dns"]){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isValid = [predicate evaluateWithObject:prams[key]];
        if(!isValid){
            [self showToastViewWithTitle:root_geshi_cuowu];
            return;
        }
    }
    
    if ([key isEqualToString:@"rate"] || [key isEqualToString:@"power"]) {
        // 判断是否为数字
        if(![NSString isNum:prams[key]]){
            [self showToastViewWithTitle:root_geshi_cuowu];
            return;
        }
    }
    
    NSMutableDictionary *prams2 = [[NSMutableDictionary alloc]initWithDictionary:prams];
    [prams2 setObject:[UserInfo defaultUserInfo].userName forKey:@"userId"];
    [prams2 setObject:self.sn forKey:@"chargeId"];
    
    NSLog(@"prams: %@",prams2);
    // 设置
    [self setChargeoConfigInfomation:prams2];
    
}

// 选择模式
- (void)selectModel:(int)model{
    
    NSMutableDictionary *prams2 = [[NSMutableDictionary alloc]init];
    [prams2 setObject:@(model) forKey:@"G_ChargerMode"];
    [prams2 setObject:[UserInfo defaultUserInfo].userName forKey:@"userId"];
    [prams2 setObject:self.sn forKey:@"chargeId"];
    
    NSLog(@"prams: %@",prams2);
    // 设置
    [self setChargeoConfigInfomation:prams2];
    
}

// 电桩切换至AP模式
- (void)switch_ap_mode{
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced]switchAPModeWithSn:self.sn userId:[UserInfo defaultUserInfo].userName success:^(id obj) {
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


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 刷新首页
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RELOAD_CHARGE" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
