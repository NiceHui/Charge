//
//  BluetoothConnectVC.m
//  ShinePhone
//
//  Created by growatt007 on 2018/7/11.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "BluetoothConnectVC.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BluetoothCell.h"
#import "HSBluetoochManager.h"

@interface BluetoothConnectVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSIndexPath *IndexPath;

@property (nonatomic, strong) UIButton *startChargeBtn;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndictor;

@property (nonatomic, strong) NSMutableArray *deviceArray;

@end

@implementation BluetoothConnectVC

- (UIActivityIndicatorView *)activityIndictor{
    if (!_activityIndictor) {
        _activityIndictor = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndictor.frame = CGRectMake(134*XLscaleW, 20*XLscaleH, 10*XLscaleW, 10*XLscaleH);
    }
    return _activityIndictor;
}

- (NSMutableArray *)deviceArray{
    if (!_deviceArray) {
        _deviceArray = [[NSMutableArray alloc]init];
    }
    return _deviceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSubview];
    self.title = HEM_chongdianzhuang;
    // 搜索蓝牙设备
    [self scanForPeripherals];
}

- (void)setupSubview{

    //导航栏背景透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //导航透明度开启
    self.navigationController.navigationBar.translucent = YES;
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 264*XLscaleH)];
    bgImageView.image = IMAGE(@"connect_bg.png");
    [self.view addSubview:bgImageView];
    
    UILabel *ConnectLabel = [[UILabel alloc]initWithFrame:CGRectMake(100*XLscaleW, 190*XLscaleW, ScreenWidth-200*XLscaleW, 23*XLscaleW)];
    ConnectLabel.font = FontSize(24*XLscaleW);
    ConnectLabel.textColor = [UIColor whiteColor];
    ConnectLabel.text = root_lianjie_chenggong;
    ConnectLabel.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:ConnectLabel];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(100*XLscaleW, CGRectGetMaxY(ConnectLabel.frame)+15*XLscaleH, ScreenWidth-200*XLscaleW, 12*XLscaleW)];
    tipLabel.font = FontSize(12*XLscaleW);
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.text = root_charucheliang;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:tipLabel];
    
    UIView *blueToothView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgImageView.frame), ScreenWidth, 50*XLscaleH)];
    blueToothView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:blueToothView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(34*XLscaleW, 13*XLscaleH, 60*XLscaleW, 14*XLscaleH)];
    label.font = FontSize(15*XLscaleW);
    label.textColor = colorblack_51;
    label.text = root_lanya;
    [blueToothView addSubview:label];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame)+6*XLscaleH,  150*XLscaleW, 10*XLscaleH)];
    label2.font = FontSize(10*XLscaleW);
    label2.textColor = colorblack_102;
    label2.text = root_dakailanya;
    [blueToothView addSubview:label2];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(blueToothView.frame), ScreenWidth, ScreenHeight-CGRectGetMaxY(blueToothView.frame)+1*XLscaleH - 52) style:UITableViewStyleGrouped];
    [tableView registerClass:[BluetoothCell class] forCellReuseIdentifier:@"BluetoothCell"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = COLOR(246, 246, 246, 1);
    tableView.bounces = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIButton *startChargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tableView.frame), ScreenWidth, 52*XLscaleH)];
    [startChargeBtn setTitle:HEM_chongdian forState:UIControlStateNormal];
    [startChargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startChargeBtn addTarget:self action:@selector(startChargeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startChargeBtn];
    self.startChargeBtn = startChargeBtn;
    if ([HSBluetoochManager instance].isConnectSuccess) {
        startChargeBtn.enabled = YES;
        [startChargeBtn setBackgroundColor:mainColor];
    }else{
        startChargeBtn.enabled = NO;
        [startChargeBtn setBackgroundColor:COLOR(180, 180, 180, 1)];
    }
}


#pragma mark -- tableViewDelegate
/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50*XLscaleH;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50*XLscaleH)];
    headView.backgroundColor = COLOR(246, 246, 246, 1);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(34*XLscaleW, 18*XLscaleH, 100*XLscaleW, 14*XLscaleH)];
    label.font = FontSize(15*XLscaleW);
    label.textColor = colorblack_102;
    [headView addSubview:label];
    if (section == 0) {
        label.text = root_wodeshebei;
    }else{
        label.text = root_kepeiduishebei;
        [headView addSubview:self.activityIndictor];
    }
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.deviceArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*XLscaleH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BluetoothCell *cell = [[BluetoothCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BluetoothCell"];
    if (!cell) {
        cell = [[BluetoothCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BluetoothCell"];
    }
    if (indexPath == self.IndexPath) {// 判断选中，打钩
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.IndexPath = indexPath;
    }
    if (indexPath.section == 1) {
        CBPeripheral *peripheral = self.deviceArray[indexPath.row];
        cell.name = peripheral.name;
    }
    return cell;
}
/// did select
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    if (self.IndexPath && self.IndexPath != indexPath) {
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.IndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    self.IndexPath = indexPath;
    // 连接 or 切换新设备
    [self conectionWithDevice:indexPath.row];
}

#pragma mark -- CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
}

// 搜索蓝牙设备
- (void)scanForPeripherals{
    [[HSBluetoochManager instance] scanForPeripherals];
    __weak typeof(self) weakSelf = self;
    [HSBluetoochManager instance].GetBluePeripheralBlock = ^(id obj) {
        if (![self.deviceArray containsObject:obj]){
            [self.deviceArray addObject:obj];
        }
        [weakSelf.tableView reloadData];
    };
}

// 连接切换设置
- (void)conectionWithDevice:(NSInteger)index {
    
    [self.activityIndictor startAnimating];// 开启菊花
    [[HSBluetoochManager instance] connectToPeripheral:index];
    
    [HSBluetoochManager instance].ConnectBluePeripheralBlock = ^(id obj){// 连接结果
        
        if ([obj isEqualToString:@"YES"]) {
            self.startChargeBtn.enabled = YES;
            [self.startChargeBtn setBackgroundColor:mainColor];
        }else{
            self.startChargeBtn.enabled = NO;
            [self.startChargeBtn setBackgroundColor:COLOR(180, 180, 180, 1)];
        }
        [self.activityIndictor stopAnimating]; // 关闭菊花
    };
    
}


// 开始充电
- (void)startChargeAction:(UIButton *)btn{
    
//    btn.selected = !btn.isSelected;
//    if (btn.isSelected) {
//        [btn setBackgroundColor:mainColor];
//        [self.activityIndictor startAnimating];
//    }else{
//        [btn setBackgroundColor:COLOR(180, 180, 180, 1)];
//        [self.activityIndictor stopAnimating];
//    }
    
//    [[HSBluetoochManager instance]makeAppointment:YES Time:480]; //设置定时 04  结束符后多了两位
    
    [[HSBluetoochManager instance] openOrStop:YES];//开关 05

//    [[HSBluetoochManager instance]setChargingpileID:@"CP0001" currentVaule:32 token_ID:@"12345678" mode:1 rate:200 language:1]; //参数设置 06
    
//    [[HSBluetoochManager instance]gettingParameter]; //获取参数 07  数据长度出错
}


@end
