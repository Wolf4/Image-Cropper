//
//  IRImageViewController.m
//  Image Editor
//
//  Created by Ihar Rubanau on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IRImageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IRCropperView.h"

@interface IRImageViewController ()
@end


@implementation IRImageViewController
@synthesize imageView = imageView_;
@synthesize cropperView = cropperView_;


#pragma mark - UIView Lifecycle

- (id)initWithImage:(UIImage *)image cropAreaSize:(CGSize)size {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    // Custom initialization
    imageView_ = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView_.image = image;
    cropperView_ = [[IRCropperView alloc]
                         initWithFrame:CGRectZero
                         cropAreaSize:size];
  }
  return self;
}

- (void)loadView {
  UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
  view.backgroundColor = [UIColor blackColor];
  self.view = view;
  [view release];
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.imageView.frame = self.view.bounds;
  self.imageView.autoresizingMask = (
//                                     UIViewAutoresizingFlexibleHeight |
//                                     UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleBottomMargin |
                                     UIViewAutoresizingFlexibleLeftMargin |
                                     UIViewAutoresizingFlexibleRightMargin);
  self.imageView.frame = [self imageRectForImageView:self.imageView];
  [self.view addSubview:self.imageView];
  self.cropperView.backgroundColor = [UIColor clearColor];
  self.cropperView.contentMode = UIViewContentModeRedraw;
  self.cropperView.autoresizingMask = (UIViewAutoresizingFlexibleHeight |
                           UIViewAutoresizingFlexibleWidth);
  self.cropperView.frame = self.view.bounds;
  UIButton *cropButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [cropButton addTarget:self
                 action:@selector(cropButtonPressed)
       forControlEvents:UIControlEventTouchUpInside];
  [cropButton setTitle:@"crop" forState:UIControlStateNormal];
  cropButton.frame = CGRectMake(10, 500, 100, 40);
  cropButton.backgroundColor = [UIColor clearColor];
  [self.cropperView addSubview:cropButton];
  UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [cancelButton addTarget:self
                   action:@selector(cancelButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
  [cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
  cancelButton.frame = CGRectMake(10, 540, 100, 40);
  cancelButton.backgroundColor = [UIColor clearColor];
  [self.cropperView addSubview:cancelButton];
  [self.view addSubview:self.cropperView];
  // gestures adding
  UIPinchGestureRecognizer *pinchGesture =
  [[UIPinchGestureRecognizer alloc]
   initWithTarget:self
   action:@selector(handlePinchGesture:)];
  [self.cropperView addGestureRecognizer:pinchGesture];
  UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(handlePanGesture:)];
  [self.cropperView addGestureRecognizer:panGesture];
  [pinchGesture release];
  [panGesture release];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)dealloc {
  [imageView_ release];
  [cropperView_ release];
  [super dealloc];
}

#pragma mark - Interface Orientation / Rotation methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io {
  return YES;
}



#pragma mark - User Interaction Methods

- (void)cropButtonPressed {
  UIImage *image = [self cropImage];
  UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image];
  [self.view addSubview:imageView2];
  [self.view bringSubviewToFront:imageView2];
  [imageView2 release];
}

- (void)cancelButtonPressed {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
  CGPoint translation = [recognizer translationInView:self.imageView];
  CGFloat scaleFactor = self.imageView.transform.a;
  self.imageView.center = CGPointMake(self.imageView.center.x +
                                      translation.x * scaleFactor,
                                       self.imageView.center.y +
                                      translation.y * scaleFactor);
  [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
  if (recognizer.state == UIGestureRecognizerStateEnded) {
    CGSize cropAreaSize = self.cropperView.cropAreaSize;
    CGSize imageViewSize = self.imageView.bounds.size;
    CGFloat scale = self.imageView.transform.a;
    if (cropAreaSize.width < (imageViewSize.width * scale) ||
        cropAreaSize.height < (imageViewSize.height * scale)) {
      [self moveImageViewBackToBorder];
    }
    //    [self imageRectForImageView:self.imageView];
  }
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer {
  if (recognizer.state == UIGestureRecognizerStateBegan) {
    CGPoint locationInView = [recognizer locationInView:self.imageView];
    CGPoint locationInSuperview = [recognizer
                                   locationInView:self.imageView.superview];
    self.imageView.layer.anchorPoint =
    CGPointMake(locationInView.x / self.imageView.bounds.size.width,
                locationInView.y / self.imageView.bounds.size.height);
    self.imageView.center = locationInSuperview;
  }
  // Scale
  [self.imageView.layer setAffineTransform:
   CGAffineTransformScale([self.imageView.layer affineTransform],
                          recognizer.scale, recognizer.scale)];
  recognizer.scale = 1;
}

#pragma mark - Model Methods

- (void)setCropAreaSize:(CGSize)size {
  self.cropperView.cropAreaSize = size;
  [self.cropperView setNeedsDisplay];
}

- (CGRect)imageRectForImageView:(UIImageView *)imageView {
  // This method return CGRect containing image in fullscreen imageView
  CGSize imgSize = imageView.image.size;
  CGSize imgVSize = imageView.frame.size;
  float imageRatio = (float)imgSize.height / imgSize.width;
  float imageVRatio = (float)imgVSize.height / imgVSize.width;
  CGRect imageRect = imageView.frame;
  if (imgSize.width < imgVSize.width && imgSize.height < imgVSize.height) {
    CGFloat xPoint = (imgVSize.width - imgSize.width) / 2;
    CGFloat yPoint = (imgVSize.height - imgSize.height) / 2;
    imageRect = CGRectMake(xPoint, yPoint, imgSize.width, imgSize.height);
    return imageRect;
  }
  if (imageRatio > imageVRatio) {
    int imageVisualHeight = imgVSize.height;
    int imageVisualWidth = (1 / imageRatio) * imageVisualHeight;
    imageRect = CGRectInset(imageView.frame,
                            (imgVSize.width - imageVisualWidth) / 2,
                            0);
  } else {
    int imageVisualWidth = imgVSize.width;
    int imageVisualHeight = imageRatio * imageVisualWidth;
    imageRect = CGRectInset(imageView.frame,
                            0,
                            (imgVSize.height - imageVisualHeight) / 2);
  }
  //  NSLog(@"image ratio: %f",(float)imgSize.height / imgSize.width );
  return imageRect;
}

- (UIImage *)cropImage {
  CGRect cropRect = [self.cropperView croppingWindowRect];
  UIGraphicsBeginImageContext(cropRect.size);
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(ctx, -cropRect.origin.x, -cropRect.origin.y);
  [self.view.layer renderInContext:ctx];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

#pragma mark - maxim's methods

- (void)moveImageViewBackToBorder {
  CGRect imageCropArreaRect = [self.cropperView croppingWindowRect];
  CGRect imageViewFrame = self.imageView.frame;
  CGFloat imageViewWidth = imageViewFrame.size.width;
  CGFloat imageViewHeight = imageViewFrame.size.height;
  if (imageViewFrame.origin.x + imageViewFrame.size.width
      < imageCropArreaRect.origin.x + imageCropArreaRect.size.width) {
    self.imageView.frame = CGRectMake(imageCropArreaRect.size.width +
                                      imageCropArreaRect.origin.x -
                                      imageViewWidth,
                                      imageViewFrame.origin.y ,
                                      imageViewWidth,
                                      imageViewHeight);
    imageViewFrame = self.imageView.frame;
  }
  if (imageViewFrame.origin.y + imageViewFrame.size.height
      < imageCropArreaRect.origin.y + imageCropArreaRect.size.width) {
    self.imageView.frame = CGRectMake(imageViewFrame.origin.x,
                                      imageCropArreaRect.origin.y +
                                      imageCropArreaRect.size.height -
                                      imageViewHeight,
                                      imageViewWidth,
                                      imageViewHeight);
    imageViewFrame = self.imageView.frame;
  }
  if (imageViewFrame.origin.x > imageCropArreaRect.origin.x) {
    self.imageView.frame = CGRectMake(imageCropArreaRect.origin.x,
                                      imageViewFrame.origin.y ,
                                      imageViewWidth,
                                      imageViewHeight);
    imageViewFrame = self.imageView.frame;
  }
  if (imageViewFrame.origin.y > imageCropArreaRect.origin.y) {
    self.imageView.frame = CGRectMake(imageViewFrame.origin.x,
                                      imageCropArreaRect.origin.y,
                                      imageViewWidth,
                                      imageViewHeight);
    imageViewFrame = self.imageView.frame;
  }
}

@end
