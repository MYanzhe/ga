//
//  PhotoViewController.h
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "BaseSettingViewController.h"

@protocol webViewidCardProtocol <JSExport>

-(void)setIdCardNum:(NSString *)str;

@end

@interface PhotoViewController : BaseViewController


@end
