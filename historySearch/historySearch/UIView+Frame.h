//
//  UIView+Frame.h
//  OC链式开发
//
//  Created by 孙承秀 on 16/12/15.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
- (UIView* (^)(CGFloat))X;

- (UIView* (^)(CGFloat))Y;

- (UIView* (^)(CGFloat))Width;

- (UIView* (^)(CGFloat))Height;

- (UIView* (^)(CGFloat))CenterX;

- (UIView* (^)(CGFloat))CenterY;

- (UIView* (^)(CGPoint))Center;

- (UIView* (^)(CGSize))Size;
- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;
- (CGFloat)centerX;
- (CGFloat)centerY;
@end
