//
//  ViewController.m
//  测试动画
//
//  Created by lin on 14-6-3.
//  Copyright (c) 2014年 北京致远. All rights reserved.
//

#import "ViewController.h"
#import "UIView+ViewAnimation.h"
#import "MenuRoundAnimationView.h"
#import "LayerView.h"

@interface ViewController ()
{
    MenuRoundAnimationView *mMenuView;
    CGMutablePathRef   mPath;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    if (mMenuView == nil) {
//        mMenuView = [[MenuRoundAnimationView alloc] initWithFrame:self.view.frame];
//        NSArray *vImageInfo = @[@{NOMAL_KEY: @"KYICircleMenuButton01",
//                                  SELETED_KEY:@"KYICircleMenuButton01",
//                                  IMAGE_WIDTH_KEY:[NSNumber numberWithInt:60],
//                                  },
//                                @{NOMAL_KEY: @"KYICircleMenuButton02",
//                                  SELETED_KEY:@"KYICircleMenuButton02",
//                                  IMAGE_WIDTH_KEY:[NSNumber numberWithInt:60],
//                                  },
//                                @{NOMAL_KEY: @"KYICircleMenuButton03",
//                                  SELETED_KEY:@"KYICircleMenuButton03",
//                                  IMAGE_WIDTH_KEY:[NSNumber numberWithInt:60],
//                                  },
//                                ];
//        [mMenuView setMenuInfo:vImageInfo CenterItem:@{
//                                                       NOMAL_KEY:@"KYICircleMenuCenterButton",
//                                                       SELETED_KEY:@"KYICircleMenuCenterButton",
//                                                       IMAGE_WIDTH_KEY:[NSNumber numberWithInt:60],
//                                                       }];
//    }
//    [self.view addSubview:mMenuView];
    
    
//-------添加自定义Layer-------------
    LayerView *vView = [[LayerView alloc] initWithFrame:CGRectMake(30, 140, 240, 200)];
    [vView setTag:100];
    [self.view addSubview:vView];
    [vView setBackgroundColor:[UIColor lightGrayColor]];
    
    CustomLissajousLayer *vLayer = (CustomLissajousLayer *)vView.layer ;
    [vLayer setBackgroundColor:[UIColor clearColor].CGColor];
    [vView release];
//--------end------------
    
    
    NSNumber *vN1 = [NSNumber numberWithInt:8653709];
    NSNumber *vN2 = [NSNumber numberWithInt:8653709];
    NSLog(@"%p",vN1);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionButton:(id)sender {
//    [self.imageView roate360DegreeAnimation:2];
//    [self.view scaleOutAnimation:.4];
    [self.imageView animationWithGroup];
    //-------路径动画
//    [self.imageView animationFollowPath];
//    [self addDrawLayer];
    //------------
    
//    LayerView *vView = (LayerView *)[self.view viewWithTag:100];
//    [(CustomLissajousLayer *)vView.layer setAmplitude:75.0];
//    [(CustomLissajousLayer *)vView.layer setA:1.0];
//    [(CustomLissajousLayer *)vView.layer setB:2.0];
//    [(CustomLissajousLayer *)vView.layer setDelta:(float)M_PI];
}

-(void)addDrawLayer{
    if (mPath == nil) {
        CALayer *vDrawLayer = [CALayer layer];
        [vDrawLayer setBounds:self.view.layer.bounds];
        [vDrawLayer setShadowColor:[UIColor redColor].CGColor];
        [vDrawLayer setShadowOffset:CGSizeMake(5, 5)];
        [vDrawLayer setDelegate: self];
        [vDrawLayer setNeedsDisplay];
        [vDrawLayer setPosition:self.view.layer.position];
        [self.view.layer addSublayer:vDrawLayer];
        
        mPath  = CGPathCreateMutable();
        CGPathMoveToPoint(mPath, NULL, 20, 30);
        CGPathAddLineToPoint(mPath, NULL, 200, 100);
        CGPathAddCurveToPoint(mPath, NULL, 60, 150, 40,300, 200, 340);
        CGPathAddArc(mPath, NULL, 200, 340, 60, 0 ,M_PI, NO);
    }
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    
    CGContextAddPath(ctx, mPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextStrokePath(ctx);
}

@end
