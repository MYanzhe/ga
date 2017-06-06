//
//  QPost.m
//  NIM
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "QPost.h"

#import "AFNetworking.h"//主要用于网络请求方法
#import <CommonCrypto/CommonHMAC.h>
#include <CommonCrypto/CommonHMAC.h>


#define PLATFORM @"IOS"

#define VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

#define HOST @"192.168.1.113"

#define URL @"http://"HOST@":8080"
//#define URL @"http://"HOST@":8080"
#define URL_PLUG @"/"

@interface QPost()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@end

@implementation QPost

+(void)getWithUrl:(NSString *)url param:(NSMutableDictionary*)param headerDict:(NSMutableDictionary*) success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable data))success
          failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[[NSURL alloc] initWithString:URL]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/%@",URL_PLUG,url] parameters:param progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable data) {
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             NSLog(@"success-->%@--->%@",url,data);
             if(success){
                 success(task,data);
             }
             
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             if(failure){
                 failure(task,error);
        }
        NSLog(@"srror-->%@--->%@",url,error);
    }];
}

@end
