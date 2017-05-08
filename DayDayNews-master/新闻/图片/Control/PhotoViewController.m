//
//  PhotoViewController.m
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "PhotoViewController.h"
#import "Photo.h"
#import "PhotoCell.h"
#import "HMWaterflowLayout.h"
#import "PhotoShowViewController.h"
#import "UIBarButtonItem+gyh.h"
#import "PullDownView.h"
#import "AFNetworking.h"//主要用于网络请求方法
#import <CommonCrypto/CommonHMAC.h>
#import <CoreLocation/CoreLocation.h>
#include <CommonCrypto/CommonHMAC.h>

#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>



@interface PhotoViewController ()<webViewidCardProtocol,UIWebViewDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong) UIWebView * webView;
@property (nonatomic , strong) NSMutableArray *      photoArray;
@property (nonatomic , assign) int                   pn;
@property (nonatomic , copy) NSString *              tag1;
@property (nonatomic , copy) NSString *              tag2;
@property (nonatomic , strong) NSArray *             classArray;
@property (nonatomic , strong) PullDownView *        pullDownView;
@property (nonatomic , strong) NSString *            degreeName;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic,strong) NSString *x;
@property (nonatomic,strong) NSString *y;
@property (nonatomic,strong) NSString *location;
@property (nonatomic,strong) NSString *deviceIp;
@property (strong, nonatomic) JSContext *context;

@end

@implementation PhotoViewController

static NSString *const ID = @"photo";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"城市";
    self.degreeName = @"晚报";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem navigationBarRightButtonItemWithTitleAndImage: [UIImage imageNamed:@"arrow_down"]
                                                Title:self.degreeName
                                                Target:self
                                                Selector:@selector(openMenu)
                                                titleColor:HEXColor(@"333333")];

    self.tag1 = @"";
    self.tag2 = @"";
    _x = @"";
    _y = @"";
    _location = @"";
    [self initCollection];
    [DeviceInfoUtil getDeviceInfo];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mynotification) name:self.title object:nil];
    
    //监听夜间模式的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleThemeChanged) name:Notice_Theme_Changed object:nil];
    
    _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://newsxmwb.xinmin.cn/"]]];
    [self.view addSubview:_webView];
//    if([CLLocationManager locationServicesEnabled]){
//        
//        if(!_locationManager){
//            
//            self.locationManager = [[CLLocationManager alloc] init];
//            
//            if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
//                [self.locationManager requestWhenInUseAuthorization];
//                [self.locationManager requestAlwaysAuthorization];
//            }
//            
//            //设置代理
//            [self.locationManager setDelegate:self];
//            //设置定位精度
//            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//            //设置距离筛选
//            [self.locationManager setDistanceFilter:100];
//            //开始定位
//            [self.locationManager startUpdatingLocation];
//            //设置开始识别方向
//            [self.locationManager startUpdatingHeading];
//            
//        }
//        
//    }else{
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                             message:@"您没有开启定位功能"
//                                                            delegate:nil
//                                                   cancelButtonTitle:@"确定"
//                                                   otherButtonTitles:nil, nil, nil];
//        [alertView show];
//    }

    [self startLocation];
}

-(void)setIdCardNum:(NSString *)str{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSDictionary *other = [DeviceInfoUtil getAppInfo];
    [dic setDictionary:other];
//    _deviceIp = [self getDeviceIPIpAddresses];
    [dic setValue:str forKey:@"idCardNum"];
    [dic setValue:@"13555881286" forKey:@"searchPhone"];
    [dic setValue:_x forKey:@"locationX"];
    [dic setValue:_y forKey:@"locationY"];
    [dic setValue:_location forKey:@"location"];
    
    
    
    [QPost getWithUrl:@"/app/idCardSearch/add" param:dic headerDict:nil :^(NSURLSessionDataTask * _Nonnull task, id  _Nullable data) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    NSLog(@"%@",str);
}

- (void)mynotification
{
//    [self.collectionView.header beginRefreshing];
}

- (void)initCollection
{
    IMP_BLOCK_SELF(PhotoViewController);
    HMWaterflowLayout *layout = [[HMWaterflowLayout alloc]init];
    layout.HeightBlock = ^CGFloat(CGFloat sender,NSIndexPath *index){
        Photo *photo = block_self.photoArray[index.item];
        return photo.small_height / photo.small_width * sender;
    };
    layout.columnsCount = 2;
}

- (void)openMenu
{
    if (self.pullDownView.isShow) {
        [self.pullDownView removeView];
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem navigationBarRightButtonItemWithTitleAndImage:[UIImage imageNamed:@"arrow_up"]
                                                    Title:self.degreeName
                                                    Target:self
                                                    Selector:@selector(openMenu)
                                                    titleColor:HEXColor(@"333333")];
        [self.pullDownView show];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)handleThemeChanged
{
    ThemeManager *defaultManager = [ThemeManager sharedInstance];
//    self.collectionView.backgroundColor = [defaultManager themeColor];
    [self.navigationController.navigationBar setBackgroundImage:[defaultManager themedImageWithName:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
//    [self.collectionView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)loadData
{
    NSLog(@"loadData");
}

- (void)initNetWorking
{
    NSLog(@"initNetWorking");
}

-(void)loadUrl{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wbindex" ofType:@"html"
                                                inDirectory:@"www"];
    //    NSString* path = [[NSBundle mainBundle] pathForResource:@"wbindex" ofType:@"html"];
    
    NSString *encodedPath = [path stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedPath];
    //    NSURLRequest *request= [NSURLRequest requestWithURL:url];
    //    [_h5view loadRequest:request];
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    dispatch_async(dispatch_get_main_queue(), ^{
        //send webview a message
        [_webView loadRequest:request];
    });
}
#pragma mark - lazy
-(NSArray *)classArray
{
    if (!_classArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"shenfenzheng" ofType:@"html"
                                                    inDirectory:@"idCard"];
        //    NSString* path = [[NSBundle mainBundle] pathForResource:@"wbindex" ofType:@"html"];
        
        NSString *idCardPath = [path stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];

        _classArray = @[
                        [PullDownItem itemWithTitle:@"晚报" icon:[UIImage imageNamed:@"jiaju"] url:@"http://newsxmwb.xinmin.cn/"],
                        [PullDownItem itemWithTitle:@"政务" icon:[UIImage imageNamed:@"meinvchannel"] url:@"http://www.shenyang.gov.cn/zwgk/zwdt/xqdt/xms/"],
                        [PullDownItem itemWithTitle:@"交通" icon:[UIImage imageNamed:@"qiche"] url:@"http://m.weizhang8.cn/liaoning/"],
                        [PullDownItem itemWithTitle:@"文化" icon:[UIImage imageNamed:@"qiche"] url:@""],
                        [PullDownItem itemWithTitle:@"生活" icon:[UIImage imageNamed:@"chongwu"] url:@""],
                        [PullDownItem itemWithTitle:@"身份证查询" icon:[UIImage imageNamed:@"dongman"] url:idCardPath],
                        [PullDownItem itemWithTitle:@"新闻" icon:[UIImage imageNamed:@"sheji"] url:@"http://www.xinmin.cn/pad/"],
                        
                        [PullDownItem itemWithTitle:@"政府" icon:[UIImage imageNamed:@"hunjia"] url:@"http://www.xinmin.gov.cn/"],
                        [PullDownItem itemWithTitle:@"公交" icon:[UIImage imageNamed:@"sheying"] url:@"http://m.weizhang8.cn/liaoning/"],
                        [PullDownItem itemWithTitle:@"就业" icon:[UIImage imageNamed:@"meishi"] url:@"http://www.syjyrcw.com/"]
                        ];
    }
    return _classArray;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    _context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _context.exceptionHandler = ^(JSContext *con, JSValue *exception) {
        NSLog(@"JSException:\n%@",exception);
        con.exception = exception;
    };
    _context[@"server"]=self;
}

- (PullDownView *)pullDownView
{
    if (!_pullDownView) {
        _pullDownView = [[PullDownView alloc]init];
        [_pullDownView setDataWithItemAry:self.classArray];
    }
    IMP_BLOCK_SELF(PhotoViewController);
    __weak typeof(self) wself = self;
    _pullDownView.SelectBlock = ^(id sender,NSString* url){
        block_self.degreeName = sender;
        block_self.navigationItem.rightBarButtonItem = [UIBarButtonItem navigationBarRightButtonItemWithTitleAndImage:[UIImage imageNamed:@"arrow_down"]
                                                                        Title:sender
                                                                        Target:block_self
                                                                        Selector:@selector(openMenu)
                                                                        titleColor:HEXColor(@"333333")];
        
        [wself.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        wself.webView.delegate = wself;
        block_self.pn = 0;
        block_self.tag1 = sender;
        block_self.tag2 = @"全部";
        
    };
    _pullDownView.removeBlock = ^{
        block_self.navigationItem.rightBarButtonItem = [UIBarButtonItem navigationBarRightButtonItemWithTitleAndImage:[UIImage imageNamed:@"arrow_down"]
                                                                            Title:block_self.degreeName
                                                                            Target:block_self
                                                                            Selector:@selector(openMenu)
                                                                            titleColor:HEXColor(@"333333")];
    };
    return _pullDownView;
}


- (NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

//loaction


-(void)startLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
    if ([[[UIDevice currentDevice]systemVersion]doubleValue] >8.0){
        [self.locationManager requestWhenInUseAuthorization];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        _locationManager.allowsBackgroundLocationUpdates =YES;
    }
    [self.locationManager startUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
            
        casekCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }break;
        default:break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

    CLLocation *newLocation = locations[0];
    
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    
    _x = [NSString stringWithFormat:@"%f",oldCoordinate.longitude];
    _y = [NSString stringWithFormat:@"%f",oldCoordinate.latitude];
    
    [manager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
        
        for (CLPlacemark *place in placemarks) {
            
            NSLog(@"name,%@",place.name);                      // 位置名
            
            NSLog(@"thoroughfare,%@",place.thoroughfare);      // 街道
            
            NSLog(@"subThoroughfare,%@",place.subThoroughfare);// 子街道
            
            NSLog(@"locality,%@",place.locality);              // 市
            
            NSLog(@"subLocality,%@",place.subLocality);        // 区
            
            NSLog(@"country,%@",place.country);                // 国家
            
            _location = [NSString stringWithFormat:@"%@%@%@%@%@",place.country,place.locality,place.subLocality,place.thoroughfare,place.name];
        }
    }];
}

- (NSString *)getDeviceIPIpAddresses

{
    
    int sockfd =socket(AF_INET,SOCK_DGRAM, 0);
    
    //    if (sockfd <</span> 0) return nil;
    
    NSMutableArray *ips = [NSMutableArray array];
 
    int BUFFERSIZE =4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd,SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            
            int len =sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                
                len = ifr->ifr_addr.sa_len;
                
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            
            if (ifr->ifr_addr.sa_family !=AF_INET) continue;
            
            if ((cptr = (char *)strchr(ifr->ifr_name,':')) != NULL) *cptr =0;
            
            if (strncmp(lastname, ifr->ifr_name,IFNAMSIZ) == 0)continue;
            
            memcpy(lastname, ifr->ifr_name,IFNAMSIZ);
            
            ifrcopy = *ifr;
            
            ioctl(sockfd,SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags &IFF_UP) == 0)continue;
            
            
            
            NSString *ip = [NSString stringWithFormat:@"%s",inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            
            [ips addObject:ip];
            
        }
        
    }
    
    close(sockfd);
    NSString *deviceIP =@"";
    for (int i=0; i < ips.count; i++)
    {
        if (ips.count >0)
            
        {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
        
    }
    NSLog(@"deviceIP========%@",deviceIP);
    return deviceIP;
}

@end
