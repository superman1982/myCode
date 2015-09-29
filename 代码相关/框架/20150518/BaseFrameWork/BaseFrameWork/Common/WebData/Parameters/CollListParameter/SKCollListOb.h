//
//  SKCollListOb.h
//  BaseFrameWork
//
//  Created by lin on 15/5/18.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SyCollaborationList_Todo = 1,       //  待办列表
    SyCollaborationList_Done,           //  已办列表
    SyCollaborationList_ToSend,         //  待发列表
    SyCollaborationList_Send            //  已发列表
}SyCollaborationListAffairState;

@interface SKCollListOb : NSObject

@property(nonatomic, assign) SyCollaborationListAffairState       affairState;
@property (nonatomic,assign)   long long lastID;
@property (nonatomic,assign) NSInteger startIndex;
@property (nonatomic,assign) NSInteger size;
@end
