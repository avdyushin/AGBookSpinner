//
//  AGBookSpinner.h
//  AGBookSpinner
//
//  Created by Grigory Avdyushin on 30.06.15.
//  Copyright (c) 2015 Grigory Avdyushin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGBookSpinner : UIView

- (void)startAnimating;
- (void)stopAnimating;

@property (assign, nonatomic, readonly, getter=isAnimating) BOOL animating;
@property (assign, nonatomic, readwrite) IBInspectable BOOL hidesWhenStopped;

@end
