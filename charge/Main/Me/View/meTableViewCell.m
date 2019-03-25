//
//  meTableViewCell.m
//  shinelink
//
//  Created by sky on 16/2/17.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "meTableViewCell.h"

@implementation meTableViewCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.imageLog = [[UIImageView alloc] initWithFrame:CGRectMake(5*XLscaleW, 5*XLscaleH, 45*XLscaleH, 45*XLscaleH)];
        
        [self.contentView addSubview:_imageLog];
        
        self.tableName = [[UILabel alloc] initWithFrame:CGRectMake(45*XLscaleH+10*XLscaleW, 5*XLscaleH, 240*XLscaleW, 45*XLscaleH)];
        
        self.tableName.font=[UIFont systemFontOfSize:16*XLscaleH];
        _tableName.adjustsFontSizeToFitWidth=YES;
        self.tableName.textAlignment = NSTextAlignmentLeft;
        self.tableName.textColor = [UIColor blackColor];
        [self.contentView addSubview:_tableName];
        
        self.imageDetail = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30*XLscaleH, 20*XLscaleH, 20*XLscaleW, 15*XLscaleH)];
        [self.imageDetail setImage:[UIImage imageNamed:@"frag4.png"]];
        [self.contentView addSubview:_imageDetail];
        
        UIView *V0=[[UIView alloc] initWithFrame:CGRectMake(0, 55*XLscaleH-1, ScreenWidth, 1)];
        V0.backgroundColor=colorblack_222;
        [self.contentView addSubview:V0];
    }
    
    return self;
}



@end
