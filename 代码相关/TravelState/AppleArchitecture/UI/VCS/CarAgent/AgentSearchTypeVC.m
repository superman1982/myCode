//
//  AgentSearchTypeVC.m
//  lvtubangmember
//
//  Created by klbest1 on 14-4-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "AgentSearchTypeVC.h"


@interface AgentSearchTypeVC ()
@end

@implementation AgentSearchTypeVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initializatio

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setScrollEnabled:NO];
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTypeArray:(NSArray *)typeArray{
    if (_typeArray == Nil) {
        _typeArray = [[NSMutableArray alloc] init];
    }
    [_typeArray removeAllObjects];
    [_typeArray addObjectsFromArray:typeArray];
    if (self.tableWidth == 0) {
        self.tableWidth = TABLEROWWIDTH;
    }
    [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableWidth, TABLEROWHEIGHT*_typeArray.count)];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.typeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TABLEROWHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.textLabel.text = [self.typeArray objectAtIndex:indexPath.row];
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_delegate respondsToSelector:@selector(didAgentSearchTypeVCSeletedType: Name:)]) {
        [_delegate didAgentSearchTypeVCSeletedType:indexPath.row Name:[self.typeArray objectAtIndex:indexPath.row]];
    }
}
 


@end
