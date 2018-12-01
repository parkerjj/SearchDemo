//
//  SDVibrantButton.m
//  SearchDemo
//
//  Created by Peigen.Liu on 12/1/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

#import "SDVibrantButton.h"


#define kSDVibrantButtonDefaultAnimationDuration 0.15
#define kSDVibrantButtonDefaultAlpha 1.0
#define kSDVibrantButtonDefaultInvertAlphaHighlighted 1.0
#define kSDVibrantButtonDefaultTranslucencyAlphaNormal 1.0
#define kSDVibrantButtonDefaultTranslucencyAlphaHighlighted 0.5
#define kSDVibrantButtonDefaultCornerRadius 4.0
#define kSDVibrantButtonDefaultRoundingCorners UIRectCornerAllCorners
#define kSDVibrantButtonDefaultBorderWidth 0.6
#define kSDVibrantButtonDefaultFontSize 14.0
#define kSDVibrantButtonDefaultTintColor [UIColor whiteColor]

/** SDVibrantButton **/

@interface SDVibrantButton () {
    
    __strong UIColor *_tintColor;
    
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
@property (nonatomic, assign) BOOL hideRightBorder;

- (void)createOverlays;
- (void)updateOverlayAlpha;

@end

/** SDVibrantButtonOverlay **/

@interface SDVibrantButtonOverlay () {
    
    __strong UIFont *_font;
    __strong UIColor *_tintColor;
}

@property (nonatomic, assign) SDVibrantButtonOverlayStyle style;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) BOOL hideRightBorder;

- (void)_updateTextHeight;

@end

/** SDVibrantButtonGroup **/

@interface SDVibrantButtonGroup ()

@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, assign) NSUInteger buttonCount;

- (void)_initButtonGroupWithSelector:(SEL)selector andObjects:(NSArray *)objects style:(SDVibrantButtonStyle)style;

@end

/** SDVibrantButton **/

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
        _animationDuration = kSDVibrantButtonDefaultAnimationDuration;
        _cornerRadius = kSDVibrantButtonDefaultCornerRadius;
        _roundingCorners = kSDVibrantButtonDefaultRoundingCorners;
        _borderWidth = kSDVibrantButtonDefaultBorderWidth;
        _invertAlphaHighlighted = kSDVibrantButtonDefaultInvertAlphaHighlighted;
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
        
        [self initSettingWithColor:self.tintColor];

    }
    return self;
}




- (void)initSettingWithColor:(UIColor*)color{
    scale = 1.2;
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
    self.spinnerView.lineWidth = 2;
    self.spinnerView.center = CGPointMake(self.frame.size.height/2,self.frame.size.height/2);
    self.spinnerView.translatesAutoresizingMaskIntoConstraints = YES;
    self.spinnerView.userInteractionEnabled = NO;
    [self addSubview:self.spinnerView];
    
    //    [self addTarget:self action:@selector(loadingAction) forControlEvents:UIControlEventTouchUpInside];
    
    //    self.forDisplayButton = [[UIButton alloc]initWithFrame:self.bounds];
    //    self.forDisplayButton.userInteractionEnabled = NO;
    //    [self.forDisplayButton setBackgroundImage:[[self imageWithColor:color cornerRadius:3] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    //    [self addSubview:self.forDisplayButton];
    }

- (void)layoutSubviews {
#ifdef __IPHONE_8_0
    self.visualEffectView.frame = self.bounds;
#endif
    self.normalOverlay.frame = self.bounds;
    self.highlightedOverlay.frame = self.bounds;
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

- (void)updateOverlayAlpha {
    
    if (self.activeTouch) {
        if (self.style == SDVibrantButtonStyleInvert) {
            self.normalOverlay.alpha = 0.0;
            self.highlightedOverlay.alpha = self.invertAlphaHighlighted * self.alpha;
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


- (void)startLoading{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    self.text = @"";
    self.spinnerView.tintColor = [UIColor colorWithWhite:0.9f alpha:0.3f];
    
    [self setCornerRadius:defaultH*scale*0.5];
    
    self.layer.bounds = CGRectMake(0, 0, defaultH*scale, defaultH*scale);
    self.spinnerView.center = CGPointMake(self.frame.size.height/2,self.frame.size.height/2);
    [self.spinnerView startAnimating];
}

- (void)stopLoading{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    [self.spinnerView stopAnimating];
    self.layer.bounds = CGRectMake(0, 0, defaultW*scale, defaultH*scale);
    
    
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
        [UIView animateWithDuration:self.animationDuration animations:update];
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
        [UIView animateWithDuration:self.animationDuration animations:update];
    } else {
        update();
    }
}

#pragma mark - Override Getters

- (UIColor *)tintColor {
    return _tintColor == nil ? kSDVibrantButtonDefaultTintColor : _tintColor;
}

#pragma mark - Override Setters

- (void)setAlpha:(CGFloat)alpha {
    _alpha = alpha;
    [self updateOverlayAlpha];
}

- (void)setInvertAlphaHighlighted:(CGFloat)invertAlphaHighlighted {
    _invertAlphaHighlighted = invertAlphaHighlighted;
    [self updateOverlayAlpha];
}

- (void)setTranslucencyAlphaNormal:(CGFloat)translucencyAlphaNormal {
    _translucencyAlphaNormal = translucencyAlphaNormal;
    [self updateOverlayAlpha];
}

- (void)setTranslucencyAlphaHighlighted:(CGFloat)translucencyAlphaHighlighted {
    _translucencyAlphaHighlighted = translucencyAlphaHighlighted;
    [self updateOverlayAlpha];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.normalOverlay.cornerRadius = cornerRadius;
    self.highlightedOverlay.cornerRadius = cornerRadius;
}

- (void)setRoundingCorners:(UIRectCorner)roundingCorners {
    _roundingCorners = roundingCorners;
    self.normalOverlay.roundingCorners = roundingCorners;
    self.highlightedOverlay.roundingCorners = roundingCorners;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.normalOverlay.borderWidth = borderWidth;
    self.highlightedOverlay.borderWidth = borderWidth;
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    self.normalOverlay.icon = icon;
    self.highlightedOverlay.icon = icon;
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.normalOverlay.text = text;
    self.highlightedOverlay.text = text;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.normalOverlay.font = font;
    self.highlightedOverlay.font = font;
}

#ifdef __IPHONE_8_0
- (void)setVibrancyEffect:(UIVibrancyEffect *)vibrancyEffect {
    
    _vibrancyEffect = vibrancyEffect;
    
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
    NSLog(@"SDVibrantButton: backgroundColor is deprecated and has no effect. Use tintColor instead.");
    [super setBackgroundColor:backgroundColor];
}

- (void)setTintColor:(UIColor *)tintColor {
    self.normalOverlay.tintColor = tintColor;
    self.highlightedOverlay.tintColor = tintColor;
}

- (void)setHideRightBorder:(BOOL)hideRightBorder {
    _hideRightBorder = hideRightBorder;
    self.normalOverlay.hideRightBorder = hideRightBorder;
    self.highlightedOverlay.hideRightBorder = hideRightBorder;
}

@end

/** SDVibrantButtonOverlay **/

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
        _roundingCorners = kSDVibrantButtonDefaultRoundingCorners;
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
    
    [self.tintColor setStroke];
    [self.tintColor setFill];
    
    CGRect boxRect = CGRectInset(self.bounds, self.borderWidth / 2, self.borderWidth / 2);
    
    if (self.hideRightBorder) {
        boxRect.size.width += self.borderWidth * 2;
    }
    
    // draw background and border
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:boxRect byRoundingCorners:self.roundingCorners cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
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
        
        if (self.style == SDVibrantButtonOverlayStyleNormal) {
            // ref: http://blog.alanyip.me/tint-transparent-images-on-ios/
            CGContextSetBlendMode(context, kCGBlendModeNormal);
            CGContextFillRect(context, iconRect);
            CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
        } else if (self.style == SDVibrantButtonOverlayStyleInvert) {
            // this will make the CGContextDrawImage below clear the image area
            CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
        }
        
        CGContextTranslateCTM(context, 0, size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
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
        
        [self.text drawInRect:CGRectMake(0.0, (size.height - self.textHeight) / 2, size.width, self.textHeight) withAttributes:@{ NSFontAttributeName:self.font, NSForegroundColorAttributeName:self.tintColor, NSParagraphStyleAttributeName:style }];
    }
}

#pragma mark - Override Getters

- (UIFont *)font {
    return _font == nil ? [UIFont systemFontOfSize:kSDVibrantButtonDefaultFontSize] : _font;
}

- (UIColor *)tintColor {
    return _tintColor == nil ? kSDVibrantButtonDefaultTintColor : _tintColor;
}

#pragma mark - Override Setters

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

- (void)setRoundingCorners:(UIRectCorner)roundingCorners {
    _roundingCorners = roundingCorners;
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
    NSLog(@"SDVibrantButtonOverlay: backgroundColor is deprecated and has no effect. Use tintColor instead.");
    [super setBackgroundColor:backgroundColor];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self setNeedsDisplay];
}

- (void)setHideRightBorder:(BOOL)hideRightBorder {
    _hideRightBorder = hideRightBorder;
    [self setNeedsDisplay];
}

#pragma mark - Private Methods

- (void)_updateTextHeight {
    CGRect bounds = [self.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.font } context:nil];
    self.textHeight = bounds.size.height;
}

@end

/** SDVibrantButtonGroup **/

@implementation SDVibrantButtonGroup

- (instancetype)init {
    NSLog(@"SDVibrantButtonGroup must be initialized with initWithFrame:buttonTitles:style: or initWithFrame:buttonIcons:style:");
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    NSLog(@"SDVibrantButtonGroup must be initialized with initWithFrame:buttonTitles:style: or initWithFrame:buttonIcons:style:");
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)buttonTitles style:(SDVibrantButtonStyle)style {
    if (self = [super initWithFrame:frame]) {
        [self _initButtonGroupWithSelector:@selector(setText:) andObjects:buttonTitles style:style];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame buttonIcons:(NSArray *)buttonIcons style:(SDVibrantButtonStyle)style {
    if (self = [super initWithFrame:frame]) {
        [self _initButtonGroupWithSelector:@selector(setIcon:) andObjects:buttonIcons style:style];
    }
    return self;
}

- (void)layoutSubviews {
    
    if (self.buttonCount == 0) return;
    
    CGSize size = self.bounds.size;
    CGFloat buttonWidth = size.width / self.buttonCount;
    CGFloat buttonHeight = size.height;
    
    [self.buttons enumerateObjectsUsingBlock:^void(SDVibrantButton *button, NSUInteger idx, BOOL *stop) {
        button.frame = CGRectMake(buttonWidth * idx, 0.0, buttonWidth, buttonHeight);
    }];
}

- (SDVibrantButton *)buttonAtIndex:(NSUInteger)index {
    return self.buttons[index];
}

#pragma mark - Override Setters

- (void)setAnimated:(BOOL)animated {
    _animated = animated;
    for (SDVibrantButton *button in self.buttons) {
        button.animated = animated;
    }
}

- (void)setAnimationDuration:(CGFloat)animationDuration {
    _animationDuration = animationDuration;
    for (SDVibrantButton *button in self.buttons) {
        button.animationDuration = animationDuration;
    }
}

- (void)setInvertAlphaHighlighted:(CGFloat)invertAlphaHighlighted {
    _invertAlphaHighlighted = invertAlphaHighlighted;
    for (SDVibrantButton *button in self.buttons) {
        button.invertAlphaHighlighted = invertAlphaHighlighted;
    }
}

- (void)setTranslucencyAlphaNormal:(CGFloat)translucencyAlphaNormal {
    _translucencyAlphaNormal = translucencyAlphaNormal;
    for (SDVibrantButton *button in self.buttons) {
        button.translucencyAlphaNormal = translucencyAlphaNormal;
    }
}

- (void)setTranslucencyAlphaHighlighted:(CGFloat)translucencyAlphaHighlighted {
    _translucencyAlphaHighlighted = translucencyAlphaHighlighted;
    for (SDVibrantButton *button in self.buttons) {
        button.translucencyAlphaHighlighted = translucencyAlphaHighlighted;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self.buttons.firstObject setCornerRadius:cornerRadius];
    [self.buttons.lastObject setCornerRadius:cornerRadius];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    for (SDVibrantButton *button in self.buttons) {
        button.borderWidth = borderWidth;
    }
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self.buttons makeObjectsPerformSelector:@selector(setFont:) withObject:font];
}

#ifdef __IPHONE_8_0
- (void)setVibrancyEffect:(UIVibrancyEffect *)vibrancyEffect {
    _vibrancyEffect = vibrancyEffect;
    [self.buttons makeObjectsPerformSelector:@selector(setVibrancyEffect:) withObject:vibrancyEffect];
}
#endif

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    NSLog(@"SDVibrantButtonGroup: backgroundColor is deprecated and has no effect. Use tintColor instead.");
    [super setBackgroundColor:backgroundColor];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self.buttons makeObjectsPerformSelector:@selector(setTintColor:) withObject:tintColor];
}

#pragma mark - Private Methods

- (void)_initButtonGroupWithSelector:(SEL)selector andObjects:(NSArray *)objects style:(SDVibrantButtonStyle)style {
    
    _cornerRadius = kSDVibrantButtonDefaultCornerRadius;
    _borderWidth = kSDVibrantButtonDefaultBorderWidth;
    
    self.opaque = NO;
    self.userInteractionEnabled = YES;
    
    NSMutableArray *buttons = [NSMutableArray array];
    NSUInteger count = objects.count;
    
    [objects enumerateObjectsUsingBlock:^void(id object, NSUInteger idx, BOOL *stop) {
        
        SDVibrantButton *button = [[SDVibrantButton alloc] initWithFrame:CGRectZero style:style];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [button performSelector:selector withObject:object];
#pragma clang diagnostic pop
        
        if (count == 1) {
            button.roundingCorners = UIRectCornerAllCorners;
        } else if (idx == 0) {
            button.roundingCorners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
            button.hideRightBorder = YES;
        } else if (idx == count - 1) {
            button.roundingCorners = UIRectCornerTopRight | UIRectCornerBottomRight;
        } else {
            button.roundingCorners = (UIRectCorner)0;
            button.cornerRadius = 0;
            button.hideRightBorder = YES;
        }
        
        [self addSubview:button];
        [buttons addObject:button];
    }];
    
    self.buttons = buttons;
    self.buttonCount = count;
}

@end
