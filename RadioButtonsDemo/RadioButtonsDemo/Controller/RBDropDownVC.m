//
//  RBDropDownVC.m
//  RadioButtonsDemo
//
//  Created by lichq on 15/11/11.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "RBDropDownVC.h"
#import <CJPopupView/CJPopupView.h>
#import "CJRadioButtonsHelper.h"
#import "TestDataUtil.h"

#define kDefaultMaxShowCount    5

@interface RBDropDownVC () <RadioButtonsDelegate> {
    
}
@property (nonatomic, strong) CJCommonRadioButtonsDataSource *commonRadioButtonsDataSource;

@end

@implementation RBDropDownVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSArray *titles = @[@"人物", @"爱好", @"其他", @"地区"];
    self.dropdownRadioButtons.radioButtonType = RadioButtonTypeCanDrop;
//    self.dropdownRadioButtons.dataSource = self;
    [self.dropdownRadioButtons commonSetupWithType:CJCommonRadioButtonTypeDropDown];
    
    self.commonRadioButtonsDataSource =
    [[CJCommonRadioButtonsDataSource alloc] initWithTitles:titles
                                          defaultShowIndex:-1
                                        maxButtonShowCount:kDefaultMaxShowCount
                                     commonRadioButtonType:CJCommonRadioButtonTypeDropDown];
    self.dropdownRadioButtons.dataSource = self.commonRadioButtonsDataSource;
    self.dropdownRadioButtons.delegate = self;
    self.dropdownRadioButtons.tag = 111;
    
    self.dropdownRadioButtons2.radioButtonType = RadioButtonTypeCanDrop;
//    self.dropdownRadioButtons2.dataSource = self;
    [self.dropdownRadioButtons2 commonSetupWithType:CJCommonRadioButtonTypeDropDown];
    
//    self.commonRadioButtonsDataSource =
//    [[CJCommonRadioButtonsDataSource alloc] initWithTitles:titles
//                                          defaultShowIndex:-1
//                                        maxButtonShowCount:kDefaultMaxShowCount
//                                     commonRadioButtonType:CJCommonRadioButtonTypeDropDown];
    self.dropdownRadioButtons2.dataSource = self.commonRadioButtonsDataSource;
    self.dropdownRadioButtons2.delegate = self;
    self.dropdownRadioButtons2.tag = 222;
    
    
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.dropdownRadioButtons scollToCurrentSelectedViewWithAnimated:NO];
    [self.dropdownRadioButtons2 scollToCurrentSelectedViewWithAnimated:NO];
}

#pragma mark - RadioButtonsDelegate
- (void)cj_radioButtons:(RadioButtons *)radioButtons chooseIndex:(NSInteger)index_cur oldIndex:(NSInteger)index_old {
    NSLog(@"index_old = %ld, index_cur = %ld", index_old, index_cur);
    
    //radioButtons.tag == 222，则才采用#import "UIView+ShowHisDropDownView.h"（其实际上内部引用了"UIView+ShowPopupInView.h"，刚好与"UIView+PopupInView.h"不同）
    if (radioButtons.tag == 222) {
        
        UIView *sender = radioButtons;
        if (index_old != -1) {
            if (index_cur == index_old) {
                [sender showHisDropDownView_dismissPopupViewAnimated:YES];
                return;
            }else{
                [sender showHisDropDownView_dismissPopupViewAnimated:NO];
            }
        }
        
        switch (index_cur) {
            case 0:
            {
                UIView *popupView = [[UIView alloc]initWithFrame:CGRectZero];
                popupView.backgroundColor = [UIColor greenColor];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(20, 50, 280, 44)];
                [btn setTitle:@"1.生成随机数，并设置" forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor redColor]];
                [btn addTarget:self action:@selector(btnAction222:) forControlEvents:UIControlEventTouchUpInside];
                [popupView addSubview:btn];
                
                CGFloat h_popupView = 100;
                UIView *popupSuperview = self.view;
                
                [sender showHisDropDownView:popupView inView:popupSuperview withHeight:h_popupView showComplete:^{
                    NSLog(@"1.显示完成");
                    [radioButtons setCjExtendViewShowing:YES];
                    
                } tapBGComplete:^{
                    NSLog(@"1.点击背景完成");
                    [radioButtons changeCurrentRadioButtonState];
                    [radioButtons setSelectedNone];
                    
                } hideComplete:^{
                    NSLog(@"1.隐藏完成");
                    
                }];
                
                break;
            }
            case 1:
            {
                UIView *popupView = [[UIView alloc]initWithFrame:CGRectZero];
                popupView.backgroundColor = [UIColor greenColor];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(20, 50, 280, 44)];
                [btn setTitle:@"2.生成随机数，并设置" forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor redColor]];
                [btn addTarget:self action:@selector(btnAction222:) forControlEvents:UIControlEventTouchUpInside];
                [popupView addSubview:btn];
                
                CGFloat h_popupView = 100;
                UIView *popupSuperview = self.view;
                
                [sender showHisDropDownView:popupView inView:popupSuperview withHeight:h_popupView showComplete:^{
                    NSLog(@"2.显示完成");
                    
                } tapBGComplete:^{
                    NSLog(@"2.点击背景完成");
                    [radioButtons changeCurrentRadioButtonState];
                    [radioButtons setSelectedNone];
                    
                } hideComplete:^{
                    NSLog(@"2.隐藏完成");
                    
                }];
                break;
            }
            case 2:
            {
                UIView *popupView = [[UIView alloc]initWithFrame:CGRectZero];
                popupView.backgroundColor = [UIColor greenColor];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(20, 50, 280, 44)];
                [btn setTitle:@"3.生成随机数，并设置" forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor redColor]];
                [btn addTarget:self action:@selector(btnAction222:) forControlEvents:UIControlEventTouchUpInside];
                [popupView addSubview:btn];
                
                CGFloat h_popupView = 100;
                UIView *popupSuperview = self.view;
                
                [sender showHisDropDownView:popupView inView:popupSuperview withHeight:h_popupView showComplete:^{
                    NSLog(@"3.显示完成");
                    
                } tapBGComplete:^{
                    NSLog(@"3.点击背景完成");
                    [radioButtons changeCurrentRadioButtonState];
                    [radioButtons setSelectedNone];
                    
                } hideComplete:^{
                    NSLog(@"3.隐藏完成");
                    
                }];
                break;
            }
            case 3:
            {
                UIView *popupView = [[UIView alloc]initWithFrame:CGRectZero];
                popupView.backgroundColor = [UIColor greenColor];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(20, 50, 280, 44)];
                [btn setTitle:@"4.生成随机数，并设置" forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor redColor]];
                [btn addTarget:self action:@selector(btnAction222:) forControlEvents:UIControlEventTouchUpInside];
                [popupView addSubview:btn];
                
                CGFloat h_popupView = 100;
                UIView *popupSuperview = self.view;
                
                [sender showHisDropDownView:popupView inView:popupSuperview withHeight:h_popupView showComplete:^{
                    NSLog(@"4.显示完成");
                    
                } tapBGComplete:^{
                    NSLog(@"4.点击背景完成");
                    [radioButtons changeCurrentRadioButtonState];
                    [radioButtons setSelectedNone];
                    
                } hideComplete:^{
                    NSLog(@"4.隐藏完成");
                    
                }];
                break;
            }
            default:
                break;
        }
        
        
        return;
    }
    
    //radioButtons.tag == 111，则才采用"UIView+PopupInView.h"
    switch (index_cur) {
        case 0:
        {
            if (index_cur == index_old) {
                [popupView1 popupInView_dismissFromSuperViewAnimated:YES];
                return;
                
            }else if (index_old == 1) {
                [popupView2 popupInView_dismissFromSuperViewAnimated:NO];
            }else if (index_old == 2){
                [popupView3 popupInView_dismissFromSuperViewAnimated:NO];
            }else if (index_old == 3){
                [popupView4 popupInView_dismissFromSuperViewAnimated:NO];
            }
            
            
            if (popupView1 == nil) {
                UIView *popupView = [[UIView alloc]initWithFrame:CGRectZero];
                popupView.backgroundColor = [UIColor greenColor];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(20, 50, 280, 44)];
                [btn setTitle:@"1.生成随机数，并设置" forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor redColor]];
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [popupView addSubview:btn];
                
                popupView1 = popupView;
                popupView1.tag = 1001;
            }
            
            CGFloat h_popupView = 100;
            UIView *sender = radioButtons;
            UIView *popupSuperview = self.view;
            CGPoint pointBtnConvert = [sender.superview convertPoint:sender.frame.origin toView:popupSuperview];
            CGPoint pointLocation = CGPointMake(pointBtnConvert.x, pointBtnConvert.y + CGRectGetHeight(sender.frame));
            CGSize size_popupView = CGSizeMake(CGRectGetWidth(sender.frame), h_popupView);
            
            [popupView1 popupInView:popupSuperview atLocationPoint:pointLocation withSize:size_popupView showComplete:^{
                NSLog(@"1.显示完成");
                
            } tapBGComplete:^{
                NSLog(@"1.点击背景完成");
                [radioButtons changeCurrentRadioButtonState];
                [radioButtons setSelectedNone];
                
            } hideComplete:^{
                NSLog(@"1.隐藏完成");
                
            }];
            
            break;
        }
        case 1:
        {
            if (index_cur == index_old) {
                [popupView2 popupInView_dismissFromSuperViewAnimated:YES];
                return;
                
            }else if (index_old == 0) {
                [popupView1 popupInView_dismissFromSuperViewAnimated:NO];
            }else if (index_old == 2){
                [popupView3 popupInView_dismissFromSuperViewAnimated:NO];
            }else if (index_old == 3){
                [popupView4 popupInView_dismissFromSuperViewAnimated:NO];
            }
            
            
            if (popupView2 == nil) {
                UIView *popupView = [[UIView alloc]initWithFrame:CGRectZero];
                popupView.backgroundColor = [UIColor greenColor];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(20, 50, 280, 44)];
                [btn setTitle:@"2.生成随机数，并设置" forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor redColor]];
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [popupView addSubview:btn];
                
                popupView2 = popupView;
                popupView2.tag = 1001;
            }
            
            CGFloat h_popupView = 100;
            UIView *sender = radioButtons;
            UIView *popupSuperview = self.view;
            CGPoint pointBtnConvert = [sender.superview convertPoint:sender.frame.origin toView:popupSuperview];
            CGPoint pointLocation = CGPointMake(pointBtnConvert.x, pointBtnConvert.y + CGRectGetHeight(sender.frame));
            CGSize size_popupView = CGSizeMake(CGRectGetWidth(sender.frame), h_popupView);
            
            [popupView2 popupInView:popupSuperview atLocationPoint:pointLocation withSize:size_popupView showComplete:^{
                NSLog(@"2.显示完成");
                
            } tapBGComplete:^{
                NSLog(@"2.点击背景完成");
                [radioButtons changeCurrentRadioButtonState];
                [radioButtons setSelectedNone];
                
            } hideComplete:^{
                NSLog(@"2.隐藏完成");
                
            }];
            break;
        }
        case 2:
        {
            if (index_cur == index_old) {
                [popupView3 popupInView_dismissFromSuperViewAnimated:YES];
                return;
                
            }else if (index_old == 0) {
                [popupView1 popupInView_dismissFromSuperViewAnimated:NO];
            }else if (index_old == 1){
                [popupView2 popupInView_dismissFromSuperViewAnimated:NO];
            }else if (index_old == 3){
                [popupView4 popupInView_dismissFromSuperViewAnimated:NO];
            }
            
            
            if (popupView3 == nil) {
                UIView *popupView = [[UIView alloc]initWithFrame:CGRectZero];
                popupView.backgroundColor = [UIColor greenColor];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(20, 50, 280, 44)];
                [btn setTitle:@"3.生成随机数，并设置" forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor redColor]];
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [popupView addSubview:btn];
                
                popupView3 = popupView;
                popupView3.tag = 1001;
            }
            
            CGFloat h_popupView = 100;
            UIView *sender = radioButtons;
            UIView *popupSuperview = self.view;
            CGPoint pointBtnConvert = [sender.superview convertPoint:sender.frame.origin toView:popupSuperview];
            CGPoint pointLocation = CGPointMake(pointBtnConvert.x, pointBtnConvert.y + CGRectGetHeight(sender.frame));
            CGSize size_popupView = CGSizeMake(CGRectGetWidth(sender.frame), h_popupView);
            
            [popupView3 popupInView:popupSuperview atLocationPoint:pointLocation withSize:size_popupView showComplete:^{
                NSLog(@"3.显示完成");
                
            } tapBGComplete:^{
                NSLog(@"3.点击背景完成");
                [radioButtons changeCurrentRadioButtonState];
                [radioButtons setSelectedNone];
                
            } hideComplete:^{
                NSLog(@"3.隐藏完成");
                
            }];
            break;
        }
        case 3:
        {
            if (index_cur == index_old) {
                [popupView4 popupInView_dismissFromSuperViewAnimated:YES];
                return;
                
            }else if (index_old == 0) {
                [popupView1 popupInView_dismissFromSuperViewAnimated:NO];
            }else if (index_old == 1){
                [popupView2 popupInView_dismissFromSuperViewAnimated:NO];
            }else if (index_old == 2){
                [popupView3 popupInView_dismissFromSuperViewAnimated:NO];
            }
            
            
            if (popupView4 == nil) {
                UIView *popupView = [[UIView alloc]initWithFrame:CGRectZero];
                popupView.backgroundColor = [UIColor greenColor];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(20, 50, 280, 44)];
                [btn setTitle:@"4.生成随机数，并设置" forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor redColor]];
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [popupView addSubview:btn];
                
                popupView4 = popupView;
                popupView4.tag = 1001;
            }
            
            CGFloat h_popupView = 100;
            UIView *sender = radioButtons;
            UIView *popupSuperview = self.view;
            CGPoint pointBtnConvert = [sender.superview convertPoint:sender.frame.origin toView:popupSuperview];
            CGPoint pointLocation = CGPointMake(pointBtnConvert.x, pointBtnConvert.y + CGRectGetHeight(sender.frame));
            CGSize size_popupView = CGSizeMake(CGRectGetWidth(sender.frame), h_popupView);
            
            [popupView4 popupInView:popupSuperview atLocationPoint:pointLocation withSize:size_popupView showComplete:^{
                NSLog(@"4.显示完成");
                
            } tapBGComplete:^{
                NSLog(@"4.点击背景完成");
                [radioButtons changeCurrentRadioButtonState];
                [radioButtons setSelectedNone];
                
            } hideComplete:^{
                NSLog(@"4.隐藏完成");
                
            }];
            break;
        }
        default:
            break;
    }
}

- (IBAction)btnAction:(id)sender{
    NSInteger index_old = self.dropdownRadioButtons.currentSelectedIndex;
    
    NSString *title = [NSString stringWithFormat:@"%d", rand()%10];
    [self.dropdownRadioButtons changeCurrentRadioButtonStateAndTitle:title];
    [self.dropdownRadioButtons setSelectedNone];
    
    if (index_old == 0) {
        [popupView1 popupInView_dismissFromSuperViewAnimated:YES];
    }else if (index_old == 1) {
        [popupView2 popupInView_dismissFromSuperViewAnimated:YES];
    }else if (index_old == 2){
        [popupView3 popupInView_dismissFromSuperViewAnimated:YES];
    }else if (index_old == 3){
        [popupView4 popupInView_dismissFromSuperViewAnimated:YES];
    }
}


- (IBAction)btnAction222:(id)sender{
    NSString *title = [NSString stringWithFormat:@"%d", rand()%10];
    [self.dropdownRadioButtons2 changeCurrentRadioButtonStateAndTitle:title];
    [self.dropdownRadioButtons2 setSelectedNone];
    
    [self.dropdownRadioButtons2 showHisDropDownView_dismissPopupViewAnimated:YES];
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
