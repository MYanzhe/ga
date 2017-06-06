//
//  RegisterViewController.m
//  新闻
//
//  Created by apple on 17/6/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerClick:(UIButton *)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];

    [dic setValue:self.phone.text forKey:@"phone"];
    [dic setValue:self.password.text forKey:@"password"];
    
    [QPost getWithUrl:@"/app/user/add" param:dic headerDict:nil :^(NSURLSessionDataTask * _Nonnull task, id  _Nullable data) {
        NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if([stringData isEqualToString:@"success"]){
            NSLog(@"success");
            [MBProgressHUD showError:@"注册成功" toView:self.view];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self toLoginViewClick:nil];
            });
        } else if([stringData isEqualToString:@"phoneUsed"]){
            NSLog(@"phoneUsed");
            [MBProgressHUD showError:@"该手机号已注册" toView:self.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}
- (IBAction)toLoginViewClick:(UIButton *)sender {
    LoginViewController *login = [[LoginViewController alloc]init];
    [self presentViewController:login animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
