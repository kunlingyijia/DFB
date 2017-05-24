//
//  MyShareEWMViewController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface MyShareEWMViewController : BaseViewController
    @property (weak, nonatomic) IBOutlet UIButton *CopyBtn;
    @property (weak, nonatomic) IBOutlet UIButton *ShareBtn;
//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *useImageView;
///用户头像url
@property (nonatomic, strong) NSString  *avatar_url ;


@end
