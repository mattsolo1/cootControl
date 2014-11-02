//
//  ViewController.h
//  cootControl
//
//  Created by Matt on 2014-10-10.
//  Copyright (c) 2014 Matt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "F53OSC.h"

@interface ViewController : UIViewController <F53OSCPacketDestination> {
    
    CGPoint lastPoint;
    CGPoint moveBackTo;
    CGPoint currentPoint;
    CGPoint location;
    UIView *xyRotateView;
    UIView *xyTranslateView;
    UISlider *zoomSlider;
    UIImageView *xyPad;
    
}


@property (weak, nonatomic) IBOutlet UIView *xyRotateView;

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer;
- (void)takeMessage:(F53OSCMessage *)message;


// -(void)takeMessage:(F53OSCMessage *)message;

@end

