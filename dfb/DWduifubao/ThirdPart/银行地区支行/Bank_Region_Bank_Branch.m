//
//  Bank_Region_Bank_Branch.m
//  Bank_Region_Bank_branch
//
//  Created by 席亚坤 on 16/12/6.
//  Copyright © 2016年 席亚坤. All rights reserved.
//
#import "Bank_Region_Bank_Branch.h"
#import "FMDatabase.h"//第三方数据库操作类
@implementation Bank_Region_Bank_BranchModel

@end
static  Bank_Region_Bank_Branch * bank = nil;
@implementation Bank_Region_Bank_Branch
+(Bank_Region_Bank_Branch*)shareBank_Region_Bank_Branch{
       static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bank = [[Bank_Region_Bank_Branch alloc]init];
        [bank creatDataBase];
    });
    return bank;
}
//1.创建数据库
-(void)creatDataBase{
    self.db = [FMDatabase databaseWithPath:[[NSBundle mainBundle]pathForResource:@"dfb_bankt" ofType:@"sqlite"]];
}

//获取银行
-(void)selectDataFromBack:(ReturnData)ReturnArr{
    //1.打开数据库
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:1];
       BOOL isOpen = [self.db open];
    if (isOpen) {
        //2.通过SQL语句操作数据库 --- 查询所有数据
        FMResultSet *reslut = [self.db executeQuery:@"select DISTINCT bank_name ,bank_no from bank "];
        while ([reslut next]) {
          Bank_Region_Bank_BranchModel *model = [[Bank_Region_Bank_BranchModel alloc]init];
            model.bank_name     =[reslut stringForColumn:@"bank_name"];
            model.bank_no =[reslut stringForColumn:@"bank_no"];
            [array addObject:model];
        }
               //3.关闭数据库
        [self.db close];
        ReturnArr(array);
    }
    
}
//获取省
-(void)selectDataFromProvince:(ReturnData)ReturnArr{
    //1.打开数据库
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:1];
    
    BOOL isOpen = [self.db open];
    if (isOpen) {
        //2.通过SQL语句操作数据库 --- 查询所有数据
        FMResultSet *reslut = [self.db executeQuery:@"select DISTINCT province_name ,province_id from bank "];
        while ([reslut next]) {

            Bank_Region_Bank_BranchModel *model = [[Bank_Region_Bank_BranchModel alloc]init];

            model.province_name     =[reslut stringForColumn:@"province_name"];
            model.province_id =[reslut stringForColumn:@"province_id"];
            [array addObject:model];

        }
        //3.关闭数据库
        [self.db close];
        ReturnArr(array);
      }
    }
//获取市
-(void)selectDataFromCityWithProvince_id:(NSString*)province_id ReturnArr :(ReturnData)ReturnArr{
    //1.打开数据库
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:1];
    BOOL isOpen = [self.db open];
    if (isOpen) {
        //2.通过SQL语句操作数据库 --- 查询所有数据
        FMResultSet *reslut = [self.db executeQuery:@"select DISTINCT city_name ,city_id from bank where  province_id= ?",province_id];
        while ([reslut next]) {
            Bank_Region_Bank_BranchModel *model = [[Bank_Region_Bank_BranchModel alloc]init];
            model.city_name     =[reslut stringForColumn:@"city_name"];
            model.city_id =[reslut stringForColumn:@"city_id"];
            [array addObject:model];
        }
        //3.关闭数据库
        [self.db close];
        ReturnArr(array)
        ;
    }
}
//获取支行
-(void)selectDataFromBack_branchWithBack_no:(NSString *)back_no city_id:(NSString*)city_id ReturnArr :(ReturnData)ReturnArr{
    //1.打开数据库
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:1];
    BOOL isOpen = [bank.db open];
    if (isOpen) {
        //2.通过SQL语句操作数据库 --- 查询所有数据
        FMResultSet *reslut = [bank.db executeQuery:@"select * from bank where bank_no= ? and city_id = ?",back_no ,city_id];
        while ([reslut next]) {
            
          Bank_Region_Bank_BranchModel *model = [[Bank_Region_Bank_BranchModel alloc]init];
            model.bank_branch     =[reslut stringForColumn:@"bank_branch"];
            model.bank_branch_no =[reslut stringForColumn:@"bank_branch_no"];
            [array addObject:model];
        }
        //3.关闭数据库
        [bank.db close];
        ReturnArr(array);
        
        
    }

}
//模糊搜索支行
-(void)selectDataFromBack_branchWithBack_no:(NSString *)back_no city_id:(NSString*)city_id Str:(NSString*)str ReturnArr :(ReturnData)ReturnArr{
    //1.打开数据库
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:1];
    BOOL isOpen = [bank.db open];
    if (isOpen) {
        //2.通过SQL语句操作数据库 --- 查询所有数据
        NSString * tt = [NSString stringWithFormat:@"select * from bank where bank_branch like  '%%%@%%' and bank_no= %@ and city_id = %@ ",str, back_no,city_id];
        FMResultSet *reslut = [bank.db executeQuery:tt];
        while ([reslut next]) {
            
            Bank_Region_Bank_BranchModel *model = [[Bank_Region_Bank_BranchModel alloc]init];
            model.bank_branch     =[reslut stringForColumn:@"bank_branch"];
            model.bank_branch_no =[reslut stringForColumn:@"bank_branch_no"];
            [array addObject:model];
        }
        //3.关闭数据库
        [bank.db close];
        ReturnArr(array);
        
        
    }
    
}

@end
