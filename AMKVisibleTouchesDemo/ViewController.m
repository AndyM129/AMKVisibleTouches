//
//  ViewController.m
//  AMKVisibleTouchesDemo
//
//  Created by Andy__M on 16/4/16.
//  Copyright © 2016年 Andy__M. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AMKVisibleTouches";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:75/255.0 green:172/255.0 blue:238/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:self.view.bounds];
    lable.text = @"Hello World";
    lable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
