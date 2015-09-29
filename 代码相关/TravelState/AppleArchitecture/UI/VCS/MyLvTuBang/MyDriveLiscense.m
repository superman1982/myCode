//
//  MyDriveLiscense.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-15.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "MyDriveLiscense.h"
#import "NewGTMBase64.h"
#import "NetManager.h"
#import "UserManager.h"
#import "ImageViewHelper.h"
#import "PhtotoInfo.h"
#import "Toast+UIView.h"

@interface MyDriveLiscense ()

{
    BOOL isShowChanese;
    BOOL isNeedToMoveFrame;
    ChoseDateVC *mChoseRegistDateVC;
    TakePhotoTool *mTakeDrivePhoto;
    IDCardCell      *mIDCardCell;       //添加驾照图片Cell
    NSMutableArray *mImageDatas;        //照片数据
    NSMutableDictionary *mDriveLiscenDic;     //驾照信息
    NSInteger    mSelectedRow;         //选择的行
    UITableViewCell    *drivingLicenseNoCell;
    UITableViewCell    *applyDateCell;
    UITableViewCell    *awardAddCell;
    UITableViewCell    *replaceDateCell;
    
}
//账号
@property (nonatomic,assign)  BOOL  isChangeData;

@property (nonatomic,retain) UITextField *carDriveField;

@end

@implementation MyDriveLiscense

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"MyDriveLiscense_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"MyDriveLiscense" bundle:aBuddle];
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
    self.title = @"我的驾驶证";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)viewWillAppear:(BOOL)animated{
    //给键盘注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initCommonData{
    if (mImageDatas == Nil) {
        mImageDatas = [[NSMutableArray alloc] init];
    }
    id vUserID = [UserManager instanceUserManager].userID;
    IFISNIL(vUserID);
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:vUserID,@"userId", nil];
    [NetManager postDataFromWebAsynchronous:APPURL821 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        if (vDataDic.count > 0) {
            mDriveLiscenDic = [[NSMutableDictionary alloc] initWithDictionary:vDataDic];
            [self.mDriveLisenseTableVIew reloadData];
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"我的驾照" Notice:@""];
    
    if (mDriveLiscenDic == Nil) {
        mDriveLiscenDic = [[NSMutableDictionary alloc] init];
    }
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [mDriveLiscenDic removeAllObjects];
    [mDriveLiscenDic release];
    [mImageDatas removeAllObjects];
    [mImageDatas release];
    [_mDriveLisenseTableVIew release];
    [_HeaderForDriveLisence release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.mDriveLisenseTableVIew.clickeDelegate = self;
    
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
    [self setMDriveLisenseTableVIew:nil];
    [super viewDidUnload];
}

-(void)setIsChangeData:(BOOL)isChangeData{
    _isChangeData = isChangeData;
    if (isChangeData) {
        UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [vRightButton setTitle:@"保存" forState:UIControlStateNormal];
        [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
        [vRightButton addTarget:self action:@selector(saveDriveLisenceButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
        self.navigationItem.rightBarButtonItem = vBarButtonItem;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }

}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
            //查看车辆信息时，自定义HeaderView
        return self.HeaderForDriveLisence.frame.size.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return self.HeaderForDriveLisence;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 4) {
            IDCardCell *vIDCell = [[[NSBundle mainBundle] loadNibNamed:@"IDCardCell" owner:self options:Nil] objectAtIndex:0];
            return vIDCell.frame.size.height;;
        }
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }
    return 0;
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
        
        UILabel *vLable = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 150, 21)];
        vLable.font = [UIFont systemFontOfSize:15];
        vLable.textColor = [UIColor darkGrayColor];
        vLable.textAlignment = NSTextAlignmentRight;
        vLable.tag = 100;
        //如果是添加车辆隐藏右边文字
        [vCell.contentView addSubview:vLable];
        SAFE_ARC_RELEASE(vLable);
        
        //设置图片
        UIImageView *vCellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 14, 60, 60)];
        vCellImageView.tag = 101;
        vCellImageView.hidden = YES;
        [vCellImageView setBackgroundColor:[UIColor redColor]];
        [vCell.contentView addSubview:vCellImageView];
        SAFE_ARC_RELEASE(vCellImageView);
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            NSString *drivingLicenseNo = [mDriveLiscenDic objectForKey:@"drivingLicenseNo"];
            IFISNIL(drivingLicenseNo);
            
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:100];
            vLable.text  = drivingLicenseNo;
            
            vCell.textLabel.text = @"驾驶证编号:";
            drivingLicenseNoCell = vCell;
        }
        else if (indexPath.row == 1) {
            NSString *applyDate = [mDriveLiscenDic objectForKey:@"applyDate"];
            IFISNIL(applyDate);
            
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:100];
            vLable.text  = applyDate;
            
            vCell.textLabel.text = @"驾驶证申领日期:";
            applyDateCell = vCell;
        }else if (indexPath.row == 2){
            NSString *awardAdd = [mDriveLiscenDic objectForKey:@"awardAdd"];
            IFISNIL(awardAdd);
            
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:100];
            vLable.text  = awardAdd;
            
            vCell.textLabel.text = @"驾驶证颁发地:";
            awardAddCell = vCell;
        }else if (indexPath.row == 3){
            NSString *replaceDate = [mDriveLiscenDic objectForKey:@"replaceDate"];
            IFISNIL(replaceDate);
            
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:100];
            vLable.text  = replaceDate;
            
            vCell.textLabel.text = @"驾驶证换证日期:";
            replaceDateCell = vCell;
        }else if (indexPath.row == 4){
            static NSString *vIdIdentify = @"idCell";
            IDCardCell *vCell = (IDCardCell*)[tableView dequeueReusableCellWithIdentifier:vIdIdentify];
            if (vCell == Nil) {
                vCell = [[[NSBundle mainBundle] loadNibNamed:@"IDCardCell" owner:self options:Nil] objectAtIndex:0];
                vCell.cellLable.text = @"驾驶证照片:";
                vCell.delegate = self;
            }
            
            NSDictionary *vImagesDic = [mDriveLiscenDic objectForKey:@"drivingLicensePhotos"];
            //获得驾驶证所有图片
            NSMutableArray *vImageViewsArray = [NSMutableArray array];
            for (NSString *vImageStr in vImagesDic) {
                PhtotoInfo *vPhtotoInfo = [[PhtotoInfo alloc] init];
                vPhtotoInfo.phtotURLStr = vImageStr;
                vPhtotoInfo.photoType = ptDriveLisence;
                //通过审核后不能删除
                if ([[mDriveLiscenDic objectForKey:@"isAudit"] intValue] == 1) {
                    vPhtotoInfo.photoType = ptBuness;
                }
                [vImageViewsArray addObject:vPhtotoInfo];
                SAFE_ARC_RELEASE(vPhtotoInfo);
            }
            [vCell initCell];
            //设置显示身份证图片
            [vCell setCell:vImageViewsArray];
            //添加本地图片
            [vCell setCell:mImageDatas];
            
            mIDCardCell = vCell;
            //移动到最新上传的图片位置++
            [mIDCardCell moveToIndexOfImage:mIDCardCell.idImagecount];
            
            return vCell;
        }
    }
    
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[mDriveLiscenDic objectForKey:@"isAudit"] intValue] == 0) {
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                [self choseDriveLisenceNumber];
            }
            if (indexPath.row == 3 || indexPath.row == 1) {
                mSelectedRow = indexPath.row;
                [self choseRegisterDate];
            }else if (indexPath.row == 2){
                [self chosePlace];
            }
            else if (indexPath.row == 4){
            }
        }
    }else{
        [self.view makeToast:@"您的驾驶证已经通过审核，不能修改！" duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
    }
}


#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#define CARENGINFILDHIGHT 70
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = [textField convertRect:textField.frame toView:self.view.window];
    int offset = frame.origin.y + 32 - (mHeight + 20 - 216.0-36);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    isNeedToMoveFrame = NO;
    if(offset > 0){
        CGRect vViewFrame = self.view.frame;
        CGRect rect = CGRectMake(0.0f,vViewFrame.origin.y -offset ,width,height);
        
        if (!isShowChanese){
            rect.origin.y = rect.origin.y + 36;
            isNeedToMoveFrame = YES;
        }
        self.view.frame = rect;
    }
    [UIView commitAnimations];

}

//结束输入
- (void)textFieldDidEndEditing:(UITextField *)textField{

}

#pragma mark 屏幕点击事件

-(void)tableTouchBegain:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(self.carDriveField.frame, vTouchPoint)) {
        [self.carDriveField resignFirstResponder];
    }
}

#pragma mark 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification{
    //键盘显示，设置_talkBarView的frame跟随键盘的frame , 对中文键盘处理
    static CGFloat normalKeyboardHeight = 216.0f;
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat distanceToMove = kbSize.height - normalKeyboardHeight;
    //如果显示了中文，则变为英文输入时，重新移动
    if (isShowChanese) {
        isShowChanese = NO;
        [UIView animateWithDuration:.3 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 36, self.view.frame.size.width, self.view.frame.size.height);
        }];
        return;
    }
    
    if (isNeedToMoveFrame && distanceToMove > 0 ) {
        isShowChanese = YES;
        [UIView animateWithDuration:.3 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - distanceToMove, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

-(void)inputKeyboardWillHide:(NSNotification *)notification{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    if (IS_IOS7) {
        rect = CGRectMake(0.0f, 64, self.view.frame.size.width, self.view.frame.size.height);
    }
    self.view.frame = rect;
    [UIView commitAnimations];
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
        if (vDataArray.count > 0) {
            ChoseProvinceVC *vChosePlaceVC = (ChoseProvinceVC *)[ViewControllerManager getBaseViewController:@"ChoseProvinceVC"];
            vChosePlaceVC.placeArray = vDataArray;
            vChosePlaceVC.delegate = self;
            //显示地区
            [ViewControllerManager showBaseViewController:@"ChoseProvinceVC" AnimationType:vaDefaultAnimation SubType:0];
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"获取省" Notice:@""];

}

#pragma mark - 删除刚刚照得照片
-(void)deleteLocalPhtoto:(PhtotoInfo *)sender{
    //检查是否是刚刚照得照片,有则删除
    if (mImageDatas.count > 0) {
        NSInteger vIndex = [mImageDatas indexOfObject:sender];
        if (vIndex != NSNotFound) {
            [mImageDatas removeObjectAtIndex:vIndex];
        }
    }
}


#pragma mark 上传图片
-(void)postImages:(id)ImageID CompletionBlock:(void (^)(void))block{
    NSMutableArray *vBase64Array = [NSMutableArray array];
    for (PhtotoInfo *vInfo in mImageDatas) {
        NSData *vImageData = UIImagePNGRepresentation(vInfo.photoImage);
        NSString *vBase64Str = [NewGTMBase64 stringByEncodingData:vImageData];
        [vBase64Array addObject:vBase64Str];
    }
    [IDCardCell postIDImages:vBase64Array PhtotoType:2 businessType:ImageID CompletionBlock:^{
        [mImageDatas removeAllObjects];
        if (block) {
            block();
        }
    } Notice:@"正在上传照片"];
}


#pragma mark - 其他业务点击事件
#pragma mark 填写行驶证证照片
-(void)didIDCardCellAddImageButtonClicked:(id)sender{
    [self choseDriveLisenceImage];
}

#pragma mark 选择入户地
- (void)chosePlace{
    [self goToChosePlaceVC];
}


#pragma mark ChoseDistrctVCDelegate
-(void)didChoseProvinceCityVCFinished:(NSDictionary *)sender
{
    if (sender == Nil || sender.count == 0) {
        LOG(@"didFinishChosedPlace传入地区参数为空");
        return;
    }
    self.isChangeData = YES;
    NSString *vProvince = [[sender objectForKey:@"province"] objectForKey:@"name"];
    NSString *vCity = [[sender objectForKey:@"city"] objectForKey:@"name"];
    NSString *awardAdd = [NSString stringWithFormat:@"%@%@",vProvince,vCity];
    UILabel *vLable = (UILabel *)[awardAddCell.contentView viewWithTag:100];
    vLable.text  = awardAdd;
    
    [mDriveLiscenDic setValue:awardAdd forKey:@"awardAdd"];
    [ViewControllerManager backToViewController:@"MyDriveLiscense" Animatation:vaDefaultAnimation SubType:0];
}

#pragma mark 选择好时间
-(void)didConfirmDate:(id)sender{
    IFISNIL(sender);
    self.isChangeData = YES;
    if (mSelectedRow == 1) {
        UILabel *vLable = (UILabel *)[applyDateCell.contentView viewWithTag:100];
        vLable.text  = sender;
        [mDriveLiscenDic setValue:sender forKey:@"applyDate"];
    }else if( mSelectedRow == 3){
        UILabel *vLable = (UILabel *)[replaceDateCell.contentView viewWithTag:100];
        vLable.text  = sender;
        [mDriveLiscenDic setValue:sender forKey:@"replaceDate"];
    }
    [self.mDriveLisenseTableVIew reloadData];
}

#pragma mark 取消选择时间
-(void)didCancleDate:(id)sender{
}

#pragma mark 时间选择器滚动
-(void)valueDidChange:(id)sender{
}

#pragma mark 添加选择时间
-(void)choseRegisterDate{
    if (mChoseRegistDateVC == nil) {
        mChoseRegistDateVC = [[ChoseDateVC alloc] init];
        mChoseRegistDateVC.delegate = self;
    }
    if (mChoseRegistDateVC.view.superview == Nil) {
        [self.view addSubview:mChoseRegistDateVC.view];
    }
}

#pragma mark 添加照相机
-(void)choseDriveLisenceImage{
    if ([[mDriveLiscenDic objectForKey:@"isAudit"] intValue] == 0) {
        if (mTakeDrivePhoto == Nil) {
            mTakeDrivePhoto = [[TakePhotoTool alloc] init];
            mTakeDrivePhoto.delegate = self;
        }
        [mTakeDrivePhoto takePhoto:self];
    }else{
        [self.view makeToast:@"您的驾驶证已经通过审核，不能修改！" duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
    }

}

#pragma mark 照相成功
-(void)didTakePhotoSucces:(id)sender{
    self.isChangeData = YES;
    UIImage *vImage = [UIImage imageWithData:sender];
    PhtotoInfo *vInfo = [[PhtotoInfo alloc] init];
    vInfo.photoImage = vImage;
    vInfo.photoType = ptSelfPhoto;
    
    [mImageDatas addObject:vInfo];
    
    //刷新图片
    NSIndexPath *vIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    [self.mDriveLisenseTableVIew reloadRowsAtIndexPaths:@[vIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    SAFE_ARC_RELEASE(vInfo);
    
}

#pragma mark 删除照片
-(void)didIDCardCellDeletePhotoSuccess:(PhtotoInfo *)sender{
    //检查是否删除的是本地图片
    [self deleteLocalPhtoto:sender];
    //不是本地，则删除URL
    if (sender.phtotURLStr != Nil) {
        NSDictionary *vDriveImageDic = [mDriveLiscenDic objectForKey:@"drivingLicensePhotos"];
        NSMutableArray *vNewImageArray = [NSMutableArray array];
        for (NSString *vImageURL in vDriveImageDic) {
            if (![vImageURL isEqualToString:sender.phtotURLStr]) {
                [vNewImageArray addObject:vImageURL];
            }
        }
        [mDriveLiscenDic setObject:vNewImageArray forKey:@"drivingLicensePhotos"];
    }
    //刷新图片
    NSIndexPath *vIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    [self.mDriveLisenseTableVIew reloadRowsAtIndexPaths:@[vIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark 添加填写驾驶证
-(void)choseDriveLisenceNumber{
    [ViewControllerManager createViewController:@"NickNameVC"];
    NickNameVC *vNickNameVC = (NickNameVC *)[ViewControllerManager getBaseViewController:@"NickNameVC"];
    vNickNameVC.title = @"驾驶证编号";
    vNickNameVC.delegate = self;
    vNickNameVC.isInputWithDigits = YES;
    [ViewControllerManager showBaseViewController:@"NickNameVC" AnimationType:vaDefaultAnimation SubType:0];

}

#pragma mark 驾驶证号填写完毕
-(void)textFieldDidFilled:(NSString *)aStr{
    IFISNIL(aStr);
    self.isChangeData = YES;
    UILabel *vLable = (UILabel *)[drivingLicenseNoCell.contentView viewWithTag:100];
    vLable.text  = aStr;
    [mDriveLiscenDic setValue:aStr forKey:@"drivingLicenseNo"];
}

#pragma mark 保存驾照信息
-(void)saveDriveLisenceButtonTouchDown:(UIButton *)sender{

    id vUserId = [UserManager instanceUserManager].userID;
    
    [mDriveLiscenDic setValue:vUserId forKey:@"userId"];
    
    NSString *drivingLicenseNo = [mDriveLiscenDic objectForKey:@"drivingLicenseNo"];
    if (drivingLicenseNo.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写驾驶证档案号！"];
        return;
    }
    
    NSString *applyDate = [mDriveLiscenDic objectForKey:@"applyDate"];
    if (applyDate.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写驾驶证申领日期！"];
        return;
    }
    
    NSString *awardAdd = [mDriveLiscenDic objectForKey:@"awardAdd"];
    if (awardAdd.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写驾驶证颁发地!"];
        return;
    }
    
    NSString *replaceDate = [mDriveLiscenDic objectForKey:@"replaceDate"];
    if (replaceDate.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写驾驶证换证日期！"];
        return;
    }

    
    [mDriveLiscenDic setValue:@[@""] forKey:@"drivingLicensePhotos"];
    
    [NetManager postDataFromWebAsynchronous:APPURL823 Paremeter:mDriveLiscenDic Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReutnrDic = [NetManager jsonToDic:responseObject];
        NSNumber *vStateNumber = [vReutnrDic objectForKey:@"stateCode"];
        if (vStateNumber != Nil) {
            if ([vStateNumber intValue] == 0) {
                self.isChangeData = NO;
                [self postImages:@"" CompletionBlock:^{
                    [self initCommonData];
                }];
   
                return ;
            }
        }
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"修改驾照信息" Notice:@""];
    
}
@end
