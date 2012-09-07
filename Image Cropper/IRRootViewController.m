//
//  IRRootViewController.m
//  Image Editor
//
//  Created by Ihar Rubanau on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IRRootViewController.h"
#import "IRCropperViewController.h"

@interface IRRootViewController ()

@end


@implementation IRRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  UIButton *fullScreenButton =
  [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [fullScreenButton setTitle:@"full screen" forState:UIControlStateNormal];
  fullScreenButton.frame = CGRectMake(50, 100, 200, 50);
  [fullScreenButton addTarget:self
                       action:@selector(fullScreenButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:fullScreenButton];
  UIButton *pageSheetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [pageSheetButton setTitle:@"page sheet" forState:UIControlStateNormal];
  pageSheetButton.frame = CGRectMake(50, 150, 200, 50);
  [pageSheetButton addTarget:self
                      action:@selector(pageSheetButtonPressed)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:pageSheetButton];
  UIButton *formSheetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [formSheetButton setTitle:@"form sheet" forState:UIControlStateNormal];
  formSheetButton.frame = CGRectMake(50, 200, 200, 50);
  [formSheetButton addTarget:self
                      action:@selector(formSheetButtonPressed)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:formSheetButton];
  UIButton *popoverButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [popoverButton setTitle:@"popover sheet" forState:UIControlStateNormal];
  popoverButton.frame = CGRectMake(50, 250, 200, 50);
  [popoverButton addTarget:self
                    action:@selector(popoverButtonPressed:)
          forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:popoverButton];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  //  NSLog(@"really super puper view %@", self.view);
  //  NSLog(@"subviews: %@", [self.view subviews]);
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fio {
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io {
  return YES;
}

- (void)fullScreenButtonPressed {
  UIImage *image = [UIImage imageNamed:@"7.jpeg"];
  IRCropperViewController *irViewController = [[IRCropperViewController alloc]
                                             initWithImage:image
                                             cropAreaSize:CGSizeMake(250, 250)];
  irViewController.modalPresentationStyle = UIModalPresentationFullScreen;
  [self presentModalViewController:irViewController animated:YES];
  [irViewController release];
}

- (void)pageSheetButtonPressed {
  UIImage *image = [UIImage imageNamed:@"5.jpeg"];
  IRCropperViewController *irViewController = [[IRCropperViewController alloc]
                                             initWithImage:image
                                             cropAreaSize:CGSizeMake(250, 250)];
  irViewController.modalPresentationStyle = UIModalPresentationPageSheet;
  [self presentModalViewController:irViewController animated:YES];
  [irViewController release];
}

- (void)formSheetButtonPressed {
  UIImage *image = [UIImage imageNamed:@"6.jpeg"];
  IRCropperViewController *irViewController = [[IRCropperViewController alloc]
                                             initWithImage:image
                                             cropAreaSize:CGSizeMake(250, 250)];
  irViewController.modalPresentationStyle = UIModalPresentationFormSheet;
  [self presentModalViewController:irViewController animated:YES];
  [irViewController release];
}

- (void)popoverButtonPressed:(UIButton *)sender {
  UIImage *image = [UIImage imageNamed:@"8.jpeg"];
  IRCropperViewController *irViewController = [[IRCropperViewController alloc]
                                             initWithImage:image
                                             cropAreaSize:CGSizeMake(250, 250)];
  UIPopoverController *popoverController =
  [[UIPopoverController alloc] initWithContentViewController:irViewController];
  popoverController.popoverContentSize = CGSizeMake(600, 600);
  CGRect anchorRect = CGRectMake(sender.frame.size.width,
                                 sender.frame.size.height / 2,
                                 0,
                                 0);
  [popoverController presentPopoverFromRect:anchorRect
                                     inView:sender
                   permittedArrowDirections:UIPopoverArrowDirectionLeft
                                   animated:YES];
  [irViewController release];
  //  NSLog(@"%f", sender.center.x);
  //  [popoverController release];
}

@end
