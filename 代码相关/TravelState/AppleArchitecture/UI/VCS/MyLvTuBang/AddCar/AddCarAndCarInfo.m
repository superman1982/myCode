//
//  AddCarAndCarInfo.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-14.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "AddCarAndCarInfo.h"
#import "NetManager.h"
#import "IDCardCell.h"
#import "NewGTMBase64.h"
#import "UserManager.h"
#import "PhtotoInfo.h"
#import "CheckManeger.h"
#import "Toast+UIView.h"
#import "CheckManeger.h"

@interface AddCarAndCarInfo ()
{
    ChoseDateVC *mChoseRegistDateVC; //选择时间
    TakePhotoTool *mTakeDrivePhoto;  //行驶至图片
    BOOL isShowChanese;
    BOOL isNeedToMoveFrame;
    UITableViewCell *addCarImageCell;       //添加车辆图片cell
    NSMutableDictionary *mParemeter;       //网络请求参数
    NSInteger isDefaultCar;              //是否为默认车辆
   IDCardCell      *mIDCardCell;       //添加驾照图片
    NSMutableArray *mImageDatas;       //添加的行驶证数据，上传到服务器
    NSInteger     mSeletedRow;         //当前选择的行
    NSDictionary *mCarTypeDic;       //选择的车辆类型信息
}
//账号
@property (nonatomic,retain) UITextField *carLisenceField;
@property (nonatomic,retain) UITextField *carBrandField;
@property (nonatomic,retain) UITextField *carSetsField;
@property (nonatomic,retain) UITextField *carRegisterField;
@property (nonatomic,retain) UITextField *yearCheckField;
@property (nonatomic,retain) UITextField *drivefileNumberField;
@property (nonatomic,retain) UITextField *carEnginField;
@property (nonatomic,retain) UITextField *carDriveField;
@property (nonatomic,retain) UITextField *carDengJiField;

@property (nonatomic,assign) BOOL isChangedInfo;
@property (nonatomic,assign) BOOL isAudit;
@end

@implementation AddCarAndCarInfo
//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"AddCarAndCarInfo_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"AddCarAndCarInfo" bundle:aBuddle];
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
    mParemeter = [[NSMutableDictionary alloc] init];
    mImageDatas = [[NSMutableArray alloc] init];
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_carDic release];
    [mImageDatas removeAllObjects];
    [mImageDatas release];
    [mParemeter removeAllObjects];
    [mParemeter release];
    [mTakeDrivePhoto release];
    [_carLisenceField release];
    [_carBrandField release];
    [_carSetsField release];
    [_carRegisterField release];
    [_yearCheckField release];
    [_carEnginField release];
    [_carDriveField release];
    [_carDengJiField release];
    [_carInfoTableView release];
    [_footerViewForDefaultCar release];
    [_headerViewForCarInfo release];
    [mChoseRegistDateVC release];
    [_headerViewForAddCar release];
    [_contentView release];
    [_carInfoTableView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.carInfoTableView.clickeDelegate = self;
    self.carInfoTableView.frame = CGRectMake(0, 0, 320, self.contentView.frame.size.height - 64);
    [self.contentView addSubview:self.carInfoTableView];
    
    //设置默认车辆状态
    if (self.carDic.count > 0) {
        isDefaultCar = [[self.carDic objectForKey:@"isDefault"] intValue];
        if (isDefaultCar) {
            [self.defaultCheckButton setBackgroundImage:[UIImage imageNamed:@"addCar_checkbox_btn_select"] forState:UIControlStateNormal];
        }
    }
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
    [self setCarInfoTableView:nil];
    [self setFooterViewForDefaultCar:nil];
    [self setHeaderViewForCarInfo:nil];
    [self setHeaderViewForAddCar:nil];
    [self setContentView:nil];
    [self setCarInfoTableView:nil];
    [super viewDidUnload];
}

//添加确定
-(void)setIsAddCar:(BOOL)isAddCar{
    _isAddCar = isAddCar;
    if (_isAddCar == YES) {
        self.title = @"添加爱车";
        UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [vRightButton setTitle:@"确定" forState:UIControlStateNormal];
        [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
        [vRightButton addTarget:self action:@selector(saveButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
        self.navigationItem.rightBarButtonItem = vBarButtonItem;
    }else{
        self.title = @"我的爱车";
    }
}

-(void)setIsChangedInfo:(BOOL)isChangedInfo{
    //没有添加爱车时，显示保存信息
    if (!self.isAddCar) {
        if (isChangedInfo) {
            UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [vRightButton setTitle:@"保存" forState:UIControlStateNormal];
            [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
            [vRightButton addTarget:self action:@selector(updateButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
            self.navigationItem.rightBarButtonItem = vBarButtonItem;
        }else{
            self.navigationItem.rightBarButtonItem = Nil;
        }
        
        _isChangedInfo = isChangedInfo;
    }

}

-(void)setIsAudit:(BOOL)isAudit{
    _isAudit = isAudit;
    if (isAudit) {
        //让UI不能被改变
        [self setUnChangedAble];
    }
}

-(void)back{
    if (_isAddCar) {
        if (self.carLisenceField.text.length > 0
            || self.carBrandField.text.length > 0
            || self.carSetsField.text.length > 0
            || self.carRegisterField.text.length > 0
            || self.yearCheckField.text.length > 0) {
            UIAlertView *vAlerView =[[UIAlertView alloc] initWithTitle:@"" message:@"您的车辆信息未保存，确定退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [vAlerView show];
            SAFE_ARC_RELEASE(vAlerView);
        }else{
            [super back];
        }
    }else{
        [super back];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
    }else{
        [super back];
    }
}
-(void)setCarDic:(NSMutableDictionary *)carDic{
    _carDic = [[NSMutableDictionary alloc] initWithDictionary:carDic];

    if (_carDic.count > 0) {
        self.carLisenceField.text = [_carDic objectForKey:@"carNumber"];
        
        self.carBrandField.text = [_carDic objectForKey:@"model"];
        
        NSNumber *vSatNumber = [_carDic objectForKey:@"seatNumber"];
        IFISNILFORNUMBER(vSatNumber);
        NSString *vSitStr = [vSatNumber intValue] == 0 ? @"" : [NSString stringWithFormat:@"%@",vSatNumber];
        self.carSetsField.text = vSitStr;
        
        self.carRegisterField.text = [_carDic objectForKey:@"buyDate"];
        
        self.yearCheckField.text = [_carDic objectForKey:@"checkDate"];
        IFISNIL(self.yearCheckField.text);
        
        self.drivefileNumberField.text =[_carDic objectForKey:@"travelCard"];
        IFISNIL(self.drivefileNumberField.text);
        
        self.carEnginField.text = [_carDic objectForKey:@"engineNumber"];
        IFISNIL(self.carEnginField.text);
        
        self.carDriveField.text = [_carDic objectForKey:@"frameNumber"];
        IFISNIL(self.carDriveField.text);
        
        self.carDengJiField.text = [_carDic objectForKey:@"cerCode"];
        IFISNIL(self.carDengJiField.text);
    }
    
}


-(UITextField *)carLisenceField{
    if (_carLisenceField == nil) {
        _carLisenceField = [[UITextField alloc] initWithFrame:CGRectMake(80, 7, 160, 30)];
        _carLisenceField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _carLisenceField.borderStyle = UITextBorderStyleRoundedRect;
        _carLisenceField.returnKeyType = UIReturnKeyDone;
        _carLisenceField.font = [UIFont systemFontOfSize:15];
        _carLisenceField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _carLisenceField.delegate = self;
    }
    
    return _carLisenceField;
}

-(UITextField *)carBrandField{
    if (_carBrandField == Nil) {
        _carBrandField = [[UITextField alloc] initWithFrame:CGRectMake(80, 7, 160, 30)];
        _carBrandField.borderStyle = UITextBorderStyleNone;
        _carBrandField.returnKeyType = UIReturnKeyDone;
        _carBrandField.delegate = self;
        _carBrandField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _carBrandField.font = [UIFont systemFontOfSize:15];
        _carBrandField.userInteractionEnabled = NO;
    }
    return _carBrandField;
}

-(UITextField *)carSetsField{
    if (_carSetsField == Nil) {
        _carSetsField = [[UITextField alloc] initWithFrame:CGRectMake(80, 7, 160, 30)];
        _carSetsField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _carSetsField.borderStyle = UITextBorderStyleRoundedRect;
        _carSetsField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _carSetsField.keyboardType = UIKeyboardTypeNumberPad;
        _carSetsField.returnKeyType = UIReturnKeyDone;
        _carSetsField.font = [UIFont systemFontOfSize:15];
        _carSetsField.delegate = self;
    }
    return _carSetsField;
}

-(UITextField *)carRegisterField{
    if (_carRegisterField == Nil) {
        _carRegisterField = [[UITextField alloc] initWithFrame:CGRectMake(80, 7, 160, 30)];
        _carRegisterField.borderStyle = UITextBorderStyleNone;
        _carRegisterField.returnKeyType = UIReturnKeyDone;
        _carRegisterField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _carRegisterField.delegate = self;
        _carRegisterField.font = [UIFont systemFontOfSize:15];
        _carRegisterField.userInteractionEnabled = NO;
    }
    return _carRegisterField;
}

-(UITextField *)yearCheckField{
    if (_yearCheckField == Nil) {
        _yearCheckField = [[UITextField alloc] initWithFrame:CGRectMake(80, 7, 160, 30)];
        _yearCheckField.borderStyle = UITextBorderStyleNone;
        _yearCheckField.returnKeyType = UIReturnKeyDone;
        _yearCheckField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _yearCheckField.delegate = self;
        _yearCheckField.font = [UIFont systemFontOfSize:15];
        _yearCheckField.userInteractionEnabled = NO;
    }
    return _yearCheckField;
}

-(UITextField *)drivefileNumberField{
    if (_drivefileNumberField == Nil) {
        _drivefileNumberField = [[UITextField alloc] initWithFrame:CGRectMake(80, 7, 160, 30)];
        _drivefileNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _drivefileNumberField.borderStyle = UITextBorderStyleRoundedRect;
        _drivefileNumberField.returnKeyType = UIReturnKeyDone;
        _drivefileNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _drivefileNumberField.font = [UIFont systemFontOfSize:15];
        _drivefileNumberField.delegate = self;
    }
    return _drivefileNumberField;
}

-(UITextField *)carEnginField{
    if (_carEnginField == Nil) {
        _carEnginField = [[UITextField alloc] initWithFrame:CGRectMake(80, 7, 160, 30)];
        _carEnginField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _carEnginField.borderStyle = UITextBorderStyleRoundedRect;
        _carEnginField.returnKeyType = UIReturnKeyDone;
        _carEnginField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _carEnginField.font = [UIFont systemFontOfSize:15];
        _carEnginField.delegate = self;
    }
    return _carEnginField;
}

-(UITextField *)carDriveField{
    if (_carDriveField == Nil) {
        _carDriveField = [[UITextField alloc] initWithFrame:CGRectMake(80, 7, 160, 30)];
        _carDriveField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _carDriveField.borderStyle = UITextBorderStyleRoundedRect;
        _carDriveField.returnKeyType = UIReturnKeyDone;
        _carDriveField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _carDriveField.font = [UIFont systemFontOfSize:15];
        _carDriveField.delegate = self;
    }
    return _carDriveField;
}

-(UITextField *)carDengJiField{
    if (_carDengJiField == Nil) {
        _carDengJiField = [[UITextField alloc] initWithFrame:CGRectMake(80, 7, 160, 30)];
        _carDengJiField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _carDengJiField.borderStyle = UITextBorderStyleRoundedRect;
        _carDengJiField.returnKeyType = UIReturnKeyDone;
        _carDengJiField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _carDengJiField.font = [UIFont systemFontOfSize:15];
        _carDengJiField.delegate = self;
    }
    return _carDengJiField;
}

#pragma mark UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([_delegate respondsToSelector:@selector(titleForHeaderView:)]) {
        NSString *vTitle = [_delegate titleForHeaderView:Nil];
        return vTitle;
    }
    //添加车辆时，设置是title
    if (_isAddCar) {
        return @"以下用于车辆的违章查询及车务代办，可选填";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        if ([_delegate respondsToSelector:@selector(heightForHeaderViewInSectionOne:)]) {
            NSInteger vHight = [_delegate heightForHeaderViewInSectionOne:Nil];
            return vHight;
        }
       //添加车辆时，header高度为20
        if (_isAddCar) {
            return self.headerViewForAddCar.frame.size.height;
        }else{
       //查看车辆信息时，自定义HeaderView
            return self.headerViewForCarInfo.frame.size.height;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //查看车辆信息时，自定义HeaderView
    if (!_isAddCar) {
        return self.headerViewForCarInfo;
    }else{
        return self.headerViewForAddCar;
    }
    return Nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
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
    }else if(section == 1){
        return 6;
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
        vCell.accessoryType = UITableViewCellAccessoryNone;
        vCell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UILabel *vLable = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 150, 21)];
        vLable.font = [UIFont systemFontOfSize:15];
        vLable.textColor = [UIColor darkGrayColor];
        vLable.textAlignment = NSTextAlignmentRight;
        vLable.tag = 100;
        //如果是添加车辆隐藏右边文字
        if (_isAddCar) {
            vLable.hidden = YES;
        }
        [vCell.contentView addSubview:vLable];
        SAFE_ARC_RELEASE(vLable);
        
        //设置图片
        UIImageView *vCellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(243, 14, 15, 15)];
        vCellImageView.tag = 101;
        vCellImageView.hidden = YES;
        vCellImageView.image = [UIImage imageNamed:@"carDetail_star_btn"];
        [vCellImageView setBackgroundColor:[UIColor clearColor]];
        [vCell.contentView addSubview:vCellImageView];
        SAFE_ARC_RELEASE(vCellImageView);
    }
   
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            vCell.textLabel.text = @"车辆牌照:";
            
            [vCell.contentView addSubview:self.carLisenceField];
            
            UIImageView *vImageView = (UIImageView *)[vCell.contentView viewWithTag:101];
            if ([[_carDic objectForKey:@"isDefault"] intValue] == 1) {
                vImageView.hidden = NO;
            }else{
                vImageView.hidden = YES;
            }
        }
        else if (indexPath.row == 1) {
            vCell.textLabel.text = @"车辆类型:";
            vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            [vCell.contentView addSubview:self.carBrandField];
            
            UIImageView *vImageView = (UIImageView *)[vCell.contentView viewWithTag:101];
            vImageView.hidden = YES;
        }else if (indexPath.row == 2){
            vCell.textLabel.text = @"座 位 数:";

            [vCell.contentView addSubview:self.carSetsField];
            UIImageView *vImageView = (UIImageView *)[vCell.contentView viewWithTag:101];
            vImageView.hidden = YES;

        }else if (indexPath.row == 3){
            vCell.textLabel.text = @"登记时间:";
            vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            [vCell.contentView addSubview:self.carRegisterField];
        }else if (indexPath.row == 4){
            vCell.textLabel.text = @"年审时间:";
            vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            [vCell.contentView addSubview:self.yearCheckField];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            vCell.textLabel.text = @"发动机号:";
            
            [vCell.contentView addSubview:self.carEnginField];
        }else if (indexPath.row == 1){
            vCell.textLabel.text = @"车架号码:";
            
            [vCell.contentView addSubview:self.carDriveField];
        } else if (indexPath.row == 2) {
            vCell.textLabel.text = @"行驶证号:";
            
            [vCell.contentView addSubview:self.drivefileNumberField];
        }else if (indexPath.row == 3){
            vCell.textLabel.text = @"登记证号:";
            
            [vCell.contentView addSubview:self.carDengJiField];
        }else if (indexPath.row == 4){
            static NSString *vIdIdentify = @"idCell";
            IDCardCell *vCell = (IDCardCell*)[tableView dequeueReusableCellWithIdentifier:vIdIdentify];
            if (vCell == Nil) {
                vCell = [[[NSBundle mainBundle] loadNibNamed:@"IDCardCell" owner:self options:Nil] objectAtIndex:0];
                vCell.delegate = self;
            }
            vCell.cellLable.text = @"行驶证照片:";
            
            NSDictionary *vImageDic = [_carDic objectForKey:@"drivingLicenseImgs"];
            //获得保险单所有图片
            NSMutableArray *vImageViewsArray = [NSMutableArray array];
            for (NSString *vImageStr in vImageDic) {
                PhtotoInfo *vInfo = [[PhtotoInfo alloc] init];
                vInfo.phtotURLStr = vImageStr;
                vInfo.businessId = [_carDic objectForKey:@"carId"];
                vInfo.photoType = ptRoadLisence;
                vInfo.isAudio = [[_carDic objectForKey:@"isAudit"] boolValue];
                [vImageViewsArray addObject:vInfo];
                SAFE_ARC_RELEASE(vInfo);
            }
            
            [vCell initCell];
            //设置显示身份证图片
            [vCell setCell:vImageViewsArray];
            //重设Cell中的本地图片
            [vCell setCell:mImageDatas];
            
            mIDCardCell = vCell;
            //移动到最新上传的图片位置++
            [mIDCardCell moveToIndexOfImage:mIDCardCell.idImagecount];
            
            return vCell;

        }else if (indexPath.row == 5){
            UITableViewCell *vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fuck"];
            [vCell.contentView addSubview:self.footerViewForDefaultCar];
            return vCell;
        }
    }
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [self choseCarType];
        }else if (indexPath.row == 3 || indexPath.row == 4) {
            mSeletedRow = indexPath.row;
            [self choseRegisterDate];
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 3) {
        }
    }
}

#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    //结束编辑开启移动
    _carInfoTableView.scrollEnabled = YES;
    return YES;
}

#define CARENGINFILDHIGHT 70
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.isAudit = [[self.carDic objectForKey:@"isAudit"] boolValue];
    if(self.isAudit){
        if (textField == self.drivefileNumberField) {
            [self.view makeToast:@"您的行驶证已通过审核，不能再修改！" duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
            return;
        }
    }
    self.isChangedInfo = YES;
    CGRect frame = [textField convertRect:textField.frame toView:self.view.window];
    int offset = frame.origin.y + 32 - (mHeight + 20 - 216.0-36);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.contentView.frame.size.width;
    float height = self.contentView.frame.size.height;
    isNeedToMoveFrame = NO;
    if(offset > 0){
        CGRect vViewFrame = self.contentView.frame;
        CGRect rect = CGRectMake(0.0f,vViewFrame.origin.y -offset ,width,height);
        
        if (!isShowChanese){
            rect.origin.y = rect.origin.y + 36;
            isNeedToMoveFrame = YES;
        }
        self.contentView.frame = rect;
    }
    [UIView commitAnimations];
    //编辑状态禁止表移动
    _carInfoTableView.scrollEnabled = NO;
}

//结束输入
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //结束编辑开启移动
    _carInfoTableView.scrollEnabled = YES;
    if (textField == self.carSetsField) {
        if (self.carSetsField.text.length > 0) {
            BOOL vIfisAllowed = [CheckManeger checkIfIsDigits:self.carSetsField.text];
            if (!vIfisAllowed) {
                [self.view makeToast:@"请输入数字！" duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
                self.carSetsField.text = @"";
            }
        }
    }
}

#pragma mark 屏幕点击事件
-(void)tableTouchBegain:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(self.carLisenceField.frame,vTouchPoint)
        &&!CGRectContainsPoint(self.carSetsField.frame, vTouchPoint)
        &&!CGRectContainsPoint(self.carEnginField.frame, vTouchPoint)
        &&!CGRectContainsPoint(self.carDriveField.frame, vTouchPoint)
        &&!CGRectContainsPoint(self.carDengJiField.frame, vTouchPoint)) {
        [self.carLisenceField resignFirstResponder];
        [self.carSetsField resignFirstResponder];
        [self.carEnginField resignFirstResponder];
        [self.carDriveField resignFirstResponder];
        [self.carDengJiField resignFirstResponder];
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
            self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y + 36, self.contentView.frame.size.width, self.contentView.frame.size.height);
        }];
        return;
    }

    if (isNeedToMoveFrame && distanceToMove > 0 ) {
        isShowChanese = YES;
        [UIView animateWithDuration:.3 animations:^{
            self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y - distanceToMove, self.contentView.frame.size.width, self.contentView.frame.size.height);
        }];
    }
}

-(void)inputKeyboardWillHide:(NSNotification *)notification{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.contentView.frame.size.width, self.contentView.frame.size.height);
    self.contentView.frame = rect;
    [UIView commitAnimations];
}

#pragma mark - 其他辅助功能
#pragma mark 清空UI
-(void)clearUI{
    self.carLisenceField.text = @"";
    self.carBrandField.text = @"";
    self.carSetsField.text = @"";
    self.carRegisterField.text = @"";
    self.yearCheckField.text = @"";
}

-(void)setUnChangedAble{
    self.drivefileNumberField.userInteractionEnabled = NO;
}

#pragma mark 上传图片
-(void)postImages:(id)ImageID CompletionBlock:(void (^)(void))block{
    if (mImageDatas.count == 0) {
        [self dealBack];
        return;
    }
    NSMutableArray *vBase64Array = [NSMutableArray array];
    for (PhtotoInfo *vInfo in mImageDatas) {
        NSData *vImageData = UIImagePNGRepresentation(vInfo.photoImage);
        NSString *vBase64Str = [NewGTMBase64 stringByEncodingData:vImageData];
        [vBase64Array addObject:vBase64Str];
    }
    [IDCardCell postIDImages:vBase64Array PhtotoType:3 businessType:ImageID CompletionBlock:^{
        [mImageDatas removeAllObjects];
        [self dealBack];
    } Notice:@"正在上传照片"];
}

#pragma mark 返回时要做的处理
-(void)dealBack{
    [self clearUI];
    [self back];
    if ([_delegate respondsToSelector:@selector(didAddCarAndCarInfoFinished:)]) {
        [_delegate didAddCarAndCarInfoFinished:Nil];
    }
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

#pragma mark - 其他辅助功能
#pragma mark - 其他业务点击事件
#pragma mark 保存车辆
-(void)saveButtonTouchDown:(id)sender{
    
    id vUserId = [UserManager instanceUserManager].userID;
    [mParemeter setObject:vUserId forKey:@"userId"];
    
    NSString *vCarLisenceStr = self.carLisenceField.text;
    if (vCarLisenceStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请添加您的车牌号!"];
        return;
    }else{
        if (![CheckManeger checkIfIsAllowedCarLisence:self.carLisenceField.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的车牌号！"];
            return;
        }
        
        [mParemeter setObject:vCarLisenceStr forKey:@"carNumber"];
    }
    
    NSString *vCarBrandStr = self.carBrandField.text;
    IFISNIL(vCarBrandStr);
    if (vCarBrandStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请添加您的车辆类型！"];
        return;
    }else{
        [mParemeter setObject:[mCarTypeDic objectForKey:@"car"] forKey:@"model"];
    }
    
    NSString *vCarSetStr = self.carSetsField.text;
    if (vCarSetStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请添加您的爱车座位数！"];
        return;
    }else{
        NSNumber *vNumberSeat = [NSNumber numberWithInt:[vCarSetStr intValue]];
        [mParemeter setObject:vNumberSeat forKey:@"seatNumber"];
    }
    
    NSString *vRegisterTimeStr = self.carRegisterField.text;
    if (vRegisterTimeStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请添加您的爱车注册时间!"];
        return;
    }else{
        [mParemeter setObject:vRegisterTimeStr forKey:@"buyDate"];
    }
    
    NSString *vYearCheck = self.yearCheckField.text;
    if (vYearCheck.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请添加您的爱车年审时间!"];
        return;
    }
    [mParemeter setObject:vYearCheck forKey:@"checkDate"];
    
    
    NSString *vCarEnginStr = self.carEnginField.text;
    IFISNIL(vCarEnginStr);
    [mParemeter setObject:vCarEnginStr forKey:@"engineNumber"];
    
    NSString *vframeNumber = self.carDriveField.text;
    IFISNIL(vframeNumber);
    [mParemeter setObject:vframeNumber forKey:@"frameNumber"];
    
    NSString *vcerCode = self.carDengJiField.text;
    IFISNIL(vcerCode);
    [mParemeter setObject:vcerCode forKey:@"cerCode"];
    
    NSString *vtravelCard = self.drivefileNumberField.text;
    IFISNIL(vtravelCard);
    [mParemeter setObject:vtravelCard forKey:@"travelCard"];
    
    [mParemeter setObject:[NSNumber numberWithInt:isDefaultCar] forKey:@"isDefault"];
    
    [mParemeter setObject:@[] forKey:@"drivingLicenseImgs"];
    [NetManager postDataFromWebAsynchronous:APPURL818 Paremeter:mParemeter Success:^(NSURLResponse *response, id responseObject) {
        //上传照片
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSString *vRetunMessage = [vReturnDic objectForKey:@"stateMessage"];
        NSDictionary *vDataDic =[vReturnDic objectForKey:@"data"];
        if (vDataDic.count > 0) {
            id carId = [vDataDic objectForKey:@"carId"];
            IFISNIL(carId);
            [self postImages:carId CompletionBlock:^{
            }];
            self.isChangedInfo =NO;
        }else{
            [SVProgressHUD showErrorWithStatus:vRetunMessage];
        }

    } Failure:^(NSURLResponse *response, NSError *error) {
    }RequestName:@"添加爱车" Notice:@""];
}

#pragma mark 更新车辆
-(void)updateButtonTouchDown:(id)sender{
    id vUserId = [UserManager instanceUserManager].userID;
    [mParemeter setObject:vUserId forKey:@"userId"];
    
    [mParemeter setObject:[self.carDic objectForKey:@"carId"] forKey:@"carId"];
    
    NSString *vCarLisenceStr = self.carLisenceField.text;
    if (vCarLisenceStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请添加您的车牌号!"];
        return;
    }else{
        if (![CheckManeger checkIfIsAllowedCarLisence:self.carLisenceField.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的车牌号！"];
            return;
        }
        [mParemeter setObject:vCarLisenceStr forKey:@"carNumber"];
    }
    
    NSString *vCarBrandStr = self.carBrandField.text;
    IFISNIL(vCarBrandStr);
    if (vCarBrandStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请添加您的车辆类型！"];
        return;
    }else{
        [mParemeter setObject:vCarBrandStr forKey:@"model"];
    }
    
    NSString *vCarSetStr = self.carSetsField.text;
    if (vCarSetStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请添加您的爱车座位数！"];
        return;
    }else{
        NSNumber *vNumberSeat = [NSNumber numberWithInt:[vCarSetStr intValue]];
        [mParemeter setObject:vNumberSeat forKey:@"seatNumber"];
    }
    
    NSString *vRegisterTimeStr = self.carRegisterField.text;
    if (vRegisterTimeStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请添加您的爱车注册时间!"];
        return;
    }else{
        [mParemeter setObject:vRegisterTimeStr forKey:@"buyDate"];
    }
    
    NSString *vYearCheck = self.yearCheckField.text;
    if (vYearCheck.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请添加您的爱车年审时间!"];
        return;
    }
    [mParemeter setObject:vYearCheck forKey:@"checkDate"];
    
    
    NSString *vCarEnginStr = self.carEnginField.text;
    IFISNIL(vCarEnginStr);
    [mParemeter setObject:vCarEnginStr forKey:@"engineNumber"];
    
    NSString *vframeNumber = self.carDriveField.text;
    IFISNIL(vframeNumber);
    [mParemeter setObject:vframeNumber forKey:@"frameNumber"];
    
    NSString *vcerCode = self.carDengJiField.text;
    IFISNIL(vcerCode);
    [mParemeter setObject:vcerCode forKey:@"cerCode"];
    
    NSString *vtravelCard = self.drivefileNumberField.text;
    IFISNIL(vtravelCard);
    [mParemeter setObject:vtravelCard forKey:@"travelCard"];
    
    [mParemeter setObject:[NSNumber numberWithInt:isDefaultCar] forKey:@"isDefault"];
    
    [NetManager postDataFromWebAsynchronous:APPURL819 Paremeter:mParemeter Success:^(NSURLResponse *response, id responseObject) {
        //上传照片
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSString *vRetunMessage = [vReturnDic objectForKey:@"stateMessage"];
        NSNumber *vStateNumber = [vReturnDic objectForKey:@"stateCode"];
        if (vStateNumber != Nil) {
            if ([vStateNumber intValue] == 0) {
                id carId = [self.carDic objectForKey:@"carId"];
                IFISNIL(carId);
                [self postImages:carId CompletionBlock:^{
                }];
                self.isChangedInfo =NO;
            }
        }else{
            [SVProgressHUD showErrorWithStatus:vRetunMessage];
        }
        
    } Failure:^(NSURLResponse *response, NSError *error) {
    }RequestName:@"添加爱车" Notice:@""];
}

#pragma mark 设置默认车辆
- (IBAction)setDefaultCarClicked:(UIButton *)sender {
    self.isChangedInfo = YES;
    if (isDefaultCar == 1) {
        isDefaultCar = 0;
        [sender setBackgroundImage:[UIImage imageNamed:@"addCar_checkbox_btn_default"] forState:UIControlStateNormal];
    }else{
        isDefaultCar = 1;
        [sender setBackgroundImage:[UIImage imageNamed:@"addCar_checkbox_btn_select"] forState:UIControlStateNormal];
    }
}

#pragma mark IDCardCellDelegate
#pragma mark 填写行驶证证照片
-(void)didIDCardCellAddImageButtonClicked:(id)sender{
    self.isAudit = [[self.carDic objectForKey:@"isAudit"] boolValue];
    //没有通过审核，添加照片
    if (!self.isAudit) {
         [self takePhoto];
    }else{
        [self.view makeToast:@"您的行驶证已通过审核，不能再修改！" duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
    }
}

#pragma mark 删除照片成功
-(void)didIDCardCellDeletePhotoSuccess:(PhtotoInfo *)sender{
    NSDictionary *vDriveImageDic = [_carDic objectForKey:@"drivingLicenseImgs"];
    NSMutableArray *vNewImageArray = [NSMutableArray array];
    for (NSString *vImageURL in vDriveImageDic) {
        if (![vImageURL isEqualToString:sender.phtotURLStr]) {
            [vNewImageArray addObject:vImageURL];
        }
    }
    [_carDic setObject:vNewImageArray forKey:@"drivingLicenseImgs"];
    //检查是否是刚照的照片
    [self deleteLocalPhtoto:sender];
    //刷新图片
    NSIndexPath *vIndexPath = [NSIndexPath indexPathForRow:4 inSection:1];
    [self.carInfoTableView reloadRowsAtIndexPaths:@[vIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark 选择好时间
-(void)didConfirmDate:(id)sender{
    self.isChangedInfo = YES;
    if (mSeletedRow == 3) {
        self.carRegisterField.text = sender;
    }else if (mSeletedRow == 4){
        self.yearCheckField.text = sender;
    }
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
-(void)takePhoto{
    if (mTakeDrivePhoto == Nil) {
        mTakeDrivePhoto = [[TakePhotoTool alloc] init];
        mTakeDrivePhoto.delegate = self;
    }
    [mTakeDrivePhoto takePhoto:self];
}

#pragma mark 照相成功
-(void)didTakePhotoSucces:(id)sender{
    self.isChangedInfo = YES;
    UIImage *vImage =  [UIImage imageWithData:sender];
    PhtotoInfo *vInfo = [[PhtotoInfo alloc] init];
    vInfo.photoImage = vImage;
    vInfo.photoType = ptSelfPhoto;

    //上传行驶证照片到服务器
    [mImageDatas addObject:vInfo];
    
    //刷新图片
    NSIndexPath *vIndexPath = [NSIndexPath indexPathForRow:4 inSection:1];
    [self.carInfoTableView reloadRowsAtIndexPaths:@[vIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    NSMutableArray *vImageArray = [NSMutableArray array];
    [mParemeter setObject:vImageArray forKey:@"policyImg"];
    SAFE_ARC_RELEASE(vInfo);
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
    self.isChangedInfo =YES;
    self.carBrandField.text = [sender objectForKey:@"car"];
        mCarTypeDic = [[NSDictionary alloc] initWithDictionary:sender];
}

@end
