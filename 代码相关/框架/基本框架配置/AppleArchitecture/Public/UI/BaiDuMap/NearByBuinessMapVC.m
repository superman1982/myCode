//
//  NearByBuinessMapVC.m
//  TestSingleMapView
//
//  Created by klbest1 on 13-11-28.
//  Copyright (c) 2013年 klbest1. All rights reserved.
//

#import "NearByBuinessMapVC.h"

@interface NearByBuinessMapVC ()

@end

@implementation NearByBuinessMapVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"NearByBuinessMapVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"NearByBuinessMapVC" bundle:aBuddle];
    }
    if (self != nil) {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IS_IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone ;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [super dealloc];
}
#endif

//设置View方向
-(void) setViewFrame:(BOOL)aPortait{
    if (aPortait) {
        if (IS_IPHONE_5) {
        }else{
        }
    }else{
    }
}

//------------------------

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[BaiDuMapView shareBaiDuMapView].mapView viewWillAppear];
    if ([self.view viewWithTag:100] == nil) {
        [self addSingleMapVC];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[BaiDuMapView shareBaiDuMapView].mapView viewWillDisappear];
    if ([self.view viewWithTag:100] != nil) {
        [[BaiDuMapView shareBaiDuMapView].view removeFromSuperview];
        [BaiDuMapView shareBaiDuMapView].delegate = nil;
    }
}

-(void)addSingleMapVC
{
    if ([BaiDuMapView shareBaiDuMapView].view.superview) {
        [[BaiDuMapView shareBaiDuMapView].view removeFromSuperview];
    }
    
    CGRect viewFrame = self.view.frame;
    if (IS_IOS7) {
        viewFrame = CGRectMake(0, -64, 320, viewFrame.size.height);
    }
    [BaiDuMapView shareBaiDuMapView].delegate = self;
    [[BaiDuMapView shareBaiDuMapView] setMapViewFrame:viewFrame];
    [[BaiDuMapView shareBaiDuMapView].view setTag:100];
    [self.view addSubview:[BaiDuMapView shareBaiDuMapView].view ];
    
}



@end
