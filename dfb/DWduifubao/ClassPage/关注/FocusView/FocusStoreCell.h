//
//  FocusStoreCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyShopModel;
@interface FocusStoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *merchant_logo;
@property (weak, nonatomic) IBOutlet UILabel *merchant_name;
@property (weak, nonatomic) IBOutlet UILabel *collect_peoples;
-(void)cellGetData:(MyShopModel*)model;
@end
