//
//  ViewController.m
//  cootControl
//
//  Created by Matt on 2014-10-10.
//  Copyright (c) 2014 Matt. All rights reserved.
//

#import "ViewController.h"

#define SENDHOST @"192.168.1.71"
#define SENDPORT 10000
#define RECIEVEPORT 3001

@interface ViewController ()

@end

@implementation ViewController




- (void)viewDidLoad {
    
    NSLog(@"log begins");
    [super viewDidLoad];
    self.oscClient = [[F53OSCClient alloc] init];
    self.oscServer = [[F53OSCServer alloc] init];
    [self.oscServer setPort:RECIEVEPORT];
    //[self.oscServer setDelegate:self];
    [self.oscServer startListening];
    // git test change
    // lalalala
    // another change from temp
    // cocococooco
    
    // * xy pad for rotate view
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    xyRotateView = [defaults objectForKey:@"xyRotateView"];
    xyRotateView = [[UIView alloc] init];
    xyRotateView.frame = self.view.frame;
    xyRotateView.backgroundColor = [UIColor colorWithRed:0.462 green:0.794 blue:0.937 alpha:0.2];
    xyRotateView.layer.borderColor = [UIColor colorWithRed:0.462 green:0.794 blue:0.937 alpha:1.0].CGColor;
    xyRotateView.layer.borderWidth = 1.0f;
    [self.view addSubview:xyRotateView];
    [xyRotateView setFrame:CGRectMake(10, 30, 320, 320)];
    
    // * xy pad for translate view
    xyTranslateView = [defaults objectForKey:@"xyTranslateView"];
    xyTranslateView = [[UIView alloc] init];
    xyTranslateView.frame = self.view.frame;
    xyTranslateView.backgroundColor = [UIColor colorWithRed:0.158 green:0.224 blue:0.760 alpha:0.2];
    xyTranslateView.layer.borderColor = [UIColor colorWithRed:0.158 green:0.224 blue:0.760 alpha:1.0].CGColor;
    xyTranslateView.layer.borderWidth = 1.0f;
    [self.view addSubview:xyTranslateView];
    [xyTranslateView setFrame:CGRectMake(690, 30, 320, 320)];
    
    
    // * make a vertical slider - doesn't work
    [zoomSlider removeConstraints:zoomSlider.constraints];
    [zoomSlider setAutoresizingMask:YES];
    zoomSlider.transform=CGAffineTransformRotate(zoomSlider.transform, 270.0/180*M_PI);

}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint touch = [recognizer locationInView:self.view];
    
    NSNumber *xpos = [NSNumber numberWithFloat:((touch.x - recognizer.view.frame.origin.x) / recognizer.view.frame.size.width)];
    NSNumber *ypos = [NSNumber numberWithFloat:((touch.y - recognizer.view.frame.origin.y) / recognizer.view.frame.size.height)];
    
    if (CGRectContainsPoint(recognizer.view.frame, touch)) {
        
        NSLog(@"one touch x: %@, pan y: %@", xpos, ypos);
        
        F53OSCMessage *messageX = [F53OSCMessage messageWithAddressPattern:@"/RotateView/x" arguments:@[xpos]];
        
        F53OSCMessage *messageY = [F53OSCMessage messageWithAddressPattern:@"/RotateView/y" arguments:@[ypos]];
        
        F53OSCMessage *messageZ = [F53OSCMessage messageWithAddressPattern:@"/RotateView/z" arguments:@[@1.0]];
        
        [self.oscClient sendPacket:messageX toHost:SENDHOST onPort:SENDPORT];
        [self.oscClient sendPacket:messageY toHost:SENDHOST onPort:SENDPORT];
        [self.oscClient sendPacket:messageZ toHost:SENDHOST onPort:SENDPORT];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        F53OSCMessage *messageZ = [F53OSCMessage messageWithAddressPattern:@"/RotateView/z" arguments:@[@0.0]];
        [self.oscClient sendPacket:messageZ toHost:SENDHOST onPort:SENDPORT];
        }
    
/*
    if (recognizer.numberOfTouches == 2) {
        
        CGPoint touch = [recognizer locationInView:self.view];
        
        NSNumber *xpos = [NSNumber numberWithFloat:((touch.x - recognizer.view.frame.origin.x) / recognizer.view.frame.size.width)];
        NSNumber *ypos = [NSNumber numberWithFloat:((touch.y - recognizer.view.frame.origin.y) / recognizer.view.frame.size.height)];
        
        if (CGRectContainsPoint(recognizer.view.frame, touch)) {
            
            NSLog(@"two touch: %@, pan y: %@", xpos, ypos);
            
            F53OSCMessage *messageX = [F53OSCMessage messageWithAddressPattern:@"/TranslateView/x" arguments:@[xpos]];
            F53OSCMessage *messageY = [F53OSCMessage messageWithAddressPattern:@"/TranslateView/y" arguments:@[ypos]];
            F53OSCMessage *messageZ = [F53OSCMessage messageWithAddressPattern:@"/TranslateView/z" arguments:@[@1.0]];
            
            [self.oscClient sendPacket:messageX toHost:SENDHOST onPort:SENDPORT];
            [self.oscClient sendPacket:messageY toHost:SENDHOST onPort:SENDPORT];
            [self.oscClient sendPacket:messageZ toHost:SENDHOST onPort:SENDPORT];
        }
        
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            F53OSCMessage *messageX = [F53OSCMessage messageWithAddressPattern:@"/TranslateView/x" arguments:@[xpos]];
            F53OSCMessage *messageY = [F53OSCMessage messageWithAddressPattern:@"/TranslateView/y" arguments:@[ypos]];
            F53OSCMessage *messageZ = [F53OSCMessage messageWithAddressPattern:@"/TranslateView/z" arguments:@[@0.0]];
            
            [self.oscClient sendPacket:messageX toHost:SENDHOST onPort:SENDPORT];
            [self.oscClient sendPacket:messageY toHost:SENDHOST onPort:SENDPORT];
            [self.oscClient sendPacket:messageZ toHost:SENDHOST onPort:SENDPORT];
        }
        
    }
 */
}


- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    
    CGPoint touch = [recognizer locationInView:self.view];
    
    if (CGRectContainsPoint(recognizer.view.frame, touch)) {
    
        NSLog(@"pinch: %f", recognizer.scale);
    
        recognizer.scale = 1;
    }
}

- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer {
    
    NSLog(@"pinch: %f", recognizer.rotation);
    
    recognizer.rotation = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    currentPoint = [touch locationInView:self.view];

    
    if (CGRectContainsPoint(xyRotateView.frame, currentPoint)) {
    
        
        F53OSCMessage *messageX = [F53OSCMessage messageWithAddressPattern:@"/RotateView/x" arguments:@[[NSNumber numberWithFloat:(currentPoint.x/ xyRotateView.frame.size.width)]]];
        
        F53OSCMessage *messageY = [F53OSCMessage messageWithAddressPattern:@"/RotateView/y" arguments:@[[NSNumber numberWithFloat:(currentPoint.y/xyRotateView.frame.size.height)]]];
        
        F53OSCMessage *messageZ = [F53OSCMessage messageWithAddressPattern:@"/RotateView/z" arguments:@[@1.0]];
        
        [self.oscClient sendPacket:messageX toHost:SENDHOST onPort:SENDPORT];
        [self.oscClient sendPacket:messageY toHost:SENDHOST onPort:SENDPORT];
        [self.oscClient sendPacket:messageZ toHost:SENDHOST onPort:SENDPORT];
        
        [super touchesBegan: touches withEvent:event];
        
    } else if (CGRectContainsPoint(xyTranslateView.frame, currentPoint)) {
        
        NSLog(@"touchbegin current translate point is %f and %f", currentPoint.x, currentPoint.y);
        

        F53OSCMessage *messageX = [F53OSCMessage messageWithAddressPattern:@"/TranslateView/x" arguments:@[[NSNumber numberWithFloat:((currentPoint.x - 650)/xyTranslateView.frame.size.width)]]];
        
        F53OSCMessage *messageY = [F53OSCMessage messageWithAddressPattern:@"/TranslateView/y" arguments:@[[NSNumber numberWithFloat:(currentPoint.y/xyTranslateView.frame.size.height)]]];

        F53OSCMessage *messageZ = [F53OSCMessage messageWithAddressPattern:@"/TranslateView/z" arguments:@[@1.0]];
        
        [self.oscClient sendPacket:messageX toHost:SENDHOST onPort:SENDPORT];
        [self.oscClient sendPacket:messageY toHost:SENDHOST onPort:SENDPORT];
        [self.oscClient sendPacket:messageZ toHost:SENDHOST onPort:SENDPORT];

    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // * creae a new UITouch object called touch
    UITouch *touch = [touches anyObject];
    currentPoint = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(xyRotateView.frame, currentPoint)) {
        
        F53OSCMessage *messageX = [F53OSCMessage messageWithAddressPattern:@"/RotateView/x" arguments:@[[NSNumber numberWithFloat:(currentPoint.x/ xyRotateView.frame.size.width)]]];
        
        F53OSCMessage *messageY = [F53OSCMessage messageWithAddressPattern:@"/RotateView/y" arguments:@[[NSNumber numberWithFloat:(currentPoint.y/xyRotateView.frame.size.height)]]];
        
        [self.oscClient sendPacket:messageX toHost:SENDHOST onPort:SENDPORT];
        [self.oscClient sendPacket:messageY toHost:SENDHOST onPort:SENDPORT];

    } else if (CGRectContainsPoint(xyTranslateView.frame, currentPoint)) {
        
        NSLog(@"touchmoved current translate point is %f and %f", currentPoint.x, currentPoint.y);

        F53OSCMessage *messageX = [F53OSCMessage messageWithAddressPattern:@"/TranslateView/x" arguments:@[[NSNumber numberWithFloat:((currentPoint.x - 650)/xyTranslateView.frame.size.width)]]];
        
        F53OSCMessage *messageY = [F53OSCMessage messageWithAddressPattern:@"/TranslateView/y" arguments:@[[NSNumber numberWithFloat:(currentPoint.y/xyTranslateView.frame.size.height)]]];
        
        [self.oscClient sendPacket:messageX toHost:SENDHOST onPort:SENDPORT];
        [self.oscClient sendPacket:messageY toHost:SENDHOST onPort:SENDPORT];

    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
   
    UITouch *touch = [touches anyObject];
    currentPoint = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(xyRotateView.frame, currentPoint)) {
    
        F53OSCMessage *messageX = [F53OSCMessage messageWithAddressPattern:@"/RotateView/x" arguments:@[[NSNumber numberWithFloat:(currentPoint.x/ xyRotateView.frame.size.width)]]];
        
        F53OSCMessage *messageY = [F53OSCMessage messageWithAddressPattern:@"/RotateView/y" arguments:@[[NSNumber numberWithFloat:(currentPoint.y/xyRotateView.frame.size.height)]]];
        
        F53OSCMessage *messageZ = [F53OSCMessage messageWithAddressPattern:@"/RotateView/z" arguments:@[@0.0]];
        
        [self.oscClient sendPacket:messageX toHost:SENDHOST onPort:SENDPORT];
        [self.oscClient sendPacket:messageY toHost:SENDHOST onPort:SENDPORT];
        [self.oscClient sendPacket:messageZ toHost:SENDHOST onPort:SENDPORT];
        
    }  else if (CGRectContainsPoint(xyTranslateView.frame, currentPoint)) {
        
        NSLog(@"touchesended current translate point is %f and %f", currentPoint.x, currentPoint.y);

        F53OSCMessage *messageX = [F53OSCMessage messageWithAddressPattern:@"/TranslateView/x" arguments:@[[NSNumber numberWithFloat:((currentPoint.x - 650)/xyTranslateView.frame.size.width)]]];
        F53OSCMessage *messageY = [F53OSCMessage messageWithAddressPattern:@"/TranslateView/y" arguments:@[[NSNumber numberWithFloat:(currentPoint.y/xyTranslateView.frame.size.height)]]];
        F53OSCMessage *messageZ = [F53OSCMessage messageWithAddressPattern:@"/TranslateView/z" arguments:@[@0.0]];
        
        [self.oscClient sendPacket:messageX toHost:SENDHOST onPort:SENDPORT];
        [self.oscClient sendPacket:messageY toHost:SENDHOST onPort:SENDPORT];
        [self.oscClient sendPacket:messageZ toHost:SENDHOST onPort:SENDPORT];
        
    }
}



- (IBAction)sendZoomMessage:(UISlider *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/Zoom/x" arguments:@[[NSNumber numberWithFloat:sender.value]]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)zoomActivate:(UISlider *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/Zoom/z" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}


- (IBAction)zoomDeactivate:(UISlider *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/Zoom/z" arguments:@[@0.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}


- (IBAction)addWater:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/AddWater/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];

}
- (IBAction)DeleteWater:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/DeleteWater/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}


- (IBAction)nextResidue:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/NextResidue/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)previousResidue:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/PreviousResidue/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}


- (IBAction)trimSideChain:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/Trim/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}


- (IBAction)FillSideChain:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/FillSideChain/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}


- (IBAction)FlipPeptBond:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/FlipPeptBond/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)TripleRefine:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/TripleRefine/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)GoToBlob:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/GoToBlob/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)AutofitRotamer:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/AutoFitRotamer/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)ManuallyRefine:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/ManualRefineRes/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)AutoRefine:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/AutoRefineRes/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)AddTerminalResidue:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/AddTerminalResidue/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)NeighborRefine:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/NeighborsRefine/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)ToggleGhosts:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/ToggleGhosts/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)ToggleHydrogens:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/AddTerminalResidue/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)Accept:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/Accept/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)Regularize:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/Regularize/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)Set2FoFcScroll:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/set2FoFc/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)FoFcScroll:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/setFoFc/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)Set2FoFcRefine:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/setRef2FoFc/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)SetFoFcRefine:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/setRefFoFc/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)Undo:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/undo/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)Redo:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/redo/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

- (IBAction)setUndo:(UIButton *)sender {
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/setUndo/x" arguments:@[@1.0]];
    [self.oscClient sendPacket:message toHost:SENDHOST onPort:SENDPORT];
}

/*
-(void)takeMessage:(F53OSCMessage *)message {
    [self.addressLabel setText:message.addressPattern];
    [self.argumentsLabel setText:[message.arguments description]];
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
