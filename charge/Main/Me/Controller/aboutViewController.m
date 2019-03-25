//
//  findViewController.m
//  shinelink
//
//  Created by sky on 16/2/15.
//  Copyright © 2016年 sky. All rights reserved.
//


#import "aboutTableViewCell.h"
#import "aboutViewController.h"
#import "aboutOneTableViewCell.h"
#import "protocol.h"


@interface aboutViewController ()<UITableViewDataSource,UITableViewDelegate>

//@property (nonatomic, strong) UIImagePickerController *cameraImagePicker;
//@property (nonatomic, strong) UIImagePickerController *photoLibraryImagePicker;
@property (nonatomic, strong) NSString *serviceNum;
@property (nonatomic, strong) NSString *currentVersion;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *appUrl;
@end

@implementation aboutViewController
{
    UITableView *_tableView;
    UIPageControl *_pageControl;
    UIScrollView *_scrollerView;
    NSString *_indenty;
    NSString *_indenty1;
    
    //全局变量 用来控制偏移量
    NSInteger pageName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    _currentVersion = [appInfo objectForKey:@"CFBundleShortVersionString"];
    
    //创建tableView的方法
    [self _createTableView];
    
    //创建tableView的头视图
    [self _createHeaderView];
    
    [self netAbout];
    
}

-(void)netAbout{
    NSString *typeString;
    if ([self.languageType isEqualToString:@"0"]) {
        typeString=@"0";
    }else{
          typeString=@"1";
    }
    
    [BaseRequest requestWithMethodResponseJsonByGet:HEAD_URL paramars:@{@"type":typeString} paramarsSite:@"/newUserAPI.do?op=getServicePhoneNum" sucessBlock:^(id content) {
        NSLog(@"getServicePhoneNum: %@", content);
        [self hideProgressView];
        if (content) {
            _serviceNum=content[@"servicePhoneNum"];
            
            [_tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self hideProgressView];
    }];
    
}

- (void)_createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
  
    
    [self.view addSubview:_tableView];
  
}

- (void)_createHeaderView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,200*XLscaleH)];
    UIColor *color=COLOR(218, 237, 244, 1);
    
    //UIColor *color=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_list_popver"]];
    [headerView setBackgroundColor:color];
    
    
    double imageSize=80*XLscaleH;
    
    UIImageView *userImage= [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-imageSize)/2, 60*XLscaleH, imageSize, imageSize)];
    [userImage setImage:[UIImage imageNamed:@"Logo123"]];
    [userImage setBackgroundColor:[UIColor grayColor]];
    userImage.layer.masksToBounds=YES;
    userImage.layer.cornerRadius=imageSize/4.0;
    
   
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-140*XLscaleW)/2, 150*XLscaleH, 140*XLscaleW,20*XLscaleH)];
    version.font=[UIFont systemFontOfSize:12*XLscaleH];
    version.textAlignment = NSTextAlignmentCenter;
    NSString *version1=root_WO_banbenhao;
    NSString *version2=_currentVersion;
    NSString *version3=[NSString stringWithFormat:@"%@%@",version1,version2];
    version.text=version3;
    version.textColor = [UIColor blackColor];
    [headerView addSubview:version];
    
    _tableView.tableHeaderView = headerView;
    [headerView addSubview:userImage];
    
}


#pragma mark -- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55*XLscaleH;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cell11=@"cell1";
    aboutTableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:cell11];
    if(indexPath.row==0)
    {
        if (!cell1) {
            cell1=[[aboutTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell11];
        }
        [cell1.imageLog setImage:[UIImage imageNamed:@"user-agreement"]];
        cell1.tableName.text = root_WO_xieyi;
        
        return cell1;
    }

    else return nil;

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    if(indexPath.row==0)
    {
        protocol *go0=[[protocol alloc]init];
        go0.title = root_WO_xieyi;
        [self.navigationController pushViewController:go0 animated:NO];
    }
    
    if(indexPath.row==1)
    {
        if ([self.languageType isEqualToString:@"0"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:_serviceNum message:root_dadianhua delegate:self cancelButtonTitle:root_cancel otherButtonTitles:root_OK, nil];
            alertView.tag = 1002;
            [alertView show];
        }
    }
}


-(void)checkUpdate{

    [self showProgressView];
    [BaseRequest requestWithMethodResponseJsonByGet:@"http://itunes.apple.com" paramars:@{@"admin":@"admin"} paramarsSite:@"/lookup?id=1128270005" sucessBlock:^(id content) {
        NSLog(@"getServicePhoneNum: %@", content);
        [self hideProgressView];
        
        if (content) {
            NSArray *resultArray = [content objectForKey:@"results"];
            
            if(resultArray.count>0){
            NSDictionary *resultDict = [resultArray objectAtIndex:0];
            
             _appVersion = [resultDict objectForKey:@"version"];
            
            if ([_appVersion doubleValue] > [_currentVersion doubleValue]) {
                NSString *oneK=root_WO_zuixin_banben; NSString *twoK=root_WO_shifou_gengxin;
                NSString *msg = [NSString stringWithFormat:@"%@%@,%@?",oneK,_appVersion,twoK];
               _appUrl = [resultDict objectForKey:@"trackViewUrl"];
            
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:root_Alet_user message:msg delegate:self cancelButtonTitle:root_WO_zanbu otherButtonTitles:root_WO_liji_gengxin, nil];
                alertView.tag = 1000;
                [alertView show];
                          }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:root_Alet_user message:root_WO_shi_zuixin_banben delegate:self cancelButtonTitle:nil otherButtonTitles:root_OK, nil];
                alertView.tag = 1001;
                [alertView show];
           
            }
            
        }else{
         UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:root_Alet_user message:root_WO_pingguo_fuwuqi_shibai delegate:self cancelButtonTitle:nil otherButtonTitles:root_OK, nil];
             [alertView1 show];
        }
        }
    } failure:^(NSError *error) {
        [self hideProgressView];
        UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:root_Alet_user message:root_WO_pingguo_fuwuqi_shibai delegate:self cancelButtonTitle:nil otherButtonTitles:root_OK, nil];
         [alertView2 show];
    }];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex) {
        if (alertView.tag == 1000) {
            if(_appUrl)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_appUrl]];
            }
        }
        
        if (alertView.tag == 1002) {
        
            NSString *strUrl = [_serviceNum stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *allString = [NSString stringWithFormat:@"tel://%@",strUrl];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
        }
    }
}

@end
