//
//  HotHomeCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/17.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotHomeCell : UICollectionViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
///HotHomeCellBlock
@property (nonatomic, copy) void(^HotHomeCellBlock)(NSInteger tag) ;




///
@property (nonatomic, strong) UICollectionView  *collectionView ;

-(void)CellGetData:(NSMutableArray*)Arr;
///
@property (nonatomic, assign) NSInteger count;

@end
