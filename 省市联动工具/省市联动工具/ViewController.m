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
@property (nonatomic,strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"address" object:nil];
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.mas_equalTo(50.0);
    }];
   
    self.label = [[UILabel alloc]init];
    self.label.textColor = [UIColor blackColor];
    self.label.font =[UIFont systemFontOfSize:18.0];
    [self.view addSubview:self.label];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
       
        make.height.mas_equalTo(44.0);
        make.top.equalTo(self.view).offset(100.0);
    }];
    
    
}
-(void)buttonClick:(UIButton *)sender
{
    STPopupController *VC =[[STPopupController alloc]initWithRootViewController:[PopViewController new]];
    VC.style = STPopupStyleBottomSheet;
    [VC presentInViewController:self completion:nil];
}
-(void)acceptMsg:(NSNotification *)sender
{
    if ([sender.name isEqualToString:@"address"]) {
        self.label.text  = [sender.userInfo objectForKey:@"address"];
    }
}
@end
