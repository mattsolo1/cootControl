//
//  ViewController.h
//  cootControl
//
//  Created by Matt on 2014-10-10.
//  Copyright (c) 2014 Matt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "F53OSC.h"

@interface ViewController : UIViewController {
    
    CGPoint lastPoint;
    CGPoint moveBackTo;
    CGPoint currentPoint;
    CGPoint location;
    UIView *xyRotateView;
    UIView *xyTranslateView;
    UISlider *zoomSlider;
    
}

@property (strong, nonatomic) F53OSCClient* oscClient;
@property (strong, nonatomic) F53OSCServer* oscServer;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *argumentsLabel;
@property (weak, nonatomic) IBOutlet UIView *xyRotateView;


// -(void)takeMessage:(F53OSCMessage *)message;

@end

