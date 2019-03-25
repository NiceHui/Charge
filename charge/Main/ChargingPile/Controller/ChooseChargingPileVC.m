//
//  ChooseChargingPileVC.m
//  ShinePhone
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 qwl. All rights reserved.
//

#import "ChooseChargingPileVC.h"
#import "ChargingPileCell.h"
#import "BluetoothConnectVC.h"

@interface ChooseChargingPileVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ChooseChargingPileVC
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60*XLscaleH, ScreenWidth, ScreenHeight-60*XLscaleH)];
        [_tableView registerClass:[ChargingPileCell class] forCellReuseIdentifier:@"ChargingPileCellID"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = colorblack_222;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = HEM_xuanzezhongdianzhuang;
    self.view.backgroundColor = colorblack_222;
    [self creatViews];
}
- (void)creatViews{
    
    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60*XLscaleH)];
    searchBgView.backgroundColor = mainColor;
    [self.view addSubview:searchBgView];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    leftView.backgroundColor = COLOR(255, 255, 255, 0.1);
    
    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(15,13*XLscaleH, ScreenWidth-30,35*XLscaleH)];
    searchTF.backgroundColor = COLOR(255, 255, 255, 0.3);
    searchTF.leftView = leftView;
    [searchTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    searchTF.placeholder = root_sousuo;
    [self.view addSubview:searchTF];
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115*XLscaleH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChargingPileCell *cell = [[ChargingPileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ChargingPileCellID"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BluetoothConnectVC *bluetoothVC = [[BluetoothConnectVC alloc]init];
    [self.navigationController pushViewController:bluetoothVC animated:YES];
}



@end
