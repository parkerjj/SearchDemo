//
//  StorageManager.m
//  Petbook
//
//  Created by 劉玥 on 15/7/2.
//  Copyright (c) 2015年 Parker. All rights reserved.
//

#import "StorageManager.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"

@interface StorageManager() {
    

}

@end

@implementation StorageManager
static StorageManager *_manager;
static NSMutableDictionary *_plistDic;

+ (void)initialize{
    [super initialize];
    if (_manager == nil) {
        _manager = [[StorageManager alloc] init];
    }
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //统一设备号
        _plistDic = [self readPListDictionaryToMemoery];

    }
    return self;
}

+ (StorageManager*)defaultManager{
    return _manager;
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (NSMutableDictionary*)readPListDictionaryToMemoery{
    NSURL *fileManagerURL =  [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *filePathURL = [fileManagerURL URLByAppendingPathComponent:@"/setting.dat"];

    NSMutableDictionary *mDic;
    
    NSData *data = [NSData dataWithContentsOfURL:filePathURL];
    @try {
        NSDictionary *dicFromFile = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
        mDic = [NSMutableDictionary dictionaryWithDictionary:dicFromFile];
    } @catch (NSException *exception) {
        mDic = [NSMutableDictionary dictionary];

    } @finally {
        
    }

    return mDic;
}

- (void)savePListDictionary{
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:[NSDictionary dictionaryWithDictionary:_plistDic]];
    
    if (myData != nil) {
        NSURL *fileManagerURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSURL *filePathURL = [fileManagerURL URLByAppendingPathComponent:@"/setting.dat"];

        
        NSError *error;
        [myData writeToURL:filePathURL options:NSDataWritingAtomic error:&error];
        if (error) {
            NSLog(@"Error:%@",error);
        }
    }
    _plistDic = [_manager readPListDictionaryToMemoery];
}
#pragma clang diagnostic pop



+ (id)getLocalValueForKey:(NSString*)key{
    return [_plistDic objectForKey:key];
}

+ (void)setLocalValueWithValue:(id <NSCopying>)value forKey:(NSString*)key{
    if (key != nil && key.length > 0 && value != nil) {
        [_plistDic setObject:value forKey:key];
        [_manager savePListDictionary];
    }
}

+ (void)removeLocalViewWithKey:(NSString*)key{
    [_plistDic removeObjectForKey:key];
    [_manager savePListDictionary];
}


@end
