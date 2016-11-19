//
//  SpeedometerView.h
//  VESC Status
//
//  Created by Heya on 11/18/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Structures.h"
#import "VescData.h"

@interface SpeedometerView : UIView {

    // Data Structure
    VescData *data;

    // Speedometer view variables
    UILabel *speedLabel, *unitLabel;
}

-(id) initWithFrame:(CGRect)frame Data: (VescData*) datax;

-(void) setSpeed;

@end
