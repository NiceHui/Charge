//
//  BaseViewController.m
//  charge
//
//  Created by growatt007 on 2018/10/16.
//  Copyright © 2018年 hshao. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    if ([currentLanguage hasPrefix:@"zh-Hans"]) {
        _languageType=@"0";
    }else if ([currentLanguage hasPrefix:@"en"]) {
        _languageType=@"1";
    }else{
        _languageType=@"2";
    }
    
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


- (NSString *)MD5:(NSString *)str {
    if (str==nil) {
        str=@"";
    }
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        NSString *tStr = [NSString stringWithFormat:@"%x", digest[i]];
        if (tStr.length == 1) {
            [result appendString:@"c"];
        }
        [result appendFormat:@"%@", tStr];
    }
    return result;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [KEYWINDOW endEditing:YES];
}

@end
