//
//  IndianaClassOneCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/3.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndianaShopClassModel;
@interface IndianaClassOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon_url;

@property (weak, nonatomic) IBOutlet UILabel *category_name;

///model
@property (nonatomic, strong) IndianaShopClassModel *model ;
@end
