//
//  MyAlertView.m
//  ShuDu
//
//  Created by 张雷 on 14-7-29.
//  Copyright (c) 2014年 zhiyou. All rights reserved.
//

#import "MyAlertView.h"
#import "MyButton.h"

@implementation MyAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}
- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self)
    {
        //此句话必须写，表示获得传递的对象
        _delegate = delegate;
        
        self.center = CGPointMake(160, 240);
        self.bounds = CGRectMake(0, 0, 100, 100);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        //self.alpha = 0.5;
        
        //标题
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake(0, 2.5, 100, 15);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"输入框";
        [self addSubview:titleLabel];
    
        //数字按钮
        for(int i = 0; i < 9; i ++)
        {
            UIButton *numButton = [UIButton buttonWithType:UIButtonTypeSystem];
            CGPoint point;
            point.x = (i%3)*(100/3);
            point.y = 20 + (i/3)*20;
            numButton.frame = CGRectMake(point.x, point.y, 100/3, 15);
            numButton.tag = 1 + i;
            
            [numButton setTitle:[NSString stringWithFormat:@"%d",i + 1] forState:UIControlStateNormal];
            [numButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:numButton];
        }
        //清空按钮
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
        clearButton.frame = CGRectMake(0, 82.5, 100/3, 15);
        [clearButton setTitle:@"清空" forState:UIControlStateNormal];
        clearButton.tag = 11;
        [clearButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clearButton];
        //取消按钮
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelButton.frame = CGRectMake(100/3, 82.5, 100/3, 15);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.tag = 0;
        [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        //提示按钮
        UIButton *tipButton = [UIButton buttonWithType:UIButtonTypeSystem];
        tipButton.frame = CGRectMake(100/3*2, 82.5, 100/3, 15);
        [tipButton setTitle:@"提示" forState:UIControlStateNormal];
        tipButton.tag = 10;
        [tipButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tipButton];
    }
    return self;
}
-(void)buttonClick:(UIButton *)aButton
{
    if([_delegate respondsToSelector:@selector(myAlertView:clickedButtonAtIndex:)])
    {
        [_delegate myAlertView:self clickedButtonAtIndex:aButton.tag];
    }
    //从俯视图移除
    [self removeFromSuperview];
}
-(void)show
{
    //获得window，并添加到window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
@end
