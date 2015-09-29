//
//  ViewController.m
//  测试域名转ip
//
//  Created by lin on 14-9-2.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import "ViewController.h"
#include <netdb.h>
#include <arpa/inet.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
//webagent.sangfor.net.cn/ssl/bjpolycn.php ---》ip:220.250.64.24
//webagent.sangfor.net.cn ---》ip:120.237.110.134

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *webSiteString = @"sslvpn.ccom.edu.cn ";
    
    //NSString to char*
    const char *webSite = [webSiteString cStringUsingEncoding:NSASCIIStringEncoding];
    
    // Get host entry info for given host
    struct hostent *remoteHostEnt = gethostbyname(webSite);
    
    // Get address info from host entry
    struct in_addr *remoteInAddr = (struct in_addr *) remoteHostEnt->h_addr_list[0];
    
    // Convert numeric addr to ASCII string
    char *sRemoteInAddr = inet_ntoa(*remoteInAddr);
    
    //char* to NSString
    NSString *ip = [[NSString alloc] initWithCString:sRemoteInAddr
                                             encoding:NSASCIIStringEncoding];
    NSLog(@"ip:%@",ip);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
