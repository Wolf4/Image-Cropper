//
//  IRImageView.m
//  Image Editor
//
//  Created by Ihar Rubanau on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IRImageCropperView.h"
#import <QuartzCore/QuartzCore.h>


@implementation IRImageCropperView
@synthesize cropAreaSize = cropAreaSize_;

- (id)initWithFrame:(CGRect)frame cropAreaSize:(CGSize)cropAreaSize {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code;
    cropAreaSize_ = cropAreaSize;
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
    self.autoresizingMask = (UIViewAutoresizingFlexibleHeight |
                             UIViewAutoresizingFlexibleWidth);
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
  CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
  CGContextSetAlpha(ctx, 0.7);
  CGContextSetLineWidth(ctx, 3);
  CGContextFillRect(ctx, self.bounds);
  CGRect cropRect = [self croppingWindowRect];
  CGContextClearRect(ctx, cropRect);
  CGRect whiteBorderRect = CGRectInset(cropRect, -2, -2);
  CGContextStrokeRect(ctx, whiteBorderRect);
}

- (CGRect)croppingWindowRect {
  CGFloat width = self.cropAreaSize.width;
  CGFloat height = self.cropAreaSize.height;
  CGFloat x = self.center.x - width / 2;
  CGFloat y = self.center.y - height / 2;
  CGRect cropRect = CGRectMake(x, y, width, height);
  return cropRect;
}

@end
