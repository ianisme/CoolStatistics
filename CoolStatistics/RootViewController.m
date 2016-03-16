//
//  RootViewController.m
//  CoolStatistics
//
//  Created by ian on 15/4/15.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import "RootViewController.h"
#import "CoolClick.h"
#import "NetworkService.h"
#import "CoolManager.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试页面1";
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = [UIColor blackColor];
    [btn1 setTitle:@"开始" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    btn1.tag = 1001;
    btn1.frame = CGRectMake(self.view.frame.size.width/2-100/2, 100, 50, 50);
    [btn1 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.backgroundColor = [UIColor blackColor];
    btn2.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [btn2 setTitle:@"结束" forState:UIControlStateNormal];
    btn2.tag = 1002;
    btn2.frame = CGRectMake(self.view.frame.size.width/2-100/2, 300, 50, 50);
    [btn2 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.backgroundColor = [UIColor blackColor];
    [btn3 setTitle:@"打印单例总值" forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    btn3.tag = 1003;
    btn3.frame = CGRectMake(self.view.frame.size.width/2-100/2+70, 300, 100, 50);
    [btn3 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    // Do any additional setup after loading the view.
}

- (void)Click:(UIButton *)btn
{
    if (btn.tag == 1001) {
        [CoolClick beginEvent:@"adsasd"];
    }else if (btn.tag == 1002){
        [CoolClick endEvent:@"adsasd"];
    }else if (btn.tag == 1003){
        NSLog(@"%@",[CoolManager shareInstance].coolMutableArray);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
