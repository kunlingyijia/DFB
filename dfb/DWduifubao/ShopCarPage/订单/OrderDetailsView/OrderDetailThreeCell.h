//
//  OrderDetailThreeCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CarModel;
@interface OrderDetailThreeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goods_logo;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *number;
///单价
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *goods_spec_name;



-(void)cellGetData:(CarModel*)model;
@end
