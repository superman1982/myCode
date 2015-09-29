//
//  MyCarVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-14.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "MyCarVC.h"
#import "AddCarAndCarInfo.h"
#import "NetManager.h"
#import "UserManager.h"

@interface MyCarVC ()

@end

@implementation MyCarVC
//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"MyCarVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"MyCarVC" bundle:aBuddle];
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
    self.title = @"我的爱车";
//    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [vRightButton setTitle:@"编辑" forState:UIControlStateNormal];
//    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
//    [vRightButton addTarget:self action:@selector(editCarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
//    self.navigationItem.rightBarButtonItem = vBarButtonItem;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    [self initWebDataComplete:nil];
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_myCarTableView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
}

//设置View方向
-(void) setViewFrame:(BOOL)aPortait{
    if (aPortait) {
        if (IS_IPHONE_5) {
        }else{
        }
    }else{
    }
}

#pragma mark 内存处理
- (void)viewShouldUnLoad{
    [super viewShouldUnLoad];
}
//----------
- (void)viewDidUnload {

    [self setMyCarTableView:nil];
    [super viewDidUnload];
}

-(void)setMyCarArray:(NSMutableArray *)myCarArray{
    if (_myCarArray == Nil) {
        _myCarArray = [[NSMutableArray alloc] init];
    }
    [_myCarArray removeAllObjects];
    [_myCarArray addObjectsFromArray:myCarArray];
    [self.myCarTableView reloadData];
}



#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger mRowCount = self.myCarArray.count;
    tableView.frame = CGRectMake(0, 0, 320, 44 *mRowCount + 44 + 10);
    if (tableView.frame.size.height > self.view.frame.size.height - 54) {
        tableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 54);
    }
    if (section == 0) {
        return mRowCount;
    }else if(section == 1){
        return 1;
    }
    return 0;
}

#pragma mark table背景颜色
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
    SAFE_ARC_AUTORELEASE(headerView);
    return headerView;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *vCarDic = [self.myCarArray objectAtIndex:row];
        [self deleteCar:vCarDic IndexPath:indexPath];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        vCell.textLabel.font = [UIFont systemFontOfSize:15];
        vCell.textLabel.textColor = [UIColor darkGrayColor];
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        vCell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        //设置图片
        UIImageView *vCellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 14, 15, 15)];
        vCellImageView.tag = 100;
        vCellImageView.hidden = YES;
        vCellImageView.image = [UIImage imageNamed:@"carDetail_star_btn"];
        [vCellImageView setBackgroundColor:[UIColor clearColor]];
        [vCell.contentView addSubview:vCellImageView];
        SAFE_ARC_RELEASE(vCellImageView);
        
    }
    if (indexPath.section == 0) {
        NSDictionary *vDic = [self.myCarArray objectAtIndex:indexPath.row];
        NSString *vCarLisence = [vDic objectForKey:@"carNumber"];
        IFISNIL(vCarLisence);
        vCell.textLabel.text = vCarLisence;
        UIImageView *vImageView = (UIImageView *)[vCell.contentView viewWithTag:100];
        if ([[vDic objectForKey:@"isDefault"] intValue] == 1) {
            vImageView.hidden = NO;
        }else{
            vImageView.hidden = YES;
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            vCell.textLabel.text = @"添加爱车";
        }
    }
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [ViewControllerManager createViewController:@"AddCarAndCarInfo"];
            AddCarAndCarInfo *vAddCarInfo = (AddCarAndCarInfo *)[ViewControllerManager getBaseViewController:@"AddCarAndCarInfo"];
            vAddCarInfo.isAddCar = YES;
            vAddCarInfo.delegate = self;
            [ViewControllerManager showBaseViewController:@"AddCarAndCarInfo" AnimationType:vaDefaultAnimation SubType:0];
        }
    }else{
        NSDictionary *vCarNumberDic = [self.myCarArray objectAtIndex:indexPath.row];
        id carId = [vCarNumberDic objectForKey:@"carId"];
        [self getCarDetail:carId Complete:^(NSMutableDictionary *responseObject) {
            [ViewControllerManager createViewController:@"AddCarAndCarInfo"];
            AddCarAndCarInfo *vAddCarInfo = (AddCarAndCarInfo *)[ViewControllerManager getBaseViewController:@"AddCarAndCarInfo"];
            vAddCarInfo.isAddCar = NO;
            vAddCarInfo.carDic = responseObject;
            vAddCarInfo.delegate =self;
            [ViewControllerManager showBaseViewController:@"AddCarAndCarInfo" AnimationType:vaDefaultAnimation SubType:0];
        }];
    }

}

#pragma mark - 其他辅助功能
-(void)initWebDataComplete:(void (^)(id responseObject))aComPlete{
    id vUserID = [UserManager instanceUserManager].userID;
    IFISNIL(vUserID);
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:vUserID,@"userId",nil];
    [NetManager postDataFromWebAsynchronous:APPURL816 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vCarArray = [NSMutableArray array];
        for (NSDictionary *vDic in vDataDic) {
            [vCarArray addObject:vDic];
        }
        self.myCarArray = vCarArray;
        if (aComPlete) {
            aComPlete(vCarArray);
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"查看我的爱车" Notice:@""];
}

#pragma mark - 爱车详情
-(void)getCarDetail:(id )aCarId Complete:(void (^)(id responseObject))aComPlete{
    id userId = [UserManager instanceUserManager].userID;
    
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                aCarId,@"carId",
                                userId,@"userId",
                                nil];
    [NetManager postDataFromWebAsynchronous:APPURL817 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSMutableDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        if (vDataDic.count > 0) {
            if (aComPlete) {
                aComPlete(vDataDic);
            }
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"获取爱车详情" Notice:@""];
}

#pragma mark 删除爱车
-(void)deleteCar:(NSDictionary *)aDic IndexPath:(NSIndexPath *)aPath{
    
    id carId = [aDic objectForKey:@"carId"];
    id userId = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                userId,@"userId",
                                carId,@"carId",
                                nil];
    [NetManager postDataFromWebAsynchronous:APPURL820 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSNumber *vStateNumber = [vReturnDic objectForKey:@"stateCode"];
        if (vStateNumber != Nil) {
            if ([vStateNumber intValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                [self.myCarArray removeObject:aDic];
                [self.myCarTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:aPath]
                                               withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"删除爱车" Notice:@""];

}

#pragma mark - 其他业务点击事件
#pragma mark AddCarAndCarInfoDelegate
-(void)didAddCarAndCarInfoFinished:(id)sender{
    [self initWebDataComplete:nil];
}

#pragma mark  点击编辑 车辆列表的编辑状态
-(void)editCarButtonClicked:(UIButton *)sender{
    if (!self.myCarTableView.editing == YES) {
        [self.myCarTableView setEditing:YES animated:YES];
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        [self.myCarTableView setEditing:NO animated:YES];
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

@end
