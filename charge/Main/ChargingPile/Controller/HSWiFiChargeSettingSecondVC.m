//
//  HSWiFiChargeSettingSecondVC.m
//  charge
//
//  Created by growatt007 on 2019/7/26.
//  Copyright © 2019 hshao. All rights reserved.
//

#import "HSWiFiChargeSettingSecondVC.h"
#import "HSTCPWiFiManager.h"
#import "InputSettingAlert.h"
#import "HSBluetoochHelper.h"
#import "SelectTimeAlert.h"
#import "ZJBLStoreShopTypeAlert.h"

@interface HSWiFiChargeSettingSecondVC ()<InputSettingDelegate, HSTCPWiFiManagerDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSInteger tryNum; // 尝试重连次数
    BOOL isSucc;
    BOOL isEdit1; // 判断哪些项进行过修改的
    BOOL isEdit2;
    BOOL isEdit3;
    BOOL isEdit4;
    BOOL isEdit5;
    BOOL isTouchCarried; // 是否点击执行下发
}

@property (nonatomic, strong) HSTCPWiFiManager *wifiManager;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *keysArray;

@property (nonatomic, strong) InputSettingAlert *inputAlert;
@property (nonatomic, strong) SelectTimeAlert *timeAlert;

@property (nonatomic, strong) NSMutableDictionary *baseInfo; // 电桩基本参数
@property (nonatomic, strong) NSMutableDictionary *netWorkInfo; // 以太网
@property (nonatomic, strong) NSMutableDictionary *accountInfo; // 账户密码
@property (nonatomic, strong) NSMutableDictionary *serverInfo; // 服务器
@property (nonatomic, strong) NSMutableDictionary *chargeInfo; // 充电参数
@property (nonatomic, strong) NSMutableDictionary *allDataDict; // 全部参数

@property (nonatomic, assign) BOOL isSolarECO; // 是否显示Solar的ECO+限制电流
@end

@implementation HSWiFiChargeSettingSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = HEM_zhuangtishezhi;
    
    // 建立连接
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
    
    isEdit1 = NO;
    isEdit2 = NO;
    isEdit3 = NO;
    isEdit4 = NO;
    isEdit5 = NO;
    isTouchCarried = NO;
    _isSolarECO = NO; // 是否显示ECO电流输入
    self.allDataDict=[[NSMutableDictionary alloc]init];
    
    [self setupAlert];
    [self createUIView];
    [self createRightItem];
    tryNum = 0;
}

// 右上角执行按键
- (void)createRightItem{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50*XLscaleW, 30*XLscaleH)];
    [button setTitle:root_zhixing forState:UIControlStateNormal];
    [button setTitleColor:mainColor forState:UIControlStateNormal];
    button.titleLabel.font = FontSize([NSString getFontWithText:root_zhixing size:CGSizeMake(50*XLscaleW, 30*XLscaleH) currentFont:16*XLscaleH]);
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
        [weakSelf.chargeInfo setObject:text forKey:@"allow_time"];
        [weakSelf.allDataDict setObject:text forKey:@"allow_time"];
        self->isEdit5 = YES;
        [weakSelf.tableView reloadData];
    };
}

- (void)createUIView{
    
    _titleArray=@[root_canshushezhi_1,root_canshushezhi_2,root_canshushezhi_3,
                  root_canshushezhi_4,root_canshushezhi_5];
    
    _itemArray = [[NSMutableArray alloc]initWithArray:@[
                 @[HEM_charge_id,root_yuyan,root_dukaiqi_miyao,
                   root_rcd_baohuzhi,root_banbenhao],
                 
                 @[HEM_charge_ip,HEM_charge_wangguang,HEM_charge_yanma,
                   HEM_charge_mac,HEM_charge_dns],
                 
                 @[root_wifi_ssid,root_wifi_key,root_buletouch_ssid,root_buletouch_key,
                   root_fourG_ssid,root_fourG_key,root_fourG_apn],
                 
                 @[HEM_charge_url,root_login_key,root_heartbeat_time,root_ping_time,root_upload_time],
                 
                 @[HEM_charge_moshi,root_max_current,HEM_charge_feilv,root_protection_temp,
                   root_max_input_power,root_allow_time,root_fengguchongdianshineng,root_gonglvfengpeishineng,
                   root_waibudianliu,root_solar_mode,root_eco_current_limit,root_dianbiaodizhi]]];
    
    _keysArray=[[NSMutableArray alloc]initWithArray:@[
                 @[@"name",@"lan",@"secret",@"rcd",@"version"],
                 
                 @[@"IP",@"gateway",@"mask",@"mac",@"dns"],
                 
                 @[@"wifi_ssid",@"wifi_key",@"buletouch_ssid",@"buletouch_key",
                   @"fourG_ssid",@"fourG_key",@"fourG_apn"],
                 
                 @[@"url",@"login_key",@"heartbeat_time",@"ping_time",@"upload_time"],
                 
                 @[@"mode",@"max_current",@"rate",@"protection_temp",
                   @"max_input_power",@"allow_time",@"peak_enable",@"power_enable",
                   @"external_current",@"solar_mode",@"eco_current_limit",@"ammeter_address"]]];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-kNavBarHeight-kBottomBarHeight) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight=45*XLscaleH;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    MJRefreshHeader *header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self showProgressView];
        self->isTouchCarried = NO;
        self->isSucc = NO;
        [[HSTCPWiFiManager instance] connectToDev:[HSBluetoochHelper dataWithString:self.devData[@"devName"] length:20]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideProgressView];
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
    self.tableView.mj_header = header;
    
    
}


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
    return 5;
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
    
    BOOL isShow = YES;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if ((section==0&&row==0) || (section==0&&row==4) || (section==1&&row==3)) {
        isShow = NO;
    }
    // 是否显示箭头
    if (isShow) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
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
    // key 值
    NSString *keyString = _keysArray[indexPath.section][indexPath.row];
    NSString *valueString = [NSString stringWithFormat:@"%@", _allDataDict[keyString]];
    
    // 密文显示
    if ([keyString isEqualToString:@"secret"] || [keyString isEqualToString:@"wifi_key"] || [keyString isEqualToString:@"buletouch_key"]) {
        valueString = @"********";
    }
    // 语言
    if ([keyString isEqualToString:@"lan"]) {
        if ([valueString isEqualToString:@"1"]) {
            valueString = root_yingwen;
        } else if ([valueString isEqualToString:@"2"]){
            valueString = root_taiwen;
        } else if ([valueString isEqualToString:@"3"]){
            valueString = root_zhongwen;
        }
    }
    // RCD等级
    if ([keyString isEqualToString:@"rcd"]) {
        if (!kStringIsEmpty(valueString)) { // 不为空
            valueString = [NSString stringWithFormat:@"%@ %@", valueString, root_dengji];
        }
    }
    // 充电模式
    if ([keyString isEqualToString:@"mode"]) {
        if ([valueString isEqualToString:@"1"]) {
            valueString = HEM_charge_model1;
        }else if ([valueString isEqualToString:@"2"]) {
            valueString = HEM_charge_model2;
        }else if ([valueString isEqualToString:@"3"]) {
            valueString = HEM_charge_model3;
        }
    }
    // 峰谷充电使能， 功率分配使能
    if ([keyString isEqualToString:@"peak_enable"] || [keyString isEqualToString:@"power_enable"]) {
        if ([valueString isEqualToString:@"1"]) {
            valueString = root_shineng;
        }else if ([valueString isEqualToString:@"0"]) {
            valueString = root_jinzhi;
        }
    }
    // external_current
    if ([keyString isEqualToString:@"external_current"] || [keyString isEqualToString:@"solar_mode"]) {
        
        valueString = [self getStringWithKind:keyString number:[valueString integerValue]];
        
    }
    // 判空
    valueString = kStringIsEmpty(valueString) ? @"--" : valueString;
    
    if (self.allDataDict.allValues.count == 0) {
        valueString = @"--";
    }
    
    lblContent.text=valueString;
    
    return cell;
}

// TODO: 点击tableView Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *titleString = _itemArray[indexPath.section][indexPath.row]; // 标题
    NSString *keyString = _keysArray[indexPath.section][indexPath.row];// key 值
    
    // 不可设置项
    if ([keyString isEqualToString:@"name"] || [keyString isEqualToString:@"version"] || [keyString isEqualToString:@"mac"]) {
        return;
    }
    
    if ([keyString isEqualToString:@"lan"] || [keyString isEqualToString:@"rcd"] || [keyString isEqualToString:@"mode"] || [keyString isEqualToString:@"peak_enable"] || [keyString isEqualToString:@"power_enable"] || [keyString isEqualToString:@"external_current"] || [keyString isEqualToString:@"solar_mode"]) {
        
        __weak typeof(self) weakSelf = self;
        NSArray *actionArray = [self getSelectArrayWithKind:keyString];// 选择项数组
        [ZJBLStoreShopTypeAlert showWithTitle:titleString titles:actionArray selectIndex:^(NSInteger SelectIndexNum){
            if (self->isSucc == NO) { // 连接命令失败， 获取值失败，不让用户进行设置
                [self showToastViewWithTitle:root_shezhi_shibai];
                return;
            }
            
            if ([keyString isEqualToString:@"lan"]) {// 语言
                
                [self.baseInfo setObject:[NSString stringWithFormat:@"%ld", SelectIndexNum+1] forKey:@"lan"];
                [self.allDataDict setObject:[NSString stringWithFormat:@"%ld", SelectIndexNum+1] forKey:@"lan"];
                self->isEdit1 = YES; // 标志为更改项
                
            } else if([keyString isEqualToString:@"rcd"]) { // RCD保护值 mA
                
                [self.baseInfo setObject:[NSString stringWithFormat:@"%ld",SelectIndexNum+1] forKey:@"rcd"];
                [self.allDataDict setObject:[NSString stringWithFormat:@"%ld",SelectIndexNum+1] forKey:@"rcd"];
                self->isEdit1 = YES; // 标志为更改项
                
            } else if([keyString isEqualToString:@"mode"]) { // 充电模式
                
                [self.chargeInfo setObject:[NSString stringWithFormat:@"%ld", SelectIndexNum+1] forKey:@"mode"];
                [self.allDataDict setObject:[NSString stringWithFormat:@"%ld", SelectIndexNum+1] forKey:@"mode"];
                self->isEdit5 = YES; // 标志为更改项
                
            } else if([keyString isEqualToString:@"peak_enable"] || [keyString isEqualToString:@"power_enable"]){ // 峰谷充电使能,  功率分配使能
                
                if (SelectIndexNum == 0) {
                    [self.chargeInfo setObject:@"1" forKey:keyString]; // 使能
                    [self.allDataDict setObject:@"1" forKey:keyString];
                } else if (SelectIndexNum == 1){
                    [self.chargeInfo setObject:@"0" forKey:keyString]; // 禁止
                    [self.allDataDict setObject:@"0" forKey:keyString];
                }
                self->isEdit5 = YES; // 标志为更改项
                
            } else if ([keyString isEqualToString:@"external_current"]){ // 外部电流采样接线方式
                
                [self.chargeInfo setObject:[NSString stringWithFormat:@"%ld", (long)SelectIndexNum] forKey:@"external_current"];
                [self.allDataDict setObject:[NSString stringWithFormat:@"%ld", (long)SelectIndexNum] forKey:@"external_current"];
                self->isEdit5 = YES; // 标志为更改项
                
            } else if ([keyString isEqualToString:@"solar_mode"]){ // solar模式
                
                [self.chargeInfo setObject:[NSString stringWithFormat:@"%ld", (long)SelectIndexNum] forKey:@"solar_mode"];
                [self.allDataDict setObject:[NSString stringWithFormat:@"%ld", (long)SelectIndexNum] forKey:@"solar_mode"];
                self->isEdit5 = YES; // 标志为更改项
                
                if(SelectIndexNum == 2){ // 选择了ECO+
                    self.isSolarECO = YES;
                }else{
                    self.isSolarECO = NO;
                }
            }
            
        } selectValue:^(NSString* valueString){
            [weakSelf.tableView reloadData];
        } showCloseButton:YES];
        
        
    } else if ([keyString isEqualToString:@"allow_time"]){ // 允许设置时间
        
        [self.timeAlert show];
        if (self.chargeInfo[@"allow_time"]) {
            self.timeAlert.selectTime = [NSString stringWithFormat:@"%@", self.chargeInfo[@"allow_time"]];
        }
        self.timeAlert.titleText = root_allow_time;
        
    } else{ // 其他
        
        [self.inputAlert show];
        if (self.allDataDict[keyString]) {
            self.inputAlert.currentText = [NSString stringWithFormat:@"%@", self.allDataDict[keyString]];
        }
        self.inputAlert.itemText = keyString;
        self.inputAlert.titleText = titleString;
    }
    
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
    if ([key isEqualToString:@"heartbeat_time"] || [key isEqualToString:@"ping_time"] || [key isEqualToString:@"upload_time"] || [key isEqualToString:@"max_current"] || [key isEqualToString:@"protection_temp"] || [key isEqualToString:@"max_input_power"] || [key isEqualToString:@"ammeter_address"]) {
        // 判断是否为数字，只能为整数
        if(![NSString isNum2:prams[key]]){
            [self showToastViewWithTitle:root_geshi_cuowu];
            return;
        }
    }
    if ([key isEqualToString:@"rate"] || [key isEqualToString:@"eco_current_limit"]) {
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
    // 超出范围 （1-8）A
    if ([key isEqualToString:@"eco_current_limit"]) {
        if ([prams[key] integerValue] < 1 || [prams[key] integerValue] > 8) {
            [self showToastViewWithTitle:[NSString stringWithFormat:@"%@（1-8）", root_chaochufanwei]];
            return;
        }
    }
    
    // 设备信息参数设置  4
    if([key isEqualToString:@"secret"]){
        [self.baseInfo setObject:prams[key] forKey:key];
        isEdit1 = YES;
    }
    
    // 设置设备以太网参数  6
    if([key isEqualToString:@"IP"] || [key isEqualToString:@"gateway"] || [key isEqualToString:@"mask"] || [key isEqualToString:@"mac"] || [key isEqualToString:@"dns"]){
        [self.netWorkInfo setObject:prams[key] forKey:key];
        isEdit2 = YES;
    }
    
    // wifi设置  8
    if([key isEqualToString:@"wifi_ssid"] || [key isEqualToString:@"wifi_key"] || [key isEqualToString:@"buletouch_ssid"] || [key isEqualToString:@"buletouch_key"] || [key isEqualToString:@"fourG_ssid"] || [key isEqualToString:@"fourG_key"] || [key isEqualToString:@"fourG_apn"]){
        [self.accountInfo setObject:prams[key] forKey:key];
        isEdit3 = YES;
    }
    
    // 服务器参数设置  10
    if([key isEqualToString:@"url"] || [key isEqualToString:@"login_key"] || [key isEqualToString:@"heartbeat_time"] || [key isEqualToString:@"ping_time"] || [key isEqualToString:@"upload_time"]){
        [self.serverInfo setObject:prams[key] forKey:key];
        isEdit4 = YES;
    }
    
    // 设备充电参数设置  12
    if([key isEqualToString:@"max_current"] || [key isEqualToString:@"rate"] || [key isEqualToString:@"protection_temp"] || [key isEqualToString:@"max_input_power"] || [key isEqualToString:@"eco_current_limit"] || [key isEqualToString:@"ammeter_address"]){
        [self.chargeInfo setObject:prams[key] forKey:key];
        isEdit5 = YES;
    }
    
    [self.allDataDict setObject:prams[key] forKey:key];
    [self.tableView reloadData];
}



#pragma mark -- HSTCPWiFiManagerDelegate   socket 回调

- (void)SocketConnectIsSucces:(BOOL)isSucces{}

- (void)TCPSocketReadData:(NSDictionary *)dataDic{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSInteger cmd = [[NSString stringWithFormat:@"%@", dataDic[@"cmd"]] integerValue];
        NSLog(@"TCPSocketReadData cmd: **%ld**", (long)cmd);
        
        // 记录全部参数
        NSArray *keys=dataDic.allKeys;
        for (int i = 0; i < keys.count; i++) {
            NSString *key = keys[i];
            [self.allDataDict setObject:dataDic[key] forKey:key];
        }
        [self.allDataDict removeObjectForKey:@"cmd"];
        
        if (cmd == 0x01) { // 获取设备信息参数 3
            
            self.baseInfo = [[NSMutableDictionary alloc]initWithDictionary:dataDic];
            [self.baseInfo removeObjectForKey:@"cmd"];
            self->isEdit1 = NO; // 重置标志
        } else if(cmd == 0x02){// 获取设备以太网参数 5
            
            self.netWorkInfo = [[NSMutableDictionary alloc]initWithDictionary:dataDic];
            [self.netWorkInfo removeObjectForKey:@"cmd"];
            self->isEdit2 = NO; // 重置标志
        } else if(cmd == 0x03){// 获取设备以太网参数 7
            
            self.accountInfo = [[NSMutableDictionary alloc]initWithDictionary:dataDic];
            [self.accountInfo removeObjectForKey:@"cmd"];
            self->isEdit3 = NO; // 重置标志
        } else if(cmd == 0x04){// 获取服务器参数 9
            
            self.serverInfo = [[NSMutableDictionary alloc]initWithDictionary:dataDic];
            [self.serverInfo removeObjectForKey:@"cmd"];
            self->isEdit4 = NO; // 重置标志
        } else if(cmd == 0x05){// 设备充电参数 11
            
            self.chargeInfo = [[NSMutableDictionary alloc]initWithDictionary:dataDic];
            [self.chargeInfo removeObjectForKey:@"cmd"];
            self->isEdit5 = NO; // 重置标志
            
            // solar模式
            if (self.chargeInfo[@"solar_mode"]) {
                NSString *valueStr = [NSString stringWithFormat:@"%@", self.chargeInfo[@"solar_mode"]];
                if([valueStr isEqualToString:@"2"]){ // ECO+
                    self.isSolarECO = YES;
                }else{
                    self.isSolarECO = NO;
                }
            }
            
            [self hideProgressView];
            self->isSucc = YES;
            [self.tableView.mj_header endRefreshing];
        }
        
        // 确认点击了执行下发按键，并且全部设置成功
        if (self->isTouchCarried && !self->isEdit1 && !self->isEdit2 && !self->isEdit3 && !self->isEdit4 && !self->isEdit5) {
            // 重置标志
            self->isTouchCarried = NO;
            // 退出该设置页面，退出时发送退出命令
            [self.navigationController popViewControllerAnimated:YES];
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


// TODO: 点击执行发送指令
- (void)touchSendComAction{
    
    if(!isEdit1 && !isEdit2 && !isEdit3 && !isEdit4 && !isEdit5){ // 未更改任何设置
        [self showToastViewWithTitle:root_weigenggai];
        return;
    }
    
    // 点击了执行下发按键
    isTouchCarried = YES;
    
    if (isEdit1) {// 设备信息参数设置  4
        [[HSTCPWiFiManager instance] setDeviceBaseInfo:self.baseInfo];
    }
    if (isEdit2) {// 设置设备以太网参数  6
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[HSTCPWiFiManager instance] setDeviceNetWorkInfo:self.netWorkInfo];
        });
    }
    if (isEdit3) {// wifi设置  8
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[HSTCPWiFiManager instance] setDevicePassInfo:self.accountInfo];
        });
    }
    if (isEdit4) {// 服务器参数设置  10
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[HSTCPWiFiManager instance] setDeviceServerInfo:self.serverInfo];
        });
    }
    if (isEdit5) {// 设备充电参数设置  12
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[HSTCPWiFiManager instance] setDeviceChargeInfo:self.chargeInfo];
        });
    }
}



- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // 退出命令
    [[HSTCPWiFiManager instance] disConnectToDev];
}

// 是否显示 ECO+电流限制 设置项
- (void)setIsSolarECO:(BOOL)isSolarECO{
    _isSolarECO = isSolarECO;
    
    NSMutableArray *items4 = [[NSMutableArray alloc]initWithArray:_itemArray[4]];
    NSMutableArray *keys4 = [[NSMutableArray alloc]initWithArray:_keysArray[4]];
    
    if (!isSolarECO) {
        [items4 removeObject:root_eco_current_limit];
        [keys4 removeObject:@"eco_current_limit"];
    }else{
        if (![items4 containsObject:root_eco_current_limit]) {
            [items4 insertObject:root_eco_current_limit atIndex:10];
        }
        if (![keys4 containsObject:@"eco_current_limit"]) {
            [keys4 insertObject:@"eco_current_limit" atIndex:10];
        }
    }
    [_itemArray replaceObjectAtIndex:4 withObject:items4];
    [_keysArray replaceObjectAtIndex:4 withObject:keys4];
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
    
    if ([kind isEqualToString:@"lan"]) {// 语言
        
        return @[root_yingwen, root_taiwen, root_zhongwen];
        
    } else if([kind isEqualToString:@"rcd"]) { // RCD保护值 mA
        
        NSMutableArray *actionArray = [NSMutableArray array];
        for (int i = 1 ; i <= 9; i++) {
            [actionArray addObject:[NSString stringWithFormat:@"%d %@",i ,root_dengji]];
        }
        return actionArray;
        
    } else if([kind isEqualToString:@"mode"]) { // 充电模式
        
        return @[HEM_charge_model1, HEM_charge_model2, HEM_charge_model3];
        
    } else if([kind isEqualToString:@"peak_enable"] || [kind isEqualToString:@"power_enable"]){ // 峰谷充电使能,  功率分配使能
        
        return @[root_shineng, root_jinzhi];
        
    } else if ([kind isEqualToString:@"external_current"]) { // 外部电流采样接线方式
        
        return @[@"CT", root_dianbiao];
        
    } else if ([kind isEqualToString:@"solar_mode"]) { // solar模式
        
        return @[@"FAST", @"ECO", @"ECO+"];
        
    }
    
    return @[@"no data"];
}

@end
