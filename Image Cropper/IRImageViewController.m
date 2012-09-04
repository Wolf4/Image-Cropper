//
//  IRImageViewController.m
//  Image Editor
//
//  Created by Ihar Rubanau on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IRImageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IRImageCropperView.h"


@interface IRImageViewController ()
@property(nonatomic, retain) UIImage *originalImage;
@property(nonatomic) CGSize cropAreaSize;
@end


@implementation IRImageViewController
@synthesize imageView = imageView_;
@synthesize imageCropperView = imageCropperView_;
@synthesize originalImage = originalImage_;
@synthesize cropAreaSize = cropAreaSize_;


#pragma mark - UIView Lifecycle

- (id)initWithImage:(UIImage *)image cropAreaSize:(CGSize)size {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    // Custom initialization
    self.originalImage = image;
//    self.cropAreaSize = size;
    imageCropperView_ = [[IRImageCropperView alloc] initWithFrame:CGRectZero cropAreaSize:size];
  }
  return self;
}

- (void)loadView {
  UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
  view.backgroundColor = [UIColor grayColor];
//  view.frame = [view superview].frame;
  view.clipsToBounds = YES;
  self.view = view;
  [view release];
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  NSLog(@"%@", self.view);
  self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
  self.imageView.backgroundColor = [UIColor blackColor];
  self.imageView.frame = self.view.bounds;
  self.imageView.image = self.originalImage;
  self.imageView.userInteractionEnabled = YES;
  self.imageView.autoresizingMask = (UIViewAutoresizingFlexibleHeight |
                                     UIViewAutoresizingFlexibleWidth);
  self.imageView.contentMode = [self appropriateContentModeForImageView];
  [self.view addSubview:self.imageView];
  
//  IRImageCropperView *imageCropperView = [[IRImageCropperView alloc]
//                                          initWithFrame:self.view.bounds
//                                          cropAreaSize:self.cropAreaSize];
  self.imageCropperView.frame = self.view.bounds;
  
  UIButton *cropButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [cropButton addTarget:self
                 action:@selector(cropButtonPressed)
       forControlEvents:UIControlEventTouchUpInside];
  [cropButton setTitle:@"crop" forState:UIControlStateNormal];
  cropButton.frame = CGRectMake(10, 500, 100, 40);
  cropButton.backgroundColor = [UIColor clearColor];
  cropButton.tag = 55;
  [self.imageCropperView addSubview:cropButton];
  UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [cancelButton addTarget:self
                   action:@selector(cancelButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
  [cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
  cancelButton.frame = CGRectMake(10, 540, 100, 40);
  cancelButton.backgroundColor = [UIColor clearColor];
  cancelButton.tag = 56;
  [self.imageCropperView addSubview:cancelButton];
  [self.view addSubview:self.imageCropperView];
  // gestures adding
  UIPinchGestureRecognizer *pinchGesture =
  [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handlePinchGesture:)];
  [self.imageCropperView addGestureRecognizer:pinchGesture];
  UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(handlePanGesture:)];
  [self.imageCropperView addGestureRecognizer:panGesture];
  [pinchGesture release];
  [panGesture release];
//  [imageCropperView release];
}

- (CGRect)imageRectForImageView:(UIImageView *)imageView {
  CGSize imgSize = imageView.image.size;
  CGSize imgVSize = imageView.frame.size;
  float imageRatio = (float)imgSize.height / imgSize.width;
  float imageVRatio = (float)imgVSize.height / imgVSize.width;
  NSLog(@"image size: %@; ratio: %f",
        NSStringFromCGSize(imgSize),
        imageRatio);
  NSLog(@"imageView size: %@; ratio: %f",
        NSStringFromCGSize(imgVSize),
        imageVRatio);
  CGRect imageRect = self.imageView.frame;
  if (imageView.contentMode == UIViewContentModeCenter) {
    CGFloat xPoint = (imgVSize.width - imgSize.width) / 2;
    CGFloat yPoint = (imgVSize.height - imgSize.height) / 2;
    imageRect = CGRectMake(xPoint, yPoint, imgSize.width, imgSize.height);
    return imageRect;
  }
  if (imageRatio > imageVRatio) {
    int imageVisualHeight = imgVSize.height;
    int imageVisualWidth = (1 / imageRatio) * imageVisualHeight;
    NSLog(@"height: %i; width: %i", imageVisualHeight, imageVisualWidth);
    imageRect = CGRectInset(imageView.frame,
                            (imgVSize.width - imageVisualWidth) / 2,
                            0);
    NSLog(@"image rect: %@", NSStringFromCGRect(imageRect));
  } else {
    int imageVisualWidth = imgVSize.width;
    int imageVisualHeight = imageRatio * imageVisualWidth;
    NSLog(@"width: %i; height: %i", imageVisualWidth, imageVisualHeight);
    imageRect = CGRectInset(imageView.frame,
                            0,
                            (imgVSize.height - imageVisualHeight) / 2);
    NSLog(@"image rect: %@", NSStringFromCGRect(imageRect));
  }
  //  NSLog(@"image ratio: %f",(float)imgSize.height / imgSize.width );
  NSLog(@"imageView frame: %@", NSStringFromCGRect(imageView.frame));
  NSLog(@"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
  return imageRect;
}

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

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)dealloc {
  [originalImage_ release];
  [imageView_ release];
  [imageCropperView_ release];
  [super dealloc];
}

#pragma mark - Interface Orientation / Rotation methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io {
  return YES;
}



#pragma mark - User Interaction Methods

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
  CGPoint translation = [recognizer translationInView:self.imageView];
  self.imageView.frame = CGRectMake(self.imageView.frame.origin.x + translation.x,
                                    self.imageView.frame.origin.y + translation.y,
                                    self.imageView.frame.size.width,
                                    self.imageView.frame.size.height);
  [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
  if (recognizer.state == UIGestureRecognizerStateEnded) {
    CGSize cropAreaSize = self.imageCropperView.cropAreaSize;
    CGSize imageViewSize = self.imageView.bounds.size;
    CGFloat scale = self.imageView.transform.a;
    if (cropAreaSize.width < (imageViewSize.width * scale) ||
        cropAreaSize.height < (imageViewSize.height * scale)) {
      [self moveImageBackToBorder];
    }
    //    [self imageRectForImageView:self.imageView];
  }
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer {
  self.imageView.transform = CGAffineTransformScale(self.imageView.transform,
                                                    recognizer.scale,
                                                    recognizer.scale);
  recognizer.scale = 1;
  if (recognizer.state == UIGestureRecognizerStateEnded) {
    //    [self returnImageSize];
    CGSize cropAreaSize = [self.imageCropperView croppingWindowRect].size;
    CGSize imageViewSize = self.imageView.bounds.size;
    CGFloat scale = self.imageView.transform.a;
    if (cropAreaSize.width < (imageViewSize.width * scale) ||
        cropAreaSize.height < (imageViewSize.height * scale)) {
      [self moveImageBackToBorder];
    }
  }
}

#pragma mark - Model Methods

- (UIViewContentMode)appropriateContentModeForImageView {
  CGSize viewSize = self.view.frame.size;
  CGSize imageSize = self.imageView.image.size;
  if (imageSize.width >= viewSize.width ||
      imageSize.height >= viewSize.height) {
    NSLog(@"UIViewContentModeScaleAspectFit");
    return UIViewContentModeScaleAspectFit;
  }
  NSLog(@"UIViewContentModeCenter");
  return UIViewContentModeCenter;
}

- (UIImage *)cropImage {
  CGRect cropRect = [self.imageCropperView croppingWindowRect];
  UIGraphicsBeginImageContext(cropRect.size);
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(ctx, -cropRect.origin.x, -cropRect.origin.y);
  [self.view.layer renderInContext:ctx];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

- (UIImage *)rotateScreenShot:(UIImage *)rawScreenShotImage {
  UIImage *screenShotImage;
  switch (self.interfaceOrientation) {
    case UIInterfaceOrientationPortrait:
      screenShotImage = [self rotateImage:rawScreenShotImage ByDegrees:0];
      break;
    case UIInterfaceOrientationPortraitUpsideDown:
      screenShotImage = [self rotateImage:rawScreenShotImage ByDegrees:180];
      break;
    case UIInterfaceOrientationLandscapeLeft:
      screenShotImage = [self rotateImage:rawScreenShotImage ByDegrees:90];
      break;
    case UIInterfaceOrientationLandscapeRight:
      screenShotImage = [self rotateImage:rawScreenShotImage ByDegrees:-90];
      break;
    default:
      screenShotImage = [self rotateImage:rawScreenShotImage ByDegrees:0];
      break;
  }
  return screenShotImage;
}


CGFloat DegreesToRadians(CGFloat degrees) {
  return degrees * M_PI / 180;
};

- (UIImage *)rotateImage:(UIImage *)image ByDegrees:(CGFloat)degrees {
  // SOURCE CODE TAKEN FROM http://www.catamount.com/forums/viewtopic.php?f=21&t=967
  // calculate the size of the rotated view's containing box
  // for our drawing space
  UIView *rotatedViewBox = [[UIView alloc]
                            initWithFrame:CGRectMake(0,
                                                     0,
                                                     image.size.width,
                                                     image.size.height)];
  CGAffineTransform t =
  CGAffineTransformMakeRotation(DegreesToRadians(degrees));
  rotatedViewBox.transform = t;
  CGSize rotatedSize = rotatedViewBox.frame.size;
  [rotatedViewBox release];
  // Create the bitmap context
  UIGraphicsBeginImageContext(rotatedSize);
  CGContextRef bitmap = UIGraphicsGetCurrentContext();
  // Move the origin to the middle of the image so we will
  // rotate and scale around the center.
  CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
  // Rotate the image context
  CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
  // Now, draw the rotated/scaled image into the context
  CGContextScaleCTM(bitmap, 1.0, -1.0);
  CGContextDrawImage(bitmap,
                     CGRectMake(-image.size.width / 2,
                                -image.size.height / 2,
                                image.size.width, image.size.height),
                     [image CGImage]);
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}


#pragma mark - maxim's methods

- (void)moveImageBackToBorder {
  CGRect imageCropArreaRect = [imageCropperView_ croppingWindowRect];
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

- (void)returnImageSize {
  if (self.imageView.frame.size.height/self.imageView.frame.size.width >=
      [imageCropperView_ croppingWindowRect].size.height/
      [imageCropperView_ croppingWindowRect].size.width &&
      self.imageView.frame.size.height <
      [imageCropperView_ croppingWindowRect].size.height) {
    self.imageView.transform =
    CGAffineTransformScale(self.imageView.transform,
                           [imageCropperView_ croppingWindowRect].size.height/
                           self.imageView.frame.size.height,
                           [imageCropperView_ croppingWindowRect].size.height/
                           self.imageView.frame.size.height);
  }
  if (self.imageView.frame.size.height /
      self.imageView.frame.size.width <
      [imageCropperView_ croppingWindowRect].size.height /
      [imageCropperView_ croppingWindowRect].size.width &&
      self.imageView.frame.size.width <
      [imageCropperView_ croppingWindowRect].size.width) {
    self.imageView.transform =
    CGAffineTransformScale(self.imageView.transform,
                           [imageCropperView_ croppingWindowRect].size.width/
                           self.imageView.frame.size.width,
                           [imageCropperView_ croppingWindowRect].size.width/
                           self.imageView.frame.size.width);
  }
}

@end
