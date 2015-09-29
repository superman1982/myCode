//
//  AgrementVC.m
//  lvtubangmember
//
//  Created by klbest1 on 14-3-25.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "AgrementVC.h"
#import "StringHelper.h"

@interface AgrementVC ()

@end

@implementation AgrementVC

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


#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_agrementTextView release];
    [_makeCarAgrement release];
    [_bookAgrement release];
    [super dealloc];
}
#endif

-(void)back{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)setAgrementType:(AgrementType)aType
{
    if (aType == atRegister) {
        self.title = @"注册协议";
        [self.view addSubview:self.agrementTextView];
    }else if(aType== atMakeCar){
        self.title = @"拼车协议";
        [self.view addSubview:self.makeCarAgrement];
    }else if (aType == atBook){
        self.title = @"报名协议";
        [self.view addSubview:self.bookAgrement];
    }
    
    self.agrementTextView.frame = self.view.frame;
    LOG(@"AgrementVC:%f",self.view.frame.size.height);
    self.makeCarAgrement.frame = self.view.frame;
    self.bookAgrement.frame = self.view.frame;
    
    if (IS_IPHONE_5) {
        self.agrementTextView.contentSize = CGSizeMake(320, self.agrementTextView.contentSize.height +70);
        self.makeCarAgrement.contentSize = CGSizeMake(320, self.makeCarAgrement.contentSize.height +70);
        self.bookAgrement.contentSize = CGSizeMake(320, self.bookAgrement.contentSize.height +70);
    }else{
        self.agrementTextView.contentSize = CGSizeMake(320, self.agrementTextView.contentSize.height +70);
        self.makeCarAgrement.contentSize = CGSizeMake(320, self.makeCarAgrement.contentSize.height +70);
        self.bookAgrement.contentSize = CGSizeMake(320, self.bookAgrement.contentSize.height +70);
    }

}

- (void)viewDidUnload {
    [self setAgrementTextView:nil];
    [self setMakeCarAgrement:nil];
    [self setBookAgrement:nil];
    [super viewDidUnload];
}
@end
