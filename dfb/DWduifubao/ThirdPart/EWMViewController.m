//
//  EWMViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/5.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "EWMViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface EWMViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIWebViewDelegate,AVAudioPlayerDelegate>
    //用于处理采集信息的代理
@property (nonatomic, strong)AVAudioPlayer * Player;

@property (strong, nonatomic)  UIView *viewPreview;
@property (strong, nonatomic) UIView *boxView;
@property (strong, nonatomic) CALayer *scanLayer;
@property(nonatomic,strong)UIImageView *imgView;
    
-(BOOL)startReading;
-(void)stopReading;
    //捕捉会话
    @property (nonatomic, strong) AVCaptureSession *captureSession;
    //展示layer
    @property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
    
    @property (nonatomic, strong) NSURLRequest *request;
    //判断是否是HTTPS的
    @property (nonatomic, assign) BOOL isAuthed;
    //返回按钮
    @property (nonatomic, strong) UIBarButtonItem *backItem;
    //关闭按钮
    @property (nonatomic, strong) UIBarButtonItem *closeItem;
 @property (strong, nonatomic)  UIWebView *MywebView;
    
   
    


@end

@implementation EWMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"扫描";
    self.viewPreview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-0)];
    [self.view addSubview:_viewPreview];
    self.MywebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-0)];
    [self.view addSubview:_MywebView];
    self.MywebView.delegate = self;
    self.MywebView.alpha = 0;
    //self.viewPreview.layer.backgroundColor = [UIColor redColor].CGColor;
    _captureSession = nil;
    [self startReading];
}
- (BOOL)startReading {
    NSError *error;
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"input%@", [error localizedDescription]);
        return NO;
    }
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    //5.2.设置输出媒体数据类型为QRCode
    //[captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    captureMetadataOutput.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code];
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    //9.将图层添加到预览view的图层上
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.5f, 0.5f);
    //10.1.扫描框
    _boxView = [[UIView alloc] initWithFrame:CGRectMake(_viewPreview.frame.size.width * 0.15f, (_viewPreview.frame.size.height - _viewPreview.frame.size.width*0.6f )/2-64, _viewPreview.frame.size.width - _viewPreview.frame.size.width * 0.3f, _viewPreview.frame.size.width - _viewPreview.frame.size.width * 0.3f)];
    
    _boxView.layer.borderColor = [UIColor clearColor].CGColor;
    _boxView.layer.borderWidth = 3.0f;
    [_viewPreview addSubview:_boxView];
    self.imgView = [[UIImageView alloc]initWithFrame:_viewPreview.bounds];
    _imgView.image = [UIImage imageNamed:@"二维码"];
    [_viewPreview addSubview:_imgView];
    
    //10.2.扫描线
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(8, 10, _boxView.bounds.size.width-20, 3);
    _scanLayer.backgroundColor = [UIColor redColor].CGColor;
    [_boxView.layer addSublayer:_scanLayer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    
    //10.开始扫描
    [_captureSession startRunning];
    return YES;
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
    {
        //判断是否有数据
        if (metadataObjects != nil && [metadataObjects count] > 0) {
            AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
            NSString *result;
            
            //判断回传的数据类型
            if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
                //[_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
                
                //NSLog(@"---%@",metadataObj.stringValue);
                result = metadataObj.stringValue;
                [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:result waitUntilDone:NO];
                // [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
                //_isReading = NO;
            }else {
                NSLog(@"不是二维码");
            }
        }
    }
- (void)reportScanResult:(NSString *)result
    {
        
        [self stopReading];
        [self loadHtml:result];
        
        self.MywebView.alpha = 1;
        
        // 以下处理了结果，继续下次扫描
    }
    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)moveScanLayer:(NSTimer *)timer
    {
        [_scanLayer removeAllAnimations];
        CGRect frame = _scanLayer.frame;
        if (_boxView.frame.size.height-10.1 < _scanLayer.frame.origin.y) {
            frame.origin.y = 20;
            _scanLayer.frame = frame;
            [_scanLayer removeFromSuperlayer];
            //10.2.扫描线
            _scanLayer = [[CALayer alloc] init];
            _scanLayer.frame = CGRectMake(8, 15, _boxView.bounds.size.width-20, 3);
            _scanLayer.backgroundColor = [UIColor redColor].CGColor;
            [_boxView.layer addSublayer:_scanLayer];


        }else{
            frame.origin.y += 5;
            [UIView animateWithDuration:1 animations:^{
                _scanLayer.frame = frame;
            }];
        }
    }
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopReading];
}
-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_imgView removeFromSuperview];
    [_boxView removeFromSuperview];
    [_scanLayer removeFromSuperlayer];
    [_videoPreviewLayer removeFromSuperlayer];
}
    //加载URL
- (void)loadHtml:(NSString *)htmlString
    {
        self.request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:htmlString]];
        [self.MywebView loadRequest:self.request];
    }
    
#pragma mark - UIWebViewDelegate
    
    //开始加载
- (BOOL)webView:(UIWebView *)awebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
    {
        NSString* scheme = [[request URL] scheme];
        //判断是不是https
        if ([scheme isEqualToString:@"https"]) {
            //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
            if (!self.isAuthed) {
                NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                [conn start];
                [awebView stopLoading];
                return NO;
            }
        }
        return YES;
    }
    
    //设置webview的title为导航栏的title
- (void)webViewDidFinishLoad:(UIWebView *)webView
    {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
#pragma mark ================= NSURLConnectionDataDelegate <NSURLConnectionDelegate>
    
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
    {
        return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    }
    
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
    {
        if ([challenge previousFailureCount] == 0) {
            self.isAuthed = YES;
            //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
            NSURLCredential *cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
        }
    }
    
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
    {
        NSLog(@"网络不给力");
    }
    
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
    {
        self.isAuthed = YES;
        //webview 重新加载请求。
        [self.MywebView loadRequest:self.request];
        [connection cancel];
    }
    
#pragma mark - 添加关闭按钮
    
- (void)addLeftButton
    {
        self.navigationItem.leftBarButtonItem = self.backItem;
        //self.navigationItem.rightBarButtonItem = self.closeItem;
    }
    
    //点击返回的方法
- (void)backNative
    {
        //判断是否有上一层H5页面
        if ([self.MywebView canGoBack]) {
            //如果有则返回
            [self.MywebView goBack];
            //同时设置返回按钮和关闭按钮为导航栏左边的按钮
            self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
        } else {
            [self closeNative];
        }
    }
    
//关闭H5页面，直接回到原生页面
- (void)closeNative
    {
    [self.navigationController popViewControllerAnimated:YES];
}
    
#pragma mark - init
    
- (UIBarButtonItem *)backItem
    {
        if (!_backItem) {
            self.backItem = [[UIBarButtonItem alloc] init];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            //这是一张“<”的图片，可以让美工给切一张
            UIImage *image = [UIImage imageNamed:@"夺宝-箭头-左.png"];
            [btn setImage:image forState:UIControlStateNormal];
            [btn setTitle:@"返回" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(backNative) forControlEvents:UIControlEventTouchUpInside];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //字体的多少为btn的大小
            [btn sizeToFit];
            //左对齐
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            //让返回按钮内容继续向左边偏移15，如果不设置的话，就会发现返回按钮离屏幕的左边的距离有点儿大，不美观
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            btn.frame = CGRectMake(0, 0, 40, 40);
            _backItem.customView = btn;
        }
        return _backItem;
    }
    
- (UIBarButtonItem *)closeItem
    {
        if (!_closeItem) {
            self.closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeNative)];
            [self.closeItem setTintColor:[UIColor colorWithHexString:ksubTitleColor]];
            
        }
        return _closeItem;
    }
    
#pragma mark - 开始播放音频
- (void)startPlaying:(id)sender {
    //必须要用AVAudioSession, 否则没有声音
    AVAudioSession * session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    NSString * str = @"http://fdfs.xmcdn.com/group15/M07/9A/FB/wKgDaFZEGv_DbeH7AGAPMoS7M4w555.mp3";
    NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:str] options:NSDataReadingMappedIfSafe error:nil];
    self.Player = [[AVAudioPlayer alloc]initWithData:data error:nil];
    //设置音量 0.0 - 1.0
    self.Player.volume = 1;
    //循环次数(默认为1,-1为无限循环)
    self.Player.numberOfLoops = 1;
    //播放速度是否可以调节
    self.Player.enableRate = YES;
    //播放速度
    self.Player.rate = 1.0f;
    //制定位置开始播放
    self.Player.currentTime = 1.0;
    //设置代理
    self.Player.delegate = self;
    //调节左右声道的大小,-1.0为完全左声道发生,1.0为完全右声道发声.
    self.Player.pan = 1.0f;
    //播放
    [self.Player play];
}

@end
