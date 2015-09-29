//
//  WelcomeVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-15.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "WelcomeVC.h"

@interface WelcomeVC ()

@end

@implementation WelcomeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"WelcomeVC" bundle:nibBundleOrNil];
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"WelcomeVC_2x" bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.scrollView addSubview:self.contentView];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setDelegate:self];
    [self.scrollView setContentSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height)];
    self.pageControl.numberOfPages = 4;
    if (IS_IOS7){
        self.edgesForExtendedLayout = UIRectEdgeNone ;
    }else{
        [self.pageControlContentView setFrame:CGRectMake(0, self.pageControlContentView.frame.origin.y-20, self.pageControlContentView.frame.size.width, self.pageControlContentView.frame.size.height)];
        [self.contentView setFrame:CGRectMake(0, -20, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        [self.scrollView setContentSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height - 20)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	self.pageControl.currentPage = page;
}

- (IBAction)userImagejiatlyButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([_delegate respondsToSelector:@selector(didWelcomeVCDismissed:)]) {
            [_delegate didWelcomeVCDismissed:Nil];
        }
    }];
}
@end
