//
//  PickerViewAlert.m
//  ShinePhone
//
//  Created by growatt007 on 2018/7/6.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "PickerViewAlert.h"

@interface PickerViewAlert ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSInteger leftNumber;
    NSInteger rightNumber;
}

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIView *viewBG;

@property (nonatomic,assign) NSInteger pickerIndex;

@end

@implementation PickerViewAlert

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self initUIView];
    }
    return self;
}

- (void)initUIView{
    
    self.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tap];
    [self setUserInteractionEnabled:YES];

    self.viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 240)];
    self.viewBG.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.viewBG];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(20*XLscaleW, 15*XLscaleH, 60*XLscaleW, 35*XLscaleH)];
    cancelBtn.titleLabel.font = FontSize(15*XLscaleW);
    [cancelBtn setTitle:root_cancel forState:UIControlStateNormal];
    [cancelBtn setTitleColor:colorblack_154 forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.viewBG addSubview:cancelBtn];
    
    UIButton *enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 70*XLscaleW, 15*XLscaleH, 60*XLscaleW, 35*XLscaleH)];
    enterBtn.titleLabel.font = FontSize(15*XLscaleW);
    [enterBtn setTitle:root_OK forState:UIControlStateNormal];
    [enterBtn setTitleColor:COLOR(0, 156, 255, 1) forState:UIControlStateNormal];
    [enterBtn addTarget:self action:@selector(tounchEnter) forControlEvents:UIControlEventTouchUpInside];
    [self.viewBG addSubview:enterBtn];
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(ScreenWidth/6, 40*XLscaleH, ScreenWidth*2/3, 200*XLscaleH)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.viewBG addSubview:self.pickerView];
    [self sendSubviewToBack:self.viewBG];
    
    float textW = 40*XLscaleW, textH = 15*XLscaleH, textX = ScreenWidth/2 - 30*XLscaleW, textY = 40*XLscaleH+self.pickerView.xmg_height/2-textH/2;
    UILabel *hourLB = [[UILabel alloc]initWithFrame:CGRectMake(textX, textY, textW, textH)];
    hourLB.text = root_shi;
    hourLB.font = FontSize(15*XLscaleH);
    hourLB.textColor = COLOR(136, 136, 136, 1);
    [self.viewBG addSubview:hourLB];
    
    UILabel *minLB = [[UILabel alloc]initWithFrame:CGRectMake(textX+self.pickerView.xmg_width/2, textY, textW, textH)];
    minLB.text = root_fen;
    minLB.font = FontSize(15*XLscaleH);
    minLB.textColor = COLOR(136, 136, 136, 1);
    [self.viewBG addSubview:minLB];
    
    leftNumber = 0;
    rightNumber = 0;
}

// 返回有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// 返回第component列有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

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

-(void)show
{
    [self showWithIndex:0];
}

-(void)hide
{
    [UIView animateWithDuration:0.4 animations:^{
        self.viewBG.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 240*XLscaleH);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)showWithIndex:(NSInteger)index
{
//    if (index<10) {
//        [self.pickerView selectRow:index inComponent:0 animated:YES];
//        self.pickerIndex=index;
//    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        self.viewBG.frame = CGRectMake(0, ScreenHeight-240*XLscaleH, ScreenWidth, 240*XLscaleH);
    }];
}

- (void)tounchEnter{
    if (self.touchEnterBlock) {
        NSString *value = @"00";
        NSString *value2 = @"00";
        
        if (leftNumber) value = [NSString SupplementZero:[NSString stringWithFormat:@"%ld",leftNumber]];
        if (rightNumber) value2 = [NSString SupplementZero:[NSString stringWithFormat:@"%ld",rightNumber]];
        
        self.touchEnterBlock(value, value2);
    }
    [self hide];
}


@end
