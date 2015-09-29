//
//  ViewController.m
//  测试打印机
//
//  Created by lin on 14-8-11.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)printButtonClicked:(id)sender {
    UIPrintInteractionController *vPrintC = [UIPrintInteractionController sharedPrintController];
    vPrintC.delegate = self;
    
    UIPrintInfo *vPrintInfo = [UIPrintInfo printInfo];
    vPrintInfo.outputType = UIPrintInfoOutputGeneral;
    vPrintC.showsPageRange = YES;
    
    UISimpleTextPrintFormatter *vTetFormatter = [[UISimpleTextPrintFormatter alloc] initWithText:@"fuck funck afjlajfoq"];
    vTetFormatter.startPage = 0;
    vTetFormatter.contentInsets = UIEdgeInsetsMake(200, 300, 0, 72.0); // 插入内容页的边缘 1 inch margins
    vTetFormatter.maximumContentWidth = 16 * 72.0;//最大范围的宽
    vPrintC.printFormatter = vTetFormatter;
    
    //等待完成
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"可能无法完成，因为印刷错误: %@", error);
        }
    };
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:sender];//调用方法的时候，要注意参数的类型－下面presentFromBarButtonItem:的参数类型是 UIBarButtonItem..如果你是在系统的UIToolbar or UINavigationItem上放的一个打印button，就不需要转换了。
        [vPrintC presentFromBarButtonItem:item animated:YES completionHandler:completionHandler];//在ipad上弹出打印那个页面
    } else {
        [vPrintC presentAnimated:YES completionHandler:completionHandler];//在iPhone上弹出打印那个页面
    }
}
@end
