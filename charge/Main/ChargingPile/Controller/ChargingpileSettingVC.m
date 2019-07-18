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
#import "ZJBLStoreShopTypeAlert.h"
#import "SetTimeRateAlert.h"
#import "SetTimeRateVC.h"

@interface ChargingpileSettingVC ()<InputSettingDelegate,setTimeRateDelegate>

@property (nonatomic, strong) EWOptionItem *IDItem;
@property (nonatomic, strong) EWOptionItem *SercetItem;
@property (nonatomic, strong) EWOptionItem *version_item;

@property (nonatomic, strong) EWOptionArrowItem *name_item;
@property (nonatomic, strong) EWOptionArrowItem *city_item;
@property (nonatomic, strong) EWOptionArrowItem *station_item;
@property (nonatomic, strong) EWOptionArrowItem *rate_item;
@property (nonatomic, strong) EWOptionArrowItem *unit_item;
@property (nonatomic, strong) EWOptionArrowItem *current_item;
@property (nonatomic, strong) EWOptionArrowItem *power_item;
@property (nonatomic, strong) EWOptionArrowItem *mode_item;

@property (nonatomic, strong) EWOptionArrowItem *ip_item;
@property (nonatomic, strong) EWOptionArrowItem *gateway_item;
@property (nonatomic, strong) EWOptionArrowItem *mask_item;
@property (nonatomic, strong) EWOptionItem *mac_item;
@property (nonatomic, strong) EWOptionArrowItem *url_item;
@property (nonatomic, strong) EWOptionArrowItem *dns_item;

@property (nonatomic, strong) EWOptionGroup *group1;
@property (nonatomic, strong) EWOptionGroup *group2;
@property (nonatomic, strong) EWOptionGroup *group3;
@property (nonatomic, strong) EWOptionGroup *group4;

@property (nonatomic, strong) NSMutableDictionary *dataDict;

@property (nonatomic, strong) InputSettingAlert *inputAlert;

@property (nonatomic, strong) NSArray *unitArray;
@property (nonatomic, strong) NSString *symbol;

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
    
    self.group1 = [[EWOptionGroup alloc]init];
    self.group2 = [[EWOptionGroup alloc]init];
    self.group3 = [[EWOptionGroup alloc]init];
    self.group4 = [[EWOptionGroup alloc]init];
    
    // ID
    EWOptionItem *IDItem = [EWOptionItem itemWithTitle:HEM_charge_id detailTitle:@"--"];
    _IDItem = IDItem;
    
    // 密钥
    EWOptionItem *SercetItem = [EWOptionItem itemWithTitle:HEM_charge_miyao detailTitle:@"--"];
    _SercetItem = SercetItem;
    
    // 版本号
    EWOptionItem *version_item = [EWOptionItem itemWithTitle:root_banbenhao detailTitle:@"--"];
    _version_item = version_item;
    
    self.group1.items = @[IDItem, SercetItem, version_item];
    
    
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
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:_name_item];
    [array addObject:_city_item];
    [array addObject:_station_item];
    NSString *name = HEM_charge_feilv;
    if (self.priceConf.count == 0) self.priceConf = @[@{@"time": @"00:00-23:59", @"price": @"0"}];
    for (int i = 0; i < self.priceConf.count; i++) {
        if (i > 0) name = @"";
        NSDictionary *timeRate = self.priceConf[i];
        NSString *title = [NSString stringWithFormat:@"%@:%@ %@:%@",root_shijianduan, timeRate[@"time"], root_feilv, timeRate[@"price"]];
        EWOptionArrowItem *rate_item_1 = [EWOptionArrowItem arrowItemWithTitle:name detailTitle:title didClickBlock:^{
            SetTimeRateVC *vc = [[SetTimeRateVC alloc]init];
            vc.delegate = self;
            vc.sn = self.sn;
            vc.symbol = self.symbol;
            vc.timeRateArray = self.priceConf;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [array addObject:rate_item_1];
    }
    
    EWOptionArrowItem *unit_item = [EWOptionArrowItem arrowItemWithTitle:root_huobidanwei detailTitle:@"--" didClickBlock:^{
        [weakSelf selectMoneyUnit];
    }];
    _unit_item = unit_item;
    
    EWOptionArrowItem *current_item = [EWOptionArrowItem arrowItemWithTitle:root_dangqiandianliu detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (weakSelf.dataDict[@"G_MaxCurrent"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.dataDict[@"G_MaxCurrent"]];
        }
        weakSelf.inputAlert.itemText = @"G_MaxCurrent";
        weakSelf.inputAlert.titleText = root_dangqiandianliu;
    }];
    _current_item = current_item;
    
    EWOptionArrowItem *power_item = [EWOptionArrowItem arrowItemWithTitle:root_zhinenggonglvfenpei detailTitle:@"--" didClickBlock:^{
        [weakSelf.inputAlert show];
        if (weakSelf.dataDict[@"G_ExternalLimitPower"]) {
            weakSelf.inputAlert.currentText = [NSString stringWithFormat:@"%@", weakSelf.dataDict[@"G_ExternalLimitPower"]];
        }
        weakSelf.inputAlert.itemText = @"G_ExternalLimitPower";
        weakSelf.inputAlert.titleText = root_zhinenggonglvfenpei;
    }];
    _power_item = power_item;
    
    
    EWOptionArrowItem *mode_item = [EWOptionArrowItem arrowItemWithTitle:HEM_charge_moshi detailTitle:@"--" didClickBlock:^{
        
        NSArray *actionArray = @[HEM_charge_model1, HEM_charge_model2, HEM_charge_model3];
        [ZJBLStoreShopTypeAlert showWithTitle:HEM_charge_moshi titles:actionArray selectIndex:^(NSInteger SelectIndexNum){
            
            NSMutableDictionary *prams2 = [[NSMutableDictionary alloc]init];
            [prams2 setObject:@(SelectIndexNum+1) forKey:@"G_ChargerMode"];
            [prams2 setObject:[UserInfo defaultUserInfo].userName forKey:@"userId"];
            [prams2 setObject:self.sn forKey:@"chargeId"];
            NSLog(@"prams: %@",prams2);
            // 设置
            [weakSelf setChargeoConfigInfomation:prams2];
            
        } selectValue:^(NSString* valueString){
            
        } showCloseButton:YES];
        
    }];
    _mode_item = mode_item;
    
    self.group2.headerTitle = HEM_charge_jichucanshu;
    [array addObject:_unit_item];
    [array addObject:_current_item];
    [array addObject:_power_item];
    [array addObject:_mode_item];
    self.group2.items = array.copy;
//    self.group2.items = @[name_item, city_item,station_item, rate_item, unit_item, current_item, power_item, mode_item];
    
    
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
    
    
    EWOptionItem *mac_item = [EWOptionItem itemWithTitle:HEM_charge_mac detailTitle:@"--"];
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
    
    self.group3.headerTitle = HEM_charge_gaojishezhi;
    self.group3.items = @[ip_item, gateway_item, mask_item, mac_item, url_item, dns_item];
    
    // 切换ap模式
    EWOptionArrowItem *switch_ap_item = [EWOptionArrowItem arrowItemWithTitle:root_qiehuan_ap detailTitle:@"" didClickBlock:^{
        [weakSelf switch_ap_mode];
    }];
    self.group4.items = @[switch_ap_item];
    
    [self.groups addObject:self.group1];
    [self.groups addObject:self.group2];
    [self.groups addObject:self.group3];
    [self.groups addObject:self.group4];
    
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
    
    self.symbol = [NSString stringWithFormat:@"%@", data[@"symbol"]]; // 货币符号
    
    self.IDItem.detailTitle = [NSString stringWithFormat:@"%@", data[@"chargeId"] ? data[@"chargeId"] : @"--"];
    self.SercetItem.detailTitle = [NSString stringWithFormat:@"%@", data[@"G_Authentication"] ? data[@"G_Authentication"] : @"--"];
    self.version_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"version"] ? data[@"version"] : @"--"];
    
    self.name_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"name"] ? data[@"name"] : @"--"];
    self.city_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"address"] ? data[@"address"] : @"--"];
    self.station_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"site"] ? data[@"site"] : @"--"];
    self.rate_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"rate"] ? data[@"rate"] : @"--"];
    self.unit_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"unit"] ? data[@"unit"] : @"--"];
    self.current_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"G_MaxCurrent"] ? data[@"G_MaxCurrent"] : @"--"];
    self.power_item.detailTitle = [NSString stringWithFormat:@"%@", data[@"G_ExternalLimitPower"] ? data[@"G_ExternalLimitPower"] : @"--"];
    
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
    
    if ([key isEqualToString:@"rate"] || [key isEqualToString:@"G_MaxCurrent"] || [key isEqualToString:@"G_ExternalLimitPower"]) {
        // 判断是否为数字
        if(![NSString isNum:prams[key]]){
            [self showToastViewWithTitle:root_geshi_cuowu];
            return;
        }
    }
    
    NSMutableDictionary *prams2 = [[NSMutableDictionary alloc]initWithDictionary:prams];
    [prams2 setObject:[UserInfo defaultUserInfo].userName forKey:@"userId"];
    [prams2 setObject:self.sn forKey:@"chargeId"];
    if([key isEqualToString:@"G_MaxCurrent"]){ // 电桩最大输出电流
        [prams2 setObject:prams[key] forKey:@"G_MaxCurrent"];
        [prams2 removeObjectForKey:key];
    } else if ([key isEqualToString:@"G_ExternalLimitPower"]){ // 智能分配功率
        [prams2 setObject:prams[key] forKey:@"G_ExternalLimitPower"];
        [prams2 removeObjectForKey:key];
    }
    
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



#pragma mark -- 设置费率成功的回调
- (void)setTimeRateWithArray:(NSArray *)timeRateArray{
    
    if (timeRateArray.count > 0) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:_name_item];
        [array addObject:_city_item];
        [array addObject:_station_item];
        NSString *name = HEM_charge_feilv;
        for (int i = 0; i < timeRateArray.count; i++) {
            if (i > 0) name = @"";
            NSDictionary *timeRate = timeRateArray[i];
            NSString *title = [NSString stringWithFormat:@"%@:%@ %@:%@",root_shijianduan, timeRate[@"time"], root_feilv, timeRate[@"price"]];
            EWOptionArrowItem *rate_item_1 = [EWOptionArrowItem arrowItemWithTitle:name detailTitle:title didClickBlock:^{
                SetTimeRateVC *vc = [[SetTimeRateVC alloc]init];
                vc.delegate = self;
                vc.sn = self.sn;
                vc.symbol = self.symbol;
                vc.timeRateArray = self.priceConf;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [array addObject:rate_item_1];
        }
        [array addObject:_unit_item];
        [array addObject:_current_item];
        [array addObject:_power_item];
        [array addObject:_mode_item];
        self.group2.items = array.copy;
        [self.groups removeObjectAtIndex:1];
        [self.groups insertObject:self.group2 atIndex:1];
        [self.tableView reloadData];
        self.priceConf = timeRateArray;
    }
}




#pragma mark -- 网络请求
// 电桩切换至AP模式
- (void)switch_ap_mode{
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced]switchAPModeWithSn:self.sn userId:[UserInfo defaultUserInfo].userName success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideProgressView];
            if ([obj[@"code"] isEqualToNumber:@0]) {
                HSWiFiChargeTipsVC *vc = [[HSWiFiChargeTipsVC alloc]init];
                vc.ChargeId = self.sn;
                [self.navigationController pushViewController:vc animated:YES];
            } else{
                [weakSelf showToastViewWithTitle:[NSString stringWithFormat:@"%@", obj[@"data"]]];
            }
        });
    } failure:^(NSError *error) {
        [weakSelf hideProgressView];
    }];
}


// 选择货币单位
- (void)selectMoneyUnit{
    
    __weak typeof(self) weakSelf = self;
    // 判断是否已经获取到列表
    if ([weakSelf.unitArray isKindOfClass:[NSArray class]]) {
        if (weakSelf.unitArray.count > 0) {
            NSMutableArray *actionArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < weakSelf.unitArray.count; i++) {
                NSDictionary *dict = weakSelf.unitArray[i];
                [actionArray addObject:[NSString stringWithFormat:@"%@(%@)",dict[@"unit"],dict[@"symbol"]]];
            }
            // 打开控件
            [ZJBLStoreShopTypeAlert showWithTitle:root_xuanzehuobi titles:actionArray selectIndex:^(NSInteger SelectIndexNum){
                NSDictionary *dict = weakSelf.unitArray[SelectIndexNum];
                
                NSMutableDictionary *prams = [[NSMutableDictionary alloc]init];
                [prams setObject:[UserInfo defaultUserInfo].userName forKey:@"userId"];
                [prams setObject:weakSelf.sn forKey:@"chargeId"];
                [prams setObject:dict[@"unit"] forKey:@"unit"];
                [prams setObject:dict[@"symbol"] forKey:@"symbol"]; // 符号
                [weakSelf setChargeoConfigInfomation:prams];// 设置
                
            } selectValue:^(NSString* valueString){
                
            } showCloseButton:YES];
            return;
        }
    }
    
    [self showProgressView];
    [[DeviceManager shareInstenced] sendCommandWithParms:@{@"cmd":@"selectMoneyUnit"} success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([obj[@"code"] isEqualToNumber:@0]) {
                
                weakSelf.unitArray = obj[@"data"];
                if ([weakSelf.unitArray isKindOfClass:[NSArray class]]) {
                    
                    NSMutableArray *actionArray = [[NSMutableArray alloc]init];
                    for (int i = 0; i < weakSelf.unitArray.count; i++) {
                        NSDictionary *dict = weakSelf.unitArray[i];
                        [actionArray addObject:[NSString stringWithFormat:@"%@(%@)",dict[@"unit"],dict[@"symbol"]]];
                    }
                    // 打开控件
                    [ZJBLStoreShopTypeAlert showWithTitle:root_xuanzehuobi titles:actionArray selectIndex:^(NSInteger SelectIndexNum){
                        NSDictionary *dict = weakSelf.unitArray[SelectIndexNum];
                        
                        NSMutableDictionary *prams = [[NSMutableDictionary alloc]init];
                        [prams setObject:[UserInfo defaultUserInfo].userName forKey:@"userId"];
                        [prams setObject:self.sn forKey:@"chargeId"];
                        [prams setObject:dict[@"unit"] forKey:@"unit"];
                        [prams setObject:dict[@"symbol"] forKey:@"symbol"]; // 符号
                        [weakSelf setChargeoConfigInfomation:prams];// 设置
                        
                    } selectValue:^(NSString* valueString){
                        
                    } showCloseButton:YES];
                }
            }else{
                [self showToastViewWithTitle:root_qingqiushibai];
            }
            [weakSelf hideProgressView];
        });
    } failure:^(NSError *error) {
        [weakSelf hideProgressView];
        [self showToastViewWithTitle:root_qingqiushibai];
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
