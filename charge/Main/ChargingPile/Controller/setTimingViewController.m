//
//  setTimingViewController.m
//  charge
//
//  Created by growatt007 on 2018/10/18.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "setTimingViewController.h"
#import "PickerViewAlert.h"

@interface setTimingViewController ()

@property (nonatomic, strong) UIButton *startBotton;
@property (nonatomic, strong) UIButton *closeBotton;
@property (nonatomic, strong) UIButton *loopButton;

@end

@implementation setTimingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = root_shezhidinghsi;
    self.view.backgroundColor = colorblack_222;
    [self setupHeadView];
}

- (void)setupHeadView{
    
    // 个人信息
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 40, 24);
    [rightBtn setTitle:root_baocun forState:UIControlStateNormal];
    [rightBtn setTitleColor:mainColor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveTiming:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    float viewW = ScreenWidth, viewH = 100*XLscaleH, viewY = 20*XLscaleH;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, viewY, viewW, viewH)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    // 开启
    float labelW = 100*XLscaleW, labelH = 15*XLscaleH, marginLF = 15*XLscaleW, marginTop = viewH/4-labelH/2;
    UILabel *starTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(marginLF, marginTop, labelW, labelH)];
    starTitleLabel.text = root_kaiqi;
    starTitleLabel.textColor = colorblack_154;
    starTitleLabel.font = FontSize(13*XLscaleH);
    [view addSubview:starTitleLabel];
    
    float buttonW = 60*XLscaleW;
    UIButton *startBotton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-marginLF-buttonW, marginTop, buttonW, labelH)];
    [startBotton setTitle:root_weishezhi forState:UIControlStateNormal];
    [startBotton setTitleColor:colorblack_154 forState:UIControlStateNormal]; ;
    startBotton.titleLabel.font = FontSize(13*XLscaleH);
    [startBotton addTarget:self action:@selector(setTiming:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:startBotton];
    _startBotton = startBotton;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, viewH/2, ScreenWidth, 1)];
    lineView.backgroundColor = colorblack_222;
    [view addSubview:lineView];
    
    // 关闭
    UILabel *closeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(marginLF, viewH/2+marginTop, labelW, labelH)];
    closeTitleLabel.text = root_guanbi;
    closeTitleLabel.textColor = colorblack_154;
    closeTitleLabel.font = FontSize(13*XLscaleH);
    [view addSubview:closeTitleLabel];
    
    UIButton *closeBotton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-marginLF-buttonW, viewH/2+marginTop, buttonW, labelH)];
    [closeBotton setTitle:root_weishezhi forState:UIControlStateNormal];
    [closeBotton setTitleColor:colorblack_154 forState:UIControlStateNormal]; ;
    closeBotton.titleLabel.font = FontSize(13*XLscaleH);
    [closeBotton addTarget:self action:@selector(setTiming:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeBotton];
    _closeBotton = closeBotton;
    
    
    float view2W = ScreenWidth, view2H = 50*XLscaleH, view2Y = CGRectGetMaxY(view.frame)+5*XLscaleH;
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, view2Y, view2W, view2H)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    
    UILabel *loopTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(marginLF, marginTop, labelW, labelH)];
    loopTitleLabel.text = root_meitian;
    loopTitleLabel.textColor = mainColor;
    loopTitleLabel.font = FontSize(13*XLscaleH);
    [view2 addSubview:loopTitleLabel];
    
    UIButton *loopButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-marginLF-40*XLscaleW, (view2H-15*XLscaleH)/2, 15*XLscaleH, 15*XLscaleH)];
    [loopButton setImage:IMAGE(@"sign_xieyi") forState:UIControlStateNormal];
    [loopButton setImage:IMAGE(@"sign_xieyi_click") forState:UIControlStateSelected];
    loopButton.titleLabel.font = FontSize(13*XLscaleH);
    [loopButton addTarget:self action:@selector(setLoopType:) forControlEvents:UIControlEventTouchUpInside];
    loopButton.transform = CGAffineTransformScale(loopButton.transform, 1*XLscaleH, 1*XLscaleH);
    [view2 addSubview:loopButton];
    _loopButton = loopButton;
    
    
    UIButton *deleteBotton = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenHeight - 150*XLscaleH, ScreenWidth, 50*XLscaleH)];
    [deleteBotton setTitle:root_shanchu forState:UIControlStateNormal];
    [deleteBotton setTitleColor:[UIColor redColor] forState:UIControlStateNormal]; ;
    [deleteBotton setBackgroundColor:[UIColor whiteColor]];
    deleteBotton.titleLabel.font = FontSize(16*XLscaleH);
    [deleteBotton addTarget:self action:@selector(deleteTiming:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBotton];
    
    if(!self.model){// 新增模式
        
        deleteBotton.hidden = YES;
    }else{// 编辑模式
        
        NSString *expiryDate = self.model.expiryDate;
        NSString *endDate = self.model.endDate;
        NSArray *expiryArray = [self separateTime:expiryDate];
        NSArray *endArray = [self separateTime:endDate];
        
        NSString *startTimeLabel = [NSString stringWithFormat:@"%@:%@",expiryArray[1],expiryArray[2]];
        NSString *endTimeLabel = [NSString stringWithFormat:@"%@:%@",endArray[1],endArray[2]];
        
        [startBotton setTitle:startTimeLabel forState:UIControlStateNormal];
        [closeBotton setTitle:endTimeLabel forState:UIControlStateNormal];
        
        if ([self.model.loopType isEqualToNumber:@0]) {
            loopButton.selected = YES;
        }else{
            loopButton.selected = NO;
        }
    }
}

// 设置定时
- (void)setTiming:(UIButton *)button{
    
    PickerViewAlert *palert = [[PickerViewAlert alloc]init];
    [palert show];
    palert.touchEnterBlock = ^(NSString *value, NSString *value2) {
        [button setTitle:[NSString stringWithFormat:@"%@:%@",value,value2] forState:UIControlStateNormal];
    };
    
}

// 设置循环
- (void)setLoopType:(UIButton *)button{
    
    button.selected = !button.selected;
}

// 删除定时
- (void)deleteTiming:(UIButton *)button{
    
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithDictionary:[self.model keyValues]];
    parms[@"ctype"] = @"3";
    [self updateChargeTiming:parms];
}


// 保存
- (void)saveTiming:(UIButton *)button{

    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    
    // 获取日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentDate = [formatter stringFromDate:[NSDate date]];
    
    NSString *startTime = _startBotton.titleLabel.text;
    NSString *closeTime = _closeBotton.titleLabel.text;
    
    if ([startTime isEqualToString:root_weishezhi] || [startTime isEqualToString:root_weishezhi]) {
        [self showToastViewWithTitle:HEM_time_buweiling];
        return;
    }
    
    NSArray *startArray = [startTime componentsSeparatedByString:@":"];
    NSArray *closeArray = [closeTime componentsSeparatedByString:@":"];
    
    NSInteger start = [startArray[0] integerValue]*60 + [startArray[1] integerValue];
    NSInteger end = [closeArray[0] integerValue]*60 + [closeArray[1] integerValue];
    
    NSInteger cValue = end - start; // 计算时间差
    if (cValue <= 0) {
        [self showToastViewWithTitle:root_time_set_Error];
        return;
    }
    if(!self.model){// 新增模式
        
        parms[@"userId"] = [UserInfo defaultUserInfo].userName;
        parms[@"connectorId"] = self.connectorId;
        parms[@"chargeId"] = self.sn;
        parms[@"ctype"] = @"1";
        parms[@"cKey"] = @"G_SetTime";
        parms[@"action"] = @"ReserveNow";
        parms[@"cValue"] = @(cValue);
        
        if (self.loopButton.isSelected) {
            parms[@"loopType"] = @(0); // 0 循环
            parms[@"loopValue"] = startTime; // 0 循环
        }else{
            parms[@"loopType"] = @(-1); // -1 不循环
        }
        
        parms[@"expiryDate"] = [NSString stringWithFormat:@"%@T%@:00.000Z",currentDate,startTime];
//        parms[@"endDate"] = [NSString stringWithFormat:@"%@T%@:00.000Z",currentDate,closeTime];
        
        [self addChargeTiming:parms];
    }else{// 编辑模式
        
        parms[@"sn"] = self.model.chargeId;
        parms[@"userId"] = self.model.userId;
        parms[@"ctype"] = @"1";
        parms[@"connectorId"] = self.model.connectorId;
        parms[@"cKey"] = self.model.cKey;
        parms[@"cValue"] = @(cValue);
        parms[@"reservationId"] = self.model.reservationId;
        
        if (self.loopButton.isSelected) {
            parms[@"loopType"] = @(0); // 0 循环
            parms[@"loopValue"] = startTime; // 0 循环
        }else{
            parms[@"loopType"] = @(-1); // -1 不循环
        }
        
        parms[@"expiryDate"] = [NSString stringWithFormat:@"%@T%@:00.000Z",currentDate,startTime];
        
        [self updateChargeTiming:parms];
    }
    

}


#pragma mark -- Http request
// 更新预约、注销、删除预约
- (void)updateChargeTiming:(NSDictionary *)parms{
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced] updateChargeTimingWithParms:parms success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideProgressView];
            if ([obj[@"code"] isEqualToNumber:@0]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            [weakSelf showToastViewWithTitle:obj[@"data"]];
        });
    } failure:^(id error) {
        [weakSelf hideProgressView];
    }];
}

- (void)addChargeTiming:(NSDictionary *)parms{
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced] addChargeTimingWithParms:parms success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideProgressView];
            if ([obj[@"code"] isEqualToNumber:@0]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            [weakSelf showToastViewWithTitle:obj[@"data"]];
        });
    } failure:^(id error) {
        [weakSelf hideProgressView];
    }];
}

// 分离时间
- (NSArray *)separateTime:(NSString *)time{
    
    NSMutableString *string = [NSMutableString stringWithString:time];
    NSMutableString *string2 = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@"T" withString:@":"]];
    NSString *time1 = [string2 stringByReplacingOccurrencesOfString:@"Z" withString:@""];
    
    NSArray *array = [time1 componentsSeparatedByString:@":"];// @"2018-10-20:11:30:27.666"
    
    return array;
}

@end
