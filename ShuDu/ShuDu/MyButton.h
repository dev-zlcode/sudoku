//
//  MyButton.h
//  ShuDu
//
//  Created by 张雷 on 14-7-28.
//  Copyright (c) 2014年 zhiyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIButton
//宫格的行和列
@property int hang,lie;
//宫格位置大和小
@property int big,small;

//+(int)fromTagHang:(int)hang lie:(int)lie;
//
//+(int)fromTagBig:(int)big small:(int)small;

@end
