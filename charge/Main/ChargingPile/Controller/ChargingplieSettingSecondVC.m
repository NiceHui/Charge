//
//  ChargingplieSettingSecondVC.m
//  charge
//
//  Created by growatt007 on 2019/7/29.
//  Copyright © 2019 hshao. All rights reserved.
//

#import "ChargingplieSettingSecondVC.h"
#import "InputSettingAlert.h"
#import "HSWiFiChargeTipsVC.h"
#import "ZJBLStoreShopTypeAlert.h"
#import "SetTimeRateAlert.h"
#import "SetTimeRateVC.h"
#import "SelectTimeAlert.h"

@interface ChargingplieSettingSecondVC ()<InputSettingDelegate,setTimeRateDelegate,UITableViewDelegate, UITableViewDataSource>{
    
    
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *keysArray;

@property (nonatomic, strong) NSMutableDictionary *dataDict; // 读取的设置值
@property (nonatomic, strong) NSMutableDictionary *setInfoDict; // 需要修改的设置值

@property (nonatomic, strong) InputSettingAlert *inputAlert;
@property (nonatomic, strong) SelectTimeAlert *timeAlert;

@property (nonatomic, strong) NSArray *unitArray;
@property (nonatomic, strong) NSString *symbol;

@property (nonatomic, assign) BOOL isSolarECO; // 是否显示Solar的ECO+限制电流

@end

@implementation ChargingplieSettingSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    
    _isSolarECO = NO; // 是否显示ECO电流输入
    _dataDict = [[NSMutableDictionary alloc]init];
    _setInfoDict = [[NSMutableDictionary alloc]init];
    
    [self setupAlert];
    [self createUIView];
    [self createRightItem];
    // 获取设置信息
    [self getChargeoConfigInfomation];
    
}

// 右上角执行按键
- (void)createRightItem{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50*XLscaleW, 30*XLscaleH)];
    [button setTitle:root_baocun forState:UIControlStateNormal];
    [button setTitleColor:mainColor forState:UIControlStateNormal];
    button.titleLabel.font = FontSize([NSString getFontWithText:root_baocun size:CGSizeMake(50*XLscaleW, 30*XLscaleH) currentFont:16*XLscaleH]);
    [button addTarget:self action:@selector(touchSendComAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

// alert
- (void)setupAlert{
    
    self.inputAlert = [[InputSettingAlert alloc] init];
    self.inputAlert.delegate = self;
    
    self.timeAlert = [[SelectTimeAlert alloc]init];
    __weak typeof(self) weakSelf = self;
    self.timeAlert.touchAlertEnter = ^(NSString * _Nonnull text) {
        [weakSelf.dataDict setObject:text forKey:@"G_AutoChargeTime"];
        [weakSelf.setInfoDict setObject:text forKey:@"G_AutoChargeTime"];
        [weakSelf.tableView reloadData];
    };
}

- (void)createUIView{
    
    _titleArray=@[@"",HEM_charge_jichucanshu,HEM_charge_gaojishezhi,@"",@""];
    
    _itemArray = [[NSMutableArray alloc]initWithArray:@[
                  @[HEM_charge_id,HEM_charge_miyao,root_banbenhao],
                  
                  @[HEM_charge_mingcheng,HEM_charge_guojia,HEM_charge_zhandian,
                    HEM_charge_feilv,root_huobidanwei,root_dangqiandianliu,
                    root_zhinenggonglvfenpei,HEM_charge_moshi],
                  
                  @[HEM_charge_ip,HEM_charge_wangguang,HEM_charge_yanma,
                    HEM_charge_mac,HEM_charge_url,HEM_charge_dns],
                  
                  @[root_gonglvfengpeishineng,root_waibudianliu,root_solar_mode,
                    root_eco_current_limit,root_fengguchongdianshineng,root_allow_time],
                  
                  @[root_qiehuan_ap]]];
    
    _keysArray=[[NSMutableArray alloc]initWithArray:@[
                  @[@"chargeId",@"G_Authentication",@"version"],
                  
                  @[@"name",@"address",@"site",@"rate",@"unit",
                    @"G_MaxCurrent",@"G_ExternalLimitPower",@"G_ChargerMode"],
                  
                  @[@"ip",@"gateway",@"mask",@"mac",
                    @"host",@"dns"],
                  
                  @[@"G_ExternalLimitPowerEnable",@"G_ExternalSamplingCurWring",@"G_SolarMode",
                    @"G_SolarLimitPower",@"G_PeakValleyEnable",@"G_AutoChargeTime"],
                  
                  @[@"switch_ap"]]];
    
    // 加入费率显示
    [self setCurrentPriceConf];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-kNavBarHeight-kBottomBarHeight) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight=45*XLscaleH;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 40*XLscaleH, 0);
    [self.view addSubview:_tableView];
    
    
    __weak typeof(self) weakSelf = self;
    MJRefreshHeader *header = [MJRefreshHeader headerWithRefreshingBlock:^{
        
        [weakSelf getChargeoConfigInfomation];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
    self.tableView.mj_header = header;
    
}

// 把费率数组加入当前数组中
- (void)setCurrentPriceConf{
    
    NSMutableArray *items1 = [[NSMutableArray alloc]initWithArray:@[HEM_charge_mingcheng,HEM_charge_guojia,HEM_charge_zhandian,
                              HEM_charge_feilv,root_huobidanwei,root_dangqiandianliu,
                              root_zhinenggonglvfenpei,HEM_charge_moshi]];
    NSMutableArray *keys1 = [[NSMutableArray alloc]initWithArray:@[@"name",@"address",@"site",@"rate",@"unit",
                              @"G_MaxCurrent",@"G_ExternalLimitPower",@"G_ChargerMode"]];
    
    if (self.priceConf.count > 0) {
        
        for (int i=0; i<(self.priceConf.count-1); i++) {
            
            [items1 insertObject:@"" atIndex:4+i];
            [keys1 insertObject:@"rate" atIndex:4+i];
        }
    }
    [_itemArray replaceObjectAtIndex:1 withObject:items1];
    [_keysArray replaceObjectAtIndex:1 withObject:keys1];
}

// 是否显示 ECO+电流限制 设置项
- (void)setIsSolarECO:(BOOL)isSolarECO{
    _isSolarECO = isSolarECO;
    
    NSMutableArray *items3 = [[NSMutableArray alloc]initWithArray:_itemArray[3]];
    NSMutableArray *keys3 = [[NSMutableArray alloc]initWithArray:_keysArray[3]];
    
    if (!isSolarECO) {
        [items3 removeObject:root_eco_current_limit];
        [keys3 removeObject:@"G_SolarLimitPower"];
    }else{
        if (![items3 containsObject:root_eco_current_limit]) {
            [items3 insertObject:root_eco_current_limit atIndex:3];
        }
        if (![keys3 containsObject:@"G_SolarLimitPower"]) {
            [keys3 insertObject:@"G_SolarLimitPower" atIndex:3];
        }
    }
    [_itemArray replaceObjectAtIndex:3 withObject:items3];
    [_keysArray replaceObjectAtIndex:3 withObject:keys3];
}

#pragma mark -- tableViewDelagate
// headview 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40*XLscaleH;
}
// 标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40*XLscaleH)];
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(10*XLscaleW, 0, ScreenWidth-20*XLscaleW, 40*XLscaleH)];
    lblTitle.text=_titleArray[section];
    lblTitle.textColor=colorblack_51;
    lblTitle.font=FontSize(14*XLscaleH);
    [header addSubview:lblTitle];
    return header;
}
// footer
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

// 组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *items = _itemArray[section];
    NSInteger count = items.count;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    // 分割线
    UIView *diverLine = [[UIView alloc] initWithFrame:CGRectMake(0, 45*XLscaleH-1, ScreenWidth, 1)];
    diverLine.backgroundColor = HexRGB(0xeeeeee);
    [cell.contentView addSubview:diverLine];
    
    // key 值
    NSString *keyString = _keysArray[indexPath.section][indexPath.row];
    NSString *valueString = [NSString stringWithFormat:@"%@", _dataDict[keyString]];
    
    // 费率
    if (indexPath.section==1 && [keyString isEqualToString:@"rate"]) {
        NSDictionary *timeRate = self.priceConf[indexPath.row-3];
        valueString = [NSString stringWithFormat:@"%@:%@ %@:%@",root_shijianduan, timeRate[@"time"], root_feilv, timeRate[@"price"]];
    }
    
    // 是否显示箭头
    if ([keyString isEqualToString:@"chargeId"] || [keyString isEqualToString:@"G_Authentication"] || [keyString isEqualToString:@"version"] || [keyString isEqualToString:@"mac"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    float marginLF=10*XLscaleW;
    float labelW1 = (ScreenWidth-2*marginLF)*0.55;
    float labelW2 = (ScreenWidth-2*marginLF)*0.45;
    
    // 标题
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(marginLF, 0, labelW1, 45*XLscaleH)];
    lblTitle.text=_itemArray[indexPath.section][indexPath.row];
    lblTitle.textColor=HexRGB(0x464646);
    lblTitle.font=FontSize(14*XLscaleH);
    lblTitle.adjustsFontSizeToFitWidth=YES;
    lblTitle.numberOfLines=0;
    [cell.contentView addSubview:lblTitle];
    
    // 读取值
    UILabel *lblContent = [[UILabel alloc]init];
    lblContent.text=@"--";
    lblContent.textColor=HexRGB(0xadadad);
    lblContent.font=FontSize(14*XLscaleH);
    lblContent.textAlignment=NSTextAlignmentRight;
    lblContent.adjustsFontSizeToFitWidth=YES;
    lblContent.numberOfLines=0;
    [cell.contentView addSubview:lblContent];
    // 判断是否有箭头
    if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        lblContent.frame = CGRectMake(CGRectGetMaxX(lblTitle.frame), 0, labelW2 - 30*XLscaleW, 45*XLscaleH);
    } else if (cell.accessoryType == UITableViewCellAccessoryNone) {
        lblContent.frame = CGRectMake(CGRectGetMaxX(lblTitle.frame), 0, labelW2 - 8*XLscaleW, 45*XLscaleH);
    }

    // 充电模式
    if ([keyString isEqualToString:@"G_ChargerMode"]) {
        if ([valueString integerValue] == 1) {
            valueString = HEM_charge_model1;
        }else if ([valueString integerValue] == 2) {
            valueString = HEM_charge_model2;
        }else if ([valueString integerValue] == 3) {
            valueString = HEM_charge_model3;
        }
    }
    
    // 峰谷充电使能， 功率分配使能
    if ([keyString isEqualToString:@"G_PeakValleyEnable"] || [keyString isEqualToString:@"G_ExternalLimitPowerEnable"]) {
        if ([valueString isEqualToString:@"1"]) {
            valueString = root_shineng;
        }else if ([valueString isEqualToString:@"0"]) {
            valueString = root_jinzhi;
        }
    }
    // external_current
    if ([keyString isEqualToString:@"G_ExternalSamplingCurWring"] || [keyString isEqualToString:@"G_SolarMode"]) {
        valueString = [self getStringWithKind:keyString number:[valueString integerValue]];
    }
    // 判空
    valueString = kStringIsEmpty(valueString) ? @"--" : valueString;
    
    if (self.dataDict.allValues.count == 0) {
        valueString = @"--";
    }
    
    if ([keyString isEqualToString:@"switch_ap"]) {
        valueString = @"";
    }
    
    lblContent.text=valueString;
    
    return cell;
}


// TODO: 点击tableView Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *titleString = _itemArray[indexPath.section][indexPath.row]; // 标题
    NSString *keyString = _keysArray[indexPath.section][indexPath.row]; // key 值
    
    // 不可设置项
    if ([keyString isEqualToString:@"chargeId"] || [keyString isEqualToString:@"G_Authentication"] || [keyString isEqualToString:@"version"] || [keyString isEqualToString:@"mac"]) {
        return;
    }
    
    
    if ([keyString isEqualToString:@"G_ChargerMode"] || [keyString isEqualToString:@"G_PeakValleyEnable"] || [keyString isEqualToString:@"G_ExternalLimitPowerEnable"] || [keyString isEqualToString:@"G_ExternalSamplingCurWring"] || [keyString isEqualToString:@"G_SolarMode"]) {
        
        __weak typeof(self) weakSelf = self;
        NSArray *actionArray = [self getSelectArrayWithKind:keyString];// 选择项数组
        [ZJBLStoreShopTypeAlert showWithTitle:titleString titles:actionArray selectIndex:^(NSInteger SelectIndexNum){
            
            if([keyString isEqualToString:@"G_ChargerMode"]) { // 充电模式
                
                [self.dataDict setObject:@(SelectIndexNum+1) forKey:@"G_ChargerMode"];
                [self.setInfoDict setObject:@(SelectIndexNum+1) forKey:@"G_ChargerMode"];
                
            } else if([keyString isEqualToString:@"G_PeakValleyEnable"] || [keyString isEqualToString:@"G_ExternalLimitPowerEnable"]){ // 峰谷充电使能,  功率分配使能

                if (SelectIndexNum == 0) {
                    [self.dataDict setObject:@"1" forKey:keyString]; // 使能
                    [self.setInfoDict setObject:@"1" forKey:keyString];
                } else if (SelectIndexNum == 1){
                    [self.dataDict setObject:@"0" forKey:keyString]; // 禁止
                    [self.setInfoDict setObject:@"0" forKey:keyString];
                }

            } else if ([keyString isEqualToString:@"G_ExternalSamplingCurWring"]){ // 外部电流采样接线方式

                [self.dataDict setObject:[NSString stringWithFormat:@"%ld", (long)SelectIndexNum] forKey:keyString];
                [self.setInfoDict setObject:[NSString stringWithFormat:@"%ld", (long)SelectIndexNum] forKey:keyString];
                
            } else if ([keyString isEqualToString:@"G_SolarMode"]){ // solar模式

                [self.dataDict setObject:[NSString stringWithFormat:@"%ld", (long)SelectIndexNum] forKey:keyString];
                [self.setInfoDict setObject:[NSString stringWithFormat:@"%ld", (long)SelectIndexNum] forKey:keyString];
                
                if(SelectIndexNum == 2){ // 选择了ECO+
                    self.isSolarECO = YES;
                }else{
                    self.isSolarECO = NO;
                }
            }
            
        } selectValue:^(NSString* valueString){
            [weakSelf.tableView reloadData];
        } showCloseButton:YES];
        
    } else if ([keyString isEqualToString:@"rate"]){ // 费率
        
        SetTimeRateVC *vc = [[SetTimeRateVC alloc]init];
        vc.delegate = self;
        vc.sn = self.sn;
        vc.symbol = self.symbol;
        vc.timeRateArray = self.priceConf;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([keyString isEqualToString:@"unit"]){ // 货币单位
        
        [self selectMoneyUnit];
        
    } else if ([keyString isEqualToString:@"G_AutoChargeTime"]){ // 允许设置时间
        
        [self.timeAlert show];
        if (self.dataDict[keyString]) {
            self.timeAlert.selectTime = [NSString stringWithFormat:@"%@", self.dataDict[keyString]];
        }
        self.timeAlert.titleText = root_allow_time;
        
    } else if ([keyString isEqualToString:@"switch_ap"]){ // 切换ap模式
        
        [self switch_ap_mode];
        
    } else {
        
        [self.inputAlert show];
        if (self.dataDict[keyString]) {
            self.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.dataDict[keyString]];
        }
        self.inputAlert.itemText = keyString;
        self.inputAlert.titleText = titleString;
    }
    
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
    
    if ([key isEqualToString:@"G_SolarLimitPower"]) {
        // 判断是否为数字， 可以为小数
        if(![NSString isNum:prams[key]]){
            [self showToastViewWithTitle:root_geshi_cuowu];
            return;
        }
    }
    
    // 超出范围 （1-8）A
    if ([key isEqualToString:@"G_SolarLimitPower"]) {
        if ([prams[key] integerValue] < 1 || [prams[key] integerValue] > 8) {
            [self showToastViewWithTitle:[NSString stringWithFormat:@"%@（1-8）", root_chaochufanwei]];
            return;
        }
    }
    
    [self.dataDict setObject:prams[key] forKey:key];
    [self.setInfoDict setObject:prams[key] forKey:key];
    [self.tableView reloadData];
}


#pragma mark -- 设置费率成功的回调
- (void)setTimeRateWithArray:(NSArray *)timeRateArray{
    if (timeRateArray.count > 0) {
        self.priceConf = timeRateArray;
        // 加入费率显示
        [self setCurrentPriceConf];
        [self.tableView reloadData];
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
                
                [self.dataDict setObject:dict[@"unit"] forKey:@"unit"];
                [self.dataDict setObject:dict[@"symbol"] forKey:@"symbol"]; // 符号
                [self.setInfoDict setObject:dict[@"unit"] forKey:@"unit"];
                [self.setInfoDict setObject:dict[@"symbol"] forKey:@"symbol"];
                
            } selectValue:^(NSString* valueString){
                [self.tableView reloadData];
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
                        
                        [self.dataDict setObject:dict[@"unit"] forKey:@"unit"];
                        [self.dataDict setObject:dict[@"symbol"] forKey:@"symbol"]; // 符号
                        [self.setInfoDict setObject:dict[@"unit"] forKey:@"unit"];
                        [self.setInfoDict setObject:dict[@"symbol"] forKey:@"symbol"];
                        
                    } selectValue:^(NSString* valueString){
                        [self.tableView reloadData];
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
                [self.dataDict setDictionary:obj[@"data"]];
                [self.setInfoDict removeAllObjects];
                self.symbol = [NSString stringWithFormat:@"%@", obj[@"data"][@"symbol"]]; // 货币符号
                
                // solar模式
                if (self.dataDict[@"G_SolarMode"]) {
                    NSString *valueStr = [NSString stringWithFormat:@"%@", self.dataDict[@"G_SolarMode"]];
                    if([valueStr isEqualToString:@"2"]){ // ECO+
                        self.isSolarECO = YES;
                    }else{
                        self.isSolarECO = NO;
                    }
                }
                
                [self.tableView reloadData];
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
- (void)touchSendComAction{
    __weak typeof(self) weakSelf = self;
    
    // 不显示 ECO+电流限制 设置项，因此如果字典中存在的话就删掉
    if (!_isSolarECO) {
        if (self.setInfoDict[@"G_SolarLimitPower"]) {
            [self.setInfoDict removeObjectForKey:@"G_SolarLimitPower"];
        }
    }
    // 未有任何更改
    if (self.setInfoDict.allKeys.count == 0) {
        [self showToastViewWithTitle:root_weigenggai];
        return;
    }
    
    [_setInfoDict setObject:[UserInfo defaultUserInfo].userName forKey:@"userId"];
    [_setInfoDict setObject:self.sn forKey:@"chargeId"];
    
    NSLog(@"_setInfoDict： %@", _setInfoDict);
    [self showProgressView];
    [[DeviceManager shareInstenced] setChargeoConfigInfomationWithParms:_setInfoDict success:^(id obj) {
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

// 根据选择项返回显示
- (NSString *)getStringWithKind:(NSString *)kind number:(NSInteger)num{
    
    NSArray *titleArray = [self getSelectArrayWithKind:kind];
    // 防止数组越界
    if (num < titleArray.count) {
        
        return titleArray[num];
    }
    return @"--";
}

// 获取选择数组
- (NSArray *)getSelectArrayWithKind:(NSString *)kind{
    
    if([kind isEqualToString:@"G_ChargerMode"]) { // 充电模式
        
        return @[HEM_charge_model1, HEM_charge_model2, HEM_charge_model3];
        
    } else if([kind isEqualToString:@"G_PeakValleyEnable"] || [kind isEqualToString:@"G_ExternalLimitPowerEnable"]){ // 峰谷充电使能,  功率分配使能
        
        return @[root_shineng, root_jinzhi];
        
    } else if ([kind isEqualToString:@"G_ExternalSamplingCurWring"]) { // 外部电流采样接线方式
        
        return @[@"CT", root_dianbiao];
        
    } else if ([kind isEqualToString:@"G_SolarMode"]) { // solar模式
        
        return @[@"FAST", @"ECO", @"ECO+"];
        
    }
    
    return @[@"no data"];
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
