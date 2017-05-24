//
//  IndianaShopDetailsVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface IndianaShopDetailsVC : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *AllLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
///商品id
@property (nonatomic, strong) NSString  *goods_id ;
@end
