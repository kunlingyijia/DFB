//
//  MyShopTwoCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyShopModel;

@interface MyShopTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *merchant_mobile;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
@property(nonatomic,copy) void(^cell)(NSString *str);

@property (weak, nonatomic) IBOutlet UILabel *address;
-(void)CellGetData:(MyShopModel*)model;

@end
