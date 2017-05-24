//
//  MoneyViewController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/31.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface MoneyViewController : BaseViewController
///act
@property (nonatomic, strong) NSString *act ;
///titlelable
@property (nonatomic, strong) NSString *titlelab ;


///账户兑富宝
@property (nonatomic, assign) CGFloat virtual_glodAndcash;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *virtual_glodAndcashLabel;


@end
