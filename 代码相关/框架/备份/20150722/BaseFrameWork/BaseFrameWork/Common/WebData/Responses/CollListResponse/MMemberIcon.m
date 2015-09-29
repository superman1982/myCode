//
//  MMemberIcon
//  M1Core
//
//  Created by Generated by Java on 2014-04-16 15:28.
//  Copyright (c) 2012年 北京致远协创软件有限公司. All rights reserved.
//

#import "MMemberIcon.h"

@implementation MMemberIcon
@synthesize  iconPath;
@synthesize  size;
@synthesize  lastModifyDate;
@synthesize  iconType;


- (void)dealloc
{
    [iconPath release];
    [lastModifyDate release];

    [super dealloc];
}


-(id)initWithIconPath:(NSString *)iconPath2 lastModifyDate:(NSString *)lastModifyDate2 iconType:(NSInteger)iconType2 size:(long long)size2
{
    if (self = [super init]) {
        self.iconPath = iconPath2;
        self.lastModifyDate = lastModifyDate2;
        self.iconType = iconType2;
        self.size = size2;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:iconPath forKey:@"IconPath"];
    [aCoder encodeObject:lastModifyDate forKey:@"LastModifyDate"];
    [aCoder encodeInteger:iconType forKey:@"IconType"];
    [aCoder encodeDouble:size forKey:@"Size"];
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    NSString * iconPath2 = [aDecoder decodeObjectForKey:@"IconPath"];
    NSString * lastModifyDate2 = [aDecoder decodeObjectForKey:@"LastModifyDate"];
    NSInteger  iconType2 = [aDecoder decodeIntegerForKey:@"IconType"];
    long long  size2 = [aDecoder decodeDoubleForKey:@"Size"];
    
    [self initWithIconPath:iconPath2 lastModifyDate:lastModifyDate2 iconType:iconType2 size:size2];
    return self;
}

@end
