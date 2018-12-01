//
//  SDVibrantButton.h
//  SearchDemo
//
//  Created by Peigen.Liu on 12/1/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMaterialDesignSpinner.h"



typedef enum {
    
    SDVibrantButtonStyleInvert,
    SDVibrantButtonStyleTranslucent,
    SDVibrantButtonStyleFill
    
} SDVibrantButtonStyle;

@interface SDVibrantButton: UIButton

@property (nonatomic, assign) BOOL animated;
@property (nonatomic, assign) CGFloat animationInterval;
@property (nonatomic, assign) CGFloat translucencyAlphaNormal;
@property (nonatomic, assign) CGFloat translucencyAlphaHighlighted;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat alpha;

#ifdef __IPHONE_8_0
// the vibrancy effect to be applied on the button
@property (nonatomic, strong) UIVibrancyEffect *vibrancyEffect;
#endif

// the background color when vibrancy effect is nil, or not supported.
@property (nonatomic, strong) UIColor *backgroundColor;


@property(nonatomic, assign)BOOL isLoading;
@property(nonatomic, retain)MMMaterialDesignSpinner *spinnerView;
@property(nonatomic, retain)UIColor *contentColor;
@property(nonatomic, retain)UIColor *progressColor;


// this is the only method to initialize a vibrant button
- (instancetype)initWithFrame:(CGRect)frame style:(SDVibrantButtonStyle)style;

- (void)startLoading;
- (void)stopLoading;

@end

typedef enum {
    
    SDVibrantButtonOverlayStyleNormal,
    SDVibrantButtonOverlayStyleInvert
    
} SDVibrantButtonOverlayStyle;

@interface SDVibrantButtonOverlay : UIView

// numeric configurations
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat borderWidth;

// icon image
@property (nonatomic, strong) UIImage *icon;

// display text
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, strong) UIFont *font;

// background color
@property (nonatomic, strong) UIColor *backgroundColor;

- (instancetype)initWithStyle:(SDVibrantButtonOverlayStyle)style;

@end
