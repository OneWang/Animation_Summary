//
//  WFSecondViewController.m
//  Animation_Summary
//
//  Created by Jack on 2018/8/24.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "WFSecondViewController.h"

@interface WFSecondViewController ()

@end

@implementation WFSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(p_pan:)];
    [self.view addGestureRecognizer:panGesture];
}

- (void)p_pan:(UIPanGestureRecognizer *)panGesture{
    bool isDisappear = NO;
    if (panGesture.state == UIGestureRecognizerStateBegan) {
//        CGPoint startPoint = [panGesture locationInView:panGesture.view];
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        CGPoint movePoint = [panGesture translationInView:panGesture.view];
        self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 620 - movePoint.y);
    }else if (panGesture.state == UIGestureRecognizerStateEnded){
        if ([panGesture translationInView:panGesture.view].y > 100) {
            isDisappear = YES;
        }
        if (isDisappear) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 620);
        }
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//| ----------------------------------------------------------------------------
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    // When the current trait collection changes (e.g. the device rotates),
    // update the preferredContentSize.
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}


//| ----------------------------------------------------------------------------
//! Updates the receiver's preferredContentSize based on the verticalSizeClass
//! of the provided \a traitCollection.
//
- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection
{
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact ? 270 : 620);

    // To demonstrate how a presentation controller can dynamically respond
    // to changes to its presented view controller's preferredContentSize,
    // this view controller exposes a slider.  Dragging this slider updates
    // the preferredContentSize of this view controller in real time.
    //
    // Update the slider with appropriate min/max values and reset the
    // current value to reflect the changed preferredContentSize.
//    self.slider.maximumValue = self.preferredContentSize.height;
//    self.slider.minimumValue = 220.f;
//    self.slider.value = self.slider.maximumValue;
}


//| ----------------------------------------------------------------------------
- (void)sliderValueChange:(UISlider *)sender
{
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, sender.value);
}

#pragma mark -
#pragma mark Unwind Actions

//| ----------------------------------------------------------------------------
//! Action for unwinding from the presented view controller (C).
//
- (void)unwindToCustomPresentationSecondViewController:(UIStoryboardSegue *)sender
{ }


@end
