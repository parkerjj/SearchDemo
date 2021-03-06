//
//  AnimatedMenuScene.m
//  Party
//
//  Created by Adnan Aftab on 8/25/15.
//  Copyright (c) 2015 CX. All rights reserved.
//

#import "AnimatedMenuScene.h"
#import "MenuItemNode.h"
#import <CoreMotion/CoreMotion.h>


static NSString *SelectAnimation = @"SelectAction";
static NSString *DeselectAnimation = @"DeselectAnimation";

@interface AnimatedMenuScene()
@property (nonatomic, strong) SKFieldNode *magneticField;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) NSTimeInterval touchStartTime;
@property (nonatomic, strong) SKNode *selectedNode;
@property (nonatomic, strong) NSMutableArray *selectedNodes;
@property (nonatomic, strong, readonly) CMMotionManager *motionManger;
@end
@implementation AnimatedMenuScene
- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        
    }
    return self;
}
- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    _selectedNodes = [NSMutableArray new];
    [self configure];
}
- (void)configure
{
    
    self.magneticField = [SKFieldNode radialGravityField];
    self.scaleMode = SKSceneScaleModeAspectFill;
    CGRect frame = self.frame;
    frame.size.width = self.magneticField.minimumRadius;
    frame.origin.x -= frame.size.width/2;
    frame.size.height = frame.size.height;
    frame.origin.y = 0;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:frame];
    self.magneticField.position = CGPointMake(frame.size.width/2, frame.size.height / 2);
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    
    _motionManger = [[CMMotionManager alloc] init];
    if ([_motionManger isAccelerometerAvailable]) {
        [_motionManger startAccelerometerUpdates];
    }
    
}

//[self configure:view];
//}
//- (void)configure: (SKView *)view
//{
//    self.magneticField = [SKFieldNode radialGravityField];
//    self.scaleMode = SKSceneScaleModeAspectFill;
//    CGRect frame = view.frame;
//    frame.origin.x = 0;
//    frame.size.height = frame.size.height;
//    frame.origin.y = 0;
//    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:[UIScreen mainScreen].bounds];
//    self.magneticField.position = CGPointMake(frame.size.width/2, frame.size.height / 2);
//    self.physicsWorld.gravity = CGVectorMake(0, -9.8);
//}
- (void)addChild:(SKNode *)node
{
    
    CGFloat x = arc4random_uniform(self.frame.size.width - node.frame.size.width);
    CGFloat y = arc4random_uniform(self.frame.size.height - node.frame.size.height);
    
    node.position = CGPointMake(x, y);
    
    if (node.physicsBody == nil)
    {
        node.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:((SKShapeNode*)node).path];
    }
    
    node.physicsBody.dynamic = YES;
    node.physicsBody.affectedByGravity = YES;
    node.physicsBody.allowsRotation = YES;
    node.physicsBody.mass = 1.7;
    node.physicsBody.friction = 0.0f;
    node.physicsBody.linearDamping = 0.2f;
    SKRange *xRange = [SKRange rangeWithLowerLimit:0 upperLimit:self.frame.size.width-node.frame.size.width];
    SKRange *yRange = [SKRange rangeWithLowerLimit:0 upperLimit:self.frame.size.height-node.frame.size.height];
    SKConstraint *constraint = [SKConstraint positionX:xRange Y:yRange];
    node.constraints = @[constraint];
    [super addChild:node];
}
- (void)setMenuNodes:(NSArray *)menuNodes
{
    if (_menuNodes)
    {
        [self.children makeObjectsPerformSelector:@selector(removeFromParent)];
    }
    _selectedNode = nil;
    [_selectedNodes removeAllObjects];
    _menuNodes = menuNodes;
    [self updateScene];
}
- (void)updateScene
{
    for (NSString *nodeTitle in _menuNodes)
    {
        MenuItemNode *menuItem = [MenuItemNode menuNodeWithTitle:nodeTitle];

        [self addChild:menuItem];
    }
}
- (SKNode *)nodeAtPoint:(CGPoint)p
{
    SKNode *node = [super nodeAtPoint:p];
    if (![node.parent isKindOfClass:[SKScene class]] &&
        ![node isKindOfClass:[MenuItemNode class]] &&
        node.parent != nil &&
        !node.userInteractionEnabled)
    {
        node = node.parent;
    }
    return node;
}
- (void)deselectNode:(SKNode*)node
{
    if (!node)
    {
        return;
    }
    [node removeActionForKey:SelectAnimation];
    SKAction *action = [SKAction scaleTo:1 duration:0.2];
    [node runAction:action completion:^{
        [node removeAllActions];
    }];
    NSInteger index = [self.children indexOfObject:node];
    if(index != NSNotFound)
    {
        [self.animatedSceneDelegate animatedMenuScene:self didDeSelectNodeAtIndex:index];
    }
}
- (void)selectNode:(SKNode*)node
{
    if (!_allowMultipleSelection)
    {
        [self deselectNode:_selectedNode];
        if (_selectedNode == node)
        {
            _selectedNode = nil;
            return;
        }
        _selectedNodes = nil;
    }
    else
    {
        if ([_selectedNodes containsObject:node])
        {
            [self deselectNode:node];
            [_selectedNodes removeObject:node];
            return;
        }
    }
    SKAction *action = [SKAction scaleTo:1.3 duration:0.2];
    [node runAction:action withKey:SelectAnimation];
    if (_allowMultipleSelection)
    {
        [self.selectedNodes addObject:node];
    }
    else
    {
        _selectedNode = node;
    }
    NSInteger index = [self.children indexOfObject:node];
    if (index != NSNotFound)
    {
        [self.animatedSceneDelegate animatedMenuScene:self didSelectNodeAtIndex:index];
    }
}


- (void)update:(NSTimeInterval)currentTime{
    CMAccelerometerData *data = self.motionManger.accelerometerData;
    if (data == nil) {
        return;
    }
    
//    CGFloat valueY = data.acceleration.y;
//    CGFloat valueX = data.acceleration.x;

//    if (fabs(valueY) > 0.2f || fabs(valueX) > 0.2f) {
//        CGVector v = CGVectorMake(800*valueX,800*valueY);
//        for (SKNode *node in self.children) {
//            [node.physicsBody applyForce:v];
//        }
//    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.startPoint = [touch locationInNode:self];
    self.touchStartTime = touch.timestamp;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint prePoint = [touch previousLocationInNode:self];
    CGPoint point = [touch locationInNode:self];
    
    float dx = point.x - prePoint.x;
    float dy = point.y - prePoint.y;
    
    for (SKNode *node in self.children)
    {
        CGVector vector = CGVectorMake(100 * dx, 100 * dy);
        [node.physicsBody applyForce:vector];
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if (node)
    {
        [self selectNode:node];
    }
}
@end
