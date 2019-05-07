//
//  EWBaseOptionController.m
//  EasyWork
//
//  Created by Ryan on 16/8/7.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "EWBaseOptionController.h"
#import "EWOptionArrowItem.h"
#import "EWOptionCell.h"
#import "MBProgressHUD.h"
//#import <UITableView+FDTemplateLayoutCell.h>

//static const DDLogLevel ddLogLevel = DDLogLevelVerbose;



@interface EWBaseOptionController ()

@property(nonatomic, strong, readwrite) NSMutableArray <EWOptionGroup *> *groups;

@end

@implementation EWBaseOptionController

- (instancetype)init {

    return [super initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {

    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置背景
//    self.view.backgroundColor = HexRGB(0xf4f4f4);

    // 设置每一组的头部高度
    self.tableView.sectionHeaderHeight = 35*XLscaleH;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
	[self.tableView registerClass:[EWOptionCell class] forCellReuseIdentifier:@"option_cell"];
	
    self.tableView.rowHeight = 45*XLscaleH;

    // 设置分割线样式
    self.tableView.separatorColor = colorblack_222;
}

- (void)dealloc {
//    DDLogVerbose(@"%@ dealloc", [self class]);
}


#pragma mark - Table view data source

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	return MAX(44, [tableView fd_heightForCellWithIdentifier:@"option_cell" configuration:^(EWOptionCell *cell) {
//		EWOptionGroup *group = self.groups[indexPath.section];
//		
//		EWOptionItem *item = group.items[indexPath.row];
//		
//		cell.item = item;
//	}]);
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.groups[section].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    EWOptionCell *cell = [EWOptionCell cellWithTableView:tableView];

    EWOptionGroup *group = self.groups[indexPath.section];

    EWOptionItem *item = group.items[indexPath.row];

    cell.item = item;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    EWOptionGroup *group = self.groups[indexPath.section];

    EWOptionItem *item = group.items[indexPath.row];

    if (item.didClickBlock) {
        item.didClickBlock();
        return;
    }

    if ([item isMemberOfClass:[EWOptionArrowItem class]]) {
        EWOptionArrowItem *arrowItem = (EWOptionArrowItem *) item;
        Class destVC = arrowItem.destinationVC;

        UIViewController *vc = [[destVC alloc] init];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    EWOptionGroup *group = self.groups[section];
    return group.headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {

    EWOptionGroup *group = self.groups[section];
    return group.footerTitle;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSMutableArray<EWOptionGroup *> *)groups {
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}


- (void)showToastViewWithTitle:(NSString *)title {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.labelText = title;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}


- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil];
    [alertView show];
}


- (void)showProgressView {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


- (void)hideProgressView {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
