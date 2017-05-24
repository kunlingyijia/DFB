//
//  MyServiceCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/2/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "MyServiceCell.h"

@implementation MyServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.label.textColor = [UIColor redColor];
       // self.label.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    }else
    {
        self.label.textColor = [UIColor blackColor];
        self.label.backgroundColor = [UIColor whiteColor];
        
    }

    
}

@end
