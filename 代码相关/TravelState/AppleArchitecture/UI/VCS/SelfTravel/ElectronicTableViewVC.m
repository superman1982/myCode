//
//  ElectronicTableViewVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-22.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ElectronicTableViewVC.h"
#import "ElectronicCell.h"
#import "ElectronicTitleCell.h"
#import "ElectronicTitleCell.h"
#import "ScenicDetailVC.h"
#import "ElectronicRouteBookVC.h"
#import "ElectronicSiteInfo.h"
#import "ElectronicBookManeger.h"

@interface ElectronicTableViewVC ()
{
    NSNumber *mNearByToDayIndex;
    NSDateFormatter *dateFormatter;   //时间格式
}
@end

@implementation ElectronicTableViewVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _routesInfoArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (IS_IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone ;
    }
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //滑动到离当前时间最近的站点
    NSIndexPath *vIndexPath = [NSIndexPath indexPathForRow:[mNearByToDayIndex intValue] inSection:0];
    if (vIndexPath != Nil) {
        [self.tableView selectRowAtIndexPath:vIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
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
    [mNearByToDayIndex release];
    [dateFormatter release];
    [_dayDataDic release];
    [_routesInfoArray removeAllObjects],_routesInfoArray = nil;
    [_firstRowContentView release];
    [super dealloc];
}
#endif

-(void)setRoutesInfoArray:(NSMutableArray *)routesInfoArray{
    if (_routesInfoArray == nil) {
        _routesInfoArray = [[NSMutableArray alloc] init];
    }
    [_routesInfoArray removeAllObjects];
    [_routesInfoArray addObjectsFromArray:routesInfoArray];
    
    [self.tableView reloadData];
}
-(void)setDayDataDic:(NSDictionary *)dayDataDic{
    _dayDataDic = [[NSDictionary alloc] initWithDictionary:dayDataDic];
    NSDictionary *vSiteDic = [_dayDataDic objectForKey:@"sites"];
    NSInteger vSiteCount = 0;
    NSMutableArray *vDayInfoArray = [NSMutableArray array];
    for (NSDictionary *vDic in vSiteDic) {
        ElectronicSiteInfo *vEleInfo = [[ElectronicSiteInfo alloc] init];
        vEleInfo.routesType = self.routesType;
        vEleInfo.dayname = [_dayDataDic objectForKey:@"name"];
        IFISNIL(vEleInfo.dayname);
        vEleInfo.realDate = [_dayDataDic objectForKey:@"realDate"];
        IFISNIL(vEleInfo.realDate);
        vEleInfo.detailFilePath = [_dayDataDic objectForKey:UNZIPFILEPATHKEY];
        IFISNIL(vEleInfo.detailFilePath);
        vEleInfo.activityId = [_dayDataDic objectForKey:@"activityId"];
        
        IFISNILFORNUMBER(vEleInfo.activityId);
        vEleInfo.siteId = [vDic objectForKey:@"siteId"];
        IFISNIL(vEleInfo.siteId);
        vEleInfo.name = [vDic objectForKey:@"name"];
        IFISNIL(vEleInfo.name);
        vEleInfo.roadBookType= [vDic objectForKey:@"roadBookType"];
        IFISNIL(vEleInfo.roadBookType);
        vEleInfo.siteNo = [vDic objectForKey:@"siteNo"];
        IFISNIL(vEleInfo.siteNo);
        vEleInfo.markType = [vDic objectForKey:@"markType"];
        IFISNIL(vEleInfo.markType);
        vEleInfo.arrivalTime = [vDic objectForKey:@"arrivalTime"];
        IFISNIL(vEleInfo.arrivalTime);
        vEleInfo.gatherTime = [vDic objectForKey:@"gatherTime"];
        IFISNIL(vEleInfo.gatherTime);
        vEleInfo.stayTime = [vDic objectForKey:@"stayTime"];
        IFISNIL(vEleInfo.stayTime);
        vEleInfo.backgroundImageUrl = [vDic objectForKey:@"backgroundImageUrl"];
        IFISNIL(vEleInfo.backgroundImageUrl);
        vEleInfo.description = [vDic objectForKey:@"description"];
        IFISNIL(vEleInfo.description);
        vEleInfo.latitude = [vDic objectForKey:@"latitude"];
        IFISNILFORNUMBER(vEleInfo.latitude);
        vEleInfo.longitude = [vDic objectForKey:@"longitude"];
        IFISNILFORNUMBER(vEleInfo.longitude);
        vEleInfo.viewpointLevel = [vDic objectForKey:@"viewpointLevel"];
        IFISNIL(vEleInfo.viewpointLevel);
        
        //寻找最接近当天得行程列表,同时满足路书是活动路书时
        if (mNearByToDayIndex == Nil && self.routesType == atActiveRoutes) {
            NSDate *vDate = [dateFormatter dateFromString:vEleInfo.gatherTime];
            NSDate *vEarlyDate = [vDate laterDate:[NSDate date]];
            if ([vEarlyDate isEqualToDate:vDate]) {
                mNearByToDayIndex = [NSNumber numberWithInt:vSiteCount];
            }
        }
        [vDayInfoArray addObject:vEleInfo];
        SAFE_ARC_RELEASE(vEleInfo);
        vSiteCount++;
    }
    
    self.routesInfoArray = vDayInfoArray;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ElectronicSiteInfo *vInfo = [_routesInfoArray objectAtIndex:indexPath.row];
    if (vInfo.backgroundImageUrl.length > 0) {
        ElectronicTitleCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"ElectronicCell" owner:self options:nil] objectAtIndex:0];
        return vCell.frame.size.height;
    }else{
        ElectronicTitleCell *vTitleCell = [[[NSBundle mainBundle] loadNibNamed:@"ElectronicTitleCell" owner:self options:nil] objectAtIndex:0];
        return vTitleCell.frame.size.height;
    }

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger vRowCount = _routesInfoArray.count;
    return vRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ElectronicSiteInfo *vInfo = [_routesInfoArray objectAtIndex:indexPath.row];
    if (vInfo.backgroundImageUrl.length > 0) {
        static NSString *CellIdentifier = @"normalCell";
        ElectronicCell *vCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (vCell == nil) {
            vCell = [[[NSBundle mainBundle] loadNibNamed:@"ElectronicCell" owner:self options:nil] objectAtIndex:0];
            SAFE_ARC_AUTORELEASE(vCell);
        }
        [vCell setCell:vInfo];
        return vCell;
    }else{
        static NSString *CellIdentifier = @"titleCell";
        ElectronicTitleCell *vCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (vCell == nil) {
            vCell = [[[NSBundle mainBundle] loadNibNamed:@"ElectronicTitleCell" owner:self options:nil] objectAtIndex:0];
            SAFE_ARC_AUTORELEASE(vCell);
        }
        [vCell setCell:vInfo];
        return vCell;
    }
    return nil;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ElectronicSiteInfo *vEInfo = [_routesInfoArray objectAtIndex:indexPath.row];
    [ViewControllerManager createViewController:@"ScenicDetailVC"];
    ScenicDetailVC *vScenVC = (ScenicDetailVC *)[ViewControllerManager getBaseViewController:@"ScenicDetailVC"];
    vScenVC.delegate = (ElectronicRouteBookVC *)[ViewControllerManager getBaseViewController:@"ElectronicRouteBookVC"];
    vScenVC.electronicInfo = vEInfo;
    [ViewControllerManager showBaseViewController:@"ScenicDetailVC" AnimationType:vaDefaultAnimation SubType:0];
}
 



- (void)viewDidUnload {
[self setFirstRowContentView:nil];
[super viewDidUnload];
}
@end
