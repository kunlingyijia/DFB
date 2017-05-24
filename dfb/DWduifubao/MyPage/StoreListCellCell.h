//
//  StoreListCellCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/9.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyShopModel;
@interface StoreListCellCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *merchant_logo;
@property (weak, nonatomic) IBOutlet UILabel *merchant_name;
@property (weak, nonatomic) IBOutlet UILabel *collect_peoples;
-(void)cellGetData:(MyShopModel*)model;
@end
