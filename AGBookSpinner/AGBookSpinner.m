//
//  AGBookSpinner.m
//  AGBookSpinner
//
//  Created by Grigory Avdyushin on 30.06.15.
//  Copyright (c) 2015 Grigory Avdyushin. All rights reserved.
//

#import "AGBookSpinner.h"

@interface AGBookSpinner ()
{
    CAShapeLayer *shapeLayer1, *shapeLayer2;
}
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
    [self clean];
    switch (self.style) {
        case AGBookSpinnerStyleSingleLine:
            [self setupSingle];
            break;
        case AGBookSpinnerStyleDoubleLine:
            [self setupDouble];
            break;
        default:
            [self setupSingle];
            break;
    }
}

- (void)clean
{
    for (CALayer *layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
}

- (void)setupSingle
{
    shapeLayer1 = [self genShapeLayer];
    
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
    
    shapeLayer1.path = pathFull.CGPath;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 3.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.repeatCount = HUGE_VALF;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [shapeLayer1 addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}

- (CAShapeLayer *)genShapeLayer
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
    return shapeLayer;
}

- (void)setupDouble
{
    shapeLayer1 = [self genShapeLayer];
    [self.layer addSublayer:shapeLayer1];

    shapeLayer2 = [self genShapeLayer];
    [self.layer addSublayer:shapeLayer2];

    CGFloat maxY = CGRectGetHeight(self.bounds);
    CGFloat minY = CGRectGetMinY(self.bounds);
    CGFloat maxX = CGRectGetMaxX(self.bounds) - 3;
    CGFloat minX = CGRectGetMinX(self.bounds) + 3;
    CGFloat midX = CGRectGetMidX(self.bounds);
    CGFloat midY = CGRectGetMidY(self.bounds);
    
    UIBezierPath *pathMLeft = [UIBezierPath bezierPath];
    [pathMLeft moveToPoint:CGPointMake(minX, maxY - 8)];
    [pathMLeft addLineToPoint:CGPointMake(minX, minY)];
    [pathMLeft addLineToPoint:CGPointMake(midX, midY - 3)];
    
    UIBezierPath *pathMRight = [UIBezierPath bezierPath];
    [pathMRight moveToPoint:CGPointMake(maxX, maxY - 8)];
    [pathMRight addLineToPoint:CGPointMake(maxX, minY)];
    [pathMRight addLineToPoint:CGPointMake(midX, midY - 3)];
    
    UIBezierPath *pathYLeft = [UIBezierPath bezierPath];
    [pathYLeft moveToPoint:CGPointMake(midX, maxY)];
    [pathYLeft addLineToPoint:CGPointMake(midX, maxY - 9)];
    [pathYLeft addLineToPoint:CGPointMake(midX/2, midY + 2)];

    UIBezierPath *pathYRight = [UIBezierPath bezierPath];
    [pathYRight moveToPoint:CGPointMake(midX, maxY)];
    [pathYRight addLineToPoint:CGPointMake(midX, maxY - 9)];
    [pathYRight addLineToPoint:CGPointMake(midX*1.5, midY + 2)];
    
    [pathMLeft appendPath:pathYLeft];
    [pathMRight appendPath:pathYRight];
    
    shapeLayer1.path = pathMLeft.CGPath;
    shapeLayer2.path = pathMRight.CGPath;
    
    [self restartDoubleAnimation];
}

- (CABasicAnimation *)pathAnimation
{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.5;
    pathAnimation.beginTime = CACurrentMediaTime();
    pathAnimation.fromValue = @(0.0f);
    pathAnimation.toValue = @(1.0f);
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return pathAnimation;
}

- (CABasicAnimation *)fadeAnimation
{
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.duration = 0.5;
    fadeAnimation.beginTime = CACurrentMediaTime() + 1.5;
    fadeAnimation.fromValue = @(1.0f);
    fadeAnimation.toValue = @(0.0f);
    fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return fadeAnimation;
}

- (void)restartAnimationOnLayer1:(CAShapeLayer *)layer1 layer2:(CAShapeLayer *)layer2
{
    CABasicAnimation *pathAnimation1 = [self pathAnimation];
    CABasicAnimation *pathAnimation2 = [self pathAnimation];
    
    pathAnimation1.delegate = self; // For animation did stop
    
    [layer1 addAnimation:pathAnimation1 forKey:@"strokeEndAnimation1"];
    [layer2 addAnimation:pathAnimation2 forKey:@"strokeEndAnimation2"];
}

- (void)restartDoubleAnimation
{
    [self restartAnimationOnLayer1:shapeLayer1 layer2:shapeLayer2];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        
        self.alpha = 0;
        self.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7);
        
    } completion:^(BOOL finished) {
        
        self.layer.transform = CATransform3DIdentity;
        [self restartDoubleAnimation];
        [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {

        }];
        
    }];
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

- (void)setStyle:(NSInteger)style
{
    _style = style;
    [self setup];
}

@end
