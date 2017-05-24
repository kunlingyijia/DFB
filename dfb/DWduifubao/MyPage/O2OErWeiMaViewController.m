//
//  O2OErWeiMaViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "O2OErWeiMaViewController.h"
#import "ErWeiMa.h"

@interface O2OErWeiMaViewController ()

@property (weak, nonatomic) IBOutlet UILabel *ErWeiMaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ErWeiMaImageView;

@end

@implementation O2OErWeiMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收款二维码";
    [self showBackBtn];
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    ErWeiMa *er =[ErWeiMa shareErWeiMa];
    // NSLog(@"%@",[AuthenticationModel getinvite_url]);
    [er erweima:_ErWeiMaImageView string:self.qrcode_url];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat: @"请用%@扫描二维码进行收款",self.ErWeiMaLabelStr]];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:20]
     
                          range:NSMakeRange(2, self.ErWeiMaLabelStr.length)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(2, self.ErWeiMaLabelStr.length)];
    
    self.ErWeiMaLabel.attributedText = AttributedStr;

   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
