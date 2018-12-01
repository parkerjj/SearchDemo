//
//  MenuItemNode.m
//  Party
//
//  Created by Adnan Aftab on 8/25/15.
//  Copyright (c) 2015 CX. All rights reserved.
//

#import "MenuItemNode.h"
#import "DSMultilineLabelNode.h"
#import "UIColor+Utility.h"

@interface MenuItemNode ()
@property (nonatomic, strong) DSMultilineLabelNode *titleNode;
@end

@implementation MenuItemNode

+ (instancetype)menuNode
{
    MenuItemNode *menuNode = [MenuItemNode new];
    [menuNode setPath:CGPathCreateWithRoundedRect(CGRectMake(0, 0, 100, 100), 50, 50, nil)];
    menuNode.strokeColor = menuNode.fillColor = [UIColor redColor];
    return menuNode;
}
+ (instancetype)menuNodeWithTitle:(NSString *)title
{
    MenuItemNode *menuNode = [self menuNode];
    menuNode.title = title;
    return menuNode;
}
+ (instancetype)menuNodeWithTitle:(NSString*)title withPercentageSize:(CGFloat)pSize{
    
    CGFloat _pSize = pSize;
    _pSize = _pSize < 0.3f ? 0.3f : _pSize;
    _pSize = _pSize > 1.0f ? 1.0f : _pSize;
    
    CGFloat size = 160 * _pSize;

    MenuItemNode *menuNode = [self menuNode];
    [menuNode setPath:CGPathCreateWithRoundedRect(CGRectMake(0, 0, size, size), size/2.0f, size/2.0f, nil)];
    menuNode.title = title;
    
    
    
    NSInteger colorHex = 0x80dbdc;
    for (int i = 0; i < 160.0f/size * 160.0f/size; i++) {
        colorHex += 0x010202;
    }
    menuNode.strokeColor = menuNode.fillColor = [UIColor colorWithHex:colorHex alpha:1.0f];

    
    
    return menuNode;
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    if (!_titleNode)
    {
        _titleNode = [[DSMultilineLabelNode alloc] initWithFontNamed:@"Play"];
        _titleNode.fontSize = self.frame.size.width/ceil((_title.length*1.1f));
        _titleNode.paragraphWidth = 70;
        _titleNode.name = @"title";
        _titleNode.fontColor = [UIColor whiteColor];
        _titleNode.position = CGPointZero;
        _titleNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        _titleNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        _titleNode.userInteractionEnabled = NO;
        [self addChild:_titleNode];
    }
    _titleNode.text = title;
}
- (void)addChild:(SKNode *)node
{
    node.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [super addChild:node];
}




@end
