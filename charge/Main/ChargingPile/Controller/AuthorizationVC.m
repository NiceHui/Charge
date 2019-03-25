//
//  AuthorizationVC.m
//  ShinePhone
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 qwl. All rights reserved.
//

#import "AuthorizationVC.h"
#import "AuthorizationCell.h"
#import "AddAuthorizationVC.h"
#import "DeviceManager.h"

@interface AuthorizationVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation AuthorizationVC

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-kNavBarHeight-kBottomBarHeight)];
        [_tableView registerClass:[AuthorizationCell class] forCellReuseIdentifier:@"AuthorizationCellID"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = colorblack_222;
    }
    return _tableView;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 获取授权列表
    [self getAuthorData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = HEM_shouquanguanli;
    self.view.backgroundColor = colorblack_222;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.frame = CGRectMake(0, 0, 60, 24);
    [addBtn setTintColor:COLOR(0, 156, 255, 1)];
    [addBtn setImage:[IMAGE(@"userlist_add_user") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addAuthorizationgClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    [self creatViews];

}
- (void)creatViews{
    [self.view addSubview:self.tableView];
}
#pragma mark---添加授权
- (void)addAuthorizationgClick{
    NSLog(@"添加授权");
    AddAuthorizationVC *addAuth = [[AddAuthorizationVC alloc]init];
    addAuth.sn = self.sn;
    [self.navigationController pushViewController:addAuth animated:YES];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65*XLscaleH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AuthorizationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AuthorizationCellID"];
    if (!cell) {
        cell = [[AuthorizationCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AuthorizationCellID"];
    }
    cell.cellIndex = indexPath.row;
    [cell setCellWithData:self.dataSource[indexPath.row]];
    cell.touchCopyTextBlock = ^(NSString *text) {
//        [self showToastViewWithTitle:@"已复制到剪贴板"];
    };
    cell.touchDeleteEventBlock = ^(NSInteger index){
        [self removeAlert:self.dataSource[index][@"userId"]];
    };
    return cell;
}

#pragma mark -- Http request
// 获取授权列表
- (void)getAuthorData{
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced] GetChargingPileUseListWithSn:self.sn success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideProgressView];
            if ([obj[@"code"] isEqualToNumber:@0]) {
                weakSelf.dataSource = obj[@"data"];
                [weakSelf.tableView reloadData];
            }else{
                [weakSelf showToastViewWithTitle:obj[@"data"]];
            }
        });
    } failure:^(NSError *error) {
        [weakSelf hideProgressView];
    }];
}

// 删除用户
- (void)deleAuthor:(NSString *)userId{
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced] DeleteAuthorChargingPileWithSn:self.sn userId:userId success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideProgressView];
            if ([obj[@"code"] isEqualToNumber:@0]) {
                [weakSelf getAuthorData];
                [weakSelf showToastViewWithTitle:root_shanchu_chenggong];
            }else{
                [weakSelf showToastViewWithTitle:obj[@"data"]];
            }
        });
    } failure:^(NSError *error) {
        [weakSelf hideProgressView];
    }];
}


// 删除提示
- (void)removeAlert:(NSString *)userId{
    UIAlertController *removeAlert = [UIAlertController alertControllerWithTitle:root_shifou_shanchu_shouquan message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *enter = [UIAlertAction actionWithTitle:root_OK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([userId isEqualToString:[NSString stringWithFormat:@"%@", [UserInfo defaultUserInfo].userName]]) {
            [self showToastViewWithTitle:HEM_delete_shouquan_tips];
            return ;
        }
        [self deleAuthor:userId];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:root_cancel style:UIAlertActionStyleCancel handler:nil];
    [removeAlert addAction:enter];
    [removeAlert addAction:cancel];
    [self presentViewController:removeAlert animated:YES completion:nil];
}


@end
