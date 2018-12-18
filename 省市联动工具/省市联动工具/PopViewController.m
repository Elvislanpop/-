//
//  PopViewController.m
//  省市联动工具
//
//  Created by DayDream on 2018/12/17.
//  Copyright © 2018 蛤蛤. All rights reserved.
//

#import "PopViewController.h"
#import <STPopup.h>
#import "DataModel.h"
#import <MJExtension.h>
@interface PopViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIPickerView *pickerView;
//原始字典/数组
@property (nonatomic,strong) NSDictionary *dicCity;

//数据模型数组
@property (nonatomic,strong) NSArray *modelProvince;
@property (nonatomic,strong) NSArray *modelCity;
@property (nonatomic,strong) NSArray *modelArea;


@end

@implementation PopViewController
-(UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView =[[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
        
        _pickerView.delegate  = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error;
    self.view.backgroundColor =[UIColor whiteColor];
    self.contentSizeInPopup = CGSizeMake(self.view.frame.size.width, 250);
    self.title =@"省";
    [self.view addSubview:self.pickerView];
    
    //省区
    NSString *fileProvince =[[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
    NSData *dataProvinve =[NSData dataWithContentsOfFile:fileProvince];
    NSArray  *arrayProvince =[NSJSONSerialization JSONObjectWithData:dataProvinve options:kNilOptions error:&error];
    self.modelProvince = [DataModel mj_objectArrayWithKeyValuesArray:arrayProvince];
    
    //市区
    NSString *fileCity =[[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    NSData *dataCity =[NSData dataWithContentsOfFile:fileCity];
    self.dicCity =[NSJSONSerialization JSONObjectWithData:dataCity options:kNilOptions error:&error];
    for (int i  = 0; i < self.modelProvince.count; i++) {
        DataModel *model = self.modelProvince[i];
        NSArray *ArrayCity = [self.dicCity objectForKey:[NSString stringWithFormat:@"%lu",model.id]];
        self.modelCity =[DataModel mj_objectArrayWithKeyValuesArray:ArrayCity];
        
    }
    
    
    //区
    NSString *fileArea =[[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
    NSData *dataArea =[NSData dataWithContentsOfFile:fileArea];
    NSArray  *arrayArea =[NSJSONSerialization JSONObjectWithData:dataArea options:kNilOptions error:&error];
    self.modelArea = [DataModel mj_objectArrayWithKeyValuesArray:arrayArea];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
           return self.modelProvince.count;
           
        case 1:
        {
            DataModel *modelProvince = self.modelProvince[3];
            NSArray *ArrayCity = [self.dicCity objectForKey:[NSString stringWithFormat:@"%lu",modelProvince.id]];
            self.modelCity =[DataModel mj_objectArrayWithKeyValuesArray:ArrayCity];
            return self.modelCity.count;
        }
        default:
            return 0;
    }
    
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
        {
            DataModel *modelProvince = self.modelProvince[row];
            return modelProvince.name;
        }
        case 1:
        {
            
            
            DataModel *modelCity = self.modelCity[row];
           
            return modelCity.name;
        }
        default:
            return @"";
    }
    
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label =[[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor blackColor];
   
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //当选中的时候取出这一行的View， 使用这个方法的前提必须Item 为自定义的Label；
    UILabel *label =  [self.pickerView viewForRow:row forComponent:component];
    label.textColor = [UIColor redColor];

}
@end
