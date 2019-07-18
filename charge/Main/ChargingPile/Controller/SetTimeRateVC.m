//
//  SetTimeRateVC.m
//  charge
//
//  Created by growatt007 on 2019/6/19.
//  Copyright © 2019 hshao. All rights reserved.
//

#import "SetTimeRateVC.h"
#import "CGXPickerView.h"

@interface SetTimeRateVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    NSInteger allNumber; // 总设置项
    NSInteger selectNum; // 选中的设置项
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *timeArray; // 用来判断时间是否重合的

@property (nonatomic, strong) NSMutableArray *priceConf;

@end

@implementation SetTimeRateVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = HEM_charge_feilv;
    
    self.view.backgroundColor = COLOR(242, 242, 242, 1);
    
    [self createUI];
    
    [self createRightItem];
    
    // 添加通知监听见键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    // 添加通知监听见键盘收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideAction:) name:UIKeyboardWillHideNotification object:nil];
    // 点击取消
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideAction:) name:@"CGXSTRING_TOUCH_CANCEL" object:nil];
}

- (void)createRightItem{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50*XLscaleW, 30*XLscaleH)];
    [button setTitle:root_baocun forState:UIControlStateNormal];
    [button setTitleColor:mainColor forState:UIControlStateNormal];
    button.titleLabel.font = FontSize([NSString getFontWithText:root_baocun size:CGSizeMake(50*XLscaleW, 30*XLscaleH) currentFont:16*XLscaleH]);
    [button addTarget:self action:@selector(touchSendComAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)createUI{
    
    allNumber = self.timeRateArray.count;
    _timeArray = [NSMutableArray array];
    _priceConf = [NSMutableArray arrayWithArray:self.timeRateArray];
    if (allNumber == 0) {
        _priceConf = [NSMutableArray array];
    }
    
    for (int i = 0; i < _priceConf.count; i++) {
        NSDictionary *dict = _priceConf[i];
        [_timeArray addObject:dict[@"time"]];
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50*XLscaleH, ScreenWidth, 250*XLscaleH)];
    _tableView.backgroundColor = COLOR(242, 242, 242, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchHideKeyBoard)];
    [_tableView addGestureRecognizer:tap];
    
    UIButton *btnAdd = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth-200*XLscaleW)/2, CGRectGetMaxY(_tableView.frame), 200*XLscaleW, 55*XLscaleH)];
    [btnAdd setTitle:HEM_tianjia forState:UIControlStateNormal];
    [btnAdd setTitleColor:mainColor forState:UIControlStateNormal];
    btnAdd.titleLabel.font = FontSize(16*XLscaleH);
    [self.view addSubview:btnAdd];
    [btnAdd addTarget:self action:@selector(btnActionAddTimeRate:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lblTips = [[UILabel alloc]initWithFrame:CGRectMake(0, 15*XLscaleH, ScreenWidth, 20*XLscaleH)];
    lblTips.text = [NSString stringWithFormat:@"(%@)",root_bixubaokuo];
    lblTips.textAlignment = NSTextAlignmentCenter;
    lblTips.textColor = colorblack_102;
    lblTips.font = FontSize(15*XLscaleH);
    [self.view addSubview:lblTips];
    
}

// 添加一条时间段费率设置
- (void)btnActionAddTimeRate:(UIButton *)button{
    
    [self getCurrentData];
    if (allNumber < 6) {
        allNumber++;
        
        if (allNumber >= 4) { // 改变view的高度
            _tableView.frame = CGRectMake(0, 50*XLscaleH, ScreenWidth, 60*XLscaleH+60*XLscaleH*allNumber);

            button.frame = CGRectMake((ScreenWidth-200*XLscaleW)/2, CGRectGetMaxY(_tableView.frame), 200*XLscaleW, 55*XLscaleH);
        }
        
        [_tableView reloadData];
    }else{
        [self showToastViewWithTitle:root_bunengchaoguo];
    }
}

// 删除一条设置
- (void)deleteDeleteTimeRate:(UIButton *)button{
    NSInteger tag = button.tag - 1700;
    
    [self getCurrentData];
    if (allNumber > 1) {
        allNumber--;
        
        if (tag < _priceConf.count) { // 移除数据
            [_priceConf removeObjectAtIndex:tag];
        }
        
        UILabel *lblTime = [self.view viewWithTag:1500+tag];
        if ([lblTime.text rangeOfString:@"-"].location != NSNotFound) {
            [self.timeArray removeObject:lblTime.text];
        }
        
        if (allNumber > 2) { // 改变view的高度
            _tableView.frame = CGRectMake(0, 50*XLscaleH, ScreenWidth, 60*XLscaleH+60*XLscaleH*allNumber);
        }
        button.frame = CGRectMake((ScreenWidth-200*XLscaleW)/2, CGRectGetMaxY(_tableView.frame), 200*XLscaleW, 55*XLscaleH);
        
        [_tableView reloadData];
    }else{
        [self showToastViewWithTitle:root_zuishaoyaoyou];
    }
}

// 记录当前的设置值，不然刷新后会消失
- (void)getCurrentData{
    [_priceConf removeAllObjects];
    for (int i = 0; i < allNumber; i++) {
        UILabel *lblTime = [self.view viewWithTag:1500+i];
        UITextField *tfRate = [self.view viewWithTag:1600+i];
        [_priceConf addObject:@{@"time": lblTime.text, @"price": tfRate.text, @"name": @""}];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return allNumber;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60*XLscaleH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.backgroundColor = kClearColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat marginTop = 5*XLscaleH;
    CGFloat viewH = 50*XLscaleH, viewW = ScreenWidth-40*XLscaleW;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20*XLscaleH, marginTop, viewW, viewH)];
    view.backgroundColor = [UIColor whiteColor];
    XLViewBorderRadius(view, 8, 0, kClearColor);
    [cell addSubview:view];
    
    CGFloat marginLF = 10*XLscaleW;
    CGFloat lblW = (viewW - 2*marginLF)/2 - 12*XLscaleW;
    
    UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(marginLF, 0, lblW, viewH)];
    lblTime.tag = 1500 +indexPath.row;
    lblTime.text = root_xuanzeshijian;
    lblTime.textColor = colorblack_102;
    lblTime.textAlignment = NSTextAlignmentCenter;
    lblTime.font = FontSize([NSString getFontWithText:lblTime.text size:lblTime.xmg_size currentFont:14*XLscaleH]);
    [view addSubview:lblTime];
    lblTime.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToAddTime:)];
    [lblTime addGestureRecognizer:tapG];
    
    
    CGFloat imgW = 10*XLscaleW, imgH = 15*XLscaleH;
    UIImageView *imgDir = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lblTime.frame), (viewH-imgH)/2, imgW, imgH)];
    imgDir.image = IMAGE(@"frag4");
    [view addSubview:imgDir];
    
    CALayer *lineLayer = [[CALayer alloc]init];
    lineLayer.frame = CGRectMake(viewW/2, (viewH-20*XLscaleH)/2, 1, 25*XLscaleH);
    lineLayer.backgroundColor = COLOR(236, 239, 241, 1).CGColor;
    [view.layer addSublayer:lineLayer];
    
    CGFloat tfW = (viewW - 2*marginLF)/2;
    UITextField *tfRate = [[UITextField alloc]initWithFrame:CGRectMake(viewW/2+2, 0, tfW-60*XLscaleW, viewH)];
    tfRate.placeholder = HEM_charge_feilv;
    tfRate.textColor = colorblack_102;
    tfRate.textAlignment = NSTextAlignmentCenter;
    [tfRate setValue:[UIFont boldSystemFontOfSize:12*XLscaleH] forKeyPath:@"_placeholderLabel.font"];
    tfRate.font = FontSize(14*XLscaleH);
    tfRate.tag = 1600 + indexPath.row;
    tfRate.delegate=self;
    [view addSubview:tfRate];
    
    UILabel *lblUnit = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tfRate.frame), 0, 10*XLscaleW, viewH)];
    lblUnit.text = kStringIsEmpty(self.symbol) ? @"" : self.symbol;
    lblUnit.textColor = colorblack_102;
    lblUnit.font = FontSize(13*XLscaleH);
    lblUnit.textAlignment = NSTextAlignmentCenter;
    lblUnit.adjustsFontSizeToFitWidth = YES;
    [view addSubview:lblUnit];
    
    CGFloat btnH = 20*XLscaleW, btnW = 18*XLscaleW;
    UIButton *btnDelete = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lblUnit.frame)+15*XLscaleW, (viewH-btnH)/2, btnW, btnH)];
    [btnDelete setImage:IMAGE(@"userlist_dalet") forState:UIControlStateNormal];
    btnDelete.tag = 1700 + indexPath.row;
    [view addSubview:btnDelete];
    [btnDelete addTarget:self action:@selector(deleteDeleteTimeRate:) forControlEvents:UIControlEventTouchUpInside];
    
//    CALayer *lineLayer2 = [[CALayer alloc]init];
//    lineLayer2.frame = CGRectMake(0, viewH-1, viewW, 1);
//    lineLayer2.backgroundColor = COLOR(236, 239, 241, 1).CGColor;
//    [view.layer addSublayer:lineLayer2];
    
    if (indexPath.row < self.priceConf.count) {
        NSDictionary *dict = self.priceConf[indexPath.row];
        lblTime.text = [NSString stringWithFormat:@"%@",dict[@"time"]];
        tfRate.text = [NSString stringWithFormat:@"%@",dict[@"price"]];
    }

    return cell;
}


- (void)touchSendComAction{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0; i < allNumber; i++) {
        UILabel *lblTime = [self.view viewWithTag:1500+i];
        UITextField *tfRate = [self.view viewWithTag:1600+i];
        
        if([lblTime.text rangeOfString:@"-"].location != NSNotFound && ![tfRate.text isEqualToString:@""]) {// 时间段,费率 是否已输入
            if (![NSString isNum:tfRate.text]) { // 是否为数字
                [self showToastViewWithTitle:root_geshi_cuowu];
                return;
            }
            [dataArray addObject:@{@"time": lblTime.text, @"price": tfRate.text, @"name": @""}];
            
        }else{
            [self showToastViewWithTitle:root_youweishuruxiang];
            return;
        }
    }
    
    NSInteger sumMinut = 0;
    for (int i = 0; i < dataArray.count; i++) {
        NSDictionary *dict = dataArray[i];
        NSString *time = dict[@"time"];
        NSString *startTime = [time componentsSeparatedByString:@"-"][0];// 开始时间
        NSString *endTime = [time componentsSeparatedByString:@"-"][1];// 结束时间
        
        NSArray *starTimes = [startTime componentsSeparatedByString:@":"];
        NSArray *endTimes = [endTime componentsSeparatedByString:@":"];
        
        int starMin = [starTimes[0] intValue]*60 + [starTimes[1] intValue];
        int endMin = [endTimes[0] intValue]*60 + [endTimes[1] intValue];
        
        if (starMin < endMin) {
            sumMinut += endMin - starMin;
        } else{
            sumMinut += 24*60-1-starMin;
            sumMinut += endMin;
        }
    }
    
    // 包括全天的时间
    if (sumMinut >= (24*60-1)) {
        NSLog(@"保存成功");
        NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
        [parms setObject:@"addPrice" forKey:@"cmd"];
        [parms setObject:[NSString stringWithFormat:@"%@", self.sn] forKey:@"chargeId"];
        [parms setObject:[UserInfo defaultUserInfo].userName forKey:@"userId"];
        [parms setObject:dataArray forKey:@"priceConf"];
        
        [self showProgressView];// 注销用户接口
        [[DeviceManager shareInstenced] sendCommandWithParms:parms success:^(id obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                    if ([[NSString stringWithFormat:@"%@", obj[@"code"]] isEqualToString:@"0"]) {
                        NSLog(@"设置成功");
                        [self showToastViewWithTitle:root_shezhi_chenggong];
                        if([self.delegate respondsToSelector:@selector(setTimeRateWithArray:)]){
                            [self.delegate setTimeRateWithArray:dataArray];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }else{
                        [self showToastViewWithTitle:root_shezhi_shibai];
                    }
                }
                [self hideProgressView];
            });
        } failure:^(NSError *error) {
            [self hideProgressView];
            [self showToastViewWithTitle:root_shezhi_shibai];
        }];
    }else{
        [self showToastViewWithTitle:root_bixubaokuo];
    }
}



// 选择开始时间结束时间
-(void)goToAddTime:(UITapGestureRecognizer *)gesture{
    
    [self.view endEditing:YES]; // 键盘收回
    UILabel *label = (UILabel *)gesture.view;
    selectNum = label.tag - 1500;
    
    if (selectNum > 3) { // view上移防遮挡
        _tableView.frame = CGRectMake(0, 50*XLscaleH-2*60*XLscaleH, ScreenWidth, 60*XLscaleH+60*XLscaleH*allNumber);
    }
    
    NSMutableArray *hours = [NSMutableArray array];
    for (int i = 0; i < 24; i++) {
        if (i<10) {
            [hours addObject:[NSString stringWithFormat:@"0%d",i]];
        }else{
            [hours addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    NSMutableArray *mins = [NSMutableArray array];
    for (int i = 0; i < 60; i++) {
        if (i<10) {
            [mins addObject:[NSString stringWithFormat:@"0%d",i]];
        }else{
            [mins addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    // 获取已设置值，显示出来
    NSArray *dfStart = @[@"00", @"00"];
    NSArray *dfEnd = @[@"23", @"59"];
    NSArray *timeArray = [label.text componentsSeparatedByString:@"-"];
    if (timeArray.count == 2) {
        dfStart = [timeArray[0] componentsSeparatedByString:@":"];
        dfEnd = [timeArray[1] componentsSeparatedByString:@":"];
    }
    
    // 选择时间
    [CGXPickerView showStringPickerWithTitle:root_kaishishijian DataSource:@[hours,mins] DefaultSelValue:dfStart IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
        NSLog(@"%@:%@",selectValue[0],selectValue[1]);
        
        [CGXPickerView showStringPickerWithTitle:root_jieshushijian DataSource:@[hours,mins] DefaultSelValue:dfEnd IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue2, id selectRow2) {
            NSLog(@"%@:%@",selectValue2[0],selectValue2[1]);
            // 新时间
            NSString *newTime = [NSString stringWithFormat:@"%@:%@-%@:%@", selectValue[0],selectValue[1], selectValue2[0],selectValue2[1]];
            
            // 获取最新时间段数据进行对比
            [self getCurrentData];
            NSMutableArray *timeArr = [NSMutableArray array];
            for (int i = 0; i < self.priceConf.count; i++) {
                NSDictionary *dict = self.priceConf[i];
                if (self->selectNum != i) {
                    if (![dict[@"time"] isEqualToString:root_xuanzeshijian]) {
                        [timeArr addObject:dict[@"time"]];
                    }
                }
            }
            
            // 特殊时间判断
            if(timeArr.count > 0 && [newTime isEqualToString:@"00:00-23:59"]){
                [self showToastViewWithTitle:root_bunengchongdie]; // 时间段不能重叠
                return ;
            }
            
            BOOL isOverlapping = NO; // 判断是否已经存在一个跨天的时间段，如果再出现一个就必定重叠
            NSMutableArray *times = [NSMutableArray array];
            // 1. 先通过循环判断是否有跨天时间段，把跨天的拆分成两段去做其他判断
            for (int i = 0; i < timeArr.count; i++) {
                NSString *time = timeArr[i];
                NSString *startTime = [time componentsSeparatedByString:@"-"][0];// 开始时间
                NSString *endTime = [time componentsSeparatedByString:@"-"][1];// 结束时间
                
                NSArray *starTimes = [startTime componentsSeparatedByString:@":"];
                NSArray *endTimes = [endTime componentsSeparatedByString:@":"];
                
                int starMin = [starTimes[0] intValue]*60 + [starTimes[1] intValue];
                int endMin = [endTimes[0] intValue]*60 + [endTimes[1] intValue];
                
                if (starMin < endMin) {
                    [times addObject:time];
                } else{
                    isOverlapping = YES;
                    [times addObject:[NSString stringWithFormat:@"%@-%@", startTime, @"23:59"]]; // 跨天的情况分两段
                    [times addObject:[NSString stringWithFormat:@"%@-%@", @"00:00", endTime]];
                }
            }
            
            // 2. 通过判断区间是否重合,来判断是否有重叠时间
            int starMin0 = [selectValue[0] intValue]*60 + [selectValue[1] intValue]; // 新加时间的开始时间
            int endMin0 = [selectValue2[0] intValue]*60 + [selectValue2[1] intValue]; // 新加时间的结束时间
            
            if (starMin0 == endMin0) {
                [self showToastViewWithTitle:root_bunengxiangtong];// 开始结束时间不能相同
                return ;
            }
            
            BOOL isBeing = NO;// 是否已存在该时间段
            if (endMin0 < starMin0) { // 结束时间大于开始时间代表是跨天的时间段
                // 判断是否已经存在一个跨天的时间段，如果再出现一个就必定重叠
                if (isOverlapping) {
                    [self showToastViewWithTitle:root_bunengchongdie]; // 时间段不能重叠
                    return ;
                }
                // 因为出现跨天的情况需要拆成两段时间才能判断  23:00-1:00  ->>  23:00-23:59 ,00:00-01:00
                NSString *newTime1 = [NSString stringWithFormat:@"%@:%@-23:59",selectValue[0],selectValue[1]];
                NSString *newTime2 = [NSString stringWithFormat:@"00:00-%@:%@",selectValue2[0],selectValue2[1]];
                for (int i = 0; i < times.count; i++) {
                    BOOL B1 = [self isOverlappingWithTime0:newTime1 Time1:times[i]];
                    BOOL B2 = [self isOverlappingWithTime0:newTime2 Time1:times[i]];
                    if (B1 || B2) {
                        isBeing = YES;
                        break;
                    }
                }
            }else{
                for (int i = 0; i < times.count; i++) {
                    isBeing = [self isOverlappingWithTime0:newTime Time1:times[i]];
                    if (isBeing) break; // 发现已存在就结束循环
                }
            }
            
            if (!isBeing) {// 不存在则添加
                [timeArr addObject:newTime];
                self.timeArray = timeArr;
                
                label.text = newTime;
            }else{
                [self showToastViewWithTitle:root_bunengchongdie]; // 时间段不能重叠
            }
            
        }];
    }];
}

// 判断时间段重叠的方法
- (BOOL)isOverlappingWithTime0:(NSString *)time0 Time1:(NSString *)time1{
    BOOL isBeing = NO;// 是否已存在该时间段
    
    // 新时间
    NSArray *arrays0 = [time0 componentsSeparatedByString:@"-"];
    NSArray *starTimes0 = [arrays0[0] componentsSeparatedByString:@":"];
    NSArray *endTimes0 = [arrays0[1] componentsSeparatedByString:@":"];
    
    int starMin0 = [starTimes0[0] intValue]*60 + [starTimes0[1] intValue];
    int endMin0 = [endTimes0[0] intValue]*60 + [endTimes0[1] intValue];
    
    // 已存在的时间
    NSArray *arrays1 = [time1 componentsSeparatedByString:@"-"];
    NSArray *starTimes1 = [arrays1[0] componentsSeparatedByString:@":"];
    NSArray *endTimes1 = [arrays1[1] componentsSeparatedByString:@":"];
    
    int starMin1 = [starTimes1[0] intValue]*60 + [starTimes1[1] intValue];
    int endMin1 = [endTimes1[0] intValue]*60 + [endTimes1[1] intValue];
    
    // 通过判断区间是否包含来确定是否时间段重合
    if ((starMin1 < starMin0 && starMin0 < endMin1) || (starMin1 < endMin0 && endMin0 < endMin1) || (starMin0 < starMin1 && starMin1 < endMin0) || (starMin0 < endMin1 && endMin1 < endMin0)) {
        isBeing = YES;
    }
    return isBeing;
}


// textField开始编辑的时候
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    selectNum = textField.tag - 1600;
    return YES;
}

// 键盘弹出
- (void)keyboardAction:(NSNotification*)sender{
    
    if (selectNum > 3) {// view上移防遮挡
        _tableView.frame = CGRectMake(0, 50*XLscaleH-2*60*XLscaleH, ScreenWidth, 60*XLscaleH+60*XLscaleH*allNumber);
    }
}
// 键盘隐藏
- (void)keyboardHideAction:(NSNotification*)sender{
    
    if (selectNum > 3) {// view恢复原位
        _tableView.frame = CGRectMake(0, 50*XLscaleH, ScreenWidth, 60*XLscaleH+60*XLscaleH*allNumber);
    }
}

- (void)touchHideKeyBoard{
    [self.view endEditing:YES];
}

@end
