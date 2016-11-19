//
//  AccelerationTimerView.h
//  VESC Status
//
//  Created by Heya on 11/3/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Structures.h"
#import "VescData.h"

@interface AccelerationTimerView : UIView {
    
    // Data Structure
    VescData *data;
    
    bool timerRunning;
    
    UILabel *status, *speed;
    UIButton *startButton;
    
    long long startRecordingTime;
}

- (id) initWithFrame:(CGRect)frame Data: (VescData*) datax;

@end
