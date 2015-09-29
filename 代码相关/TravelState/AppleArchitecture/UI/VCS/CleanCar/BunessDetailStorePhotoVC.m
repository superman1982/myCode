//
//  BunessDetailStorePhotoVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "BunessDetailStorePhotoVC.h"
#import "NetManager.h"
#import "ImageViewHelper.h"
#import "PhotoBrowserVC.h"
#import "PhtotoInfo.h"

@interface BunessDetailStorePhotoVC ()
{
    NSInteger mPageIndex;
    NSInteger mPageSize;
    BOOL      mIsInitWebData;
}
@property (nonatomic,retain) NSMutableArray *bunessPhotosArray;
@end

@implementation BunessDetailStorePhotoVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"BunessDetailStorePhotoVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"BunessDetailStorePhotoVC" bundle:aBuddle];
    }
    if (self != nil) {
        [self initCommonData];
    }
    return self;
}

//主要用来方向改变后重新改变布局
- (void) setLayout: (BOOL) aPortait {
    [super setLayout: aPortait];
    [self setViewFrame:aPortait];
}

//重载导航条
-(void)initTopNavBar{
    [super initTopNavBar];
    self.title = @"商家相册";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

//初始化数据
-(void)initCommonData{
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_bunessPhotosArray removeAllObjects];
    [_bunessPhotosArray release];
    [super dealloc];
}
#endif

// 初始View
- (void) initView: (BOOL) aPortait {
    [self initWebData];
  /*  //kktest
    self.bunessPhotosArray = @[ @"http://118.123.249.138:7001/2013114/be6f6889-594f-400f-ac86-17c7bfb81d10.jpg",
                                @"http://118.123.249.138:7001/2013114/6688ad3d-a853-4515-911e-9660ffc8eef4.jpg",
                                @"http://118.123.249.138:7001/2013114/801c7c02-e7fc-4c3c-98b7-0eead1597189.jpg",
                                @"http://118.123.249.138:7001/2013114/bca9d6e2-2f56-451e-8b20-146c3d5d67f6.jpg",
                                @"http://118.123.249.138:7001/2013114/25b134d9-a833-431b-aa00-50363414a02f.jpg",
                                @"http://118.123.249.138:7001/201399/0c715780-6352-48ce-8fa3-28886c21c78f.jpg",
                                @"http://118.123.249.138:7001/201399/0c715780-6352-48ce-8fa3-28886c21c78f.jpg",
                                @"http://118.123.249.138:7001/201399/0c715780-6352-48ce-8fa3-28886c21c78f.jpg",
                                @"http://118.123.249.138:7001/201399/0c715780-6352-48ce-8fa3-28886c21c78f.jpg"
                                ];*/
}

//设置View方向
-(void) setViewFrame:(BOOL)aPortait{
    if (aPortait) {
    }else{
    }
}

//------------------------------------------------
-(void)setBunessPhotosArray:(NSMutableArray *)bunessPhotosArray{
    if (_bunessPhotosArray == Nil) {
        _bunessPhotosArray = [[NSMutableArray alloc] init];
    }
    if (mIsInitWebData) {
        [_bunessPhotosArray removeAllObjects];
    }
    [_bunessPhotosArray addObjectsFromArray:bunessPhotosArray];
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource -----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bunessPhotosArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"tuPianCell";
    DianPuTuPianCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DianPuTuPianCell" owner:self options:nil] objectAtIndex:0];
        cell.delegate = self;
    }
    
    NSInteger vImageOneIndex = indexPath.row*4;
    NSInteger vImageTwoIndex = indexPath.row*4 + 1;
    NSInteger vImageThreeIndex = indexPath.row*4 + 2;
    NSInteger vImageForIndex = indexPath.row *4 +3;
    
    cell.button1.tag = vImageOneIndex;
    cell.button2.tag = vImageTwoIndex;
    cell.button3.tag = vImageThreeIndex;
    cell.button4.tag = vImageForIndex;
    
     NSString *vImageOneURLStr = @"";
    NSString *vImageTwoURLStr = @"";
    NSString *vImageThreeURLStr = @"";
    NSString *vImageForURLStr = @"";
    if ((self.bunessPhotosArray.count > vImageOneIndex)) {
        PhtotoInfo *vInfo = [self.bunessPhotosArray objectAtIndex:vImageOneIndex];
        vImageOneURLStr = vInfo.phtotURLStr;
        cell.button1.hidden = NO;
        [cell.imageView1 setImageWithURL:[NSURL URLWithString:vImageOneURLStr ] PlaceHolder:[UIImage imageNamed:@"lvtubang.png"]];
    }
    if ((self.bunessPhotosArray.count > vImageTwoIndex)) {
        PhtotoInfo *vInfo = [self.bunessPhotosArray objectAtIndex:vImageTwoIndex];
        vImageTwoURLStr =vInfo.phtotURLStr;
        cell.button2.hidden = NO;
        [cell.imageView2 setImageWithURL:[NSURL URLWithString:vImageTwoURLStr]PlaceHolder:[UIImage imageNamed:@"lvtubang.png"]];
    }
    
    if ((self.bunessPhotosArray.count > vImageThreeIndex)) {
        PhtotoInfo *vInfo = [self.bunessPhotosArray objectAtIndex:vImageThreeIndex];
        vImageThreeURLStr = vInfo.phtotURLStr;
        cell.button3.hidden = NO;
        [cell.imageView3 setImageWithURL:[NSURL URLWithString:vImageThreeURLStr] PlaceHolder:[UIImage imageNamed:@"lvtubang.png"]];
    }

    if ((self.bunessPhotosArray.count > vImageForIndex)) {
        PhtotoInfo *vInfo = [self.bunessPhotosArray objectAtIndex:vImageForIndex];
        vImageForURLStr =  vInfo.phtotURLStr;
        cell.button4.hidden = NO;
        [cell.iamgeView4 setImageWithURL:[NSURL URLWithString:vImageForURLStr] PlaceHolder:[UIImage imageNamed:@"lvtubang.png"]];
    }
    
    return cell;
}

#pragma mark - 其他辅助功能
-(void)initWebData{
    mPageSize = 14;
    mPageIndex = 0;
    mIsInitWebData = YES;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:self.shangJiaInfo.bunessId ,@"businessId",   [NSNumber numberWithInt:mPageIndex],@"pageIndex",
        [NSNumber numberWithInt:mPageSize],@"pageSize",
                                nil];
   [self postWebData:vParemeter];
}

-(void)downLoadWebData{
    mPageIndex++;
    mIsInitWebData = NO;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:self.shangJiaInfo.bunessId,@"businessId",   [NSNumber numberWithInt:mPageIndex],@"pageIndex",
        [NSNumber numberWithInt:mPageSize],@"pageSize",
                                nil];
    [self postWebData:vParemeter];
}

-(void)postWebData:(NSDictionary *)aParemeter{
    [NetManager postDataFromWebAsynchronous:APPURL903 Paremeter:aParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vPhotosArray = [NSMutableArray array];
        if (vDataDic.count > 0) {
            NSDictionary *vPhotosDic = [vDataDic objectForKey:@"photos"];
            for (NSString *vImageURLStr in vPhotosDic) {
                PhtotoInfo *vInfo = [[PhtotoInfo alloc] init];
                vInfo.phtotURLStr = vImageURLStr;
                vInfo.photoType = ptBuness;
                [vPhotosArray addObject:vInfo];
                SAFE_ARC_RELEASE(vInfo);
            }
        }
        self.bunessPhotosArray = vPhotosArray;
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"请求商家相册" Notice:@""];
}

#pragma mark - 其他业务点击事件
-(void)tuPianChosed:(NSInteger)pIndex{
    LOG(@"点击第%d张图片",pIndex);

    [ViewControllerManager createViewController:@"PhotoBrowserVC"];
    
    PhotoBrowserVC *vVC = (PhotoBrowserVC *)[ViewControllerManager getBaseViewController:@"PhotoBrowserVC"];
    vVC.samplePictures = self.bunessPhotosArray;
    [ViewControllerManager showBaseViewController:@"PhotoBrowserVC" AnimationType:vaDefaultAnimation SubType:0];
    [vVC moveToIndex:pIndex IsURLDataSource:YES];
    
}
@end
