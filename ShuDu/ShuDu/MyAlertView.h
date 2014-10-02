//
//  MyAlertView.h
//  ShuDu
//
//  Created by 张雷 on 14-7-29.
//  Copyright (c) 2014年 zhiyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAlertView : UIView
@property (nonatomic,assign) id delegate;

- (id)initWithDelegate:(id)delegate;
-(void)show;

@end
@protocol MyAlertViewDelegate <NSObject>

- (void)myAlertView:(MyAlertView *)myAlertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
