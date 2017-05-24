//
//  NavigationView.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>







@protocol NavigationViewdelegate <NSObject>

-(void)NavErWeiMaPush;
-(void)NavSouSuoPush;
-(void)NavMassagePush;
@end
@interface NavigationView : UIView
///自制导航代理
@property (nonatomic, assign) id<NavigationViewdelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *SaoYiSaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *sousuoBtn;
@property (weak, nonatomic) IBOutlet UIButton *SouSuoKuangBtn;
@property (weak, nonatomic) IBOutlet UIButton *XiaoXiBtn;

@end
