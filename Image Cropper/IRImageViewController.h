//
//  IRImageViewController.h
//  Image Editor
//
//  Created by Ihar Rubanau on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IRImageCropperView;
@interface IRImageViewController : UIViewController
@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, retain) IRImageCropperView *imageCropperView;
- (id)initWithImage:(UIImage *)image cropAreaSize:(CGSize)size;
- (UIImage *)cropImage;
@end
