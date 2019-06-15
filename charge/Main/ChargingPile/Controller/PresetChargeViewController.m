//
//  PresetChargeViewController.m
//  charge
//
//  Created by growatt007 on 2018/10/17.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "PresetChargeViewController.h"
#import "PickerViewAlert.h"
#import "DeviceManager.h"
#import "ZJBLStoreShopTypeAlert.h"

@interface PresetChargeViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSInteger leftNumber;
    NSInteger rightNumber;
}
@property (nonatomic, strong) UITextField *presetValueTF; // 预设数值
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSString *tips;

@property (nonatomic, strong) NSArray *unitArray;
@property (nonatomic, assign) NSInteger unitNum;

@end

@implementation PresetChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    leftNumber = 0;
    rightNumber = 0;
    _unitNum = 0;
    
    [self setupSubview];
}

- (void)setupSubview{
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60*XLscaleH, ScreenWidth/2, 25*XLscaleH)];
    titleLabel.text = [NSString stringWithFormat:@"%@ -", root_yushe];
    titleLabel.font = FontSize(20*XLscaleH);
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.textColor = colorblack_51;
    [self.view addSubview:titleLabel];
    
    UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2, 60*XLscaleH, ScreenWidth/2, 25*XLscaleH)];
    titleLabel2.text = _programme;
    titleLabel2.font = FontSize(20*XLscaleH);
    titleLabel2.textAlignment = NSTextAlignmentLeft;
    titleLabel2.textColor = mainColor;
    [self.view addSubview:titleLabel2];
    
    UITextField *presetValueTF = [[UITextField alloc]initWithFrame:CGRectMake(15*XLscaleW, 180*XLscaleH, ScreenWidth-30*XLscaleW, 45*XLscaleH)];
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    presetValueTF.attributedPlaceholder = [NSAttributedString.alloc initWithString:self.tips attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:FontSize(14*XLscaleH)}];
    presetValueTF.font = FontSize(14*XLscaleH);
    presetValueTF.leftViewMode = UITextFieldViewModeAlways;
    presetValueTF.textAlignment = NSTextAlignmentCenter;
//    presetValueTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:presetValueTF];
    self.presetValueTF = presetValueTF;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20*XLscaleW, CGRectGetMaxY(presetValueTF.frame)-5*XLscaleH, ScreenWidth-40*XLscaleW, 1)];
    lineView.backgroundColor = colorblack_222;
    [self.view addSubview:lineView];
    
    // 时间选择
    UIView *timeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel2.frame)+20*XLscaleH, ScreenWidth, 170*XLscaleH)];
    timeView.backgroundColor = COLOR(232, 236, 239, 1);
    [self.view addSubview:timeView];
    
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(ScreenWidth/6, 0, ScreenWidth*2/3, timeView.xmg_height)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [timeView addSubview:pickerView];
    self.pickerView = pickerView;
    
    float textW = 40*XLscaleW, textH = 15*XLscaleH, textX = ScreenWidth/2 - 40*XLscaleW, textY = timeView.xmg_height/2-textH/2;
    UILabel *hourLB = [[UILabel alloc]initWithFrame:CGRectMake(textX, textY, textW, textH)];
    hourLB.text = root_shi;
    hourLB.font = FontSize(15*XLscaleH);
    hourLB.textColor = COLOR(136, 136, 136, 1);
    [timeView addSubview:hourLB];
    
    UILabel *minLB = [[UILabel alloc]initWithFrame:CGRectMake(textX+pickerView.xmg_width/2, textY, textW, textH)];
    minLB.text = root_fen;
    minLB.font = FontSize(15*XLscaleH);
    minLB.textColor = COLOR(136, 136, 136, 1);
    [timeView addSubview:minLB];
    
    // 确定按键
    UIButton *enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(40*XLscaleW, CGRectGetMaxY(timeView.frame)+20*XLscaleH, ScreenWidth-80*XLscaleW, 50*XLscaleH)];
    [enterBtn setTitle:root_quereng forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CAGradientLayer *gradientLayer0 = [[CAGradientLayer alloc] init];
    gradientLayer0.cornerRadius = 22*XLscaleH;
    gradientLayer0.frame = enterBtn.bounds;
    gradientLayer0.colors = @[
                              (id)[UIColor colorWithRed:1.0f/255.0f green:230.0f/255.0f blue:114.0f/255.0f alpha:1.0f].CGColor,
                              (id)[UIColor colorWithRed:0.0f/255.0f green:227.0f/255.0f blue:192.0f/255.0f alpha:1.0f].CGColor];
    gradientLayer0.locations = @[@0, @1];
    [gradientLayer0 setStartPoint:CGPointMake(0, 1)];
    [gradientLayer0 setEndPoint:CGPointMake(1, 1)];
    [enterBtn.layer addSublayer:gradientLayer0];
    XLViewBorderRadius(enterBtn, 25*XLscaleH, 0, kClearColor);
    enterBtn.titleLabel.font = FontSize(18*XLscaleH);
    [self.view addSubview:enterBtn];
    [enterBtn addTarget:self action:@selector(presetValue:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_programme isEqualToString:@"Time"]) {// 时间
        self.presetValueTF.hidden = YES;
        lineView.hidden = YES;
    }else{
        timeView.hidden = YES;
    }
    
    if ([_programme isEqualToString:@"Amount"]) {// 金额
        presetValueTF.frame = CGRectMake(15*XLscaleW, 180*XLscaleH, ScreenWidth-100*XLscaleW, 45*XLscaleH);
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(presetValueTF.frame), CGRectGetMinY(presetValueTF.frame)+10*XLscaleH, 1, 25*XLscaleH)];
        lineView2.backgroundColor = colorblack_222;
        [self.view addSubview:lineView2];
        
        UIButton *moneyUnitBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(presetValueTF.frame), CGRectGetMinY(presetValueTF.frame), 70*XLscaleW, 45*XLscaleH)];
        [moneyUnitBtn setTitle:@"£" forState:UIControlStateNormal];
        [moneyUnitBtn setImage:IMAGE(@"country_drop") forState:UIControlStateNormal];
        [moneyUnitBtn setTitleColor:colorblack_51 forState:UIControlStateNormal];
        [self.view addSubview:moneyUnitBtn];
        [moneyUnitBtn addTarget:self action:@selector(selectMoneyUnitAction:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat img_W = moneyUnitBtn.imageView.frame.size.width;
        CGFloat tit_W = moneyUnitBtn.titleLabel.frame.size.width;
        CGFloat Spacing = 8*XLscaleW;
        [moneyUnitBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - (img_W + Spacing / 2), 0, (img_W + Spacing / 2))];
        [moneyUnitBtn setImageEdgeInsets:UIEdgeInsetsMake(0, (tit_W + Spacing / 2), 0, - (tit_W + Spacing / 2))];
    }
}

- (void)setProgramme:(NSString *)programme{
    
    _programme = programme;
    
    if ([programme isEqualToString:@"Amount"]) {// 金额
        self.tips = root_shuru_amount;
    }else if ([programme isEqualToString:@"Electricity"]) {// 电量
        self.tips = root_shuru_electricity;
    }else if ([programme isEqualToString:@"Time"]) {// 时间
        self.tips = @"Please input";
    }
}


// 点击预设
- (void)presetValue:(UIButton *)button{
    
    if (self.returnPresetValueAndprogramme) {
        
        NSString *value1 = @"0";
        NSString *value2 = @"0";
        
        if ([_programme isEqualToString:@"Amount"] || [_programme isEqualToString:@"Electricity"]) {// 金额, 电量
            
            if (![NSString isNum:self.presetValueTF.text]) { // 判断输入是否是数字
                [self showToastViewWithTitle:root_geshi_cuowu];
                return;
            }
            
            if(self.presetValueTF.text.length >0 && [self.presetValueTF.text floatValue] > 0){// 判断输入是否大于零
                
                value1 = self.presetValueTF.text;
                
            }else{
                [self showToastViewWithTitle:root_geshi_cuowu];
                return ;
            }
            
        }else if ([_programme isEqualToString:@"Time"]) {// 时间
            
            NSInteger totalValue = leftNumber + rightNumber;
            if (totalValue) {
                if (leftNumber) value1 = [NSString stringWithFormat:@"%ld",(long)leftNumber];
                if (rightNumber) value2 = [NSString SupplementZero:[NSString stringWithFormat:@"%ld",(long)rightNumber]];
            }else{
                [self showToastViewWithTitle:HEM_time_buweiling];
                return ;
            }
        }
        
        NSDictionary *dict = @{@"unit": @"pound"}; // 默认英镑
        if ([self.unitArray isKindOfClass:[NSArray class]]) {
            if (self.unitArray.count > 0) {
                dict = self.unitArray[_unitNum];
            }
        }
        NSString *unitString = dict[@"unit"];
        
        self.returnPresetValueAndprogramme(value1,value2,_programme, unitString);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- UIPickerViewDelegate
// 返回有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 2;
}
// 返回第component列有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return 24;
    }else{
        return 60;
    }
}
//返回第component列高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44*XLscaleH;
}
// 返回第component列第row行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        return [NSString stringWithFormat:@"%ld",row];
    }else{
        return [NSString stringWithFormat:@"%ld",row];
    }
}
// 监听UIPickerView选中
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        leftNumber = row;
    }else{
        rightNumber = row;
    }
    
}


// 选择货币单位
- (void)selectMoneyUnitAction:(UIButton *)button{
    
    // 判断是否已经获取到列表
    if ([self.unitArray isKindOfClass:[NSArray class]]) {
        if (self.unitArray.count > 0) {
            NSMutableArray *actionArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < self.unitArray.count; i++) {
                NSDictionary *dict = self.unitArray[i];
                [actionArray addObject:[NSString stringWithFormat:@"%@(%@)",dict[@"unit"],dict[@"symbol"]]];
            }
            // 打开控件
            [ZJBLStoreShopTypeAlert showWithTitle:root_xuanzehuobi titles:actionArray selectIndex:^(NSInteger SelectIndexNum){
                self.unitNum = SelectIndexNum;
                NSDictionary *dict = self.unitArray[SelectIndexNum];
                [button setTitle:dict[@"symbol"] forState:UIControlStateNormal];
            } selectValue:^(NSString* valueString){
                
            } showCloseButton:YES];
            
            return;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    [self showProgressView];
    [[DeviceManager shareInstenced] sendCommandWithParms:@{@"cmd":@"selectMoneyUnit"} success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([obj[@"code"] isEqualToNumber:@0]) {
                
                self.unitArray = obj[@"data"];
                if ([self.unitArray isKindOfClass:[NSArray class]]) {
                 
                    NSMutableArray *actionArray = [[NSMutableArray alloc]init];
                    for (int i = 0; i < self.unitArray.count; i++) {
                        NSDictionary *dict = self.unitArray[i];
                        [actionArray addObject:[NSString stringWithFormat:@"%@(%@)",dict[@"unit"],dict[@"symbol"]]];
                    }
                    // 打开控件
                    [ZJBLStoreShopTypeAlert showWithTitle:root_xuanzehuobi titles:actionArray selectIndex:^(NSInteger SelectIndexNum){
                        weakSelf.unitNum = SelectIndexNum;
                        NSDictionary *dict = self.unitArray[SelectIndexNum];
                        [button setTitle:dict[@"symbol"] forState:UIControlStateNormal];
                    } selectValue:^(NSString* valueString){
                        
                    } showCloseButton:YES];
                }
            }else{
                [self showToastViewWithTitle:root_qingqiushibai];
            }
            [weakSelf hideProgressView];
        });
    } failure:^(NSError *error) {
        [weakSelf hideProgressView];
        [self showToastViewWithTitle:root_qingqiushibai];
    }];
}

@end
