//
//  AddJiaoQiangXiangVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-21.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "AddJiaoQiangXiangVC.h"
#import "ImageViewHelper.h"
#import "NewGTMBase64.h"
#import "NetManager.h"
#import "UserManager.h"
#import "ChoseProvinceVC.h"
#import "PhtotoInfo.h"
#import "Toast+UIView.h"
#import "CheckManeger.h"

@interface AddJiaoQiangXiangVC ()
{
    ChoseDateVC *mChoseDateVC;
    TakePhotoTool *mTakePhoto;
    NSInteger mSelectedRow;    //列表选择行
    NSMutableDictionary *mParemeter;  //网络请求参数
    IDCardCell *mInsuranImageCell;  //保单图片cell
    NSMutableArray *mImageDatas;
}
@property (nonatomic,retain) UITextField *jiaoQiangXianInsuranceNumberField;
@property (nonatomic,retain) UITextField *insuranceCompanyField;
@property (nonatomic,retain) UITextField *insurancePhoneNumber;
@property (nonatomic,retain) UITextField *insurancePlace;
@property (nonatomic,retain) UITextField *insuranceStartTime;
@property (nonatomic,retain) UITextField *insuranceEndTime;
@end

@implementation AddJiaoQiangXiangVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"AddJiaoQiangXiangVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"AddJiaoQiangXiangVC" bundle:aBuddle];
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
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    mParemeter = [[NSMutableDictionary alloc] init];
    mImageDatas = [[NSMutableArray alloc] init];
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [mParemeter release];
    [mChoseDateVC release];
    [mTakePhoto release];
    [_jiaoQiangXianInsuranceNumberField release];
    [_insuranceCompanyField release];
    [_insurancePhoneNumber release];
    [_insurancePlace release];
    [_insuranceStartTime release];
    [_insuranceEndTime release];
    [_jiaoQiangXianTableView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.jiaoQiangXianTableView.clickeDelegate = self;
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

-(void)setIsAddJiaoQiangXian:(BOOL)isAddJiaoQiangXian{
    _isAddJiaoQiangXian = isAddJiaoQiangXian;
    if (_isAddJiaoQiangXian) {
        self.title = @"添加交强保险";
        UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [vRightButton setTitle:@"确定" forState:UIControlStateNormal];
        [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
        [vRightButton addTarget:self action:@selector(confirmButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
        self.navigationItem.rightBarButtonItem = vBarButtonItem;
    }else{
        self.title = @"保险详情";
        self.jiaoQiangXianInsuranceNumberField.hidden = YES;
        self.insuranceCompanyField.hidden = YES;
        self.insurancePhoneNumber.hidden = YES;
        self.insurancePlace.hidden = YES;
        self.insuranceStartTime.hidden = YES;
        self.insuranceEndTime.hidden = YES;
    }
}

-(UITextField *)jiaoQiangXianInsuranceNumberField{
    if (_jiaoQiangXianInsuranceNumberField == Nil) {
        _jiaoQiangXianInsuranceNumberField = [[UITextField alloc] initWithFrame:CGRectMake(95, 7, 150, 30)];
        _jiaoQiangXianInsuranceNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _jiaoQiangXianInsuranceNumberField.borderStyle = UITextBorderStyleRoundedRect;
        _jiaoQiangXianInsuranceNumberField.keyboardType = UIKeyboardTypeASCIICapable;
        _jiaoQiangXianInsuranceNumberField.returnKeyType = UIReturnKeyDone;
        _jiaoQiangXianInsuranceNumberField.font = [UIFont systemFontOfSize:15];
        _jiaoQiangXianInsuranceNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _jiaoQiangXianInsuranceNumberField.delegate = self;
    }

    
    return _jiaoQiangXianInsuranceNumberField;
}

-(UITextField *)insuranceCompanyField{
    if (_insuranceCompanyField == Nil) {
        _insuranceCompanyField = [[UITextField alloc] initWithFrame:CGRectMake(95, 7, 150, 30)];
        _insuranceCompanyField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _insuranceCompanyField.borderStyle = UITextBorderStyleRoundedRect;
        _insuranceCompanyField.returnKeyType = UIReturnKeyDone;
        _insuranceCompanyField.font = [UIFont systemFontOfSize:15];
        _insuranceCompanyField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _insuranceCompanyField.delegate = self;
    }

    
    return _insuranceCompanyField;
}

-(UITextField *)insurancePhoneNumber{
    if (_insurancePhoneNumber == Nil) {
        _insurancePhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(95, 7, 150, 30)];
        _insurancePhoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
        _insurancePhoneNumber.borderStyle = UITextBorderStyleRoundedRect;
        _insurancePhoneNumber.returnKeyType = UIReturnKeyDone;
        _insurancePhoneNumber.keyboardType = UIKeyboardTypePhonePad;
        _insurancePhoneNumber.font = [UIFont systemFontOfSize:15];
        _insurancePhoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _insurancePhoneNumber.delegate = self;
    }

    
    return _insurancePhoneNumber;
}

-(UITextField *)insurancePlace{
    if (_insurancePlace == Nil) {
        _insurancePlace = [[UITextField alloc] initWithFrame:CGRectMake(95, 7, 150, 30)];
        _insurancePlace.clearButtonMode = UITextFieldViewModeWhileEditing;
        _insurancePlace.borderStyle = UITextBorderStyleNone;
        _insurancePlace.returnKeyType = UIReturnKeyDone;
        _insurancePlace.font = [UIFont systemFontOfSize:15];
        _insurancePlace.delegate = self;
        _insurancePlace.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _insurancePlace.userInteractionEnabled = NO;
    }

    return _insurancePlace;
}

-(UITextField *)insuranceStartTime{
    if (_insuranceStartTime == Nil) {
        _insuranceStartTime = [[UITextField alloc] initWithFrame:CGRectMake(95, 7, 150, 30)];
        _insuranceStartTime.clearButtonMode = UITextFieldViewModeWhileEditing;
        _insuranceStartTime.borderStyle = UITextBorderStyleNone;
        _insuranceStartTime.returnKeyType = UIReturnKeyDone;
        _insuranceStartTime.keyboardType = UIKeyboardTypePhonePad;
        _insuranceStartTime.font = [UIFont systemFontOfSize:15];
        _insuranceStartTime.delegate = self;
        _insuranceStartTime.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _insuranceStartTime.userInteractionEnabled = NO;
    }

    return _insuranceStartTime;
}

-(UITextField *)insuranceEndTime{
    if (_insuranceEndTime == Nil) {
        _insuranceEndTime = [[UITextField alloc] initWithFrame:CGRectMake(95, 7, 150, 30)];
        _insuranceEndTime.clearButtonMode = UITextFieldViewModeWhileEditing;
        _insuranceEndTime.borderStyle = UITextBorderStyleNone;
        _insuranceEndTime.returnKeyType = UIReturnKeyDone;
        _insuranceEndTime.keyboardType = UIKeyboardTypePhonePad;
        _insuranceEndTime.font = [UIFont systemFontOfSize:15];
        _insuranceEndTime.delegate = self;
        _insuranceEndTime.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _insuranceEndTime.userInteractionEnabled = NO;
    }

    return _insuranceEndTime;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 6) {
        IDCardCell *vIDCell = [[[NSBundle mainBundle] loadNibNamed:@"IDCardCell" owner:self options:Nil] objectAtIndex:0];
        return vIDCell.frame.size.height;;
    }
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        vCell.textLabel.font = [UIFont systemFontOfSize:15];
        vCell.textLabel.textColor = [UIColor darkGrayColor];
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        //设置图片
        UIImageView *vCellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 14, 60, 60)];
        vCellImageView.tag = 100;
        vCellImageView.hidden = YES;
        [vCellImageView setBackgroundColor:[UIColor redColor]];
        [vCell.contentView addSubview:vCellImageView];
        SAFE_ARC_RELEASE(vCellImageView);
        
        //设置介绍
        UILabel *vLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 11, 200, 21)];
        [vLable setBackgroundColor:[UIColor clearColor]];
        vLable.font = [UIFont systemFontOfSize:15];
        vLable.textColor = [UIColor darkGrayColor];
        vLable.textAlignment = NSTextAlignmentRight;
        vLable.tag = 101;
        vLable.hidden = YES;
        [vCell.contentView addSubview:vLable];
        SAFE_ARC_RELEASE(vLable);
        
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //文字描述
            vCell.textLabel.text = @"商业险单号:";
            [vCell.contentView addSubview:self.jiaoQiangXianInsuranceNumberField];
            
            if (!_isAddJiaoQiangXian) {
                UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
                vLable.hidden = NO;
                vLable.text = self.insuranceInfo.policyNumber;
            }
        }else if (indexPath.row == 1){
            //文字描述
            vCell.textLabel.text = @"保险公司:";
            [vCell.contentView addSubview:self.insuranceCompanyField];
            
            if (!_isAddJiaoQiangXian) {
                UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
                vLable.hidden = NO;
                vLable.text = self.insuranceInfo.insuranceCompany;
            }
        }else if (indexPath.row == 2){
            //文字描述
            vCell.textLabel.text = @"报险电话:";
            [vCell.contentView addSubview:self.insurancePhoneNumber];
            
            if (!_isAddJiaoQiangXian) {
                UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
                vLable.hidden = NO;
                vLable.text = self.insuranceInfo.reportPhone;
            }
        }else if (indexPath.row == 3){
            //文字描述
            vCell.textLabel.text = @"投保地区:";
            [vCell.contentView addSubview:self.insurancePlace];
            vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (!_isAddJiaoQiangXian) {
                UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
                vLable.hidden = NO;
                vLable.text = self.insuranceInfo.insuranceArea;
            }
            
        }else if (indexPath.row == 4){
            //文字描述
            vCell.textLabel.text = @"交强险生效:";
            [vCell.contentView addSubview:self.insuranceStartTime];
            vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (!_isAddJiaoQiangXian) {
                UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
                vLable.hidden = NO;
                vLable.text = self.insuranceInfo.effectiveDate;
            }
        }else if (indexPath.row == 5){
            //文字描述
            vCell.textLabel.text = @"交强险到期:";
            [vCell.contentView addSubview:self.insuranceEndTime];
            vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (!_isAddJiaoQiangXian) {
                UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
                vLable.hidden = NO;
                vLable.text = self.insuranceInfo.expirationDate;
            }
        }else if (indexPath.row == 6){
            //文字描述
            static NSString *vIdIdentify = @"idCell";
            IDCardCell *vCell = (IDCardCell*)[tableView dequeueReusableCellWithIdentifier:vIdIdentify];
            if (vCell == Nil) {
                vCell = [[[NSBundle mainBundle] loadNibNamed:@"IDCardCell" owner:self options:Nil] objectAtIndex:0];
                vCell.delegate = self;
            }
            vCell.cellLable.text = @"保险单照片:";
            
            //获得保险单所有图片
            NSMutableArray *vPhotoInfoArray = [NSMutableArray array];
            for (NSString *vImageStr in self.insuranceInfo.policyImg) {
                PhtotoInfo *vInfo = [[PhtotoInfo alloc] init];
                vInfo.phtotURLStr = vImageStr;
                vInfo.businessId = self.insuranceInfo.insuranceId;
                vInfo.photoType = ptJiaoQiangInsurance;
                vInfo.isAudio = [self.insuranceInfo.isAudit boolValue];
                [vPhotoInfoArray addObject:vInfo];
                SAFE_ARC_RELEASE(vInfo);
            }
            //设置显示身份证图片
            [vCell initCell];
            [vCell setCell:vPhotoInfoArray];
            [vCell setCell:mImageDatas];
            
            mInsuranImageCell = vCell;
            //移动到最新上传的图片位置++
            [mInsuranImageCell moveToIndexOfImage:mInsuranImageCell.idImagecount];
            
            return vCell;
        }
    }
    
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isAddJiaoQiangXian) {
        mSelectedRow = indexPath.row;
        if ([self.insuranceInfo.isAudit intValue] == 0) {
            if (indexPath.row == 3) {
                [self chosePlace];
            }else if (indexPath.row == 4) {
                [self choseDate];
            }else if (indexPath.row == 5){
                [self choseDate];
            }else if (indexPath.row == 6){
                [self choseHeadImage];
            }
        }else{
            [self.view makeToast:@"您的保险已通过审核，不能修改！" duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
        }
 
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [super textFieldDidEndEditing:textField];
    if (textField == self.jiaoQiangXianInsuranceNumberField) {
        if (textField.text.length > 0) {
            BOOL vIfIsAllowed =  [CheckManeger isLettersAndNumbers:textField.text];
            if (!vIfIsAllowed) {
                [self.view makeToast:@"请输入正确的保险单号！" duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
                self.jiaoQiangXianInsuranceNumberField.text = @"";
            }
        }
    }
}

#pragma mark - 其他辅助功能
-(void)goToChosePlaceVC{
    [ViewControllerManager createViewController:@"ChoseProvinceVC"];
    NSDictionary *vParemeterDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"type",[NSNumber numberWithInt:0],@"id",nil];
    [NetManager postDataFromWebAsynchronous:APPURL103 Paremeter:vParemeterDic Success:^(NSURLResponse *response, id responseObject) {
        //解析返回数据到数组
        NSDictionary *vDataDic = [[NetManager jsonToDic:responseObject] objectForKey:@"data"];
        NSMutableArray *vDataArray = [NSMutableArray array];
        for (NSDictionary *vDic in vDataDic) {
            [vDataArray addObject:vDic];
        }
        if (vDataArray.count >0) {
            ChoseProvinceVC *vChosePlaceVC = (ChoseProvinceVC *)[ViewControllerManager getBaseViewController:@"ChoseProvinceVC"];
            vChosePlaceVC.placeArray = vDataArray;
            vChosePlaceVC.isNeedChosedDistrict = NO;
            vChosePlaceVC.fromVCName = @"AddJiaoQiangXiangVC";
            vChosePlaceVC.delegate = self;
            //显示地区
            [ViewControllerManager showBaseViewController:@"ChoseProvinceVC" AnimationType:vaDefaultAnimation SubType:0];
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"获取省" Notice:@""];

}

#pragma mark 上传图片
-(void)postImages:(id)ImageID CompletionBlock:(void (^)(void))block{
    NSMutableArray *vBase64Array = [NSMutableArray array];
    for (PhtotoInfo *vInfo in mImageDatas) {
        NSData *vImageData = UIImagePNGRepresentation(vInfo.photoImage);
        NSString *vBase64Str = [NewGTMBase64 stringByEncodingData:vImageData];
        [vBase64Array addObject:vBase64Str];
    }
    [IDCardCell postIDImages:vBase64Array PhtotoType:5 businessType:ImageID CompletionBlock:^{
        [mImageDatas removeAllObjects];
        [self dealBack];
    } Notice:@"正在上传照片"];
}

#pragma mark - 删除刚刚照得照片
-(void)deleteLocalPhtoto:(PhtotoInfo *)sender{
    //检查是否是刚刚照得照片,有则删除
    if (mImageDatas.count > 0) {
        NSInteger vIndex = [mImageDatas indexOfObject:sender];
        if (vIndex != NSNotFound) {
            [mImageDatas removeObjectAtIndex:vIndex];
            //图片移除完了，那么需要提示用户，
            if (mImageDatas.count == 0) {
                [mParemeter removeObjectForKey:@"policyImg"];
            }
        }
    }
}

#pragma mark 返回时要做的处理
-(void)dealBack{
    [self back];
    if ([_delegate respondsToSelector:@selector(didAddJiaoQiangXiangFinished:)]) {
        [_delegate didAddJiaoQiangXiangFinished:Nil];
    }
}


#pragma mark - 其他业务点击事件
#pragma mark 选择时间
//选择生日
-(void)choseDate{
    if (mChoseDateVC == nil) {
        mChoseDateVC = [[ChoseDateVC alloc] init];
        mChoseDateVC.delegate = self;
    }
    if (mChoseDateVC.view.superview == Nil) {
        [self.view addSubview:mChoseDateVC.view];
    }
}
//确定选择时间
-(void)didConfirmDate:(id)sender{
    if (mSelectedRow == 4) {
        self.insuranceStartTime.text = sender;
        [mParemeter setObject:sender forKey:@"effectiveDate"];
    }else if(mSelectedRow == 5){
        self.insuranceEndTime.text = sender;
        [mParemeter setObject:sender forKey:@"expirationDate"];
    }
}
//取消选择时间
-(void)didCancleDate:(id)sender{
}
//时间选择器滚动
-(void)valueDidChange:(id)sender{
}

#pragma mark 填写行保险单照片
-(void)didIDCardCellAddImageButtonClicked:(id)sender{
    if (_isAddJiaoQiangXian) {
        [self choseHeadImage];
    }
}
#pragma mark 删除照片成功
-(void)didIDCardCellDeletePhotoSuccess:(PhtotoInfo *)sender{
    if (sender.phtotURLStr.length > 0) {
        [self.insuranceInfo.policyImg removeObject:sender.phtotURLStr];
        if ([_delegate respondsToSelector:@selector(didAddJiaoQiangXiangFinished:)]) {
            [_delegate didAddJiaoQiangXiangFinished:Nil];
        }
    }

    //检查是否删除本地图片
    [self deleteLocalPhtoto:sender];
    //刷新图片
    NSIndexPath *vIndexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    [self.jiaoQiangXianTableView reloadRowsAtIndexPaths:@[vIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark 选择图片
-(void)choseHeadImage{
    if (mTakePhoto == Nil) {
        mTakePhoto = [[TakePhotoTool alloc] init];
        mTakePhoto.delegate = self;
    }
    [mTakePhoto takePhoto:self];
}

#pragma mark - TakePhotoSucces
#pragma mark 照相成功 保单选择成功
-(void)didTakePhotoSucces:(id)sender{
    UIImage *vImage = [UIImage imageWithData:sender];
    PhtotoInfo *vPhotoInfo = [[PhtotoInfo alloc] init];
    vPhotoInfo.photoImage = vImage;
    vPhotoInfo.photoType = ptSelfPhoto;
    
    //上传保险但照片到服务器
    [mImageDatas addObject:vPhotoInfo];
    
    //刷新图片
    NSIndexPath *vIndexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    [self.jiaoQiangXianTableView reloadRowsAtIndexPaths:@[vIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    NSMutableArray *vImagesArray = [NSMutableArray array];
    [mParemeter setObject:vImagesArray forKey:@"policyImg"];
}

#pragma mark 选择地区
-(void)chosePlace{
    [self goToChosePlaceVC];
}

#pragma mark ChoseDistrctVCDelegate
#pragma mark 城市选择完毕
-(void)didChoseProvinceCityVCFinished:(NSDictionary *)sender{
    if (sender == Nil || sender.count == 0) {
        LOG(@"didFinishChosedPlace传入地区参数为空");
        return;
    }
    
    NSString *vProinceStr = [[sender objectForKey:@"province"] objectForKey:@"name"];
    IFISNIL(vProinceStr);
    NSString *vCityStr = [[sender objectForKey:@"city"] objectForKey:@"name"];
    IFISNIL(vCityStr);
    
    self.insurancePlace.text = [NSString stringWithFormat:@"%@%@",vProinceStr,vCityStr];
    [ViewControllerManager backToViewController:@"AddJiaoQiangXiangVC" Animatation:vaDefaultAnimation SubType:0];
}


#pragma mark 点击确定按钮
-(void)confirmButtonTouchDown:(id)sender{
    NSString *vInsuranceNumber =self.jiaoQiangXianInsuranceNumberField.text;
    if (vInsuranceNumber.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写保险单号"];
        return;
    }else{
        [mParemeter setObject:vInsuranceNumber forKey:@"policyNumber"];
    }
    
    NSString *vInsuranceCompany = self.insuranceCompanyField.text;
    if (vInsuranceCompany.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写保险公司！"];
        return;
    }else{
        [mParemeter setObject:vInsuranceCompany forKey:@"insuranceCompany"];
    }
    
    NSString *vInsurancePhone = self.insurancePhoneNumber.text;
    if (vInsurancePhone.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写保险电话！"];
        return;
    }else{
        [mParemeter setObject:vInsurancePhone forKey:@"reportPhone"];
    }
    
    NSString *vInsurancePlaceStr = self.insurancePlace.text;
    if (vInsurancePlaceStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择投保地区"];
        return;
    }else{
        [mParemeter setObject:vInsurancePlaceStr forKey:@"insuranceArea"];
    }
    
    
    NSString *vEffectiveDate = self.insuranceStartTime.text;
    if (vEffectiveDate.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写生效日期！"];
        return;
    }else{
        [mParemeter setObject:vEffectiveDate forKey:@"effectiveDate"];
    }
    
    NSString *vExpirationDate = self.insuranceEndTime.text;
    if (vExpirationDate.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写到期日期！"];
        return;
    }else{
        [mParemeter setObject:vExpirationDate forKey:@"expirationDate"];
    }
    
    id vPolicyImage = [mParemeter objectForKey:@"policyImg"];
    if (vPolicyImage == Nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择保单图片！"];
        return;
    }
    
    id vUserID = [UserManager instanceUserManager].userID;
    [mParemeter setObject:vUserID forKey:@"userId"];
    
    [NetManager postDataFromWebAsynchronous:APPURL505 Paremeter:mParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSNumber *vStateNumber = [vReturnDic objectForKey:@"stateCode"];
        NSString *vReturnMessage = [vReturnDic objectForKey:@"stateMessage"];
        if ([vStateNumber intValue] == 0) {
            //添加照片
            NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
            id insuranceId = [vDataDic objectForKey:@"insuranceId"];
            IFISNIL(insuranceId);
            [self postImages:insuranceId CompletionBlock:Nil];
        }else{
            [SVProgressHUD showErrorWithStatus:vReturnMessage];
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"添加交强保险" Notice:@"正在上传保险资料"];

}

- (void)viewDidUnload {
[self setJiaoQiangXianTableView:nil];
[super viewDidUnload];
}
@end
