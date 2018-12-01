//
//  SDVibrantButton.h
//  SearchDemo
//
//  Created by Peigen.Liu on 12/1/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMaterialDesignSpinner.h"


NS_ASSUME_NONNULL_BEGIN


typedef enum {
    
    SDVibrantButtonStyleInvert,
    SDVibrantButtonStyleTranslucent,
    SDVibrantButtonStyleFill
    
} SDVibrantButtonStyle;

@interface SDVibrantButton : UIControl

@property(nonatomic, retain) MMMaterialDesignSpinner *spinnerView;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) CGFloat invertAlphaHighlighted;
@property (nonatomic, assign) CGFloat translucencyAlphaNormal;
@property (nonatomic, assign) CGFloat translucencyAlphaHighlighted;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) UIRectCorner roundingCorners;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, strong) UIFont *font;

#ifdef __IPHONE_8_0
// the vibrancy effect to be applied on the button
@property (nonatomic, strong) UIVibrancyEffect *vibrancyEffect;
#endif

// the deprecated background color
@property (nonatomic, strong) UIColor *backgroundColor DEPRECATED_MSG_ATTRIBUTE("Use tintColor instead.");

// the tint color when vibrancy effect is nil, or not supported.
@property (nonatomic, strong) UIColor *tintColor;

// this is the only method to initialize a vibrant button
- (instancetype)initWithFrame:(CGRect)frame style:(SDVibrantButtonStyle)style;

- (void)startLoading;
- (void)stopLoading;



@end

/** SDVibrantButtonOverlay **/

typedef enum {
    
    SDVibrantButtonOverlayStyleNormal,
    SDVibrantButtonOverlayStyleInvert
    
} SDVibrantButtonOverlayStyle;

@interface SDVibrantButtonOverlay : UIView

// numeric configurations
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) UIRectCorner roundingCorners;
@property (nonatomic, assign) CGFloat borderWidth;

// icon image
@property (nonatomic, strong) UIImage *icon;

// display text
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, strong) UIFont *font;

// the deprecated background color
@property (nonatomic, strong) UIColor *backgroundColor DEPRECATED_MSG_ATTRIBUTE("Use tintColor instead.");

// tint color
@property (nonatomic, strong) UIColor *tintColor;

- (instancetype)initWithStyle:(SDVibrantButtonOverlayStyle)style;

@end

/** SDVibrantButtonGroup **/

@interface SDVibrantButtonGroup : UIView

@property (nonatomic, readonly) NSArray *buttons;
@property (nonatomic, readonly) NSUInteger buttonCount;

@property (nonatomic, assign) BOOL animated;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat invertAlphaHighlighted;
@property (nonatomic, assign) CGFloat translucencyAlphaNormal;
@property (nonatomic, assign) CGFloat translucencyAlphaHighlighted;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIFont *font;

#ifdef __IPHONE_8_0
// the vibrancy effect to be applied on the button
@property (nonatomic, strong) UIVibrancyEffect *vibrancyEffect;
#endif

// the deprecated background color
@property (nonatomic, strong) UIColor *backgroundColor DEPRECATED_MSG_ATTRIBUTE("Use tintColor instead.");

// the tint color when vibrancy effect is nil, or not supported.
@property (nonatomic, strong) UIColor *tintColor;

- (instancetype)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)buttonTitles style:(SDVibrantButtonStyle)style;
- (instancetype)initWithFrame:(CGRect)frame buttonIcons:(NSArray *)buttonIcons style:(SDVibrantButtonStyle)style;

- (SDVibrantButton *)buttonAtIndex:(NSUInteger)index;

@end
NS_ASSUME_NONNULL_END
