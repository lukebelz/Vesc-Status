//
//  CurrentTripView.h
//  VESC Status
//
//  Created by Heya on 11/25/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Structures.h"
#import "VescData.h"

@interface CurrentTripView : UIView {
    
    // Data Structure
    VescData *data;
    
    // Labels
    UILabel *TimeLabel, *DistanceLabel;
    
}

-(id) initWithFrame:(CGRect)frame Data: (VescData*) datax;

-(void) reloadView;

@end
