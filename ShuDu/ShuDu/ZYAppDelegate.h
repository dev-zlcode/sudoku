//
//  ZYAppDelegate.h
//  ShuDu
//
//  Created by 张雷 on 14-7-28.
//  Copyright (c) 2014年 zhiyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"

@interface ZYAppDelegate : UIResponder <UIApplicationDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) UIWindow *window;
//按键数组
@property (strong,nonatomic) NSMutableArray *muarrayMyButton;
//当前按键
@property (strong,nonatomic) MyButton *currentBtn;
//完整的数独序列
@property (nonatomic,copy) NSMutableArray *completeArray;
//挖洞后的数独序列
@property (nonatomic,copy) NSMutableArray *holeArray;
//当前正在变化的数独序列
@property (nonatomic,copy) NSMutableArray *currentArray;
//当前洞数
@property (nonatomic,assign) int currentCnt;

@end
