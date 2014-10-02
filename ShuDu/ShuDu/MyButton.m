//
//  MyButton.m
//  ShuDu
//
//  Created by 张雷 on 14-7-28.
//  Copyright (c) 2014年 zhiyou. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//+(int)fromTagHang:(int)hang lie:(int)lie
//{
//    //通过行和列获取tag值
//    int tag;
//    tag = hang * 9 +  lie + 1;
//    
//    return tag;
//}
//+(int)fromTagBig:(int)big small:(int)small
//{
//    //通过大格和小格获取tag值
//    int tag;
//    int aHang = big / 3 *3 + small / 3;
//    int aLie =  big % 3 *3 + small % 3;
//    
//    tag = aHang * 9 +  aLie + 1;
//    
//    return tag;
//}
@end
