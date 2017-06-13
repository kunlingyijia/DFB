//
//  IndianaHomeOneVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/29.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndianaHomeOneVC.h"
#import "IndianaMenu.h"
#import "IndianaHomeModel.h"
#import "SGAdvertScrollView.h"
@interface IndianaHomeOneVC ()<SGAdvertScrollViewDelegate>
@property(nonatomic,strong)    SDCycleScrollView *cycleScrollViewImage;
@property(nonatomic,strong)  SDCycleScrollView * cycleScrollViewText;
@property(nonatomic,strong)IndianaMenu *indianaMenu;
@property(nonatomic,strong)SGAdvertScrollView *SGAdvertScrollViewImage;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)UILabel *label;
@end
@implementation IndianaHomeOneVC
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    
    [self.OneBtn setImagePosition:LXMImagePositionTop spacing:2];
    [self.TwoBtn setImagePosition:LXMImagePositionTop spacing:2];
    [self.ThreeBtn setImagePosition:LXMImagePositionTop spacing:2];
    [self.FourBtn setImagePosition:LXMImagePositionTop spacing:2];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self createView];
}
- (void)createView {
    // 网络加载图片的轮播器
    if (!_cycleScrollViewImage) {
        self. cycleScrollViewImage = [SDCycleScrollView   cycleScrollViewWithFrame:CGRectMake(0, 0, Width, Width*0.4) delegate:self placeholderImage:[UIImage imageNamed:@"敬请期待long"]];
        self. cycleScrollViewImage.autoScrollTimeInterval =3.0;
        [self.ShufflingImgView addSubview:  _cycleScrollViewImage];
    }
    // 轮播文字
    if (!_cycleScrollViewText) {
        self. cycleScrollViewText = [SDCycleScrollView   cycleScrollViewWithFrame:CGRectMake(42, 0, Width-42, Width*0.1-5) delegate:self placeholderImage:nil];
        _cycleScrollViewText.scrollDirection = UICollectionViewScrollDirectionVertical;
        _cycleScrollViewText.onlyDisplayText = YES;
        _cycleScrollViewText.titleLabelBackgroundColor = [UIColor whiteColor];
        _cycleScrollViewText.titleLabelTextFont = [UIFont systemFontOfSize:13];
        _cycleScrollViewText.titleLabelTextColor = [UIColor grayColor];
        _cycleScrollViewText.autoScrollTimeInterval =3.0;
        //[self.ShufflingLabelView addSubview:  _cycleScrollViewText];
    }
//    // 轮播文字-- 副文本式
//    if (!_SGAdvertScrollViewImage) {
//        self. SGAdvertScrollViewImage = [[SGAdvertScrollView alloc] initWithFrame:CGRectMake(0, 0, Width, Width*0.1-5)];
//      _SGAdvertScrollViewImage. image = [UIImage imageNamed:@"兑富夺宝-消息图标"];
//       _SGAdvertScrollViewImage.isHaveMutableAttributedString = YES;
//        _SGAdvertScrollViewImage.advertScrollViewDelegate = self;
//        _SGAdvertScrollViewImage.tintColor = [UIColor grayColor];
//        _SGAdvertScrollViewImage.titleFont = [UIFont systemFontOfSize:13];
//        _SGAdvertScrollViewImage.titleArray = self.dataArray.count==0 ? @[[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"暂无数据"]]]:self.dataArray;
//        [self.ShufflingLabelView addSubview:  _SGAdvertScrollViewImage];
//    }
    
    
    // 轮播文字-- 副文本式
    if (!_label) {
        self. label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, Width-40, Width*0.1-5)];
        __block   NSInteger  count = 0;
        self.label.font = [UIFont systemFontOfSize:12];
        self.label.tintColor = [UIColor lightGrayColor];
        self.label.numberOfLines = 1 ;
        [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer*_Nonnulltimer) {
            CATransition*tran = [CATransition animation];
            //tran.type=kCATransitionFade;
            //配置过度动画类型
            tran.type = @"cube";
            tran.subtype=kCATransitionFromTop;
            [self.label.layer addAnimation:tran forKey:@"trans"];
            if (self.dataArray.count==0) {
                return;
            }
            self.label.attributedText= self.dataArray[count];
            if(count== self.dataArray.count-1) {
                
                count=0;
                
            }else{
                
                count=count+1;
            }
            
        }];
        [self.ShufflingLabelView addSubview:  _label];
    }
    if (!_indianaMenu) {
        self.indianaMenu = [[IndianaMenu alloc]initWithFrame:CGRectMake(0, 0, Width, Width*0.11) IsClass:NO ClassArr:[@[@""]mutableCopy] ClassOneBtntitle:@""];
        [self.MenuView addSubview:_indianaMenu];
        __weak typeof(self) weakSelf = self;

        _indianaMenu.IndianaMenuBlock=^(NSInteger tag,NSString * IsUp){
            weakSelf.IndianaHomeOneCellMenuBlock(tag,IsUp);
                        
        };
    }
    
}

#pragma mark - 点击事件
- (IBAction)BtnAction:(UIButton *)sender {
    
    self.IndianaHomeOneCellBlock(sender.tag-210);
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    cycleScrollView =_cycleScrollViewImage;
  self. IndianaHomeOneCellScrollViewImageBlock(index);
    
}



///轮播图赋值
-(void)cellGetDataWithBanner:(NSMutableArray*)arr{
    
    // 网络加载图片的轮播器
    if (_cycleScrollViewImage) {
        NSMutableArray *banner_imageArr = [NSMutableArray arrayWithCapacity:0];
        for (IndianaHomeModel * model in arr) {
            [banner_imageArr addObject:model.banner_image];
        }
    _cycleScrollViewImage.imageURLStringsGroup =   banner_imageArr;
    
    }

    
    
    
    
}
///喇叭赋值
-(void)cellGetDataWithWin:(NSMutableArray*)arr{
    [self.dataArray removeAllObjects];
            for (IndianaHomeModel * model in arr) {
    
                    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"恭喜 %@ %@获得%@",model.name,model.time_before,model.goods_name]];
                            [AttributedStr addAttribute:NSFontAttributeName
    
                                                  value:[UIFont systemFontOfSize:12]
    
                                                  range:NSMakeRange(3, model.name.length+1)];
    
                            [AttributedStr addAttribute:NSForegroundColorAttributeName
    
                                                  value:[UIColor colorWithHexString:@"#1757ae"]
    
                                                  range:NSMakeRange(3, model.name.length+1)];
    
        
                [self.dataArray addObject:AttributedStr];
    
    
               // [banner_imageArr addObject:[NSString stringWithFormat:@"恭喜 ""%@"" %@获得%@",model.name,model.time_before,model.goods_name]];
    
    
            }
    if (self.dataArray.count==0) {
        return;
    }
       self.label.attributedText= self.dataArray[self.dataArray.count-1];

            //_SGAdvertScrollViewImage.titleArray = banner_imageArr.count==0 ? @[[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"暂无数据"]]]:banner_imageArr;
            
           // _SGAdvertScrollViewImage.titleArray = banner_imageArr;

    
//    // 网络加载图片的轮播器
    
//    if (_cycleScrollViewText) {
//        NSMutableArray *banner_imageArr = [NSMutableArray arrayWithCapacity:0];
//        for (IndianaHomeModel * model in arr) {
//
//            
//            
//            [banner_imageArr addObject:[NSString stringWithFormat:@"恭喜 ""%@"" %@获得%@",model.name,model.time_before,model.goods_name]];
//            
//            
//        }
//        
//
//         _cycleScrollViewText.titlesGroup = banner_imageArr.count==0 ? @[@"暂无数据"]:banner_imageArr;
//    }

    
//    if (_SGAdvertScrollViewImage) {
//        [_SGAdvertScrollViewImage removeFromSuperview];
//        _SGAdvertScrollViewImage = nil;
//    }
    
//    // 轮播文字-- 副文本式
//    if (!_SGAdvertScrollViewImage) {
//        self. SGAdvertScrollViewImage = [[SGAdvertScrollView alloc] initWithFrame:CGRectMake(0, 0, Width, Width*0.1-5)];
//        _SGAdvertScrollViewImage. image = [UIImage imageNamed:@"兑富夺宝-消息图标"];
//        _SGAdvertScrollViewImage.isHaveMutableAttributedString = YES;
//        _SGAdvertScrollViewImage.advertScrollViewDelegate = self;
//        _SGAdvertScrollViewImage.tintColor = [UIColor grayColor];
//        _SGAdvertScrollViewImage.titleFont = [UIFont systemFontOfSize:13];
//        
//        [self.ShufflingLabelView addSubview:  _SGAdvertScrollViewImage];
//    }
//    
//    [self.dataArray removeAllObjects];
//    // 网络加载图片的轮播器
//    if (_SGAdvertScrollViewImage) {
//
//        
//
//
//       
//    }

    
    
    
}





/// 代理方法
- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index {
    
}



@end
