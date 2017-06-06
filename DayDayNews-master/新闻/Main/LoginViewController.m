//
//  LoginViewController.m
//  新闻
//
//  Created by apple on 17/6/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "TabbarViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIButton *login;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginClick:(UIButton*)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:self.phone.text forKey:@"phone"];
    [dic setValue:self.pwd.text forKey:@"password"];
    
    [QPost getWithUrl:@"/app/user/login" param:dic headerDict:nil :^(NSURLSessionDataTask * _Nonnull task, id  _Nullable data) {
        NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if([stringData isEqualToString:@"success"]){
            NSLog(@"success");
            TabbarViewController *tabbarMain = [[TabbarViewController alloc]init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabbarMain;
        } else if([stringData isEqualToString:@"error"]){
            NSLog(@"error");
            [MBProgressHUD showError:@"用户名或密码错误" toView:self.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

- (IBAction)registerClick:(UIButton *)sender {
    RegisterViewController *re = [[RegisterViewController alloc]init];
    [self presentViewController:re animated:YES completion:nil];
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
