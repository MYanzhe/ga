//
//  QPost.h
//  NIM
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QPost : NSObject
+(void)getWithUrl:(NSString *)url param:(NSMutableDictionary*)param headerDict:(NSMutableDictionary*) success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable data))success
failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;
@end
