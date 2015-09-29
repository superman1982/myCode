//
//  ServiceTypeTableVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ServiceTypeTableVC.h"

@interface ServiceTypeTableVC ()
{
    NSArray *mServiceTypeArrays;
}
@end

@implementation ServiceTypeTableVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    self = [super initWithNibName:aNibName bundle:aBuddle];
    if (self != nil) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSArray *vServiceArray = @[
            @{@"type": [NSNumber numberWithInt:stViewPoint],@"title": @"景点",},
            @{@"type": [NSNumber numberWithInt:stFood],@"title": @"美食",},
            @{@"type": [NSNumber numberWithInt:stHotel],@"title": @"酒店",},
            @{@"type": [NSNumber numberWithInt:stCasula],@"title": @"休闲",},
            @{@"type": [NSNumber numberWithInt:stLive],@"title": @"生活",},
            @{@"type": [NSNumber numberWithInt:stOther],@"title": @"其他",},
            ];
    //laziy alloc
    mServiceTypeArrays = [[NSArray alloc] initWithArray:vServiceArray];
    CGRect vViewRect= self.view.frame;
    [self.tableView setFrame:CGRectMake(0,0, 320, (mServiceTypeArrays.count) *44)];
    if (self.tableView.frame.size.height > vViewRect.size.height - 64) {
        [self.tableView setFrame:CGRectMake(0,0, 320, vViewRect.size.height - 64)];
    }
    [self.view setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:0.7]];
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [mServiceTypeArrays release];
    [_tableView release];
    [super dealloc];
}
#endif

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return mServiceTypeArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        SAFE_ARC_AUTORELEASE(cell);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.textLabel.text = [[mServiceTypeArrays objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.tag = [[[mServiceTypeArrays objectAtIndex:indexPath.row] objectForKey:@"type"] intValue];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *vDic = [mServiceTypeArrays objectAtIndex:indexPath.row];
    SearchType vSearchType = [[vDic objectForKey:@"type"] intValue];

    if ([_delegate respondsToSelector:@selector(didServiceTypeTableVCSelected:)]) {
        [_delegate didServiceTypeTableVCSelected:vSearchType];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(self.tableView.frame, vTouchPoint)) {
        [self.view removeFromSuperview];
    }
}

- (void)viewDidUnload {
[super viewDidUnload];
}
@end
