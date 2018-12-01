//
//  StorageManager.h
//  Petbook
//
//  Created by Peigen.Liu on 15/7/2.
//  Copyright (c) 2015年 Parker. All rights reserved.
//

#define kScreenSizeWidth            MIN([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)
#define kScreenSizeHeight           MAX([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)
#define kScreenSize                 CGSizeMake(kScreenSizeWidth,kScreenSizeHeight)
#define kFontPlay                   [UIFont fontWithName:@"Play" size:16.0f]
#define kFontPlaySize(a)            [UIFont fontWithName:@"Play" size:a]


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StorageManager : NSObject{

}

/**
 *  StorageManager的实例
 *
 *  @return StorageManager的实例
 */
+ (StorageManager*)defaultManager;


/**
 *  根据Key取持久化数据
 *
 *  @param key Key
 *
 *  @return Value
 */
+ (id)getLocalValueForKey:(NSString*)key;

/**
 *  根据Key保存持久化数据
 *
 *  @param value Value
 *  @param key   Key
 */
+ (void)setLocalValueWithValue:(id <NSCopying>)value forKey:(NSString*)key;


/**
 *  删除Key对应的Value
 *
 *  @param key Key
 */
+ (void)removeLocalViewWithKey:(NSString*)key;


@end
