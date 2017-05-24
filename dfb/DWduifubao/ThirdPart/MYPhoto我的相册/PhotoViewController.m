//
//  PhotoViewController.m
//  CollectionViewPhoto
//
//  Created by Mac on 16/4/19.
//  Copyright © 2016年 jyb. All rights reserved.
//

#import "PhotoViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "FrameModel.h"
#import "MBProgressHUD.h"

#define SCREEN_WIDTH            [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT           [[UIScreen mainScreen] bounds].size.height
// 图片保存成功提示文字
#define SDPhotoBrowserSaveImageSuccessText @" 保存成功 ";

// 图片保存失败提示文字
#define SDPhotoBrowserSaveImageFailText @" 保存失败 ";
@interface PhotoViewController ()<UIScrollViewDelegate>
{
    BOOL            _large;
    UIScrollView    *_zoomingScrollView;
    CGFloat         _contentOffsetX;
    UIScrollView    *scroll;
    UIPageControl *_pageControl;
}

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH+20, SCREEN_HEIGHT)];
    scroll.tag = 55;
    scroll.delegate = self;
    scroll.backgroundColor = [UIColor blackColor];
    scroll.contentSize = CGSizeMake((SCREEN_WIDTH+20)*self.urlArray.count, SCREEN_HEIGHT);
    scroll.pagingEnabled = YES;
    [self.view addSubview:scroll];
    if (self.urlArray.count > 1 )
    {
        UIPageControl *pCtrl = [[UIPageControl alloc] init];
        pCtrl.frame =  CGRectMake((self.view.bounds.size.width-60)/2, self.view.bounds.size.height-30, 80, 30);
        pCtrl.numberOfPages = self.urlArray.count;
        [self.view addSubview:pCtrl];
        _pageControl = pCtrl;
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [scroll setContentOffset:CGPointMake(self.index * (SCREEN_WIDTH+20), 0) animated:NO];
    _contentOffsetX = scroll.contentOffset.x;
    _pageControl.currentPage =self. index;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (int i = 0; i < self.urlArray.count; i ++) {
        
        UIScrollView *scl = [[UIScrollView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH+20)*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        scl.tag = 44;
        scl.delegate = self;
        scl.minimumZoomScale = 1.0;
        scl.maximumZoomScale = 2.0;
        scl.decelerationRate = 0.1;
        scl.backgroundColor = [UIColor blackColor];
        [scroll addSubview:scl];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:imgView animated:NO];
        hud.mode = MBProgressHUDModeDeterminate;
        [imgView addSubview:hud];
        
        [SDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
        
        [imgView sd_setImageWithURL:[self.urlArray objectAtIndex:i] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            hud.progress = (float)receivedSize / (float)expectedSize;
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [hud hide:NO];
        }];
        
        
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.clipsToBounds = YES;
        imgView.userInteractionEnabled = YES;
        imgView.tag = 666;
        [scl addSubview:imgView];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [imgView addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        singleTap.numberOfTapsRequired = 1;
        [imgView addGestureRecognizer:singleTap];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewLongPressed:)];
         [imgView addGestureRecognizer:longPress];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        
        if (i != self.index) {
            
            imgView.frame = CGRectMake(0, SCREEN_HEIGHT/4, SCREEN_WIDTH, SCREEN_HEIGHT/2);
            
        }else{
            
            CGRect frame = CGRectMake(0, SCREEN_HEIGHT/4, SCREEN_WIDTH, SCREEN_HEIGHT/2);
            imgView.frame = self.imgFrame;
            [UIView animateWithDuration:0.2 animations:^{
                imgView.frame = frame;
            } completion:^(BOOL finished) {
                
            }];
        }
        
    }
}
- (void)imageViewLongPressed:(UILongPressGestureRecognizer *)gesture{
     if(gesture.state == UIGestureRecognizerStateBegan){
         __weak typeof(self) weakSelf = self;

         UIAlertController * alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
         UIAlertAction * OK = [UIAlertAction actionWithTitle:@"保存图片" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
             
             UIImageView* imageView=(UIImageView*)[gesture view];
             //调用方法
             UIImage *savedImage = imageView.image;
             [weakSelf saveImageToPhotos:savedImage];
             
         }];
         UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
         }];
         [alertC addAction:OK];
         [alertC addAction:cancel];
         [self presentViewController:alertC animated:YES completion:nil];

         
         
    
     }
    
}
//实现该方法
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //因为需要知道该操作的完成情况，即保存成功与否，所以此处需要一个回调方法image:didFinishSavingWithError:contextInfo:
}
//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    //NSString *msg = nil ;
    //if(error != NULL){
       // msg = @"保存图片失败" ;
    //}else{
       // msg = @"保存图片成功" ;
    //}
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:14];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = SDPhotoBrowserSaveImageFailText;
    }   else {
        label.text = SDPhotoBrowserSaveImageSuccessText;
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
    //UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    //[self showViewController:alert sender:nil];
}
//注iOS9弃用了UIAlertView类。




- (void)singleTap:(UITapGestureRecognizer *)gesture
{
    UIImageView *imgView = (UIImageView *)gesture.view;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    self.view.backgroundColor = [UIColor clearColor];
    scroll.backgroundColor = [UIColor clearColor];
    [window addSubview:imgView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
       // imgView.frame = self.imgFrame;
        
    } completion:^(BOOL finished) {
        
        if (_completedBlock) {
            _completedBlock();
        }
        
        [imgView removeFromSuperview];
    }];
    
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)doubleTap:(UITapGestureRecognizer *)gesture
{
    UIScrollView *scl = (UIScrollView *)gesture.view.superview;
    
    if (scl.zoomScale == scl.maximumZoomScale) {
        
        [scl setZoomScale:1.0 animated:YES];
        _large = NO;
        _zoomingScrollView = nil;
        return;
    }
    
    if (_large) {
        
        [scl setZoomScale:1.0 animated:YES];
        _large = NO;
        _zoomingScrollView = nil;
        
    }else{
        
        CGPoint location = [gesture locationInView:gesture.view];
        [scl zoomToRect:CGRectMake(location.x, location.y, 1, 1) animated:YES];
        _large = YES;
        _zoomingScrollView = scl;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return (UIImageView *)[scrollView viewWithTag:666];
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    static CGFloat x,y;
    
    UIScrollView *superscl = (UIScrollView *)scrollView.superview;
    
    CGFloat xcenter = scrollView.center.x-superscl.contentOffset.x , ycenter = scrollView.center.y;
    
    if (_zoomingScrollView == nil) {
        x = xcenter;
        y = ycenter;
    }else{
        xcenter = x;
        ycenter = y;
        _zoomingScrollView = nil;
    }
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
    [[scrollView viewWithTag:666] setCenter:CGPointMake(xcenter, ycenter)];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 55) {
        
        if (scrollView.contentOffset.x != _contentOffsetX) {
            _contentOffsetX = scrollView.contentOffset.x;
            
            if (_zoomingScrollView) {
                [_zoomingScrollView setZoomScale:1.0 animated:YES];
                _large = NO;
            }
        }
        
        self.index = (NSInteger)(_contentOffsetX / (SCREEN_WIDTH+20));
        _pageControl.currentPage =self. index;
        FrameModel *frame = [self.frameArray objectAtIndex:self.index];
        
        self.imgFrame = CGRectMake(frame.x, frame.y, frame.width, frame.height);
    }
    
    if (_indexBlock) {
        _indexBlock(_index);
    }
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
