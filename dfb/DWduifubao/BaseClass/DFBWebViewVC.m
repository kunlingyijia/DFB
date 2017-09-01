//
//  DFBWebViewVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/10.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DFBWebViewVC.h"
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
@interface DFBWebViewVC ()<UIWebViewDelegate>{
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
    int a;
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *closeItem;

@end
@implementation DFBWebViewVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.closeItem;
    [self initWebView];
    _progressLayer = [WYWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
      a = 1;
}
- (void)initWebView{
    if (!self.webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64.1, Width, self.view.frame.size.height-64.1)];
        self.webView.delegate = self;
        [self.view addSubview:self.webView];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//设置webview的title为导航栏的title
- (void)webViewDidFinishLoad:(UIWebView *)webView
{    [_progressLayer finishedLoad];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = webView.request.URL.absoluteString;
    [_progressLayer startLoad];

    NSArray *data = [url componentsSeparatedByString:@"https%3A%2F%2Fskb.yeepay.com%2Fskb-app%2FtoWithDrawRJT.action%3Ftoken"];
    if (data.count > 1) {
        NSString *drawUrlStr = [url stringByReplacingOccurrencesOfString:@"http://pay.zgduifubao.com/TP/dfb/outerlink.html?title=%E6%8F%90%E7%8E%B0&url=" withString:@""];
        
        drawUrlStr = [self URLDecodedString:drawUrlStr];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:drawUrlStr]];
        return NO;
    }
    

    return YES;
}

-(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_progressLayer finishedLoad];
    
    [_progressLayer startLoad];
    
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{   [_progressLayer finishedLoad];
    NSLog(@"网络不给力");
}
- (void)loadUrl:(NSString *)url{
    [self initWebView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
        self.closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeNative)];
        
    }
    return _closeItem;
}

- (void)closeNative{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
