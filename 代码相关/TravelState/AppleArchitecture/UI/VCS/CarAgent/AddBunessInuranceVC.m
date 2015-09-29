//
//  AddBunessInuranceVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-21.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "AddBunessInuranceVC.h"
#import "NetManager.h"
#import "NewGTMBase64.h"
#import "UserManager.h"
#import "ImageViewHelper.h"
#import "PhtotoInfo.h"
#import "CheckManeger.h"
#import "Toast+UIView.h"

@interface AddBunessInuranceVC ()
{
    ChoseDateVC *mChoseDateVC;
    TakePhotoTool *mTakePhotoVC;
    NSMutableDictionary *mParemeter;  //网络请求参数
    NSInteger mSeletedRow;
    IDCardCell *mInsuranImageCell;  //保单图片cell
    UITableViewCell *mInsuranceStartCell; //保单生效时间
    UITableViewCell *mInsuranceEndCell;   //保单到期时间
    NSMutableArray *mImageDatas;         //上传的图片
}
@property (nonatomic,retain) UITextField *bunessInsuranceNumberField;
@property (nonatomic,retain) UITextField *insuranceCompanyField;
@property (nonatomic,retain) UITextField *insurancePhoneNumber;
@property (nonatomic,retain) UITextField *insuranceStartTime;
@property (nonatomic,retain) UITextField *insuranceEndTime;

@end

@implementation AddBunessInuranceVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"AddBunessInuranceVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"AddBunessInuranceVC" bundle:aBuddle];
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
    [mChoseDateVC release];
    [mTakePhotoVC release];
    [_bunessInsuranceNumberField release];
    [_insuranceCompanyField release];
    [_insurancePhoneNumber release];
    [_insuranceStartTime release];
    [_insuranceEndTime release];
    [mParemeter removeAllObjects],[mParemeter release];
    [_bunessTableView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.bunessTableView.clickeDelegate = self;
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

-(void)setIsAddBunessInsurance:(BOOL)isAddBunessInsurance{
    _isAddBunessInsurance = isAddBunessInsurance;
    if (_isAddBunessInsurance) {
        self.title = @"添加商业保险";
        UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [vRightButton setTitle:@"确定" forState:UIControlStateNormal];
        [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
        [vRightButton addTarget:self action:@selector(confirmButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
        self.navigationItem.rightBarButtonItem = vBarButtonItem;
    }else{
        self.title = @"商业保险详情";
        self.bunessInsuranceNumberField.hidden = YES;
        self.insuranceCompanyField.hidden = YES;
        self.insurancePhoneNumber.hidden = YES;
        self.insuranceStartTime.hidden = YES;
        self.insuranceEndTime.hidden = YES;
    }
}

-(UITextField *)bunessInsuranceNumberField{
    if (_bunessInsuranceNumberField == Nil) {
        _bunessInsuranceNumberField = [[UITextField alloc] initWithFrame:CGRectMake(95, 7, 150, 30)];
    }
    _bunessInsuranceNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _bunessInsuranceNumberField.borderStyle = UITextBorderStyleRoundedRect;
    _bunessInsuranceNumberField.returnKeyType = UIReturnKeyDone;
    _bunessInsuranceNumberField.keyboardType = UIKeyboardTypeASCIICapable;
    _bunessInsuranceNumberField.font = [UIFont systemFontOfSize:15];
    _bunessInsuranceNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _bunessInsuranceNumberField.delegate = self;
    
    return _bunessInsuranceNumberField;
}

-(UITextField *)insuranceCompanyField{
    if (_insuranceCompanyField == Nil) {
        _insuranceCompanyField = [[UITextField alloc] initWithFrame:CGRectMake(95, 7, 150, 30)];
    }
    _insuranceCompanyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _insuranceCompanyField.borderStyle = UITextBorderStyleRoundedRect;
    _insuranceCompanyField.returnKeyType = UIReturnKeyDone;
    _insuranceCompanyField.font = [UIFont systemFontOfSize:15];
    _insuranceCompanyField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _insuranceCompanyField.delegate = self;
    
    return _insuranceCompanyField;
}

-(UITextField *)insurancePhoneNumber{
    if (_insurancePhoneNumber == Nil) {
        _insurancePhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(95, 7, 150, 30)];
    }
    _insurancePhoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    _insurancePhoneNumber.borderStyle = UITextBorderStyleRoundedRect;
    _insurancePhoneNumber.returnKeyType = UIReturnKeyDone;
    _insurancePhoneNumber.keyboardType = UIKeyboardTypePhonePad;
    _insurancePhoneNumber.font = [UIFont systemFontOfSize:15];
    _insurancePhoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _insurancePhoneNumber.delegate = self;
    
    return _insurancePhoneNumber;
}

-(UITextField *)insuranceStartTime{
    if (_insuranceStartTime == Nil) {
        _insuranceStartTime = [[UITextField alloc] initWithFrame:CGRectMake(95, 7, 150, 30)];
    }
    _insuranceStartTime.clearButtonMode = UITextFieldViewModeWhileEditing;
    _insuranceStartTime.borderStyle = UITextBorderStyleNone;
    _insuranceStartTime.returnKeyType = UIReturnKeyDone;
    _insuranceStartTime.keyboardType = UIKeyboardTypePhonePad;
    _insuranceStartTime.font = [UIFont systemFontOfSize:15];
    _insuranceStartTime.delegate = self;
    _insuranceStartTime.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _insuranceStartTime.userInteractionEnabled = NO;
    return _insuranceStartTime;
}

-(UITextField *)insuranceEndTime{
    if (_insuranceEndTime == Nil) {
        _insuranceEndTime = [[UITextField alloc] initWithFrame:CGRectMake(95, 7, 150, 30)];
    }
    _insuranceEndTime.clearButtonMode = UITextFieldViewModeWhileEditing;
    _insuranceEndTime.borderStyle = UITextBorderStyleNone;
    _insuranceEndTime.returnKeyType = UIReturnKeyDone;
    _insuranceEndTime.keyboardType = UIKeyboardTypePhonePad;
    _insuranceEndTime.font = [UIFont systemFontOfSize:15];
    _insuranceEndTime.delegate = self;
    _insuranceEndTime.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _insuranceEndTime.userInteractionEnabled = NO;
    return _insuranceEndTime;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 5) {
        IDCardCell *vIDCell = [[[NSBundle mainBundle] loadNibNamed:@"IDCardCell" owner:self options:Nil] objectAtIndex:0];
        return vIDCell.frame.size.height;;
    }
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
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
            [vCell.contentView addSubview:self.bunessInsuranceNumberField];
            
            if (!_isAddBunessInsurance) {
                UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
                vLable.hidden = NO;
                vLable.text =self.insuranceInfo.policyNumber;
            }
        }else if (indexPath.row == 1){
            //文字描述
            vCell.textLabel.text = @"保险公司:";
            [vCell.contentView addSubview:self.insuranceCompanyField];
            
            if (!_isAddBunessInsurance) {
                UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
                vLable.hidden = NO;
                vLable.text = self.insuranceInfo.insuranceCompany;
            }
        }else if (indexPath.row == 2){
            //文字描述
            vCell.textLabel.text = @"报险电话:";
            [vCell.contentView addSubview:self.insurancePhoneNumber];
            
            if (!_isAddBunessInsurance) {
                UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
                vLable.hidden = NO;
                vLable.text = self.insuranceInfo.reportPhone;
            }
        }else if (indexPath.row == 3){
            //文字描述
            vCell.textLabel.text = @"商业险生效:";
            [vCell.contentView addSubview:self.insuranceStartTime];
            vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (!_isAddBunessInsurance) {
                UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
                vLable.hidden = NO;
                vLable.text = self.insuranceInfo.effectiveDate;
            }
        }else if (indexPath.row == 4){
            //文字描述
            vCell.textLabel.text = @"商业险到期:";
            [vCell.contentView addSubview:self.insuranceEndTime];
            vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (!_isAddBunessInsurance) {
                UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
                vLable.hidden = NO;
                vLable.text = self.insuranceInfo.expirationDate;
            }
        }else if (indexPath.row == 5){
            static NSString *vIdIdentify = @"idCell";
            IDCardCell *vCell = (IDCardCell*)[tableView dequeueReusableCellWithIdentifier:vIdIdentify];
            if (vCell == Nil) {
                vCell = [[[NSBundle mainBundle] loadNibNamed:@"IDCardCell" owner:self options:Nil] objectAtIndex:0];
                vCell.delegate = self;
            }

            vCell.cellLable.text = @"保险单照片:";
            
            //获得保险单所有图片
            NSMutableArray *vImageViewsArray = [NSMutableArray array];
            for (NSString *vImageStr in self.insuranceInfo.policyImg) {
                PhtotoInfo *vInfo = [[PhtotoInfo alloc] init];
                vInfo.phtotURLStr = vImageStr;
                vInfo.businessId = self.insuranceInfo.insuranceId;
                vInfo.photoType = ptBunessInsurance;
                vInfo.isAudio = [self.insuranceInfo.isAudit boolValue];
                [vImageViewsArray addObject:vInfo];
                SAFE_ARC_RELEASE(vInfo);
            }
            [vCell initCell];
            //设置显示身份证图片
            [vCell setCell:vImageViewsArray];
            //重设本地图片
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
    mSeletedRow = indexPath.row;
    if (_isAddBunessInsurance) {
        if ([self.insuranceInfo.isAudit intValue] == 0) {
            if (indexPath.row == 3) {
                [self choseDate];
            }else if (indexPath.row == 4){
                [self choseDate];
            }else if (indexPath.row == 5){
                [self choseHeadImage:0];
            }
        }else{
            [self.view makeToast:@"您的保险已通过审核，不能修改！" duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
        }

    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [super textFieldDidEndEditing:textField];
    if (textField == self.bunessInsuranceNumberField) {
        if (textField.text.length > 0) {
            BOOL vIfIsAllowed =  [CheckManeger isLettersAndNumbers:textField.text];
            if (!vIfIsAllowed) {
                [self.view makeToast:@"请输入正确的保险单号！" duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
                self.bunessInsuranceNumberField.text = @"";
            }
        }
    }
}

#pragma mark 其他辅助功能
#pragma mark 上传图片
-(void)postImages:(id)ImageID CompletionBlock:(void (^)(void))block{
    NSMutableArray *vBase64Array = [NSMutableArray array];
    for (PhtotoInfo *vInfo in mImageDatas) {
        NSData *vImageData = UIImagePNGRepresentation(vInfo.photoImage);
        NSString *vBase64Str = [NewGTMBase64 stringByEncodingData:vImageData];
        [vBase64Array addObject:vBase64Str];
    }
    [IDCardCell postIDImages:vBase64Array PhtotoType:4 businessType:ImageID CompletionBlock:^{
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
    if ([_delegate respondsToSelector:@selector(didAddBunessInuranceSucces:)]) {
        [_delegate didAddBunessInuranceSucces:Nil];
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
    if (mSeletedRow == 3) {
        self.insuranceStartTime.text = sender;
        [mParemeter setObject:sender forKey:@"effectiveDate"];
    }else if(mSeletedRow == 4){
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

#pragma mark IDCardCellDelegate
#pragma mark 填写行保险单照片
-(void)didIDCardCellAddImageButtonClicked:(id)sender{
    [self choseHeadImage:0];
}

#pragma mark 删除照片成功
-(void)didIDCardCellDeletePhotoSuccess:(PhtotoInfo *)sender{
    if (sender.phtotURLStr.length > 0) {
        [self.insuranceInfo.policyImg removeObject:sender.phtotURLStr];
        //刷新保险信息
        if ([_delegate respondsToSelector:@selector(didAddBunessInuranceSucces:)]) {
            [_delegate didAddBunessInuranceSucces:Nil];
        }
    }
    
    //检查是否是本地图片
    [self deleteLocalPhtoto:sender];

    //刷新图片
    NSIndexPath *vIndexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    [self.bunessTableView reloadRowsAtIndexPaths:@[vIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark 选择保单图片
-(void)choseHeadImage:(NSInteger)aIndex{
    if (mTakePhotoVC == Nil) {
        mTakePhotoVC = [[TakePhotoTool alloc] init];
        mTakePhotoVC.delegate = self;
    }
    [mTakePhotoVC takePhoto:self];
}

#pragma mark - TakePhotoSucces
#pragma mark 照相成功 保单选择成功
-(void)didTakePhotoSucces:(id)sender{
     UIImage *vImage = [UIImage imageWithData:sender];
    PhtotoInfo *vInfo = [[PhtotoInfo alloc] init];
    vInfo.photoImage = vImage;
    vInfo.photoType = ptSelfPhoto;
    //保存保险照片
    [mImageDatas addObject:vInfo];
    //刷新图片
    NSIndexPath *vIndexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    [self.bunessTableView reloadRowsAtIndexPaths:@[vIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    NSMutableArray *vImageArray = [NSMutableArray array];
    [mParemeter setObject:vImageArray forKey:@"policyImg"];
    SAFE_ARC_RELEASE(vInfo);

}

#pragma mark 确定
-(void)confirmButtonTouchDown:(id)sender{
    NSString *vInsuranceNumber =self.bunessInsuranceNumberField.text;
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
    
    [NetManager postDataFromWebAsynchronous:APPURL503 Paremeter:mParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSNumber *vStateNumber = [vReturnDic objectForKey:@"stateCode"];
        NSString *vReturnMessage = [vReturnDic objectForKey:@"stateMessage"];
        if ([vStateNumber intValue] == 0) {
            //上传照片
            NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
            id insuranceId = [vDataDic objectForKey:@"insuranceId"];
            IFISNIL(insuranceId);
            [self postImages:insuranceId CompletionBlock:Nil];
        }else{
            [SVProgressHUD showErrorWithStatus:vReturnMessage];
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"添加商业保险" Notice:@"正在上传保险资料"];
}

- (void)viewDidUnload {
[self setBunessTableView:nil];
[super viewDidUnload];
}
@end
