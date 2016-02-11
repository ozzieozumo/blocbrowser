//
//  AwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Luke Everett on 2/11/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"

@interface AwesomeFloatingToolbar()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, weak) UILabel *currentLabel;

@end

@implementation AwesomeFloatingToolbar : UIView

- (instancetype) initWithFourTitles:(NSArray *)titles {
    
    self = [super init];
    
    if (self) {
        
        // set the titles and colors
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                       [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                       [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                       [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        // create the labels
        NSMutableArray *labelsArray = [[NSMutableArray alloc] init];
        
        for (NSString *title in self.currentTitles) {
            
            UILabel *label = [[UILabel alloc] init];
            label.userInteractionEnabled = NO;
            label.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:title];
            NSString *titleStr = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *color = [self.colors objectAtIndex:currentTitleIndex];
            
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            label.text = titleStr;
            label.backgroundColor = color;
            label.textColor = [UIColor whiteColor];
            
            [labelsArray addObject:label];
        }
        
        self.labels = labelsArray;
        
        // add all the labels as subviews
        
        for (UILabel *label in self.labels) {
            [self addSubview:label];
        }
        
    }
    return self;
    
}

#pragma mark - Button Enabling

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString*)title {
    
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound){
        UILabel *label = [self.labels objectAtIndex:index];
        label.userInteractionEnabled = enabled;
        label.alpha = enabled ? 1.0 : 0.25;
    }
    
}

- (void) layoutSubviews {
    
    // layout the labels in a 2 x 2 grid
    
    for (UILabel *label in self.labels) {
        NSUInteger index = [self.labels indexOfObject:label];
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        if (index < 2) {
            // first two labels go on top row
            labelY = 0;
        } else {
            // next two labels go on second row
            labelY = CGRectGetHeight(self.bounds) / 2;
        }
        
        if (index % 2 == 0) {
            // even items in first column
            labelX = 0;
        } else {
            //odd items in second column
            labelX = CGRectGetWidth(self.bounds) / 2;
        }
        
        label.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    }
}

#pragma mark - Touch Handling

- (UILabel *)labelFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject]; // set is assumed to be size 1
    CGPoint location = [touch locationInView:self];
    UIView *subView = [self hitTest:location withEvent:event];
    
    // if the hit test found a label, return it. otherwise nil
    
    if ([subView isKindOfClass:[UILabel class]]) {
        return (UILabel *)subView;
    } else {
        return nil;
    }
}
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
    UILabel *label = [self labelFromTouches:touches withEvent:event];
    
    self.currentLabel = label;
    self.currentLabel.alpha = 0.5;
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UILabel *label = [self labelFromTouches:touches withEvent:event];
    
    if (self.currentLabel != label) {
        // moved off the current label
        self.currentLabel.alpha = 1;
    } else {
        // moved back onto the current label
        self.currentLabel.alpha = 0.5;
    }

}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UILabel *label = [self labelFromTouches:touches withEvent:event];
    
    if (self.currentLabel == label) {
        NSLog(@"Label tapped: %@", self.currentLabel.text);
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
            [self.delegate floatingToolbar:self didSelectButtonWithTitle:self.currentLabel.text];
        }
    }
    self.currentLabel.alpha = 1;
    self.currentLabel = nil;
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.currentLabel.alpha = 1;
    self.currentLabel = nil;

    
}

@end
