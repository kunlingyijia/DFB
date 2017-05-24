//
//  MyLoanOrCardTwoCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyLoanOrCardModel;
@interface MyLoanOrCardTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image_url;



-(void)CellGetData:(MyLoanOrCardModel*)model;
@end
