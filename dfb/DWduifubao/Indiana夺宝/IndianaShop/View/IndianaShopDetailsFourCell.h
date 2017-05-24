//
//  IndianaShopDetailsFourCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndianaUserSunModel;
@interface IndianaShopDetailsFourCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar_url;
@property (weak, nonatomic) IBOutlet UILabel *nick_name;

@property (weak, nonatomic) IBOutlet UILabel *label;
///model
@property (nonatomic, strong) IndianaUserSunModel *model ;
@end
