//
//  DataManager.m
//  GuiZhouRenShiKaoShi
//
//  Created by xcode on 13-3-15.
//  Copyright (c) 2013年 xcode. All rights reserved.
//

#import "DataManager.h"

@interface DataManager()
@property(nonatomic, strong)  NSString *dbPath;
@property(nonatomic, strong)  FMDatabase *dbRef;
@end

@implementation DataManager

+ (DataManager *)sharedInstance
{
    static DataManager *dm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        dm = [[DataManager alloc] init];
    });
    return dm;
}

- (NSString *)dbPath
{
    if(_dbPath) return _dbPath;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return [docDir stringByAppendingPathComponent:@"product.sqlite"];
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.dbRef = [FMDatabase databaseWithPath:self.dbPath];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        if([manager fileExistsAtPath:self.dbPath] == NO)
        {
            if(![self.dbRef open])
            {
                NSLog(@"不能打开数据库");
                return self;
            }
            
            NSString *sql = @"create table product(rid INTEGER PRIMARY KEY, pid INTEGER unique, title text, city text, customerCount INTEGER, desc text,\
                              imageUrl text,coastPrice REAL, vipPrice REAL, notVipPrice REAL)";
            if(![self.dbRef executeUpdate:sql])
            {
                NSLog(@"创建数据库失败");
            }
            
            [self.dbRef close];
        }
    }
    return self;
}


+ (void)collectProdcut:(Product *)product result:(void(^)(BOOL rect))result
{
    [[DataManager sharedInstance] collectProdcut:product result:^(BOOL rect) {
        result(rect);
    }];
}

+ (void)removeCollectedProduct:(NSInteger)pid
{
    [[DataManager sharedInstance] removeCollectedProduct:pid];
}

+ (void)getAllCollectedProduct:(void(^)(NSMutableArray *))result
{
    [[DataManager sharedInstance] getAllCollectedProduct:^(NSMutableArray *rect) {
        result(rect);
    }];
}

- (void)collectProdcut:(Product *)product result:(void(^)(BOOL rect))result
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if(![self.dbRef open])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                 result(NO);
            });
            NSLog(@"打开数据库失败!");
            return;
        }
        
        FMResultSet *rs = [self.dbRef executeQueryWithFormat:@"select * from product where pid=%d",product.ID];
        int itemCount = 0;
        while([rs next])
        {
            ++itemCount;
            break;
        }
        
        if(itemCount > 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                result(NO);
            });
            return;
        }
        
        BOOL aBool = [self.dbRef executeUpdate:@"insert into product (pid,title,city,customerCount,desc,imageUrl,coastPrice,vipPrice,notVipPrice) values(?,?,?,?,?,?,?,?,?)",
                      [NSNumber numberWithInteger:product.ID],
                      product.shopName,
                      product.cityName,
                      [NSNumber numberWithInt:product.sumBuyQty],
                      product.description,
                      product.txImg,
                      [NSNumber numberWithFloat:product.priceGoods],
                      [NSNumber numberWithFloat:product.priceGroup],
                      [NSNumber numberWithFloat:product.priceNonMember]];
        
        [self.dbRef close];
        dispatch_async(dispatch_get_main_queue(), ^{
            result(aBool);
        });
    });
}

- (void)removeCollectedProduct:(NSInteger)pid
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if(![self.dbRef open])
        {
            NSLog(@"打开数据库失败!");
            return;
        }
        
        [self.dbRef executeUpdateWithFormat:@"delete from product where rid=%d", pid];
        [self.dbRef close];
    });
}

- (void)getAllCollectedProduct:(void(^)(NSMutableArray *))result
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *productArray = [NSMutableArray new];

        if(![self.dbRef open])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                result(productArray);
            });
            NSLog(@"打开数据库失败!");
            return;
        }
        
        FMResultSet *rs = [self.dbRef executeQuery:@"select * from product"];
        while([rs next])
        {
            Product *product = [Product new];
            
            product.ID              = [rs intForColumn:@"pid"];
            product.dbID            = [rs intForColumn:@"rid"];
            product.shopName        = [rs stringForColumn:@"title"];
            product.cityName        = [rs stringForColumn:@"city"];
            product.sumBuyQty       = [rs intForColumn:@"customerCount"];
            product.description     = [rs stringForColumn:@"desc"];
            product.txImg           = [rs stringForColumn:@"imageUrl"];
            product.priceGoods      = [rs doubleForColumn:@"coastPrice"];
            product.priceGroup      = [rs doubleForColumn:@"vipPrice"];
            product.priceNonMember  = [rs doubleForColumn:@"notVipPrice"];
            
            [productArray addObject:product];
        }

        [self.dbRef close];
        dispatch_async(dispatch_get_main_queue(), ^{
            result(productArray);
        });
    });
}

@end



