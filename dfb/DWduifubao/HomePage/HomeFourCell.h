//
//  HomeFourCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyShopModel;

@interface HomeFourCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *merchant_name;
@property (weak, nonatomic) IBOutlet UIImageView *merchant_logo;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet PublicBtn *JinDianBut;
///MyShopModel*)model
//@property (nonatomic, strong) MyShopModel*model ;


-(void)cellGetData:(MyShopModel*)model;

@end
