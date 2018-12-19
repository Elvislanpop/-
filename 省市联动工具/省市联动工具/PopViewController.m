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
@property (nonatomic,strong) NSDictionary *dictArea;

//数据模型数组
@property (nonatomic,strong) NSArray *modelProvince;
@property (nonatomic,strong) NSArray *modelCity;
@property (nonatomic,strong) NSArray *modelArea;
//选中的数据用于回调
@property (nonatomic,strong) NSString *selectProvince;
@property (nonatomic,strong) NSString *selectCity;
@property (nonatomic,strong) NSString *selectArea;

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
    self.title =@"省市区选择";
    [self.view addSubview:self.pickerView];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneClick:)];
    
    //省区
    NSString *fileProvince =[[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
    NSData *dataProvinve =[NSData dataWithContentsOfFile:fileProvince];
    NSArray  *arrayProvince =[NSJSONSerialization JSONObjectWithData:dataProvinve options:kNilOptions error:&error];
    self.modelProvince = [DataModel mj_objectArrayWithKeyValuesArray:arrayProvince];
    
    //市区
    NSString *fileCity =[[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    NSData *dataCity =[NSData dataWithContentsOfFile:fileCity];
    self.dicCity =[NSJSONSerialization JSONObjectWithData:dataCity options:kNilOptions error:&error];
    
    
    
    //区
    NSString *fileArea =[[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
    NSData *dataArea =[NSData dataWithContentsOfFile:fileArea];
    self.dictArea =[NSJSONSerialization JSONObjectWithData:dataArea options:kNilOptions error:&error];
    
    [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
           return self.modelProvince.count;
           
        case 1:
        {
            return self.modelCity.count;
        }
        case 2:
            return self.modelArea.count;
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
        case 2:
        {
            DataModel *modelArea = self.modelArea[row];
            return modelArea.name;
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
    switch (component) {
        case 0:
        {
            DataModel *modelProvince = self.modelProvince[row];
            NSArray *ArrayCity = [self.dicCity objectForKey:[NSString stringWithFormat:@"%lu",modelProvince.id]];
            self.modelCity =[DataModel mj_objectArrayWithKeyValuesArray:ArrayCity];
           
           [self.pickerView reloadComponent:1];
           [self.pickerView selectRow:0 inComponent:1 animated:YES];
           [self pickerView:self.pickerView didSelectRow:0 inComponent:1];
          
           
        }
            break;
        case 1:
        {
            DataModel *modelCity =self.modelCity[row];
            NSArray *ArrayArea =[self.dictArea objectForKey:[NSString stringWithFormat:@"%lu",modelCity.id]];
            self.modelArea =[DataModel mj_objectArrayWithKeyValuesArray:ArrayArea];
            
            //刷新后一列的数据源
            [self.pickerView reloadComponent:2];
            //保持数据刷新的时候后一列从头开始
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
            //保持联动
            [self pickerView:self.pickerView didSelectRow:0 inComponent:2];
            
        }
            break;
        case 2:
        {
          
        }
            break;
        default:
            break;
    }
    [self selectedPickerViewRow:row InComponent:component];
   

}
-(void)selectedPickerViewRow:(NSInteger)row InComponent:(NSInteger)Component
{
    
    switch (Component) {
        case 0:
            {
                DataModel *model = self.modelProvince[row];
                self.selectProvince =  model.name;
            }
            break;
        case 1:
        {
            DataModel *model = self.modelCity[row];
            self.selectCity = model.name;
        }
            break;
        case 2:
        {
            DataModel *model = self.modelArea[row];
            self.selectArea = model.name;
        }
            break;
        default:
            break;
    }
   
    
    
}

-(void)DoneClick:(UIBarButtonItem *)sender
{
    self.selectedValue = [NSString stringWithFormat:@"%@     %@   %@",self.selectProvince,self.selectCity,self.selectArea];
    NSLog(@"%@",self.selectedValue);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"address" object:nil userInfo:@{@"address":self.selectedValue}];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
