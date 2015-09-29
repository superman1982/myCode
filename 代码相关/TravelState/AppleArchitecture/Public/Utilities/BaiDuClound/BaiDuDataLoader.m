//
//  QCMRDataLoader.m
//  兴途邦
//
//  Created by apple on 13-5-22.
//  Copyright (c) 2013年 xingde. All rights reserved.
//

#import "BaiDuDataLoader.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "ShangJiaInfo.h"
#import "NetManager.h"
#import "ActivityRouteManeger.h"
#import "UserManager.h"

@implementation BaiDuDataLoader

@synthesize delegate;


-(void) searchBusiness: (SearchType) aSearchType
            BaiDuParemeter:(struct BaiDuCould)aBaiDu
              SortFlag: (SortType) aSortFlag
          BusinessName: (NSString *) aBusinessName {
    
    NSString *vBusinessName = @"";
    // 如果是模糊搜索的话，q是不能有值
    if (aBusinessName != nil && aSearchType == stMuFu) {
        vBusinessName = aBusinessName;
    }
    // 百度地图的表ID
    NSString *aGetabeID = [[TerminalData instanceTerminalData].applicationInitDic objectForKey:@"geotableId"];
    // 拼接URL
    NSMutableString *vURLStr = [[NSMutableString alloc] initWithString: @""];
    [vURLStr appendFormat: @"%@nearby?q=%@&ak=%@&geotable_id=%@", BAIDUCLOUNDURL, vBusinessName, BAIDUAK, aGetabeID];
    NSString *vFilterStr = @"filter=wash_cosmetology:1,1|";
    int vBeginStar = aBaiDu.bdBeginStar;
    // 如果是模糊搜索的话，排序只能是按认证排序
    mSearchBunessType = aSearchType;
    switch (aSearchType) {
        case stWash_Consmetology:
            vFilterStr = @"filter=wash:1,1|";
            break;
        case stMaintenance:
            vFilterStr = @"filter=maintenance:1,1|";
            break;
        case stRefit:
            vFilterStr = @"filter=Refit:1,1|";
            break;
        case stChauffeur_Drive:
            vFilterStr = @"filter=chauffeur_drive:1,1|";
            break;
        case stMuFu:
            vFilterStr = @"filter=";
            vBeginStar = 1;
            break;
        case stViewPoint:
            vFilterStr = @"filter=viewpoint:1,1|";
            break;
        case stFood:
            vFilterStr = @"filter=food:1,1|";
            break;
        case stHotel:
            vFilterStr = @"filter=hotel:1,1|";
            break;
        case stCasula:
            vFilterStr = @"filter=casual:1,1|";
            break;
        case stLive:
            vFilterStr = @"filter=live:1,1|";
            break;
        case stOther:
            vFilterStr = @"filter=other:1,1|";
            break;
        default:
            vFilterStr = @"filter= 没有该项";
            break;
    }
    [vURLStr appendFormat: @"&%@isauthenticate:0,1|stars:%i,5", vFilterStr, vBeginStar];
    
    NSString *vSortStr = @"isauthenticate";
    NSInteger vDistance = [[[TerminalData instanceTerminalData].applicationInitDic objectForKey:@"mapRadius"] intValue];
    mSortType = aSortFlag;
    // 如果是模糊搜索的话，排序只能是按认证排序
    if (aSearchType != stMuFu) {
        switch (aSortFlag) {
            case stDistance:
                 {
                     vSortStr = @"distance";
                     if (aBaiDu.bdDistance > 0) {
                         vDistance = aBaiDu.bdDistance;
                     }
                 }
                
                break;
            case stStar:
                mStarNumer = aBaiDu.bdBeginStar;
                vSortStr = @"stars";
                break;
            case stPrice:
            default:
                break;
        }
    }
    // 获取用户的当前坐标
    CLLocationCoordinate2D vUserLocation = [ActivityRouteManeger shareActivityManeger].userChosedBunessCoord;
    //如果是洗车，始终采用用户位置
    if (mSearchBunessType == stWash_Consmetology||
        mSearchBunessType ==stGasstation||
        mSearchBunessType == stStopstation) {
         vUserLocation = [UserManager instanceUserManager].userCoord;
    }
    [vURLStr appendFormat: @"&sortby=%@:1&location=%f,%f", vSortStr,vUserLocation.longitude, vUserLocation.latitude];
    [vURLStr appendFormat: @"&radius=%i&page_index=%i&page_size=%i&scope=2", vDistance, aBaiDu.bdPageIndex, aBaiDu.bdPageSize];
    
    // URL地址进行编码处理，因为里面有可能有中文可是其它字符
    NSString *vURLEncoder = [vURLStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    SAFE_ARC_RELEASE(vURLStr);
    LOG(@"URLEncoder:%@", vURLEncoder);
    // 根据上面的URL创建一个请求
    
    [self begainLoading:vURLEncoder];
}


-(void)begainLoading:(NSString *)aURLStr{
    //开始连接百度云
    if ([delegate respondsToSelector:@selector(begainLoadBaiduCloundData:)]) {
        [delegate begainLoadBaiduCloundData:nil];
    }
    
    [NetManager getURLDataFromWeb:aURLStr Parameter:nil Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSMutableArray *vBuinessArray = [vReturnDic objectForKey:@"contents"];
//        LOG(@"百度云获取到得商家：%@",vBuinessArray);
        [self dealWithBunessData:vBuinessArray];
    } Failure:^(NSURLResponse *response, NSError *error) {
        if ([delegate respondsToSelector:@selector(LoadBaiduCloundDataFailure:)]) {
            [delegate LoadBaiduCloundDataFailure:error];
        }
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }RequestName:@"请求百度云" Notice:@""];

}

-(void)dealWithBunessData:(NSMutableArray *)aArray{
    NSMutableArray *vArray = [self getShangJiaInfo:aArray];
    //返回数据到需要的地方
    if (vArray.count > 0) {
        if ([delegate respondsToSelector:@selector(LoadBaiduCloundDataFinished:)]) {
            [delegate LoadBaiduCloundDataFinished:vArray];
        }
    }else{
    
        if ([delegate respondsToSelector:@selector(LoadBaiduCloundWithNoDataExist:)]) {
            [delegate LoadBaiduCloundWithNoDataExist:vArray];
        }
    }
    
    if (mSortType != stStar || mStarNumer < 1) { //当进行非星级搜索或者星级数小于1时都要进行百度搜索
        [self searchBaiDuMapBuenessInfo]; //查询百度数据
    } else {
        if ([delegate respondsToSelector:@selector(LoadBaiDuSearchFailer:)]) {
            [delegate LoadBaiDuSearchFailer:nil];
        }
    }
}


-(NSMutableArray *)getShangJiaInfo:(id)aData
{
    if (mShangJiaDic == nil) {
        mShangJiaDic = [[NSMutableDictionary alloc] init];
    }
    NSMutableArray *vArray = [NSMutableArray array];
    for (NSDictionary *dic in aData) {
        ShangJiaInfo *vShangJai = [[ShangJiaInfo alloc] init];
        vShangJai.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"] ];
        vShangJai.address = [NSString stringWithFormat:@"%@",[dic objectForKey:@"address"]];
        vShangJai.phone = [NSString stringWithFormat:@"%@", [dic objectForKey:@"phone"]];
        vShangJai.photo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"photo"]];
        vShangJai.isauthenticate = [[dic objectForKey:@"isauthenticate"] integerValue];
        vShangJai.stars = [[dic objectForKey:@"stars"] integerValue];
        vShangJai.distance = [[dic objectForKey:@"distance"] integerValue];
        
        NSArray *lArray = [dic objectForKey:@"location"];
        CLLocationCoordinate2D v2d =  CLLocationCoordinate2DMake([[lArray objectAtIndex:1] floatValue], [[lArray objectAtIndex:0] floatValue]);
        vShangJai.pt = v2d;
        
        vShangJai.bunessId = [dic objectForKey:@"business_id"];
        IFISNIL(vShangJai.bunessId);
        vShangJai.type = [[dic objectForKey:@"chauffeur_drive"] intValue];
        vShangJai.userid = [[dic objectForKey:@"uid"] intValue];
        [mShangJiaDic setObject:@"hasInfo" forKey:vShangJai.name]; //保存商家名,供重复检测
        [vArray addObject: vShangJai];
        SAFE_ARC_RELEASE(vShangJai);
    }
    
    return vArray;
}

//拼接百度搜索URL
-(void)searchBaiDuMapBuenessInfo
{
    if (myPt.longitude <= 0) {
        myPt = [ActivityRouteManeger shareActivityManeger].userChosedBunessCoord;
    }
    //如果是洗车，始终采用用户位置
    if (mSearchBunessType == stWash_Consmetology ||
        mSearchBunessType ==stGasstation||
        mSearchBunessType == stStopstation
        ) {
        myPt = [UserManager instanceUserManager].userCoord;
    }
    NSString *vType = @"";
    switch (mSearchBunessType) {
        case stWash_Consmetology:
            vType = @"洗车";
            break;
        case stMaintenance:
            vType = @"修车";
            break;
        case stRefit:
            vType = @"改装";
            break;
        case stChauffeur_Drive:
            vType = @"代驾";
            break;
        case stMuFu:
            break;
        case stTyre:
            vType = @"轮胎";
            break;
        case stAssist:
            vType = @"救援";
            break;
        case stGasstation:
            vType = @"加油站";
            break;
        case stStopstation:
            vType = @"停车场";
            break;
        default:
            break;
    }

    NSMutableString *vBaiDuSearchURLMutStr = [[NSMutableString alloc] initWithFormat:@""];
    [vBaiDuSearchURLMutStr appendFormat:@"%@ak=%@",BAIDUSEARCHURL,BAIDUAK];
    [vBaiDuSearchURLMutStr appendFormat:@"&output=json&query=%@",vType];
    [vBaiDuSearchURLMutStr appendFormat:@"&page_size=20&page_num=0"];
    [vBaiDuSearchURLMutStr appendFormat:@"&scope=2&location=%f,%f&radius=5000",myPt.latitude,myPt.longitude];
    [vBaiDuSearchURLMutStr appendFormat:@"&filter=sort_name:distance|distance:0"];

    NSString *vBaiDuSearchURLStr = [vBaiDuSearchURLMutStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    LOG(@"非认证URL:%@",vBaiDuSearchURLStr);
    SAFE_ARC_RELEASE(vBaiDuSearchURLMutStr);
    [self loadBuinessData:vBaiDuSearchURLStr];
}

//百度搜索数据
-(void)loadBuinessData:(NSString *)aURLStr{
    
    [NetManager getURLDataFromWeb:aURLStr Parameter:nil Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vBuenessDic = [vReturnDic objectForKey:@"results"];
        [self analyzeData:vBuenessDic];
    } Failure:^(NSURLResponse *response, NSError *error) {
        if ([delegate respondsToSelector:@selector(LoadBaiDuSearchFailer:)]) {
            [delegate LoadBaiDuSearchFailer:error];
        }
    } RequestName:@"请求百度搜索" Notice:@""];
}

//将百度搜索数据取出
-(void) analyzeData:(NSDictionary *) aData {
    NSMutableArray *vBaiduSearchArray = [NSMutableArray array];
    for (NSDictionary *dic in aData) {
        
        NSString *shangJiaName = [dic objectForKey:@"name"];
        
        if ([mShangJiaDic objectForKey:shangJiaName] == nil ) {
            ShangJiaInfo *shangJiaData = [[ShangJiaInfo alloc] init];
            shangJiaData.name = shangJiaName;
            shangJiaData.address = [dic objectForKey:@"address"];
            shangJiaData.phone = [dic objectForKey:@"telephone"];
            NSDictionary *lDic = [dic objectForKey:@"detail_info"];
            
            shangJiaData.distance = [[lDic objectForKey:@"distance"] integerValue];
            lDic = [dic objectForKey:@"location"];
            double latitude = [[lDic objectForKey:@"lat"] doubleValue];
            double longtude = [[lDic objectForKey:@"lng"] doubleValue];
            shangJiaData.pt= CLLocationCoordinate2DMake(latitude, longtude);
            
            [vBaiduSearchArray addObject:shangJiaData];
            SAFE_ARC_RELEASE(shangJiaData);
        }
    }
    
    if ([delegate respondsToSelector:@selector(LoadBaiDuSearchFinish:)]) {
        [delegate LoadBaiDuSearchFinish:vBaiduSearchArray];
    }
}


-(void)sortData:(NSMutableArray *)aData
{
    NSMutableArray *vSortData = aData;
    NSMutableArray *vAnthenticateArray = [NSMutableArray array];
    NSMutableArray *vNoAnthenticateArray = [NSMutableArray array];
    //将非认证和认证的分开
    for (NSDictionary *dic in vSortData) {
        if ([[dic objectForKey:@"isauthenticate"] intValue]) {
                
            [vAnthenticateArray addObject:dic];
        }else{
            [vNoAnthenticateArray addObject:dic];
        }
            
    }
    
     if (mSortType == stDistance ) {            
        [self bubbleSortWithArray:vAnthenticateArray sortKey:@"distance" IsPositiveSequence:YES];
        [self bubbleSortWithArray:vNoAnthenticateArray sortKey:@"distance" IsPositiveSequence:YES];            
    }else if(mSortType == stStar){            
        [self bubbleSortWithArray:vAnthenticateArray sortKey:@"stars" IsPositiveSequence:NO];
        [self bubbleSortWithArray:vNoAnthenticateArray sortKey:@"stars" IsPositiveSequence:NO];
    }
        
    [vSortData removeAllObjects];
    [vSortData addObjectsFromArray:vAnthenticateArray];
    [vSortData addObjectsFromArray:vNoAnthenticateArray];
        
}

-(void)bubbleSortWithArray:(NSMutableArray *)aData sortKey:(NSString *)aKey IsPositiveSequence:(BOOL)aPositive
{
    BOOL vIsPositive = aPositive;
    if (!vIsPositive) {  //如果是综合排序，则星级从高到低排
        for (int i = 0; i< aData.count; i++) { //对服务类型进行排序。星级从大到小            
            for (int j = aData.count-1; j >= i; j--) {                
                if ([[[aData objectAtIndex:j] objectForKey:aKey] intValue] > [[[aData objectAtIndex:i] objectForKey:aKey] intValue]) {                    
                    id temp = [aData objectAtIndex:j];
                    [aData replaceObjectAtIndex:j withObject:[aData objectAtIndex:i]];
                    [aData replaceObjectAtIndex:i withObject:temp];
                }
            }
        }
    } else {
        for (int i = 0; i< aData.count; i++) { //对服务类型进行排序。距离从小到大            
            for (int j = aData.count-1; j >= i; j--) {                
                if ([[[aData objectAtIndex:j] objectForKey:aKey] intValue] < [[[aData objectAtIndex:i] objectForKey:aKey] intValue]) {
                    id temp = [aData objectAtIndex:j];
                    [aData replaceObjectAtIndex:j withObject:[aData objectAtIndex:i]];
                    [aData replaceObjectAtIndex:i withObject:temp];
                }
            }
        }
    }
}

#pragma mark 计算两坐标间的距离
+ (float )distanceFromLocation:(CLLocationCoordinate2D)aStartCoord
                   ToLocation:(CLLocationCoordinate2D)aEndCoord{
    CLLocation *vStartLocation = [[CLLocation alloc] initWithLatitude:aStartCoord.latitude longitude:aStartCoord.longitude];
    CLLocation *vEndLocation = [[CLLocation alloc] initWithLatitude:aEndCoord.latitude longitude:aEndCoord.longitude];
    float vDistance = [vStartLocation distanceFromLocation:vEndLocation];
    SAFE_ARC_RELEASE(vStartLocation);
    SAFE_ARC_RELEASE(vEndLocation);
    return vDistance;
}

#if __has_feature(objc_arc)
#else
-(void)dealloc
{
    [mShangJiaDic removeAllObjects],mShangJiaDic = nil;
    [super dealloc];
}
#endif
@end
