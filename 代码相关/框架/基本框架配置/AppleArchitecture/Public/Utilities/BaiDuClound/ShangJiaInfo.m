//
//  ShangJiaInfo.m
//  车途邦
//
//  Created by klbest1 on 13-11-7.
//  Copyright (c) 2013年 xingde. All rights reserved.
//

#import "ShangJiaInfo.h"



@implementation ShangJiaInfo
@synthesize photo = _photo;
@synthesize isauthenticate = _isauthenticate;
@synthesize stars = _stars;
@synthesize distance = _distance;
@synthesize bunessId = _bunessId;
@synthesize type = _type;
@synthesize userid = _userid;

-(id)initName:(NSString *)aName Address:(NSString *)aAdress Phone:(NSString *)aPhone
Photo:(NSString *)aPhoto Isauthenticate:(NSInteger )aAuth Stars:(NSInteger)star
Distance:(NSInteger)aDistane Pt:(CLLocationCoordinate2D)aPt BussId:(id)aBunessId
Type:(NSInteger)aType UserId:(NSInteger)aUserId
{
    self = [super init];
    
    if (self) {
        
        self.name = aName;
        self.address = aAdress;
        self.phone = aPhone;
        self.photo = aPhoto;
        self.isauthenticate = aAuth;
        self.stars = star;
        self.distance = aDistane;
        self.pt = aPt;
        self.bunessId = aBunessId;
        self.type = aType;
        self.userid = aUserId;
    }
    
    return self;
}

@end
