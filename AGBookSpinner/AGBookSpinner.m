//
//  AGBookSpinner.m
//  AGBookSpinner
//
//  Created by Grigory Avdyushin on 30.06.15.
//  Copyright (c) 2015 Grigory Avdyushin. All rights reserved.
//

#import "AGBookSpinner.h"

@interface AGBookSpinner ()
@property (assign, nonatomic, getter=isPaused) BOOL paused;
@end

@implementation AGBookSpinner

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectInset(self.bounds, 2.0, 2.0);
    shapeLayer.anchorPoint = CGPointMake(0.5, 0.5);
    shapeLayer.anchorPointZ = 0.5;
    shapeLayer.shouldRasterize = YES;
    shapeLayer.strokeColor = self.tintColor.CGColor;
    shapeLayer.lineWidth = 5.0f;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.rasterizationScale = [[UIScreen mainScreen] scale];
    [self.layer addSublayer:shapeLayer];
    
    CGFloat maxY = CGRectGetHeight(self.bounds);
    CGFloat minY = CGRectGetMinY(self.bounds);
    CGFloat maxX = CGRectGetMaxX(self.bounds) - 3;
    CGFloat minX = CGRectGetMinX(self.bounds) + 3;
    CGFloat midX = CGRectGetMidX(self.bounds);
    CGFloat midY = CGRectGetMidY(self.bounds);
    
    UIBezierPath *pathFull = [UIBezierPath bezierPath];
    
    UIBezierPath *pathM = [UIBezierPath bezierPath];
    [pathM moveToPoint:CGPointMake(minX, maxY - 8)];
    [pathM addLineToPoint:CGPointMake(minX, minY)];
    [pathM addLineToPoint:CGPointMake(midX, midY - 3)];
    [pathM addLineToPoint:CGPointMake(maxX, minY)];
    [pathM addLineToPoint:CGPointMake(maxX, maxY - 8)];

    UIBezierPath *pathY = [UIBezierPath bezierPath];
    [pathY moveToPoint:CGPointMake(midX/2, midY + 2)];
    [pathY addLineToPoint:CGPointMake(midX, maxY - 9)];
    [pathY addLineToPoint:CGPointMake(midX*1.5, midY + 2)];
    [pathY moveToPoint:CGPointMake(midX, maxY - 9)];
    [pathY addLineToPoint:CGPointMake(midX, maxY)];
    
    [pathFull appendPath:pathM];
    [pathFull appendPath:pathY];
    
    shapeLayer.path = pathFull.CGPath;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 3.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.repeatCount = HUGE_VALF;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(40, 40);
}

- (void)startAnimating
{
    if (!self.isAnimating) {
        self.paused = NO;
    }
}

- (void)stopAnimating
{
    if (self.isAnimating) {
        self.paused = YES;
    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            ((CAShapeLayer *)layer).strokeColor = tintColor.CGColor;
        }
    }
}

- (BOOL)isAnimating
{
    return !self.isPaused;
}

- (void)setPaused:(BOOL)paused
{
    _paused = paused;
    self.hidden = paused && self.hidesWhenStopped;
    
    if (paused) {
        CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.layer.speed = 0.0;
        self.layer.timeOffset = pausedTime;
    } else {
        CFTimeInterval pausedTime = [self.layer timeOffset];
        self.layer.speed = 1.0;
        self.layer.timeOffset = 0.0;
        self.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        self.layer.beginTime = timeSincePause;
    }
}

@end
