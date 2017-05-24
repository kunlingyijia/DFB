//
//  HeaderReusableView.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicBtn.h"
@interface HeaderReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *Label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet PublicBtn *btn;
@end
