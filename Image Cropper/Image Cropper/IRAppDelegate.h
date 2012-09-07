//
//  IRAppDelegate.h
//  Image Cropper
//
//  Created by Igor Rubanau on 9/3/12.
//  Copyright (c) 2012 Igor Rubanau. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IRRootViewController;
@interface IRAppDelegate : UIResponder <UIApplicationDelegate>
@property(strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) IRRootViewController *viewController;
@end
