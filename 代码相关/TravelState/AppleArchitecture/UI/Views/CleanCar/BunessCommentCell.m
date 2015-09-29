//
//  BunessCommentCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "BunessCommentCell.h"
#import "ImageViewHelper.h"
#import "StringHelper.h"
#import "ActivityRouteManeger.h"

@implementation BunessCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCell:(NSDictionary *)aDic{
    NSString *vHeadImageURLStr = [aDic objectForKey:@"headerImageUrl"];
    [self.headerImageUrl setImageWithURL:[NSURL URLWithString:vHeadImageURLStr] PlaceHolder:[UIImage imageNamed:@"lvtubang.png"]];
    [self.headerImageUrl.layer setCornerRadius:5];
    [self.headerImageUrl.layer setMasksToBounds:YES];
    
    NSString *vDate = [aDic objectForKey:@"date"];
    IFISNIL(vDate);
    self.date.text = vDate;
    
    NSString *vContent = [aDic objectForKey:@"content"];
    IFISNIL(vContent);
    self.content.text = vContent;
    [self setHightOfCell:vContent];
    
    NSString *vNickNameStr = [aDic objectForKey:@"nickName"];
    IFISNIL(vNickNameStr);
    self.nickName.text = vNickNameStr;
    
    NSString *memberLeverName = [aDic objectForKey:@"memberLeverName"];
    IFISNIL(memberLeverName);
    self.memberLevelLable.text = memberLeverName;
    
    NSInteger vStarNumber = [[aDic objectForKey:@"stars"] integerValue];
    [ActivityRouteManeger addStarsToView:self.starImageView StarNumber:vStarNumber];
}


-(void)setHightOfCell:(NSString *)aContentStr{
    if (aContentStr == Nil) {
        return;
    }
    //计算评论内容size
    CGSize vConstrainedSize = CGSizeMake(self.content.frame.size.width, CGFLOAT_MAX);
    CGSize vTextSize = [StringHelper caluateStrLength:aContentStr Front:self.content.font ConstrainedSize:vConstrainedSize];
    //重新布局评论Lable大小以适应字体
    [self.content setFrame:CGRectMake(self.content.frame.origin.x, self.content.frame.origin.y, self.content.frame.size.width, vTextSize.height)];
    //计算contentLable最大高度
    float vContentLableMaxHeightInOringinCell = self.contentView.frame.size.height - self.content.frame.origin.y;
    //计算超出contentLable最大高度的长度
    if (vTextSize.height > vContentLableMaxHeightInOringinCell) {
        float needToExtentdHeight = vTextSize.height - vContentLableMaxHeightInOringinCell;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + needToExtentdHeight + 6);
    }
}

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_headerImageUrl release];
    [_date release];
    [_content release];
    [_nickName release];
    [_memberLevelLable release];
    [_starImageView release];
    [super dealloc];
}
#endif
@end
