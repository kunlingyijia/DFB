//
//  OrderMainCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PublicBtn;
@class GoodsModel;
@interface OrderMainCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *goods_logo;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *name;

-(void)cellGetData:(GoodsModel*)model;
@end
