//
//  SDVibrantButton.m
//  SearchDemo
//
//  Created by Peigen.Liu on 12/1/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

#import "SDVibrantButton.h"
#import "UIColor+Utility.h"


#define kSDVibrantButtonDefaultAnimationInterval 0.15
#define kSDVibrantButtonDefaultAlpha 1.0
#define kSDVibrantButtonDefaultTranslucencyAlphaNormal 1.0
#define kSDVibrantButtonDefaultTranslucencyAlphaHighlighted 0.5
#define kSDVibrantButtonDefaultCornerRadius 4.0
#define kSDVibrantButtonDefaultBorderWidth 0.6
#define kSDVibrantButtonDefaultFontSize 14.0
#define kSDVibrantButtonDefaultBackgroundColor [UIColor whiteColor]

@interface SDVibrantButton () {
    
    __strong UIColor *_backgroundColor;
    
    CGFloat defaultW;
    CGFloat defaultH;
    CGFloat defaultR;
    CGFloat scale;
}

@property (nonatomic, assign) SDVibrantButtonStyle style;

#ifdef __IPHONE_8_0
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
#endif

@property (nonatomic, strong) SDVibrantButtonOverlay *normalOverlay;
@property (nonatomic, strong) SDVibrantButtonOverlay *highlightedOverlay;

@property (nonatomic, assign) BOOL activeTouch;

- (void)createOverlays;

@end

@implementation SDVibrantButton

- (instancetype)init {
    NSLog(@"SDVibrantButton must be initialized with initWithFrame:style:");
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    NSLog(@"SDVibrantButton must be initialized with initWithFrame:style:");
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame style:(SDVibrantButtonStyle)style {
    if (self = [super initWithFrame:frame]) {
        
        self.style = style;
        self.opaque = NO;
        self.userInteractionEnabled = YES;
        
        // default values
        _animated = YES;
        _animationInterval = kSDVibrantButtonDefaultAnimationInterval;
        _cornerRadius = kSDVibrantButtonDefaultCornerRadius;
        _borderWidth = kSDVibrantButtonDefaultBorderWidth;
        _translucencyAlphaNormal = kSDVibrantButtonDefaultTranslucencyAlphaNormal;
        _translucencyAlphaHighlighted = kSDVibrantButtonDefaultTranslucencyAlphaHighlighted;
        _alpha = kSDVibrantButtonDefaultAlpha;
        _activeTouch = NO;
        
        // create overlay views
        [self createOverlays];
        
#ifdef __IPHONE_8_0
        // add the default vibrancy effect
        self.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
#endif
        
        [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
        [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchDragOutside | UIControlEventTouchCancel];
        
        [self initSettingWithColor:self.backgroundColor];

    }
    return self;
}


- (instancetype)initWithCoder:(nonnull NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.style = SDVibrantButtonStyleInvert;
        self.opaque = NO;
        self.userInteractionEnabled = YES;
        
        // default values
        _animated = YES;
        _animationInterval = kSDVibrantButtonDefaultAnimationInterval;
        _cornerRadius = kSDVibrantButtonDefaultCornerRadius;
        _borderWidth = kSDVibrantButtonDefaultBorderWidth;
        _translucencyAlphaNormal = kSDVibrantButtonDefaultTranslucencyAlphaNormal;
        _translucencyAlphaHighlighted = kSDVibrantButtonDefaultTranslucencyAlphaHighlighted;
        _alpha = kSDVibrantButtonDefaultAlpha;
        _activeTouch = NO;
        
        // create overlay views
        [self createOverlays];
        
#ifdef __IPHONE_8_0
        // add the default vibrancy effect
        self.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
#endif
        
        [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
        [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchDragOutside | UIControlEventTouchCancel];
        
        self.text = self.titleLabel.text;
        
        [self initSettingWithColor:self.backgroundColor];
        
    }
    return self;
}





- (void)initSettingWithColor:(UIColor*)color{
    scale = 0.9f;
    //    bgView = [[UIView alloc]initWithFrame:self.bounds];
    //    bgView.backgroundColor = color;
    //    bgView.userInteractionEnabled = NO;
    //    bgView.hidden = YES;
    //    [self addSubview:bgView];
    
    defaultW = self.frame.size.width;
    defaultH = self.frame.size.height;
    defaultR = self.layer.cornerRadius;
    
    MMMaterialDesignSpinner *spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectZero];
    self.spinnerView = spinnerView;
    self.spinnerView.bounds = CGRectMake(0, 0, defaultH*0.8, defaultH*0.8);
    self.spinnerView.lineWidth = 1.5;
    self.spinnerView.center = CGPointMake(self.frame.size.height/2,self.frame.size.height/2);
    self.spinnerView.translatesAutoresizingMaskIntoConstraints = YES;
    self.spinnerView.userInteractionEnabled = NO;
    [self.normalOverlay insertSubview:self.spinnerView atIndex:0];
    
    //    [self addTarget:self action:@selector(loadingAction) forControlEvents:UIControlEventTouchUpInside];
    
    //    self.forDisplayButton = [[UIButton alloc]initWithFrame:self.bounds];
    //    self.forDisplayButton.userInteractionEnabled = NO;
    //    [self.forDisplayButton setBackgroundImage:[[self imageWithColor:color cornerRadius:3] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    //    [self addSubview:self.forDisplayButton];
    
    self.contentColor = color;
}



- (void)layoutSubviews {
#ifdef __IPHONE_8_0
    self.visualEffectView.frame = self.bounds;
#endif
    self.normalOverlay.frame = self.bounds;
    self.highlightedOverlay.frame = self.bounds;
    
    defaultW = self.frame.size.width;
    defaultH = self.frame.size.height;
    defaultR = self.layer.cornerRadius;
    self.spinnerView.bounds = CGRectMake(0, 0, defaultH*0.8, defaultH*0.8);
    
}

- (void)createOverlays {
    
    if (self.style == SDVibrantButtonStyleFill) {
        self.normalOverlay = [[SDVibrantButtonOverlay alloc] initWithStyle:SDVibrantButtonOverlayStyleInvert];
    } else {
        self.normalOverlay = [[SDVibrantButtonOverlay alloc] initWithStyle:SDVibrantButtonOverlayStyleNormal];
    }
    
    if (self.style == SDVibrantButtonStyleInvert) {
        self.highlightedOverlay = [[SDVibrantButtonOverlay alloc] initWithStyle:SDVibrantButtonOverlayStyleInvert];
        self.highlightedOverlay.alpha = 0.0;
    } else if (self.style == SDVibrantButtonStyleTranslucent || self.style == SDVibrantButtonStyleFill) {
        self.normalOverlay.alpha = self.translucencyAlphaNormal * self.alpha;
    }
    
#ifndef __IPHONE_8_0
    // for iOS 8, these two overlay views will be added as subviews in setVibrancyEffect:
    [self addSubview:self.normalOverlay];
    [self addSubview:self.highlightedOverlay];
#endif
    
}

- (void)startLoading{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    _isLoading = YES;
    self.text = @"";
    self.spinnerView.tintColor = [UIColor colorWithHex:0xFFFFFF alpha:1.0f];
    
    [self setCornerRadius:defaultH*scale*0.5];
    
//    self.layer.bounds = CGRectMake(0, 0, defaultH*scale, defaultH*scale);
    self.spinnerView.center = CGPointMake(self.frame.size.height/2,self.frame.size.height/2);
    [self.spinnerView startAnimating];
}

- (void)stopLoading{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    _isLoading = NO;
    [self setText:nil];
    [self.spinnerView stopAnimating];
//    self.layer.bounds = CGRectMake(0, 0, defaultW*scale, defaultH*scale);
    
    
}



#pragma mark - Control Event Handlers

- (void)touchDown {
    
    self.activeTouch = YES;
    
    void(^update)(void) = ^(void) {
        if (self.style == SDVibrantButtonStyleInvert) {
            self.normalOverlay.alpha = 0.0;
            self.highlightedOverlay.alpha = self.alpha;
        } else if (self.style == SDVibrantButtonStyleTranslucent || self.style == SDVibrantButtonStyleFill) {
            self.normalOverlay.alpha = self.translucencyAlphaHighlighted * self.alpha;
        }
    };
    
    if (self.animated) {
        [UIView animateWithDuration:self.animationInterval animations:update];
    } else {
        update();
    }
    
}

- (void)touchUp {
    
    self.activeTouch = NO;
    
    void(^update)(void) = ^(void) {
        if (self.style == SDVibrantButtonStyleInvert) {
            self.normalOverlay.alpha = self.alpha;
            self.highlightedOverlay.alpha = 0.0;
        } else if (self.style == SDVibrantButtonStyleTranslucent || self.style == SDVibrantButtonStyleFill) {
            self.normalOverlay.alpha = self.translucencyAlphaNormal * self.alpha;
        }
    };
    
    if (self.animated) {
        [UIView animateWithDuration:self.animationInterval animations:update];
    } else {
        update();
    }
    
    
}

#pragma mark - Override Getters

- (UIColor *)backgroundColor {
    return _backgroundColor == nil ? kSDVibrantButtonDefaultBackgroundColor : _backgroundColor;
}

#pragma mark - Override Setters

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.normalOverlay.cornerRadius = cornerRadius;
    self.highlightedOverlay.cornerRadius = cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.normalOverlay.borderWidth = borderWidth;
    self.highlightedOverlay.borderWidth = borderWidth;
}

- (void)setIcon:(UIImage *)icon {
    self.normalOverlay.icon = icon;
    self.highlightedOverlay.icon = icon;
}

- (void)setText:(NSString *)text {
    self.normalOverlay.text = text;
    self.highlightedOverlay.text = text;
}

- (void)setFont:(UIFont *)font {
    self.normalOverlay.font = font;
    self.highlightedOverlay.font = font;
}

- (void)setAlpha:(CGFloat)alpha {
    
    _alpha = alpha;
    
    if (self.activeTouch) {
        if (self.style == SDVibrantButtonStyleInvert) {
            self.normalOverlay.alpha = 0.0;
            self.highlightedOverlay.alpha = self.alpha;
        } else if (self.style == SDVibrantButtonStyleTranslucent || self.style == SDVibrantButtonStyleFill) {
            self.normalOverlay.alpha = self.translucencyAlphaHighlighted * self.alpha;
        }
    } else {
        if (self.style == SDVibrantButtonStyleInvert) {
            self.normalOverlay.alpha = self.alpha;
            self.highlightedOverlay.alpha = 0.0;
        } else if (self.style == SDVibrantButtonStyleTranslucent || self.style == SDVibrantButtonStyleFill) {
            self.normalOverlay.alpha = self.translucencyAlphaNormal * self.alpha;
        }
    }
}

#ifdef __IPHONE_8_0
- (void)setVibrancyEffect:(UIVibrancyEffect *)vibrancyEffect {
    
    [self.normalOverlay removeFromSuperview];
    [self.highlightedOverlay removeFromSuperview];
    [self.visualEffectView removeFromSuperview];
    
    if (vibrancyEffect != nil) {
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
        self.visualEffectView.userInteractionEnabled = NO;
        [self.visualEffectView.contentView addSubview:self.normalOverlay];
        [self.visualEffectView.contentView addSubview:self.highlightedOverlay];
        [self addSubview:self.visualEffectView];
    } else {
        [self addSubview:self.normalOverlay];
        [self addSubview:self.highlightedOverlay];
    }
}
#endif

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.normalOverlay.backgroundColor = backgroundColor;
    self.highlightedOverlay.backgroundColor = backgroundColor;
}

@end

@interface SDVibrantButtonOverlay () {
    
    __strong UIFont *_font;
    __strong UIColor *_backgroundColor;
    
    UIImage *_iconBackup;

}

@property (nonatomic, assign) SDVibrantButtonOverlayStyle style;
@property (nonatomic, assign) CGFloat textHeight;

- (void)_updateTextHeight;

@end

@implementation SDVibrantButtonOverlay

- (instancetype)initWithStyle:(SDVibrantButtonOverlayStyle)style {
    if (self = [self init]) {
        self.style = style;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        
        _cornerRadius = kSDVibrantButtonDefaultCornerRadius;
        _borderWidth = kSDVibrantButtonDefaultBorderWidth;
        
        self.opaque = NO;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGSize size = self.bounds.size;
    if (size.width == 0 || size.height == 0) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    [self.backgroundColor setStroke];
    [self.backgroundColor setFill];
    
    CGRect boxRect = CGRectInset(self.bounds, self.borderWidth, self.borderWidth);
    
    // draw background and border
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:boxRect cornerRadius:self.cornerRadius];
    path.lineWidth = self.borderWidth;
    [path stroke];
    
    if (self.style == SDVibrantButtonOverlayStyleInvert) {
        // fill the rounded rectangle area
        [path fill];
    }
    
    CGContextClipToRect(context, boxRect);
    
    // draw icon
    if (self.icon != nil) {
        
        CGSize iconSize = self.icon.size;
        CGRect iconRect = CGRectMake((size.width - iconSize.width) / 2,
                                     (size.height - iconSize.height) / 2,
                                     iconSize.width,
                                     iconSize.height);
        
        CGContextTranslateCTM(context, 0, size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        if (self.style == SDVibrantButtonOverlayStyleNormal) {
            // ref: http://blog.alanyip.me/tint-transparent-images-on-ios/
            CGContextSetBlendMode(context, kCGBlendModeNormal);
            CGContextFillRect(context, iconRect);
            CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
        } else if (self.style == SDVibrantButtonOverlayStyleInvert) {
            // this will make the CGContextDrawImage below clear the image area
            CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
        }
        
        // for some reason, drawInRect does not work here
        CGContextDrawImage(context, iconRect, self.icon.CGImage);
    }
    
    // draw text
    if (self.text != nil) {
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.lineBreakMode = NSLineBreakByTruncatingTail;
        style.alignment = NSTextAlignmentCenter;
        
        if (self.style == SDVibrantButtonOverlayStyleInvert) {
            // this will make the drawInRect below clear the text area
            CGContextSetBlendMode(context, kCGBlendModeClear);
        }
        
        [self.text drawInRect:CGRectMake(0.0, (size.height - self.textHeight) / 2, size.width, self.textHeight) withAttributes:@{ NSFontAttributeName:self.font, NSForegroundColorAttributeName:self.backgroundColor, NSParagraphStyleAttributeName:style }];
    }
}

#pragma mark - Override Getters

- (UIFont *)font {
    return _font == nil ? [UIFont systemFontOfSize:kSDVibrantButtonDefaultFontSize] : _font;
}

- (UIColor *)backgroundColor {
    return _backgroundColor == nil ? kSDVibrantButtonDefaultBackgroundColor : _backgroundColor;
}

#pragma mark - Override Setters

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self setNeedsDisplay];
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    _text = nil;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    if (text == nil) {
        [self setIcon:[_iconBackup copy]];
        _text = [text copy];
        [self _updateTextHeight];
        [self setNeedsDisplay];
        return;
    }
    _iconBackup = [_icon copy];
    _icon = nil;
    _text = [text copy];
    [self _updateTextHeight];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self _updateTextHeight];
    [self setNeedsDisplay];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self setNeedsDisplay];
}

#pragma mark - Private Methods

- (void)_updateTextHeight {
    CGRect bounds = [self.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.font } context:nil];
    self.textHeight = bounds.size.height;
}

@end
