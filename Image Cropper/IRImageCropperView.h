//
//  IRImageView.h
//  Image Editor
//
//  Created by Ihar Rubanau on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRImageCropperView : UIView
@property(nonatomic, assign) CGSize cropAreaSize;
- (CGRect)croppingWindowRect;
- (id)initWithFrame:(CGRect)frame cropAreaSize:(CGSize)cropAreaSize;
@end
