//
//  TimingListViewController.m
//  charge
//
//  Created by growatt007 on 2018/10/18.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "TimingListViewController.h"
#import "TimingTableViewCell.h"
#import "setTimingViewController.h"
#import "ChargeTimingModel.h"

@interface TimingListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *emptyView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TimingListViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [self getChargeTimingList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = root_dingshi;
    self.view.backgroundColor = colorblack_222;
    [self setupHeadView];
    [self setupTableView];
    [self setupEmpty];
}

- (void)setupHeadView{
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 60, 24);
    [rightBtn setTitle:root_xinzeng forState:UIControlStateNormal];
    [rightBtn setTitleColor:mainColor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addNewTiming:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50*XLscaleH)];
    [self.view addSubview:headView];
    _headView = headView;
    
    float imageW = 18*XLscaleH, imageH = 18*XLscaleH, imageX = 20*XLscaleH, imageY = 50*XLscaleH/2 -imageH/2;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    imageView.image = [UIImage imageNamed:@"prepare_yuyue"];
    [_headView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+3, 50*XLscaleH/2 -20*XLscaleH/2, ScreenWidth*1/2, 20*XLscaleH)];
    titleLabel.text = root_yushefangan;
    titleLabel.textColor = colorblack_154;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [_headView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
}

- (void)setupEmpty{
    
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-kNavBarHeight)];
    emptyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:emptyView];
    [self.view bringSubviewToFront:emptyView];
    self.emptyView = emptyView;
    self.emptyView.hidden = YES;
    
    UIImageView *emptyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 100*XLscaleW, ScreenHeight/2-150*XLscaleH, 200*XLscaleW, 120*XLscaleH)];
    emptyImageView.image = IMAGE(@"empty.png");
    [emptyView addSubview:emptyImageView];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 150*XLscaleW,CGRectGetMaxY(emptyImageView.frame)+30*XLscaleH, 300*XLscaleW, 40*XLscaleH)];
    tipLabel.font = FontSize(16*XLscaleW);
    tipLabel.textColor = colorblack_154;
    tipLabel.text = HEM_meiyou_dingshi;
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [emptyView addSubview:tipLabel];
    
}

- (void)setupTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50*XLscaleH, ScreenWidth, ScreenHeight)];
    _tableView.backgroundColor = COLOR(255, 255, 255, 0);
    _tableView.separatorStyle = UITableViewCellEditingStyleNone;
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[TimingTableViewCell class] forCellReuseIdentifier:@"TimingTableViewCell"];
}

#pragma mark -- Http request
// 获取充电桩定时预约列表
- (void)getChargeTimingList{
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced] getChargeTimingListWithUserId:[UserInfo defaultUserInfo].userName Sn:self.sn ConnectorId:self.connectorId cKey:@"G_SetTime" success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideProgressView];
            if ([obj[@"code"] isEqualToNumber:@0]) {
                weakSelf.dataArray = [ChargeTimingModel objectArrayWithKeyValuesArray:obj[@"data"]];
                [weakSelf.tableView reloadData];
                [weakSelf CalculationLengthOftime];
            }
        });
    } failure:^(id error) {
        [weakSelf hideProgressView];
    }];
}

// 更新预约、注销、删除预约
- (void)updateChargeTiming:(NSDictionary *)parms{
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced] updateChargeTimingWithParms:parms success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideProgressView];
            if ([obj[@"code"] isEqualToNumber:@0]) {
                [weakSelf getChargeTimingList];
            }
            [weakSelf showToastViewWithTitle:obj[@"data"]];
        });
    } failure:^(id error) {
        [weakSelf hideProgressView];
    }];
}

- (void)CalculationLengthOftime{
    
    NSInteger totalValue = 0;
    for (int i = 0; i < self.dataArray.count; i++) {
        ChargeTimingModel *model = self.dataArray[i];
        NSInteger cValue = [model.cValue integerValue];
        totalValue += cValue;
    }
    NSString *hour = [NSString stringWithFormat:@"%ld", totalValue/60];
    NSString *min = [NSString SupplementZero:[NSString stringWithFormat:@"%ld", totalValue%60]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@h%@min",root_yushefangan,hour,min];
}

#pragma mark -- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(!self.dataArray.count){
        _headView.hidden = YES;
        self.emptyView.hidden = NO;
    }else{
        _headView.hidden = NO;
        self.emptyView.hidden = YES;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55*XLscaleH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TimingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimingTableViewCell"];
    if (!cell) {
        cell=[[TimingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimingTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    ChargeTimingModel *model = self.dataArray[indexPath.row];
    [cell setCellDataWithModel:model];
    __weak typeof(self) weakSelf = self;
    cell.touchOpenOrCloseTiming = ^(BOOL isOpen, BOOL loopType, NSString *type) {
        NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];//[model keyValues]
        
        parms[@"sn"] = model.chargeId;
        parms[@"userId"] = model.userId;
        parms[@"reservationId"] = model.reservationId;
        parms[@"connectorId"] = model.connectorId;
        parms[@"cKey"] = model.cKey;
        parms[@"cValue"] = model.cValue;
        
        // 更新日期
        NSString *expiryDate = model.expiryDate;
//        NSString *endDate = model.endDate;
        NSDateFormatter *dateformat = [[NSDateFormatter alloc]init];
        [dateformat setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateformat stringFromDate:[NSDate date]];
        parms[@"expiryDate"] = [NSString stringWithFormat:@"%@%@",dateString, [expiryDate substringWithRange:NSMakeRange(10, expiryDate.length-10)]];
//        parms[@"endDate"] = [NSString stringWithFormat:@"%@%@",dateString, [endDate substringWithRange:NSMakeRange(10, expiryDate.length-10)]];
        
        if (isOpen) {
            parms[@"ctype"] = @"1";// 开启
        }else{
            parms[@"ctype"] = @"2";// 关闭
        }
        if (loopType == 1) {
            parms[@"loopType"] = @(0); // 每天
            parms[@"loopValue"] = [expiryDate substringWithRange:NSMakeRange(11, 5)]; // 每天
        }else{
            parms[@"loopType"] = @(-1); // 取消每天
        }
        
        if (isOpen || [type isEqualToString:@"switch"]) {// 关闭状态点击每天不会发送指令
            [weakSelf updateChargeTiming:parms];
        }
    };
    
    return cell;
}

// did
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChargeTimingModel *model = self.dataArray[indexPath.row];
    setTimingViewController *vc = [[setTimingViewController alloc]init];
    vc.sn = self.sn;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}


// 添加定时
- (void)addNewTiming:(UIButton *)button{
    
    setTimingViewController *vc = [[setTimingViewController alloc]init];
    vc.sn = self.sn;
    vc.connectorId = self.connectorId;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_CONNECTOR_NUM" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
