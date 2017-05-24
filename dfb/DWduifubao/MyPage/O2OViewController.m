//
//  O2OViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/1.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "O2OViewController.h"

@interface O2OViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIBarButtonItem *closeItem;
@end

@implementation O2OViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *url = [NSString stringWithFormat:@"%@",[AuthenticationModel geto2o_url]];
    NSLog(@"%@",[AuthenticationModel geto2o_url]);
    self.webView.delegate = self;
    self.webView.frame = CGRectMake(0, 0, Width, Height);
    [self loadHTML:url];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = webView.request.URL.absoluteString;
    
    
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
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{       NSLog(@"网络不给力");
}
- (void)loadUrl:(NSString *)url{
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

@end
