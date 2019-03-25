//
//  ChargeRecordVC.m
//  ShinePhone
//
//  Created by growatt007 on 2018/7/10.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "ChargeRecordVC.h"
#import "ChargeRecordCell.h"
#import "ChargeRecordModel.h"

@interface ChargeRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIView *emptyView;
@end

@implementation ChargeRecordVC

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-kNavBarHeight-kBottomBarHeight)];
        [_tableView registerClass:[ChargeRecordCell class] forCellReuseIdentifier:@"ChargeRecordCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = colorblack_222;
    }
    return _tableView;
}

// 懒加载
- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = HEM_chongdianjilu;
    self.view.backgroundColor = colorblack_222;
    [self setupSubview];
    [self getChargingpileRecordList];
}

- (void)setupSubview{
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header  = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        [weakSelf getChargingpileRecordList];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
    header.automaticallyChangeAlpha = YES;    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    header.lastUpdatedTimeLabel.hidden = YES;    // 隐藏时间
    self.tableView.mj_header = header;
    
    [self.view addSubview:self.tableView];
        
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
    tipLabel.text = HEM_meiyou_jilu;
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [emptyView addSubview:tipLabel];
    
}

#pragma mark -- Http request
// 获取记录
- (void)getChargingpileRecordList{
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced] ChargeRecordChargingPileWithUserId:[UserInfo defaultUserInfo].userName Sn:self.sn page:@0 success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideProgressView];
            [weakSelf.tableView.mj_header endRefreshing];
            if ([obj[@"code"] isEqualToNumber:@0]) {
                weakSelf.dataSource = [ChargeRecordModel objectArrayWithKeyValuesArray:obj[@"data"]];
                [weakSelf.tableView reloadData];
            }
        });
    } failure:^(NSError *error) {
        [weakSelf hideProgressView];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSource.count) {
        self.emptyView.hidden = YES;
    }else{
        self.emptyView.hidden = NO;
    }
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145*XLscaleH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChargeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChargeRecordCell"];
    if (!cell) {
        cell = [[ChargeRecordCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ChargeRecordCell"];
    }
    
    [cell setCellDataWithModel:self.dataSource[indexPath.row]];
    
    return cell;
}



@end
