//
//  ArticleVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/2/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "ArticleVC.h"
#import "MyServiceModel.h"
#import "PhotoViewController.h"
@interface ArticleVC ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)UIButton * btn;

@end

@implementation ArticleVC
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UI
    [self SET_UI];
    [self SET_DATA];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    }
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
}

#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    [_webview.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
/**
 *  监听属性值发生改变时回调
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {        CGFloat y = _webview.scrollView.contentOffset.y;
        NSLog(@"%lf",y);
        if (y>Height*1.2) {
            if (!_btn) {
                self.btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
                _btn.frame = CGRectMake(Width-Width*0.12-15, Height-Width*0.5, Width*0.12, Width*0.12);
                [_btn setImage:[UIImage imageNamed:@"向上返回箭头"] forState:(0)];
                _btn.contentMode =UIViewContentModeScaleAspectFill;
                _btn .backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
                [_btn.layer setLaberMasksToBounds:YES cornerRadius:Width*0.06 borderWidth:0.3 borderColor:[UIColor grayColor]];
                [_btn addTarget:self action:@selector(UpTo) forControlEvents:(UIControlEventTouchUpInside)];
                [self.view addSubview:self.btn];
            }
        }else{
            if (_btn) {
                [_btn removeFromSuperview];
                _btn = nil;
            }
        }
        
    }
}
-(void)UpTo{
    
    if ([_webview subviews]) {
        UIScrollView* scrollView = [[_webview subviews] objectAtIndex:0];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}

#pragma mark - 关于数据
-(void)SET_DATA{
    NSLog(@"%@",self.article_id);
    
    if (self.type.length !=0) {
    [self requestDetailByType];
    }else{
    [self requestAction];
    }
    
}
#pragma mark - 商品网络请求
-(void)requestAction{
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = @{@"article_id":self.article_id};
    __weak typeof(self) weakSelf = self;

    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Article/requestDetail" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC: self success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"商品图文详情----%@",response);
        if (baseRes.resultCode == 1) {
            
            //反编译 [html HtmlToString]
            // [_webview loadHTMLString:[response[@"data"][@"content"] HtmlToString]baseURL:nil];
            [[LoadWaitSingle shareManager]showLoadWaitViewImage:@"兑富宝加载等待图"];
             [_webview loadHTMLString:response[@"data"][@"content"] baseURL:nil];
            weakSelf.title =response[@"data"][@"title"];
            
        }else{
            [weakSelf showToast:baseRes.msg];
        }
        
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
    
    
}

-(void)requestDetailByType{
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = @{@"type":self.type};
    __weak typeof(self) weakSelf = self;
    
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Article/requestDetailByType" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC: self success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"商品图文详情----%@",response);
        if (baseRes.resultCode == 1) {
            //反编译 [html HtmlToString]
            // [_webview loadHTMLString:[response[@"data"][@"content"] HtmlToString]baseURL:nil];
            [_webview loadHTMLString:response[@"data"][@"content"] baseURL:nil];
            weakSelf.title =response[@"data"][@"title"];
            
        }else{
            [weakSelf showToast:baseRes.msg];
        }
        
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[LoadWaitSingle shareManager] hideLoadWaitView];
      /*
    // 将商品详情界面图片等比例缩小至屏幕 JS
    NSString *smallImagesJS = @"var count = document.images.length;\
    for (var i = 0; i < count; i++) {\
    var image = document.images[i];\
    image.style.width='100%%';\
    image.style.height = 'auto';\
    };";
    [webView stringByEvaluatingJavaScriptFromString:smallImagesJS];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
     */
 
    
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    
    js=[NSString stringWithFormat:js,Width,Width-15];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
   
    //这里是js，主要目的实现对url的获取
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    self.dataArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
    if (self.dataArray.count >= 2) {
        [self.dataArray removeLastObject];
    }
    //urlResurlt 就是获取到得所有图片的url的拼接；mUrlArray就是所有Url的数组
    
    //添加图片可点击js
    [webView stringByEvaluatingJavaScriptFromString:@"function registerImageClickAction(){\
     var imgs=document.getElementsByTagName('img');\
     var length=imgs.length;\
     for(var i=0;i<length;i++){\
     img=imgs[i];\
     img.onclick=function(){\
     window.location.href='image-preview:'+this.src}\
     }\
     }"];
    [webView stringByEvaluatingJavaScriptFromString:@"registerImageClickAction();"];
    
    
    
}
//在这个方法中捕获到图片的点击事件和被点击图片的url
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //预览图片
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString* path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        NSLog(@"%@",path);
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",path);
        
        int index =0;
        
        for (int i=0; i<self.dataArray.count; i++) {
            if ([path isEqualToString:self.dataArray[i]]) {
                index =i;
            }
        }
        PhotoViewController *photoVC = [[PhotoViewController alloc] init];
        photoVC.urlArray = self.dataArray;
        //    SDCollectionViewCell * Cell=[cycleScrollView.mainView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        photoVC.imgFrame = self.view.frame;
        photoVC.index = index;
        //photoVC.frameArray = [_frameArray copy];
        photoVC.imgData = [self getImageDataWithUrl:[self.dataArray objectAtIndex:index]];
        //[self presentViewController:photoVC animated:NO completion:nil];
        photoVC.indexBlock = ^(NSInteger index){
        //[cycleScrollView ImageContentOffset:CGPointMake(index*Width,0)];
            
        };
        
        [photoVC setCompletedBlock:^(void){
            //        [_coverView removeFromSuperview];
            //        _coverView = nil;
        }];

        
        
        //path 就是被点击图片的url
        return NO;
    }
    return YES;
}

- (NSData *)getImageDataWithUrl:(NSString *)url
{
    NSData *imageData = nil;
    BOOL isExit = [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:url]];
    if (isExit) {
        NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:url]];
        if (cacheImageKey.length) {
            NSString *cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
            if (cacheImagePath.length) {
                imageData = [NSData dataWithContentsOfFile:cacheImagePath];
            }
        }
    }
    if (!imageData) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    }
    
    return imageData;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:@"网络无法连接"];
    [[LoadWaitSingle shareManager] hideLoadWaitView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{  [[NSNotificationCenter defaultCenter] removeObserver:self];
     [self.webview.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    NSLog(@"%@销毁了", [self class]);
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
