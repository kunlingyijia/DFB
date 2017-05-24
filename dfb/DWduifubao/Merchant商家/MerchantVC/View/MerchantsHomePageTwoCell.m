//
//  MerchantsHomePageTwoCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "MerchantsHomePageTwoCell.h"

@implementation MerchantsHomePageTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)oneBtnAction:(PublicBtn *)sender {
    self.MerchantsHomePageTwoCellBlock(sender.tag-100);
      

    
    
    
}




@end
