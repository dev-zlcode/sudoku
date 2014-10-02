//
//  ZYAppDelegate.m
//  ShuDu
//
//  Created by 张雷 on 14-7-28.
//  Copyright (c) 2014年 zhiyou. All rights reserved.
//

#import "ZYAppDelegate.h"
#import "MyAlertView.h"

#define MAIN_BG_COLOR [UIColor colorWithRed:249/255.0 green:248/255.0 blue:237/255.0 alpha:1]
#define VIEW_BG_COLOR [UIColor colorWithRed:173/255.0 green:158/255.0 blue:144/255.0 alpha:1]
#define BUTTON_BG_COLOR [UIColor colorWithRed:193/255.0 green:179/255.0 blue:165/255.0 alpha:1]
#define DISABLE_FONT_CLOLR [UIColor blackColor]
#define ENABLE_FONT_CLOLR [UIColor whiteColor]
@implementation ZYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = MAIN_BG_COLOR;
    [self.window makeKeyAndVisible];
    
    //标题
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake( 0, 30, 320, 20);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.text = @"数独";
    [self.window addSubview:titleLab];
    
    //游戏说明
    UILabel *tipLab = [[UILabel alloc]init];
    tipLab.frame = CGRectMake( 10, 410, 310, 60);
    tipLab.font = [UIFont systemFontOfSize:12];
    tipLab.numberOfLines = 0;
    tipLab.text = @"游戏说明：行、列、小宫格内由1到9不相同的数字即胜利\n黑色字体：固定数字\n白色字体：可变数字\n红色字体：冲突数字";
    tipLab.textColor = VIEW_BG_COLOR;
    [self.window addSubview:tipLab];
    
    //副View
    UIView *bigView = [[UIView alloc]initWithFrame:CGRectMake(9, 100, 302, 302)];
    bigView.backgroundColor = VIEW_BG_COLOR;
    [self.window addSubview:bigView];
    
    //按钮
    for(int i = 0; i < 2; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(60 + 150*i, 60, 70, 30);
        btn.tag = 100 + i;
        switch (i)
        {
            case 0:[btn setTitle:@"等级选择" forState:UIControlStateNormal];break;
            case 1:[btn setTitle:@"重新游戏" forState:UIControlStateNormal];break;
            default:break;
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.window addSubview:btn];
    }
    
    //宫格和按钮
    //行：0到8
    //列：0到8
    //tag值：1到81
    
    _muarrayMyButton = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < 9; i++)
        for(int j = 0; j < 9; j++)
        
        {
            //产生宫格坐标:i行j列
            //列位置
            int x = 5 + 30*j + j/3*5 + (j - j/3)*2;
            //行位置
            int y = 5 + 30*i + i/3*5 + (i - i/3)*2;
            
            MyButton *gongGeMyButton = [[MyButton alloc]init];
            gongGeMyButton.frame = CGRectMake(x, y, 30, 30);
            gongGeMyButton.backgroundColor = BUTTON_BG_COLOR;
            gongGeMyButton.tag = i * 9 +  j + 1;
            //行
            gongGeMyButton.hang = i;
            //列
            gongGeMyButton.lie = j;
            //大格位置
            gongGeMyButton.big = j/3 + i/3*3;
            //小格位置
            gongGeMyButton.small = j %3+ i %3 *3;
            //设置标题
            [gongGeMyButton setTitle:[NSString stringWithFormat:@"%ld",(long)gongGeMyButton.tag] forState:UIControlStateNormal];
            //初始化字体颜色
            [gongGeMyButton setTitleColor:ENABLE_FONT_CLOLR forState:UIControlStateNormal];
            [gongGeMyButton addTarget:self action:@selector(myButtonXiangYing:) forControlEvents:UIControlEventTouchUpInside];
            [bigView addSubview:gongGeMyButton];
            
            [_muarrayMyButton addObject:gongGeMyButton];
        }
    
    //初始化游戏
    _currentCnt = 20;
    [self initGema:_currentCnt];
    
    return YES;
}

-(void)btnClick:(UIButton *)btn
{
    switch (btn.tag%100)
    {
            //选关
        case 0:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选关" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"入门" otherButtonTitles:@"简单",@"中等",@"较难", nil];
            [sheet showInView:self.window];
        }
            break;
            //重新开始
        case 1:
        {
            [self initGema:_currentCnt];
        }
            break;
            
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button = %ld",(long)buttonIndex);
    switch (buttonIndex)
    {
            //入门
        case 0:_currentCnt = 20;[self initGema:_currentCnt];break;
            //简单
        case 1:_currentCnt = 30;[self initGema:_currentCnt];break;
            //中等
        case 2:_currentCnt = 40;[self initGema:_currentCnt];break;
            //较难
        case 3:_currentCnt = 50;[self initGema:_currentCnt];break;
            //取消
        case 4:break;
        default:break;
    }
}

-(void)initGema:(int)cnt
{
    NSLog(@"初始化游戏");
    
    //初始化按钮
    [self enableBtn];
    //获取数独序列
    _completeArray = [self makeShuDuIndex];
    //对给定的数独序列挖洞
    _holeArray = [self makeHole:_completeArray count:cnt];
    //使按键不可用
    [self disableBtn:_holeArray];
    //把挖洞后的序列赋给当前序列
    //为防止完整序列被修改，进行备份
    _currentArray = [[NSMutableArray alloc]init];
    for(int i = 0; i < 81; i ++)
    {
        [_currentArray addObject:[_holeArray objectAtIndex:i]];
    }
    //显示改变的序列
    [self show:_currentArray];
}

-(void)disableBtn:(NSMutableArray *)indexArray
{
    //使按键无效
    for(int i = 0; i < 81; i ++)
    {
        MyButton *btn = [_muarrayMyButton objectAtIndex:i];
        NSString *str = [indexArray objectAtIndex:i];
        if(![str isEqualToString:@""])
        {
            //使该按钮无效
            btn.enabled = NO;
            //按钮字体
            [btn setTitleColor:DISABLE_FONT_CLOLR forState:UIControlStateNormal];
        }
    }
}

-(void)enableBtn
{
    //使按键有效
    for(int i = 0; i < 81; i ++)
    {
        MyButton *btn = [_muarrayMyButton objectAtIndex:i];
        
        //使该按钮无效
        btn.enabled = YES;
        //按钮字体
        [btn setTitleColor:ENABLE_FONT_CLOLR forState:UIControlStateNormal];
        //初始化标题
        [btn setTitle:@"" forState:UIControlStateNormal];
    }
}

-(void)myButtonXiangYing:(MyButton *)aMyButton
{
    NSLog(@"hang = %d lie = %d big = %d small = %d tag = %ld",aMyButton.hang,aMyButton.lie,aMyButton.big,aMyButton.small,(long)aMyButton.tag);
    
    //显示myAlertView
    MyAlertView *alert = [[MyAlertView alloc]initWithDelegate:self];
    [alert show];
    
    //获取当前按下的按键对象，myAlertView的代理方法用到
    _currentBtn = aMyButton;
    
    //使按键无效,防止误按
    for(int i = 0; i < 81; i ++)
    {
        MyButton *btn = [_muarrayMyButton objectAtIndex:i];
        
        //使该按钮无效
        btn.enabled = NO;
    }
}

- (void)myAlertView:(MyAlertView *)myAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //取消按键索引值 0
    //1到9按键索引值 1 2 3 4 5 6 7 8 9
    //提示索引只是10
    //清空索引只是11
    NSLog(@"myAlertView %ld",(long)buttonIndex);
    if(buttonIndex == 10)
    {
        NSString *str = [_completeArray objectAtIndex:_currentBtn.tag-1];
        [_currentArray replaceObjectAtIndex:_currentBtn.tag-1 withObject:str];
        [self show:_currentArray];
    }
    else if(buttonIndex == 11)
    {
        [_currentArray replaceObjectAtIndex:_currentBtn.tag-1 withObject:@""];
        [self show:_currentArray];
    }
    else if(buttonIndex)
    {
        //给当前按钮赋值（1到9）
        [_currentArray replaceObjectAtIndex:_currentBtn.tag-1 withObject:[NSString stringWithFormat:@"%ld",(long)buttonIndex]];
        [self show:_currentArray];
    }
    
    if([self judge])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"恭喜你，赢了" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    //使按键有效，解除误按
    for(int i = 0; i < 81; i ++)
    {
        MyButton *btn = [_muarrayMyButton objectAtIndex:i];
        
        //使该按钮有效
        btn.enabled = YES;
    }
    
    //使得挖孔的按钮继续无效
    [self disableBtn:_holeArray];
}

-(BOOL)judge
{
    //判断
    //YES 胜利 NO没有胜利
    BOOL isOK = YES;
    
    //列
    for(int i = 0; i < 9; i++)
    {
        NSMutableArray *indexArray = [[NSMutableArray alloc]init];
        for(int j = 0; j < 9; j++)
        {
            int index = [self fromIndexLie:i hang:j];
            MyButton *btn = [_muarrayMyButton objectAtIndex:index];
            NSString *str = [btn titleForState:UIControlStateNormal];
            [indexArray addObject:str];
        }
        
        isOK = ![self judge9Index:indexArray];
        
        //如果有重复或空格，则没有胜利
        if(!isOK)
        {
            return isOK;
        }
    }
    
    //行
    for(int i = 0; i < 9; i++)
    {
        NSMutableArray *indexArray = [[NSMutableArray alloc]init];
        for(int j = 0; j < 9; j++)
        {
            int index = [self fromIndexLie:j hang:i];
            MyButton *btn = [_muarrayMyButton objectAtIndex:index];
            NSString *str = [btn titleForState:UIControlStateNormal];
            [indexArray addObject:str];
        }
        
        isOK = ![self judge9Index:indexArray];
        
        //如果有重复或空格，则没有胜利
        if(!isOK)
        {
            return isOK;
        }
    }
    
    //宫格
    for(int i = 0; i < 9; i++)
    {
        NSMutableArray *indexArray = [[NSMutableArray alloc]init];
        for(int j = 0; j < 9; j++)
        {
            int index = [self fromIndexBig:i small:j];
            MyButton *btn = [_muarrayMyButton objectAtIndex:index];
            NSString *str = [btn titleForState:UIControlStateNormal];
            [indexArray addObject:str];
            
        }
        isOK = ![self judge9Index:indexArray];
        
        //如果有重复或空格，则没有胜利
        if(!isOK)
        {
            return isOK;
        }
    }
    
    return isOK;
}

-(BOOL)judge9Index:(NSMutableArray *)indexArray
{
    //判断9个数的序列是否有重复
    //NO没有重复和空格，YES有重复或空格
    BOOL isOK = NO;
    for(int i = 0; i < 9; i++)
    {
        int iValue =[[indexArray objectAtIndex:i] intValue];
        //判断有没有重复
        if(!iValue)
        {
            isOK = YES;
        }
        else
        {
            for(int j = 0; j < 9; j++)
            {
                int jValue =[[indexArray objectAtIndex:j] intValue];
                if( (i != j) && (iValue == jValue) )
                {
                    isOK = YES;
                }
            }
        }
    }
    return isOK;
}

-(NSMutableArray *)make9Index
{
    NSLog(@"生成1到9不相同的随机序列");
    
    //初始化0到9的数组
    NSMutableArray *indexArray = [[NSMutableArray alloc]init];
    for(int i = 0; i < 9; i ++)
    {
        [indexArray addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    
    NSMutableArray *valueArray = [[NSMutableArray alloc]init];
    for(int i = 0; i < 9; i ++)
    {
        int needIndex = arc4random()%indexArray.count;
        [valueArray addObject:[indexArray objectAtIndex:needIndex]];
        //删除indexArray中的数字
        [indexArray removeObjectAtIndex:needIndex];
    }
    
    return valueArray;
}

-(NSMutableArray *)makeShuDuIndex
{
    NSLog(@"生成完整的数独随机序列");

    //初始化数组
    NSMutableArray *indexArray = [[NSMutableArray alloc]init];
    for(int i = 0; i < 81; i ++)
    {
        [indexArray addObject:@""];
    }
    
    //获取不相同的9位序列
    NSMutableArray *make9index = [self make9Index];
    //NSLog(@"make9index%@",make9index);
    
    //i表是列
    //j表示行
    //初始化中间九宫格
    for(int i = 3; i < 6; i ++)
        for(int j = 3; j < 6; j ++)
        {
            int smallIndex = (i-3) +  (j-3)*3;
            int bigIndex = [self fromIndexLie:i hang:j];
            [indexArray replaceObjectAtIndex:bigIndex withObject:[make9index objectAtIndex:smallIndex]];
        }
    
    // 由中间的九宫格交叉变换，初始化上下左右四个九宫格
    //上下
    for(int i = 3; i < 6; i ++)
    {
        int l = 0;
        for(int j = 3; j < 6; j ++)
        {
            
            if(i == 3)
            {
                int bigIndex1 = [self fromIndexLie:i+1 hang:l];
                [indexArray replaceObjectAtIndex:bigIndex1 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                int bigIndex2 = [self fromIndexLie:i+2 hang:l+6];
                [indexArray replaceObjectAtIndex:bigIndex2 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                l ++;
            }
            else if(i == 4)
            {
                int bigIndex1 = [self fromIndexLie:i+1 hang:l];
                [indexArray replaceObjectAtIndex:bigIndex1 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                int bigIndex2 = [self fromIndexLie:i-1 hang:l+6];
                [indexArray replaceObjectAtIndex:bigIndex2 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                l ++;
            }
            else if(i == 5)
            {
                int bigIndex1 = [self fromIndexLie:i-2 hang:l];
                [indexArray replaceObjectAtIndex:bigIndex1 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                int bigIndex2 = [self fromIndexLie:i-1 hang:l+6];
                [indexArray replaceObjectAtIndex:bigIndex2 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                l ++;
            }
        }
    }
    //左右
    for(int j = 3; j < 6; j ++)
    {
        int l = 0;
        for(int i = 3; i < 6; i ++)
        {
            
            if(j == 3)
            {
                int bigIndex1 = [self fromIndexLie:l hang:j+1];
                [indexArray replaceObjectAtIndex:bigIndex1 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                int bigIndex2 = [self fromIndexLie:l+6 hang:j+2];
                [indexArray replaceObjectAtIndex:bigIndex2 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                l ++;
            }
            else if(j == 4)
            {
                int bigIndex1 = [self fromIndexLie:l hang:j+1];
                [indexArray replaceObjectAtIndex:bigIndex1 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                int bigIndex2 = [self fromIndexLie:l+6 hang:j-1];
                [indexArray replaceObjectAtIndex:bigIndex2 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                l ++;
            }
            else if(j == 5)
            {
                int bigIndex1 = [self fromIndexLie:l hang:j-2];
                [indexArray replaceObjectAtIndex:bigIndex1 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                int bigIndex2 = [self fromIndexLie:l+6 hang:j-1];
                [indexArray replaceObjectAtIndex:bigIndex2 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                l ++;
            }
        }
    }
    // 由中间的九宫格交叉变换，初始化四个角的四个九宫格
    //左上角和右上角
    for(int i = 0; i < 3; i ++)
    {
        int l = 0;
        for(int j = 3; j < 6; j ++)
        {
            
            if(i == 0)
            {
                int bigIndex1 = [self fromIndexLie:i+1 hang:l];
                [indexArray replaceObjectAtIndex:bigIndex1 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                int bigIndex2 = [self fromIndexLie:i+2 hang:l+6];
                [indexArray replaceObjectAtIndex:bigIndex2 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                l ++;
            }
            else if(i == 1)
            {
                int bigIndex1 = [self fromIndexLie:i+1 hang:l];
                [indexArray replaceObjectAtIndex:bigIndex1 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                int bigIndex2 = [self fromIndexLie:i-1 hang:l+6];
                [indexArray replaceObjectAtIndex:bigIndex2 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                l ++;
            }
            else if(i == 2)
            {
                int bigIndex1 = [self fromIndexLie:i-2 hang:l];
                [indexArray replaceObjectAtIndex:bigIndex1 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                int bigIndex2 = [self fromIndexLie:i-1 hang:l+6];
                [indexArray replaceObjectAtIndex:bigIndex2 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                l ++;
            }
        }
    }
    //左下角和右下角
    for(int i = 6; i < 9; i ++)
    {
        int l = 0;
        for(int j = 3; j < 6; j ++)
        {
            
            if(i == 6)
            {
                int bigIndex1 = [self fromIndexLie:i+1 hang:l];
                [indexArray replaceObjectAtIndex:bigIndex1 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                int bigIndex2 = [self fromIndexLie:i+2 hang:l+6];
                [indexArray replaceObjectAtIndex:bigIndex2 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                l ++;
            }
            else if(i == 7)
            {
                int bigIndex1 = [self fromIndexLie:i+1 hang:l];
                [indexArray replaceObjectAtIndex:bigIndex1 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                int bigIndex2 = [self fromIndexLie:i-1 hang:l+6];
                [indexArray replaceObjectAtIndex:bigIndex2 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                l ++;
            }
            else if(i == 8)
            {
                int bigIndex1 = [self fromIndexLie:i-2 hang:l];
                [indexArray replaceObjectAtIndex:bigIndex1 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                int bigIndex2 = [self fromIndexLie:i-1 hang:l+6];
                [indexArray replaceObjectAtIndex:bigIndex2 withObject:[indexArray objectAtIndex:[self fromIndexLie:i hang:j]]];
                l ++;
            }
        }
    }
    //NSLog(@"indexArray%@",indexArray);
    return indexArray;
}

-(NSMutableArray *)makeHole:(NSMutableArray *)indexArray  count:(int)count
{
    NSLog(@"通过挖洞法生成可复原的数独序列");
    
    //为防止完整序列被修改，进行备份
    NSMutableArray *valueArray = [[NSMutableArray alloc]init];
    for(int i = 0; i < 81; i ++)
    {
        [valueArray addObject:[indexArray objectAtIndex:i]];
    }
    
    while (YES)
    {
        int cnt = 0;
        
        //随机洞的位置
        int rand = arc4random()%81;
        [valueArray replaceObjectAtIndex:rand withObject:@""];
 
        //判断现在已经有的洞
        for(int i = 0; i < 81; i ++)
        {
            NSString *str = [valueArray objectAtIndex:i];

            if([str isEqualToString:@""])
            {
                cnt ++;
            }
        }
        
        //当挖的洞数目与需要的相同时结束循环。
        if(cnt == count)
        {
            break;
        }
    }
    
    return valueArray;
}
-(void)show:(NSMutableArray *)indexArray
{
    //显示序列
    for(int i = 0; i < 81; i ++)
    {
        MyButton *btn = [_muarrayMyButton objectAtIndex:i];
        [btn setTitle:[indexArray objectAtIndex:i] forState:UIControlStateNormal];
    }
}

-(int)fromIndexLie:(int)lie hang:(int)hang
{
    //通过行和列获取index值
    int index;
    index = hang * 9 +  lie;
    
    return index;
}

-(int)fromIndexBig:(int)big small:(int)small
{
    //通过大格和小格获取index值
    int index;
    int aLie =  big % 3 *3 + small % 3;
    int aHang = big / 3 *3 + small / 3;
    
    index = aHang * 9 +  aLie;
    
    return index;
}
@end
