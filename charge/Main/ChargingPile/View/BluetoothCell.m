//
//  BluetoothCell.m
//  ShinePhone
//
//  Created by growatt007 on 2018/7/11.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "BluetoothCell.h"

@implementation BluetoothCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(34*XLscaleW, 17*XLscaleH, 200*XLscaleW, 17*XLscaleH)];
        nameLabel.font = FontSize(18*XLscaleW);
        nameLabel.text = root_lanya;
        nameLabel.textColor = colorblack_51;
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        CALayer *line = [[CALayer alloc]init];
        line.frame = CGRectMake(34*XLscaleW, 49*XLscaleH, ScreenWidth-68*XLscaleW, 1*XLscaleH);
        line.backgroundColor = COLOR(246, 246, 246, 1).CGColor;
        [self.layer addSublayer:line];
        
    }
    return self;
}

- (void)setName:(NSString *)name{
    _name = name;
    self.nameLabel.text = name.length ? name : root_peijian;
}


@end
