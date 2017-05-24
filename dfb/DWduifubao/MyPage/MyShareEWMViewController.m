//
//  MyShareEWMViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MyShareEWMViewController.h"
#import "ErWeiMa.h"
@interface MyShareEWMViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ErWeiMaImageView;
@property(nonatomic,strong)NSString *ShareStr;
@property(nonatomic,strong)NSString * ShareImageStr;
@end

@implementation MyShareEWMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.CopyBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.CopyBtn.layer.borderWidth = 0.5;
    self.CopyBtn.layer.cornerRadius = 5;
     self.ShareBtn.layer.cornerRadius = 5;
    self.ShareBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.ShareBtn.layer.borderWidth = 0.5;
    self.title = @"我的二维码";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
   self.ShareStr =  [NSString stringWithFormat:@"%@%@", [AuthenticationModel getinvite_url],[AuthenticationModel getLoginToken]];
    self.ShareImageStr =[NSString stringWithFormat:@"%@",[AuthenticationModel getinvite_image]];
    self.useImageView.layer.masksToBounds = YES;
    self.useImageView.layer.cornerRadius = 10.0;
    [DWHelper SD_WebImage:self.useImageView imageUrlStr:self.avatar_url placeholderImage:nil];
    ErWeiMa *er =[ErWeiMa shareErWeiMa];
   // NSLog(@"%@",[AuthenticationModel getinvite_url]);
    [er erweima:_ErWeiMaImageView string:_ShareStr];
}
#pragma mark - 复制链接
- (IBAction)CopyBtnAction:(UIButton *)sender {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
        [pab setString:_ShareStr];
    
    if (pab == nil) {
        [self showToast:@"复制失败"];
    }else
    {
        [self showToast:@"已复制"];
    }
}
#pragma mark - 分享
- (IBAction)ShareAction:(UIButton *)sender {
    //显示分享面板
    __weak typeof(self) weakSelf = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        [weakSelf shareWebPageToPlatformType:platformType];
    }];
    

}
    #pragma mark - 分享text
    - (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
    {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //设置文本
        messageObject.text = self.ShareStr;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
            }
        }];
    }


- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //设置文本
    messageObject.text =[NSString stringWithFormat:@"%@%@%@", self.ShareStr,[AuthenticationModel getinvite_title],[AuthenticationModel getinvite_description]];

    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
   // shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    [shareObject setShareImage:[AuthenticationModel getinvite_image]];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

#pragma mark - 分享网页
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[AuthenticationModel getinvite_title] descr:[AuthenticationModel getinvite_description] thumImage:self.ErWeiMaImageView.image];
    //设置网页地址
    shareObject.webpageUrl =self.ShareStr;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
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
