//
//  PersonalInfomationVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-10.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "PersonalInfomationVC.h"
#import "AnimationTransition.h"
#import "NickNameVC.h"
#import "ImageViewHelper.h"
#import "UserManager.h"
#import "NetManager.h"
#import "NewGTMBase64.h"
#import "PhtotoInfo.h"
#import "Toast+UIView.h"

@interface PersonalInfomationVC ()
{
    BOOL isChosedHeadImage;   //修改用户头像
    TakePhotoTool *mTakePhoto;
    NSMutableDictionary *mParemeter;
    UITableViewCell *mHeadImageCell; //头像cell
    UITableViewCell *mNicknameCell;  //昵称
    UITableViewCell *mRealnameCell;  //真实姓名
    UITableViewCell *mSexCell;     //性别
    UITableViewCell *mBirthDayCell;  // 生日
    UITableViewCell *msingatureCell;  //个性签名
    UITableViewCell *mIDNumberCell;   //身份证号码cell
    IDCardCell      *mIDCardCell;     //身份证照片
    NSMutableArray   *imageDatasArray;  //身份证照片信息
    NSData          *mHeadData;
    NSInteger       mSelectedRow;     //选中第几个cell，判断昵称，身份证等
}
//是否改变了用户信息
@property (nonatomic,assign)   BOOL isChangeInfomations;

@end

@implementation PersonalInfomationVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
       self = [super initWithNibName:@"PersonalInfomationVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"PersonalInfomationVC" bundle:aBuddle];
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
    self.title = @"个人资料";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    if (mParemeter == Nil) {
        mParemeter = [[NSMutableDictionary alloc] init];
    }
    if (imageDatasArray == Nil) {
        imageDatasArray = [[NSMutableArray alloc] init];
    }
    [self initWebData];
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [mParemeter removeAllObjects],[mParemeter release];
    [_userInfo release];
    [_MPmenuTableView release];
    [_choseSexView release];
    [mTakePhoto release];
    [_hearViewForPersonInfo release];

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

-(void)setIsChangeInfomations:(BOOL)isChangeInfomations{
    _isChangeInfomations = isChangeInfomations;
    if (isChangeInfomations) {
        UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [vRightButton setTitle:@"保存" forState:UIControlStateNormal];
        [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
        [vRightButton addTarget:self action:@selector(saveButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
        self.navigationItem.rightBarButtonItem = vBarButtonItem;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 88;
    }
    if (indexPath.section == 1 && indexPath.row == 1 ) {
        IDCardCell *vIDCell = [[[NSBundle mainBundle] loadNibNamed:@"IDCardCell" owner:self options:Nil] objectAtIndex:0];
        return vIDCell.frame.size.height;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return self.hearViewForPersonInfo.frame.size.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return self.hearViewForPersonInfo;
    }
    return Nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 7;
    }else if(section == 1){
        return 2;
    }
    return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        vLable.font = [UIFont systemFontOfSize:15];
        vLable.textAlignment = NSTextAlignmentRight;
        vLable.textColor = [UIColor darkGrayColor];
        [vLable setBackgroundColor:[UIColor clearColor]];
        vLable.tag = 101;
        [vCell.contentView addSubview:vLable];
        SAFE_ARC_RELEASE(vLable);
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //左边介绍
            vCell.textLabel.text = @"头像:";
            //显示图片
            UIImageView *vCellImageView = (UIImageView *)[vCell.contentView viewWithTag:100];
            vCellImageView.layer.cornerRadius = 5;
            vCellImageView.layer.masksToBounds = YES;
            vCellImageView.hidden = NO;
            NSString *vHeadImagURLStr = self.userInfo.headerImageUrl;
            
            [vCellImageView setImageWithURL:[NSURL URLWithString:vHeadImagURLStr] PlaceHolder:[UIImage imageNamed:@"lvtubang.png"]];
            if (mHeadData != Nil) {
                [vCellImageView setImage:[UIImage imageWithData:mHeadData]];
            }
            //添加点击头像响应事件
            UIButton *vHeadImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [vHeadImageButton setFrame:vCellImageView.frame];
            [vHeadImageButton addTarget:self action:@selector(headImageClicked:) forControlEvents:UIControlEventTouchUpInside];
            [vCell.contentView addSubview:vHeadImageButton];
            
            //隐藏右边文字介绍
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
            vLable.hidden = YES;
            mHeadImageCell = vCell;
        }else if(indexPath.row == 1){
            //左边介绍
            vCell.textLabel.text = @"姓名:";
            //右边介绍
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
            vLable.hidden = NO;
            vLable.text = self.userInfo.realName;
            mRealnameCell = vCell;
        }else if(indexPath.row == 2){
            //左边介绍
            vCell.textLabel.text = @"电话:";
            //右边介绍
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
            vLable.hidden = NO;
            vLable.text = self.userInfo.phone;
        }
        else if(indexPath.row == 3){
            //左边介绍
            vCell.textLabel.text = @"昵称:";
            //右边介绍
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
             vLable.hidden = NO;
            vLable.text = self.userInfo.nickname;
            mNicknameCell = vCell;
        }else if(indexPath.row == 4){
            //左边介绍
            vCell.textLabel.text = @"性别:";
            //右边介绍
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
            vLable.text = self.userInfo.sex;
            mSexCell = vCell;
        }else if(indexPath.row == 5){
            //左边介绍
            vCell.textLabel.text = @"生日:";
            //右边介绍
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
            vLable.hidden = NO;
            vLable.text = self.userInfo.birthday;
            mBirthDayCell = vCell;
        }else if(indexPath.row == 6){
            //左边介绍
            vCell.textLabel.text = @"签名:";
            //右边介绍
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
            vLable.hidden = NO;
            vLable.text = self.userInfo.signature;
            msingatureCell = vCell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //左边介绍
            vCell.textLabel.text = @"身份证号:";
            //右边介绍
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
            vLable.hidden = NO;
            if ([self.userInfo.idNumber intValue] > 0) {
                NSString *vIDNumberStr = [NSString stringWithFormat:@"%@",self.userInfo.idNumber];
                vIDNumberStr = vIDNumberStr.length > 0 ? vIDNumberStr :@"";
                vLable.text = vIDNumberStr ;
            }
  
            mIDNumberCell = vCell;
        }else if(indexPath.row == 1){
            static NSString *vIdIdentify = @"idCell";
            IDCardCell *vCell = (IDCardCell*)[tableView dequeueReusableCellWithIdentifier:vIdIdentify];
            if (vCell == Nil) {
                vCell = [[[NSBundle mainBundle] loadNibNamed:@"IDCardCell" owner:self options:Nil] objectAtIndex:0];
                vCell.delegate = self;
            }
            
            //获得身份证所有图片
            NSMutableArray *vImageViewsArray = [NSMutableArray array];
            for (NSString *vImageStr in self.userInfo.idImgs) {
                PhtotoInfo *vInfo = [[PhtotoInfo alloc] init];
                vInfo.phtotURLStr = vImageStr;
                vInfo.photoType = ptIDCard;
                //通过审核不能被修改
                if ([self.userInfo.isAudit intValue] == 1) {
                    vInfo.photoType = ptBuness;
                }
                [vImageViewsArray addObject:vInfo];
                SAFE_ARC_RELEASE(vInfo);
            }
            //
            [vCell initCell];
            //设置显示身份证图片
            [vCell setCell:vImageViewsArray];
            //重设Cell中的本地图片
            [vCell setCell:imageDatasArray];

            mIDCardCell = vCell;
            //移动到最新上传的图片位置++
            [mIDCardCell moveToIndexOfImage:mIDCardCell.idImagecount];
            
            return vCell;
        }
    }

    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        mSelectedRow = indexPath.row;
        if (indexPath.row == 0) {
            [self choseHeadImage:indexPath.row];
        }else if (indexPath.row == 1){
            [self nickNameClicked];
        }else if (indexPath.row == 3){
            [self nickNameClicked];
        }else if (indexPath.row == 4){
            [self choseSexClicked];
        }else if (indexPath.row == 5){
            [self choseBirthdayClicked];
        }else if (indexPath.row == 6){
            [self signatureClicked];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){
            mSelectedRow = 100;
            if ([self.userInfo.isAudit intValue] == 0) {
                [self IDCardClicked];
            }else{
                [self.view makeToast:@"您的身份证已通过审核，不能再修改！" duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
            }
            
        }else if (indexPath.row == 1){
        }
    }
}

#pragma mark - 其他辅助功能
-(void)initWebData{
    //拼接请求个人资料参数
    id vUserID = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:vUserID,@"userId", nil];
    //请求个人资料
    [NetManager postDataFromWebAsynchronous:APPURL801 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        //更新个人资料信息
        if (vDataDic.count > 0) {
            [[UserManager instanceUserManager] setUserInfomation:vDataDic];
            self.userInfo = [UserManager instanceUserManager].userInfo;
            [self.MPmenuTableView reloadData];
        }
        
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"请求个人资料" Notice:@""];
    //头像初始化为空，如果有更新头像，那么会将新的头像保存
    [mParemeter setObject:@"" forKey:@"headerPhone"];
}

#pragma mark - 删除刚刚照得照片
-(void)deleteLocalPhtoto:(PhtotoInfo *)sender{
    //检查是否是刚刚照得照片,有则删除
    if (imageDatasArray.count > 0) {
        NSInteger vIndex = [imageDatasArray indexOfObject:sender];
        if (vIndex != NSNotFound) {
            [imageDatasArray removeObjectAtIndex:vIndex];
        }
    }
}


#pragma mark 上传图片
-(void)postImages:(id)ImageID CompletionBlock:(void (^)(void))block{
    NSMutableArray *vBase64Array = [NSMutableArray array];
    for (PhtotoInfo *vInfo in imageDatasArray) {
        NSData *vImageData = UIImagePNGRepresentation(vInfo.photoImage);
        NSString *vBase64Str = [NewGTMBase64 stringByEncodingData:vImageData];
        [vBase64Array addObject:vBase64Str];
    }
    [IDCardCell postIDImages:vBase64Array PhtotoType:1 businessType:ImageID CompletionBlock:^{
        [imageDatasArray removeAllObjects];
        if (block) {
            block();
        }
    } Notice:@"正在上传照片"];
}

#pragma mark - 其他业务点击事件
#pragma mark 选择头像
//头像
-(void)choseHeadImage:(NSInteger)aIndex{
    //判断是否是选择头像
    if (aIndex == 0) {
        isChosedHeadImage = YES;
    }else if ( aIndex == 1){
        isChosedHeadImage = NO;
    }
    if (mTakePhoto == Nil) {
        mTakePhoto = [[TakePhotoTool alloc] init];
        mTakePhoto.delegate = self;
    }
    [mTakePhoto takePhoto:self];
}

#pragma mark - TakePhotoSucces
#pragma mark 头像选择成功
-(void)didTakePhotoSucces:(id)sender{
    if (sender == nil) {
        LOGERROR(@"didTakePhotoSucces");
        return;
    }
    self.isChangeInfomations = YES;
    if (isChosedHeadImage) {
        mHeadData = sender;
        //刷新图片
        NSIndexPath *vIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.MPmenuTableView reloadRowsAtIndexPaths:@[vIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        UIImage *vImage =  [UIImage imageWithData:sender];
        PhtotoInfo *vInfo = [[PhtotoInfo alloc] init];
        vInfo.photoImage = vImage;
        vInfo.photoType = ptSelfPhoto;
        
        //保存保险照片
        [imageDatasArray addObject:vInfo];
        
        //刷新图片
        NSIndexPath *vIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        [self.MPmenuTableView reloadRowsAtIndexPaths:@[vIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark 头像删除成功
-(void)didIDCardCellDeletePhotoSuccess:(PhtotoInfo *)sender{
    //检查是否删除的是本地图片
    [self deleteLocalPhtoto:sender];
    //不是本地，则删除URL
    if (sender.phtotURLStr != Nil) {
        [self.userInfo.idImgs removeObject:sender.phtotURLStr];
    }
    //刷新图片
    NSIndexPath *vIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    [self.MPmenuTableView reloadRowsAtIndexPaths:@[vIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark 选择昵称
//选择昵称
-(void)nickNameClicked{
    [ViewControllerManager createViewController:@"NickNameVC"];
    NickNameVC *vNickNameVC = (NickNameVC *)[ViewControllerManager getBaseViewController:@"NickNameVC"];
    vNickNameVC.delegate = self;
    if (mSelectedRow == 3) {
        vNickNameVC.title = @"昵称";
        vNickNameVC.inputTextField.keyboardType = UIKeyboardTypeDefault;
    }else if( mSelectedRow == 1){
        vNickNameVC.title = @"姓名";
        vNickNameVC.inputTextField.keyboardType = UIKeyboardTypeDefault;
    }
    [ViewControllerManager showBaseViewController:@"NickNameVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 选择性别
//选择性别
-(void)choseSexClicked{
    if (self.choseSexView == Nil) {
        self.choseSexView = [[ChosePickerVC alloc] init];
        self.choseSexView.delegate = self;
    }
    if (self.choseSexView.view.superview == nil) {
        [self.view addSubview:self.choseSexView.view];
    }
}
#pragma mark  性别数据源
-(NSArray *)pickerDataSource:(id)sender{
    NSArray *vSexArray = [NSArray arrayWithObjects:@"男",@"女",nil];
    return vSexArray;
}
#pragma mark 性别确定
-(void)didConfirmPicker:(id)sender{
    if (sender == Nil) {
        LOGERROR(@"didConfirmPicker");
        return;
    }
    self.isChangeInfomations = YES;
    NSIndexPath *vIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    UITableViewCell *vCell = [self.MPmenuTableView cellForRowAtIndexPath:vIndexPath];
    //右边介绍
    UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
    vLable.hidden = NO;
    vLable.text = sender;
    [mParemeter setObject:sender forKey:@"sex"];
    //显示UI
    UILabel *vSexLable = (UILabel *) [mSexCell.contentView viewWithTag:101];
    vSexLable.text = sender;
}

#pragma mark 性别取消
-(void)didCanclePicker:(id)sender{
}

#pragma mark 选择生日
//选择生日
-(void)choseBirthdayClicked{
    if (self.choseDateVC == nil) {
        self.choseDateVC = [[ChoseDateVC alloc] init];
        self.choseDateVC.delegate = self;
    }
    if (self.choseDateVC.view.superview == Nil) {
        [self.view addSubview:self.choseDateVC.view];
    }
}
//确定选择时间
-(void)didConfirmDate:(id)sender{
    if (sender == Nil) {
        LOGERROR(@"didConfirmDate");
        return;
    }
    self.isChangeInfomations = YES;
    [mParemeter setObject:sender forKey:@"birthday"];
    //显示UI
    UILabel *vSexLable = (UILabel *) [mBirthDayCell.contentView viewWithTag:101];
    vSexLable.text = sender;
}
//取消选择时间
-(void)didCancleDate:(id)sender{
}
//时间选择器滚动
-(void)valueDidChange:(id)sender{
}

#pragma mark 填写签名
-(void)signatureClicked{
    [ViewControllerManager createViewController:@"FillSignatureVC"];
    FillSignatureVC *vVC = (FillSignatureVC *)[ViewControllerManager getBaseViewController:@"FillSignatureVC"];
    vVC.delegate = self;
    [ViewControllerManager showBaseViewController:@"FillSignatureVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark FillSignatureVCDelegate
-(void)didFillSignatureFinished:(id)sender{
    if (sender == Nil) {
        LOGERROR(@"didFillSignatureFinished");
        return;
    }
    self.isChangeInfomations = YES;
    [mParemeter setObject:sender forKey:@"signature"];
    //显示UI
    UILabel *vSexLable = (UILabel *) [msingatureCell.contentView viewWithTag:101];
    vSexLable.text = sender;
}

#pragma mark 填写身份证号
-(void)IDCardClicked{
    [ViewControllerManager createViewController:@"NickNameVC"];
    NickNameVC *vNickNameVC = (NickNameVC *)[ViewControllerManager getBaseViewController:@"NickNameVC"];
    vNickNameVC.delegate = self;
    vNickNameVC.title = @"身份证号";
    [ViewControllerManager showBaseViewController:@"NickNameVC" AnimationType:vaDefaultAnimation SubType:0];

}

#pragma mark 身份证号或昵称填写完毕
-(void)textFieldDidFilled:(NSString *)aStr{
    if (aStr == Nil) {
        LOGERROR(@"textFieldDidFilled");
        return;
    }
    self.isChangeInfomations = YES;
    if (mSelectedRow == 1) {
        [mParemeter setObject:aStr forKey:@"realName"];
        //显示UI
        UILabel *vRealNameLable = (UILabel *) [mRealnameCell.contentView viewWithTag:101];
        vRealNameLable.text = aStr;
    }else if (mSelectedRow == 3) {
        [mParemeter setObject:aStr forKey:@"nickname"];
        //显示UI
        UILabel *vSexLable = (UILabel *) [mNicknameCell.contentView viewWithTag:101];
        vSexLable.text = aStr;
    }else if (mSelectedRow == 100){
        //显示UI
        UILabel *vIDNumberLable = (UILabel *) [mIDNumberCell.contentView viewWithTag:101];
        vIDNumberLable.text = aStr;
    }
}

#pragma mark IDCardCellDelegate
#pragma mark 添加身份证照片
-(void)didIDCardCellAddImageButtonClicked:(id)sender{
    if ([self.userInfo.isAudit intValue] == 0) {
        [self choseHeadImage:1];
    }else{
        [self.view makeToast:@"您的身份证已通过审核，不能再修改！" duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
    }
}

/*"headerPhone": "String:头像（base64）",
 "nickname": "String:昵称",
 "sex": "String:男、女",
 "birthday": "String:生日",
 "signature": "String:个性签名"
*/
#pragma mark 点击保存
-(void)saveButtonTouchDown:(id)sender{
    [mParemeter setObject:self.userInfo.usertId forKey:@"userId"];
    //再次保存个人信息，因为有些资料为空时，也要传

    //上传的头像
    if (mHeadData != Nil) {
        NSString *imgBase64Str = [NewGTMBase64 stringByEncodingData:mHeadData];
        [mParemeter setObject:imgBase64Str forKey:@"headerPhone"];
        //移除缓存
        UIImageView *vImageView = [[UIImageView alloc] init];
        [vImageView removeImageWithURLStr:self.userInfo.headerImageUrl];
        vImageView = Nil;
        
        mHeadData = Nil;
    }
    
    UILabel *vRealNameLable = (UILabel *) [mRealnameCell.contentView viewWithTag:101];
    IFISNIL(vRealNameLable.text);
    [mParemeter setObject:vRealNameLable.text forKey:@"realName"];
    
    UILabel *vNickLable = (UILabel *) [mNicknameCell.contentView viewWithTag:101];
    IFISNIL(vNickLable.text);
    [mParemeter setObject:vNickLable.text forKey:@"nickname"];
    
    UILabel *vSexLable = (UILabel *) [mSexCell.contentView viewWithTag:101];
    IFISNIL(vSexLable.text);
    [mParemeter setObject:vSexLable.text forKey:@"sex"];
    
    UILabel *vBirthLable = (UILabel *) [mBirthDayCell.contentView viewWithTag:101];
    if (vBirthLable.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"生日不能为空！"];
        return;
    }
    [mParemeter setObject:vBirthLable.text forKey:@"birthday"];
    
    UILabel *vSignLable = (UILabel *) [msingatureCell.contentView viewWithTag:101];
    IFISNIL(vSignLable.text);
    [mParemeter setObject:vSignLable.text forKey:@"signature"];
    
    UILabel *vIDNumberLable = (UILabel *) [mIDNumberCell.contentView viewWithTag:101];
    //验证身份证号
    if (vIDNumberLable.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写身份证！"];
        return;
    }
    IFISNIL(vIDNumberLable.text);
    [mParemeter setObject:vIDNumberLable.text forKey:@"idNumber"];
    //验证身份证图片
    if (self.userInfo.idImgs.count == 0 && imageDatasArray.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传身份证图片！"];
        return;
    }
    [NetManager postDataFromWebAsynchronous:APPURL802 Paremeter:mParemeter Success:^(NSURLResponse *response, id responseObject) {
        //更新成功则设为NO,隐藏保存按钮，信息将不会被再次提交
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSNumber *vReturnState = [vReturnDic objectForKey:@"stateCode"];
        if ([vReturnState intValue] == 0) {
            self.isChangeInfomations = NO;
            if ([_delegate respondsToSelector:@selector(didPersonalInfomationVCChanged:)]) {
                [_delegate didPersonalInfomationVCChanged:Nil];
            }
            if (imageDatasArray.count > 0) {
                //上传身份证到服务器
                [self postImages:@"" CompletionBlock:^{
                    [self initWebData];
                }];
            }
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"修改个人资料" Notice:@""];

}

#pragma mark 点击头像
-(void)headImageClicked:(id)sender{
    PhtotoInfo *vInfo = [[PhtotoInfo alloc] init];
    vInfo.photoImage = ((UIImageView *)[mHeadImageCell.contentView viewWithTag:100]).image;
    vInfo.photoType = ptBuness;
    [ViewControllerManager createViewController:@"PhotoBrowserVC"];
    PhotoBrowserVC *vVC = (PhotoBrowserVC *)[ViewControllerManager getBaseViewController:@"PhotoBrowserVC"];
    vVC.samplePictures = [NSMutableArray arrayWithObject:vInfo];
    [ViewControllerManager showBaseViewController:@"PhotoBrowserVC" AnimationType:vaDefaultAnimation SubType:0];
    [vVC moveToIndex:0 IsURLDataSource:NO];
    vInfo = Nil;
}

- (void)viewDidUnload {
   [self setMPmenuTableView:nil];
    [self setChoseSexView:nil];
    [self setHearViewForPersonInfo:nil];
   [super viewDidUnload];
}
@end
