//
//  MyShopThreeCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyShopModel;

@interface MyShopThreeCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *address;
-(void)CellGetData:(MyShopModel*)model;

@end
