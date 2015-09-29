//
//  ChoseCityVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-13.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ChoseCityVC.h"

#define kSectionSelectorWidth 45

@interface ChoseCityVC ()
{
    NSMutableArray *cellData;
    NSMutableArray *sectionsData;
    id chosedData;
}

@property (nonatomic, strong) CHSectionSelectionView *selectionView;
@end

@implementation ChoseCityVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"ChoseCityVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"ChoseCityVC" bundle:aBuddle];
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
    self.title = @"选择城市";
    UIButton *vCancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vCancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [vCancleButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vCancleButton addTarget:self action:@selector(cancleButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vCancleButton];
    self.navigationItem.leftBarButtonItem = vBarButtonItem;
    
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"确定" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vRightButton addTarget:self action:@selector(confirmButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_selectionView reloadSections];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _cityTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width-kSectionSelectorWidth, self.view.bounds.size.height);
    _selectionView.frame = CGRectMake(self.view.bounds.size.width-kSectionSelectorWidth, 0, kSectionSelectorWidth, self.view.bounds.size.height);
}

-(void)initCommonData{
    cellData = [[NSMutableArray alloc ]init];
    sectionsData = [[NSMutableArray alloc ]init];
}

-(void)dealWithData:(NSDictionary *)aCellDataDic Section:(NSArray *)aSection{
    [sectionsData removeAllObjects];
    [cellData removeAllObjects];
    [sectionsData addObjectsFromArray:aSection];
    //分解每个Section中的数据
    for (NSString *vSectionKey in aSection) {
        NSArray *vCellDataItemArray = [aCellDataDic objectForKey:vSectionKey];
        if (vCellDataItemArray.count > 0) {
            [cellData addObject:vCellDataItemArray];
        }
    }
}
#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [cellData removeAllObjects],[cellData release];
    [sectionsData removeAllObjects],[sectionsData release];
    [_cityTableView release];
    [_selectionView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    _selectionView = [[CHSectionSelectionView alloc] init];
    _selectionView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    _selectionView.dataSource = self;
    _selectionView.delegate = self;
    // the view should show a callout when an item is selected
    _selectionView.showCallouts = YES;
    // Callouts should appear on the right side
    _selectionView.calloutDirection = SectionCalloutDirectionLeft;
    _selectionView.calloutPadding = 20;
    [self.view addSubview:_selectionView];
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
    _selectionView = Nil;
    [self setCityTableView:nil];
    [super viewDidUnload];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark - SectionSelectionView DataSource

// Tell the datasource how many sections we have - best is to forward to the tableviews datasource
-(NSInteger)numberOfSectionsInSectionSelectionView:(CHSectionSelectionView *)sectionSelectionView
{
    return [_cityTableView.dataSource numberOfSectionsInTableView:_cityTableView];
}

// Create a nice callout view so that you see whats selected when
// your finger covers the sectionSelectionView
-(UIView *)sectionSelectionView:(CHSectionSelectionView *)selectionView callOutViewForSelectedSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    // you MUST set the size of the callout in this method
    label.frame = CGRectMake(0, 0, 80, 80);
    
    // do some ui stuff
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor redColor];
    label.font = [UIFont boldSystemFontOfSize:40];
    label.text = [_cityTableView.dataSource tableView:_cityTableView titleForHeaderInSection:section];
    label.textAlignment = NSTextAlignmentCenter;
    
    // dont use that in your code cause layer shadows are
    // negatively affecting performance
    [label.layer setCornerRadius:label.frame.size.width/2];
    [label.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [label.layer setBorderWidth:3.0f];
    [label.layer setShadowColor:[UIColor blackColor].CGColor];
    [label.layer setShadowOpacity:0.8];
    [label.layer setShadowRadius:5.0];
    [label.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    return label;
}

//右边的Item根据TableView的Section来取
-(CHSectionSelectionItemView *)sectionSelectionView:(CHSectionSelectionView *)selectionView sectionSelectionItemViewForSection:(NSInteger)section
{
    CHSectionSelectionItemView *vSelectionItem = [[CHSectionSelectionItemView alloc] init];
    vSelectionItem.titleLabel.text = [_cityTableView.dataSource tableView:_cityTableView titleForHeaderInSection:section];
//    vSelectionItem.bgImageView.image = [UIImage imageNamed:@"sectionItemBG"];
    vSelectionItem.titleLabel.shadowColor = [UIColor darkGrayColor];
    vSelectionItem.titleLabel.shadowOffset = CGSizeMake(0, 1);
    SAFE_ARC_AUTORELEASE(vSelectionItem);
    return vSelectionItem;
}

//////////////////////////////////////////////////////////////////////////
#pragma mark - SectionSelectionView Delegate

// Jump to the selected section in our tableview
-(void)sectionSelectionView:(CHSectionSelectionView *)sectionSelectionView didSelectSection:(NSInteger)section
{
    [_cityTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


//////////////////////////////////////////////////////////////////////////
#pragma mark - TableView Delegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionsData objectAtIndex:section];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark - TableView DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   
    NSArray *vCellItemData = [cellData objectAtIndex:indexPath.section];
    cell.textLabel.text = [vCellItemData objectAtIndex:indexPath.row];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray  *)[cellData objectAtIndex:section]).count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionsData count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    chosedData = [[cellData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 其他业务点击事件
#pragma mark 取消
-(void)cancleButtonTouchDown:(id)sender{
    [self back];
}
#pragma mark 完成
-(void)confirmButtonTouchDown:(id)sender{
    if ([_delegate respondsToSelector:@selector(didChosedPlace:)]) {
        [ViewControllerManager backViewController:vaNoAnimation SubType:vsFromLeft];
        [_delegate didChosedPlace:chosedData];
    }
}
@end
