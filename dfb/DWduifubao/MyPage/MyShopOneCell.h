//
//  MyShopOneCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyShopModel;
@interface MyShopOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *merchant_logo;

@property (weak, nonatomic) IBOutlet UILabel *merchant_name;
@property (weak, nonatomic) IBOutlet UIImageView *GuanZhuImageView;
@property (weak, nonatomic) IBOutlet UILabel *GuanZhuLabel;
@property (weak, nonatomic) IBOutlet UILabel *collect_peoples;
@property (weak, nonatomic) IBOutlet UIImageView *main_image;

@property (weak, nonatomic) IBOutlet UIButton *GuanZhuBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property(nonatomic,copy) void(^cell)();

-(void)CellGetData:(MyShopModel*)model;
@end

