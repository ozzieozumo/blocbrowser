//
//  AwesomeFloatingToolbar.h
//  BlocBrowser
//
//  Created by Luke Everett on 2/11/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AwesomeFloatingToolbar;

@protocol AwesomeFloatingToolbarDelegate <NSObject>

@optional

- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title;
- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset;
- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToResizeWithScale:(CGFloat)scale;

@end

@interface AwesomeFloatingToolbar : UIView

- (instancetype) initWithFourTitles:(NSArray *)titles;

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString*)title;

@property (nonatomic, weak) id <AwesomeFloatingToolbarDelegate> delegate;

// These properties are used by the didTryToResizeWithScale delegate method.  They store the initial transform and bounds of the view, i.e. at the start of the pinch.
@property (nonatomic) CGAffineTransform pinchInitialTransform;
@property (nonatomic) CGRect pinchInitialBounds;

@end
