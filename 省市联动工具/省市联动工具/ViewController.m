//
//  ViewController.m
//  省市联动工具
//
//  Created by DayDream on 2018/12/17.
//  Copyright © 2018 蛤蛤. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import <STPopup.h>
#import "PopViewController.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button =[UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.mas_equalTo(50.0);
    }];
   
   
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)buttonClick:(UIButton *)sender
{
    STPopupController *VC =[[STPopupController alloc]initWithRootViewController:[PopViewController new]];
    VC.style = STPopupStyleBottomSheet;
    [VC presentInViewController:self completion:nil];
}

@end
