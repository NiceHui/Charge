//
//  StTransitions.h
//  ButtonAnimation
//
//  Created by KeyTaotao on 15/12/24.
//  Copyright © 2015年 KeyTaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface StTransitions : NSObject<UIViewControllerAnimatedTransitioning>

-(instancetype) initWithTransitionDuration:(NSTimeInterval)transitionDuration StartingAlpha:(CGFloat)startingAlpha isBOOL:(BOOL)is;

@property (nonatomic,assign) NSTimeInterval transitionDuration;

@property (nonatomic,assign) CGFloat startingAlpha;

@property (nonatomic,assign) BOOL is;

@property (nonatomic,retain) id transitionContext;
@end
