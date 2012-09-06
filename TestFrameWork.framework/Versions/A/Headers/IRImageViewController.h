//
//  IRImageViewController.h
//  Image Editor
//
//  Created by Ihar Rubanau on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IRCropperView;
@interface IRImageViewController : UIViewController
@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, retain) IRCropperView *cropperView;
- (id)initWithImage:(UIImage *)image cropAreaSize:(CGSize)size;
- (UIImage *)cropImage;
- (void)setCropAreaSize:(CGSize)size;
@end
