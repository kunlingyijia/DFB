//
//  IndianaHomeOneVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/29.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndianaHomeOneVC : UICollectionViewCell<SDCycleScrollViewDelegate>
///轮播图
@property (nonatomic, copy) void(^IndianaHomeOneCellScrollViewImageBlock)(NSInteger tag);
///分类-我的-晒单-帮助
@property (nonatomic, copy) void(^IndianaHomeOneCellBlock)(NSInteger tag);

///人气-最新-进度-
@property (nonatomic, copy) void(^IndianaHomeOneCellMenuBlock)(NSInteger tag,NSString * IsUp);

@property (weak, nonatomic) IBOutlet UIButton *OneBtn;
@property (weak, nonatomic) IBOutlet UIButton *TwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *ThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *FourBtn;

@property (weak, nonatomic) IBOutlet UIView *ShufflingImgView;
@property (weak, nonatomic) IBOutlet UIView *ShufflingLabelView;
@property (weak, nonatomic) IBOutlet UIView *MenuView;

-(void)cellGetDataWithBanner:(NSMutableArray*)arr;
-(void)cellGetDataWithWin:(NSMutableArray*)arr;


@end
