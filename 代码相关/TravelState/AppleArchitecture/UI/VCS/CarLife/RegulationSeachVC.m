//
//  RegulationSeachVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-25.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "RegulationSeachVC.h"
#import "NetManager.h"
#import "UserManager.h"
#import "RegulationAddCarVC.h"

@interface RegulationSeachVC ()

@property (nonatomic,retain) NSMutableArray *myCarArray;
@end

@implementation RegulationSeachVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"RegulationSeachVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"RegulationSeachVC" bundle:aBuddle];
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
    self.title = @"违章查询";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
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

-(void)setMyCarArray:(NSMutableArray *)myCarArray{
    if (_myCarArray == Nil) {
        _myCarArray = [[NSMutableArray alloc] init];
    }
    [_myCarArray removeAllObjects];
    [_myCarArray addObjectsFromArray:myCarArray];
    [self.regulationTableView reloadData];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"选择查询车辆";
}

#pragma mark tableview headerview背景
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
    UILabel *vTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 320, 21)];
    vTitleLable.backgroundColor = [UIColor clearColor];
    [vTitleLable setFont:[UIFont systemFontOfSize:15]];
    vTitleLable.textColor = [UIColor darkGrayColor];
    
    if (section == 0) {
        vTitleLable.text = @"选择查询车辆";
        [headerView addSubview:vTitleLable];
    }
    SAFE_ARC_AUTORELEASE(vTitleLable);
    SAFE_ARC_AUTORELEASE(headerView);
    return headerView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.myCarArray.count == 0) {
        [tableView setFrame:CGRectMake(0, 0, 320, 44+35)];
        return 1;
    }else{
        [tableView setFrame:CGRectMake(0, 0, 320, 35 + 44 * self.myCarArray.count)];
        return self.myCarArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        vCell.textLabel.font = [UIFont systemFontOfSize:14];
        vCell.textLabel.textColor = [UIColor darkGrayColor];
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    /*"userId": "String:用户id",
     }
     服务器应答:
     {
     "commandCode": "int:命令码",
     "stateCode": "int:0、成功；其他、错误",
     "stateMessage": "String:成功、失败、错误的描述",
     "data":
     [
     {
     "carId": "int:车辆Id",
     "carNumber": "String:车牌号码",
     "isDefault": "int:1、为默认车辆"
     },
     …
     ]
     }
*/
    if (self.myCarArray.count == 0) {
        vCell.textLabel.font = [UIFont systemFontOfSize:13];
         vCell.textLabel.text = @"您还没有注册车辆,请注册车辆后查询违章";
    }else{
        vCell.textLabel.text = [[self.myCarArray objectAtIndex:indexPath.row] objectForKey:@"carNumber"];
        IFISNIL(vCell.textLabel.text);
    }
    
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.myCarArray.count == 0) {
        [ViewControllerManager createViewController:@"AddCarAndCarInfo"];
        AddCarAndCarInfo *vAddCarVC = (AddCarAndCarInfo *)[ViewControllerManager getBaseViewController:@"AddCarAndCarInfo"];
        vAddCarVC.delegate  = self;
        vAddCarVC.isAddCar = YES;
        [ViewControllerManager showBaseViewController:@"AddCarAndCarInfo" AnimationType:vaDefaultAnimation SubType:0];
    }else {
        NSDictionary *vCarDic = [self.myCarArray objectAtIndex:indexPath.row];
        [ViewControllerManager createViewController:@"RegulationAddCarVC"];
        RegulationAddCarVC *vVC = (RegulationAddCarVC *)[ViewControllerManager getBaseViewController:@"RegulationAddCarVC"];
        vVC.carDic = vCarDic;
        [ViewControllerManager showBaseViewController:@"RegulationAddCarVC" AnimationType:vaDefaultAnimation SubType:0];
    }

}

#pragma mark  AddCarAndCarDelegate
#pragma mark 车辆添加完毕
-(void)didAddCarAndCarInfoFinished:(id)sender{
    [self initWebDataSuccess:Nil];
}

#pragma mark - 其他辅助功能
-(void)initWebDataSuccess:(void (^)(NSURLResponse *response,id responseObject))aSuccess{
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
        //获取成功后需要做一些事
        if (aSuccess) {
            aSuccess(response,responseObject);
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"查看我的爱车" Notice:@""];
}

@end
