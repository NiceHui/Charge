//
//  aboutOneTableViewCell.m
//  shinelink
//
//  Created by sky on 16/2/17.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "aboutOneTableViewCell.h"

@implementation aboutOneTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.imageLog = [[UIImageView alloc] initWithFrame:CGRectMake(5*XLscaleW, 5*XLscaleH, 45*XLscaleH, 45*XLscaleH)];
        
        [self.contentView addSubview:_imageLog];
        
        self.tableName = [[UILabel alloc] initWithFrame:CGRectMake(45*XLscaleH+10*XLscaleH, 5*XLscaleH, 140*XLscaleW, 45*XLscaleH)];
        self.tableName.font=[UIFont systemFontOfSize:16*XLscaleH];
        self.tableName.textAlignment = NSTextAlignmentLeft;
        self.tableName.textColor = [UIColor blackColor];
        [self.contentView addSubview:_tableName];
        
        self.tableDetail = [[UILabel alloc] initWithFrame:CGRectMake(195*XLscaleW, 5*XLscaleW, 115*XLscaleW, 45*XLscaleH)];
        self.tableDetail.font=[UIFont systemFontOfSize:12*XLscaleH];
        self.tableDetail.textAlignment = NSTextAlignmentRight;
        self.tableDetail.adjustsFontSizeToFitWidth=YES;
        self.tableDetail.textColor = [UIColor blackColor];
        [self.contentView addSubview:_tableDetail];
        
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 1));
}

@end
