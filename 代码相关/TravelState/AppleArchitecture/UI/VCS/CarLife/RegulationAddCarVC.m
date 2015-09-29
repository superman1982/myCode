//
//  RegulationAddCarVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-25.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "RegulationAddCarVC.h"
#import "NetManager.h"
#import "UserManager.h"
#import "RegulationChoseProvince.h"
#import "StringHelper.h"
#import "RegulationSearchResultsVC.h"
#import "CheckManeger.h"

@interface RegulationAddCarVC ()
{
    NSDictionary *mCarTypeDic;
    NSDictionary *mPlaceDic;
    NSString *mNoticeStr;
}
@property (nonatomic,retain) UITextField *regulationPlaceField;
@property (nonatomic,retain) UITextField *regulationCarTypeField;
@property (nonatomic,retain) UITextField *regulationCarLisenceField;
@property (nonatomic,retain) UITextField *regulationCarDriveNumberFiled;
@property (nonatomic,retain) UITextField *regulationEnginNumberField;
@property (nonatomic,retain) UITextField *regulationGegisterBookNumberField;
@end

@implementation RegulationAddCarVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"RegulationAddCarVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"RegulationAddCarVC" bundle:aBuddle];
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
    self.title = @"添加违章信息";
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"查询" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vRightButton addTarget:self action:@selector(addCarFinishButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    mNoticeStr = @"提示：为了能准确查出您的违章信息，请注意以下信息的正确性!";
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
    [self initWebData];
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

-(UITextField *)regulationPlaceField{
    if (_regulationPlaceField == Nil) {
        _regulationPlaceField = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _regulationPlaceField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _regulationPlaceField.borderStyle = UITextBorderStyleNone;
        _regulationPlaceField.returnKeyType = UIReturnKeyDone;
        _regulationPlaceField.font = [UIFont systemFontOfSize:15];
        _regulationPlaceField.delegate = self;
        _regulationPlaceField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _regulationPlaceField.userInteractionEnabled = NO;
    }

    return _regulationPlaceField;
}

-(UITextField *)regulationCarTypeField{
    if (_regulationCarTypeField == Nil) {
        _regulationCarTypeField = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _regulationCarTypeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _regulationCarTypeField.borderStyle = UITextBorderStyleNone;
        _regulationCarTypeField.returnKeyType = UIReturnKeyDone;
        _regulationCarTypeField.font = [UIFont systemFontOfSize:15];
        _regulationCarTypeField.delegate = self;
        _regulationCarTypeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _regulationCarTypeField.userInteractionEnabled = NO;
    }

    return _regulationCarTypeField;
}

-(UITextField *)regulationCarLisenceField{
    if (_regulationCarLisenceField == Nil) {
        _regulationCarLisenceField = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _regulationCarLisenceField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _regulationCarLisenceField.borderStyle = UITextBorderStyleRoundedRect;
        _regulationCarLisenceField.returnKeyType = UIReturnKeyDone;
        _regulationCarLisenceField.font = [UIFont systemFontOfSize:15];
        _regulationCarLisenceField.delegate = self;
        _regulationCarLisenceField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }

    return _regulationCarLisenceField;
}

-(UITextField *)regulationCarDriveNumberFiled{
    if (_regulationCarDriveNumberFiled == Nil) {
        _regulationCarDriveNumberFiled = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _regulationCarDriveNumberFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _regulationCarDriveNumberFiled.borderStyle = UITextBorderStyleRoundedRect;
        _regulationCarDriveNumberFiled.returnKeyType = UIReturnKeyDone;
        _regulationCarDriveNumberFiled.font = [UIFont systemFontOfSize:15];
        _regulationCarDriveNumberFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _regulationCarDriveNumberFiled.delegate = self;
    }

    return _regulationCarDriveNumberFiled;
}

-(UITextField *)regulationEnginNumberField{
    if (_regulationEnginNumberField == Nil) {
        _regulationEnginNumberField = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _regulationEnginNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _regulationEnginNumberField.borderStyle = UITextBorderStyleRoundedRect;
        _regulationEnginNumberField.returnKeyType = UIReturnKeyDone;
        _regulationEnginNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _regulationEnginNumberField.font = [UIFont systemFontOfSize:15];
        _regulationEnginNumberField.delegate = self;
    }

    return _regulationEnginNumberField;
}

-(UITextField *)regulationGegisterBookNumberField{
    if (_regulationGegisterBookNumberField == Nil) {
        _regulationGegisterBookNumberField = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _regulationGegisterBookNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _regulationGegisterBookNumberField.borderStyle = UITextBorderStyleRoundedRect;
        _regulationGegisterBookNumberField.returnKeyType = UIReturnKeyDone;
        _regulationGegisterBookNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _regulationGegisterBookNumberField.font = [UIFont systemFontOfSize:15];
        _regulationGegisterBookNumberField.delegate = self;
    }

    return _regulationGegisterBookNumberField;
}


#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView          // Default is 1 if not implemented
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 60;
    }
    return 0;
}

#pragma mark tableview headerview背景
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
    if (section == 1){
        UILabel *vLable = [self getNoticeLable:mNoticeStr];
        [headerView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, vLable.frame.size.height + 15)];
        [headerView addSubview:vLable];
    }
    SAFE_ARC_AUTORELEASE(headerView);
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        vCell.textLabel.font = [UIFont systemFontOfSize:15];
        vCell.textLabel.textColor = [UIColor darkGrayColor];
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.accessoryType = UITableViewCellAccessoryNone;
        vCell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    if (indexPath.section == 0) {
        
        if (indexPath.row ==0) {
            vCell.textLabel.text = @"违章地点:";
            vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [vCell.contentView addSubview:self.regulationPlaceField];
        }else if (indexPath.row == 1){
            vCell.textLabel.text = @"车辆类型:";
            vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [vCell.contentView addSubview:self.regulationCarTypeField];
        }
        else if (indexPath.row == 2){
            vCell.textLabel.text = @"车 牌 号";
            [vCell.contentView addSubview:self.regulationCarLisenceField];
        }
    }else if(indexPath.section == 1){
        
        if (indexPath.row == 0){
            vCell.textLabel.text = @"车 架 号:";
            [vCell.contentView addSubview:self.regulationCarDriveNumberFiled];
        }
        else if (indexPath.row == 1){
            vCell.textLabel.text = @"发动机号:";
            [vCell.contentView addSubview:self.regulationEnginNumberField];
        }
        else if (indexPath.row == 2){
            vCell.textLabel.text = @"登记证书:";
            [vCell.contentView addSubview:self.regulationGegisterBookNumberField];
        }

    }
    
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self choseRegulationPlace];
        }else if(indexPath.row ==1){
            [self choseCarType];
        }
    }
}

#define CARENGINFILDHIGHT 70
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //转换View位置坐标，因为IOS7取消View自动伸缩时，View位置坐标与IOS5不相同
    CGRect frame = [textField convertRect:textField.frame toView:self.view.window];
    //计算TextField多出键盘的高度，以中文键盘为标准
    int offset = frame.origin.y + 32 - (mHeight + 20 - 216.0-36);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    isNeedToMoveFrame = NO;
    if(offset > 0){
        //移动后的View位置
        CGRect vViewFrame = self.view.frame;
        CGRect rect = CGRectMake(0.0f,vViewFrame.origin.y -offset ,vViewFrame.size.width,vViewFrame.size.height);
        if (!isShowChanese){
            //不是中文键盘时，向下多移动36个像素，
            rect.origin.y = rect.origin.y + 36;
            //设置isNeedToMoveFrame = YES，英文变中文键盘时移动;
            //根据本页面作特殊调整 调整像素为36-offset
            if(IS_IPHONE_5){
                if (textField == self.regulationEnginNumberField) {
                     rect.origin.y = rect.origin.y - 3;
                }
            }else{
                if (textField == self.regulationCarDriveNumberFiled ) {
                    rect.origin.y = rect.origin.y - 22;
                }
            }
            isNeedToMoveFrame = YES;
        }
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}

#pragma mark - 其他辅助功能
-(void)initWebData{
    
    id carId = [_carDic objectForKey:@"carId"];
    IFISNIL(carId);
    id userId = [UserManager instanceUserManager].userID;
    IFISNIL(userId);
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                carId,@"carId",
                                userId,@"userId",
                                nil];
    [NetManager postDataFromWebAsynchronous:APPURL817 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSMutableDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        if (vDataDic.count > 0) {
            [self reSetUI:vDataDic];
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"获取爱车详情" Notice:@""];
}

#pragma mark 自动填写有关信息
-(void)reSetUI:(NSDictionary *)aDic{
    self.regulationCarLisenceField.text = [aDic objectForKey:@"carNumber"];
    IFISNIL(self.regulationCarLisenceField.text);
    
    self.regulationCarDriveNumberFiled.text = [aDic objectForKey:@"frameNumber"];
    IFISNIL(self.regulationCarDriveNumberFiled.text);
    
    self.regulationEnginNumberField.text = [aDic objectForKey:@"engineNumber"];
    IFISNIL(self.regulationEnginNumberField.text);
    
    self.regulationGegisterBookNumberField.text = [aDic objectForKey:@"cerCode"];
    IFISNIL(self.regulationGegisterBookNumberField.text);
}

#pragma mark 违章提示
-(NSString *)noticeRegulation:(NSDictionary *)aPlaceDic{
    LOG(@"违章地区信息%@",aPlaceDic);
    NSMutableString *vNoticeStr = [[NSMutableString alloc] initWithString:@""];
    if ([[aPlaceDic objectForKey:@"engine"] intValue]==1) {
        NSString *vEngineNumberCount = [aPlaceDic objectForKey:@"engineno"];
        if ([vEngineNumberCount intValue] == 0) {
            [vNoticeStr appendString:@"填写全部引擎号   "];
        }else{
            [vNoticeStr appendString:[NSString stringWithFormat:@"填写后%@位引擎号   ",vEngineNumberCount]];
        }
    }
    
    if ([[aPlaceDic objectForKey:@"class"] intValue] == 1) {
        NSString *vClassnoCount = [aPlaceDic objectForKey:@"classno"];
        if ([vClassnoCount intValue] == 0) {
            [vNoticeStr appendString:@"填写全部车架号   "];
        }else{
            [vNoticeStr appendString:[NSString stringWithFormat:@"填写后%@位车架号   ",vClassnoCount]];
        }
    }
    
    if ([[aPlaceDic objectForKey:@"regist"] intValue] == 1) {
        NSString *vRegistnoAcount = [aPlaceDic objectForKey:@"registno"];
        if ([vRegistnoAcount intValue] == 0) {
            [vNoticeStr appendString:@"填写全部登记证号   "];
        }else{
            [vNoticeStr appendString:[NSString stringWithFormat:@"填写后%@位登记证号   ",vRegistnoAcount]];
        }
    }
    
    return vNoticeStr;
}

#pragma mark 获取提示自适应大小的Lable
-(UILabel *)getNoticeLable:(NSString *)aStr{
    UIFont *vFont = [UIFont systemFontOfSize:14];
    CGSize vLableSize = [StringHelper caluateStrLength:aStr Front:vFont ConstrainedSize:CGSizeMake(320, CGFLOAT_MAX)];
    UILabel *vLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 300, vLableSize.height)];
    [vLable setNumberOfLines:0];
    vLable.font = vFont;
    vLable.text = aStr;
    [vLable setBackgroundColor:[UIColor clearColor]];
    
    return vLable;
}

#pragma mark 获取违章查询URL
-(NSString *)getRegulationURLStrWithPlaceDic:(NSDictionary *)aPlaceDic
                            CarTypeDic:(NSDictionary *)aCarTypeDic
                CarLisence:(NSString *)aCarLisence
               EnginNumber:(NSString *)aEngin
                   ClassNo:(NSString *)aClassno
                  RegistNo:(NSString *)aRegistNo
{
    
    NSMutableString *regulationSearchURL = [[NSMutableString alloc] initWithString:APPURL923];
    [regulationSearchURL appendString:@"dtype=json"];
    [regulationSearchURL appendString:@"&"];
    [regulationSearchURL appendString:[NSString stringWithFormat:@"key=%@",JUHEKEY]];
    [regulationSearchURL appendString:@"&"];
    [regulationSearchURL appendString:[NSString stringWithFormat:@"city=%@",[aPlaceDic objectForKey:@"city_code"]]];
    [regulationSearchURL appendString:@"&"];
    [regulationSearchURL appendString:[NSString stringWithFormat:@"hphm=%@",aCarLisence]];
    [regulationSearchURL appendString:@"&"];
    [regulationSearchURL appendString:[NSString stringWithFormat:@"hpzl=%@",[aCarTypeDic objectForKey:@"id"]]];
    if ([[aPlaceDic objectForKey:@"engine"] intValue]==1) {
        [regulationSearchURL appendString:@"&"];
        [regulationSearchURL appendString:[NSString stringWithFormat:@"engineno=%@",aEngin]];
    }
    
    if ([[aPlaceDic objectForKey:@"class"] intValue] == 1) {
        [regulationSearchURL appendString:@"&"];
        [regulationSearchURL appendString:[NSString stringWithFormat:@"classno=%@",aClassno]];
    }
    
    if ([[aPlaceDic objectForKey:@"regist"] intValue] == 1) {
        [regulationSearchURL appendString:@"&"];
        [regulationSearchURL appendString:[NSString stringWithFormat:@"registno=%@",aRegistNo]];
    }
    
    NSString *vUTF8URLstr = [regulationSearchURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return vUTF8URLstr;
}

#pragma mark - 其他业务点击事件
#pragma mark 查询
-(void)addCarFinishButtonTouchDown:(id)sender{
    if (self.regulationPlaceField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择违章地点！"];
        return;
    }
    
    if (self.regulationCarTypeField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择车辆类型！"];
        return;
    }
    
    if (self.regulationCarLisenceField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写车牌号码！"];
        return;
    }
    
    if (![CheckManeger checkIfIsAllowedCarLisence:self.regulationCarLisenceField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的车牌号！"];
        return;
    }
    
    if ([[mPlaceDic objectForKey:@"engine"] intValue]==1) {
        if (self.regulationEnginNumberField.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写车辆引擎号！"];
            return;
        }
    }
    
    if ([[mPlaceDic objectForKey:@"class"] intValue] == 1) {
        if (self.regulationCarDriveNumberFiled.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写车架号！"];
            return;
        }

    }
    
    if ([[mPlaceDic objectForKey:@"regist"] intValue] == 1) {
        if (self.regulationGegisterBookNumberField.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写登记证号！"];
            return;
        }

    }
    
    //获取违章查询URL
    NSString *vURLStr = [self getRegulationURLStrWithPlaceDic:mPlaceDic CarTypeDic:mCarTypeDic CarLisence:self.regulationCarLisenceField.text EnginNumber:self.regulationEnginNumberField.text ClassNo:self.regulationCarDriveNumberFiled.text RegistNo:self.regulationGegisterBookNumberField.text];
    
    [NetManager getURLDataFromWeb:vURLStr Parameter:Nil Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"result"];
        NSDictionary *vListsDic = Nil;
        if (vDataDic.count > 0) {
            vListsDic = [vDataDic objectForKey:@"lists"];
            
            //有违章信息才显示违章结果
            if (vListsDic.count > 0) {
                [ViewControllerManager createViewController:@"RegulationSearchResultsVC"];
                RegulationSearchResultsVC *vVC = (RegulationSearchResultsVC *)[ViewControllerManager getBaseViewController:@"RegulationSearchResultsVC"];
                vVC.resultDic = vDataDic;
                [ViewControllerManager showBaseViewController:@"RegulationSearchResultsVC" AnimationType:vaDefaultAnimation SubType:0];
            }
        }
        
        //显示相关提示信息
        NSString *vReson = [vReturnDic objectForKey:@"reason"];
        NSString *resultcode = [vReturnDic objectForKey:@"resultcode"];
        //查询失败原因
        if ([resultcode intValue] != 200) {
            [SVProgressHUD showErrorWithStatus:vReson];
        }else{
            //查询成功
            if (vListsDic.count == 0) {
                [SVProgressHUD showSuccessWithStatus:@"暂无违章信息"];
            }else{
                [SVProgressHUD showSuccessWithStatus:vReson];
            }
        }
        
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"查询违章" Notice:@"正在查询"];
}


#pragma mark 选择违章城市
-(void)choseRegulationPlace{
    [ViewControllerManager createViewController:@"RegulationChoseProvince"];
    RegulationChoseProvince *vVC = (RegulationChoseProvince *)[ViewControllerManager getBaseViewController:@"RegulationChoseProvince"];
    vVC.delegate = self;
    [ViewControllerManager showBaseViewController:@"RegulationChoseProvince" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 城市选择完毕
-(void)didRegulationChoseCityVCSelected:(NSDictionary *)sender{
    [ViewControllerManager backToViewController:@"RegulationAddCarVC" Animatation:vaDefaultAnimation SubType:0];
    mPlaceDic = [[NSDictionary alloc] initWithDictionary:sender];
    self.regulationPlaceField.text = [sender objectForKey:@"city_name"];
    IFISNIL(self.regulationPlaceField.text);
    //显示违章输入信息提示
    mNoticeStr = [self noticeRegulation:sender];
    [self.regulationAddCarVCTableView reloadData];
}

#pragma mark 选择车辆类型
-(void)choseCarType{
    //    id useId = [UserManager instanceUserManager].userID;
    //    NSNumber *queryType = [NSNumber numberWithInt:1];
    //    NSString *provinceCode = @"";
    //    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                useId,@"useId",
    //                                queryType,@"queryType",
    //                                provinceCode,@"provinceCode",
    //                                nil];
    //    [NetManager postDataFromWebAsynchronous:APPURL601 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
    //    } Failure:^(NSURLResponse *response, NSError *error) {
    //    } RequestName:@"获取车辆品牌" Notice:@""];
    [ViewControllerManager createViewController:@"CarTypeVC"];
    CarTypeVC *vVC = (CarTypeVC *)[ViewControllerManager getBaseViewController:@"CarTypeVC"];
    vVC.delegate = self;
    [ViewControllerManager showBaseViewController:@"CarTypeVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 车辆类型选择完毕
-(void)didCarTypeVCSelected:(NSDictionary *)sender{

    self.regulationCarTypeField.text = [sender objectForKey:@"car"];
    mCarTypeDic = [[NSDictionary alloc] initWithDictionary:sender];

}

@end
