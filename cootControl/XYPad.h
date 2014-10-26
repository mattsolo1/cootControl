//
//  XYPad.h
//  cootControl
//
//  Created by Matt on 2014-10-12.
//  Copyright (c) 2014 Matt. All rights reserved.
//

#ifndef cootControl_XYPad_h
#define cootControl_XYPad_h
#import <UIKit/UIKit.h>
#import "F53OSC.h"

// * For making an XY touch pad inside a view

@interface XYPadArea : UIView {
    
    NSString *_name;
    UIColor *_backGroundColor;
    UIColor *_borderColor;
    float _borderWidth;
    
    NSString *_messageX;
    NSString *_messageY;
    
    NSString *_messageZ_Begin;
    NSString *_messageZ_Moved;
    NSString *_messageZ_End;
    
}

- (NSString *) xyPadName;
- (void) setName: (NSString *) newName;



@end

#endif
