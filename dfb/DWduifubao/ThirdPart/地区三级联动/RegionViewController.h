//
//  RegionViewController.h
//  test
//
//  Created by 席亚坤 on 16/11/18.
//  Copyright © 2016年 席亚坤. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnData1)(NSDictionary*reqionDic );

@interface RegionViewController : UIViewController
-(void)ReqionReturn:(ReturnData1)data;

///block
@property (nonatomic, copy) ReturnData1 returnData ;
@property (weak, nonatomic) IBOutlet UIView *underView;


@end
