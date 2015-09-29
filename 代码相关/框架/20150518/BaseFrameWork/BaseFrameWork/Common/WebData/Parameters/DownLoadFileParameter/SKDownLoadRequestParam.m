//
//  SKDownLoadRequestParameter.m
//  BaseFrameWork
//
//  Created by lin on 15/5/22.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKDownLoadRequestParam.h"
#import "SKNetManager.h"
#import "SKLocalSetting.h"

#define kServerDownloadAddress @"%@/seeyon/servlet/SeeyonMobileBrokerServlet;jsessionid=%@?serviceProcess=A6A8_File&method=download&fileId=%@&type=%d&createDate=%@&filename=%@"

@implementation SKDownLoadRequestParam

- (void)dealloc
{
    [_fileDownloadRequestID release];
    [_uuID release];
    [_createDate release];
    [_fileName release];
    [_suffix release];
    [_downloadUrl release];
    [_vCode release];
    
    [_serverID release];
    [_ownerID release];
    
    [_saveFilePathDirectory release];
    
    [super dealloc];
}

-(NSString *)requestURLStr{
    if (_requestURLStr == nil &&
        _lastModifyTime != nil ) {
        NSString *vSessionID = [SKNetManager jsessionID:@"https://211.157.139.215:9946/seeyon/servlet/SeeyonMobileBrokerServlet?serviceProcess=A6A8_Common&responseCompress=gzip"];
        NSString *vServerAddress = [SKLocalSetting instanceSkLocalSetting].domain;
        _requestURLStr = [[NSString alloc] initWithFormat:kServerDownloadAddress,
                          vServerAddress,
                          vSessionID,
                          _uuID,
                          _type,
                          _createDate,
                          _fileName];
        _requestURLStr = [_requestURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return _requestURLStr;
}

-(NSString *)attID{
    if (_uuID == nil
        || _uuID.length == 0
        || ([_uuID rangeOfString:@"null"].location != NSNotFound)) {
        return _requestURLStr;
    }
    return _uuID;
}
@end
