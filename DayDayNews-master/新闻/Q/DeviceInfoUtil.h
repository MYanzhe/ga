//
//  DeviceInfoUtil.h
//  新闻
//
//  Created by apple on 17/5/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfoUtil : NSObject
+ (NSString *)getUUID;
+ (void)getDeviceInfo;
+ (NSString *)getMacAddress;
+ (NSDictionary *)getAppInfo;
@end
