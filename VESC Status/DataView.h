//
//  DataView.h
//  VESC Status
//
//  Created by Heya on 10/25/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Structures.h"
#import "VescData.h"

@interface DataView : UIView {
    
    // Data Structure
    VescData *data;

    // Labels
    UILabel *TimeLabel, *DistanceLabel, *CurrentVoltageLabel, *CurrentBatteryPercentageLabel, *CurrentBatteryAmpLabel, *CurrentMotorAmpLabel, *CurrentTempLabel, *CurrentFaultCodeLabel, *CurrentSpeedLabel;
    UILabel *MaxSpeedLabel, *MaxMotorAmpLabel, *MaxTempLabel, *MaxBatteryAmpLabel;
    UILabel *AvgSpeedLabel, *AverageMotorAmpLabel, *AverageTempLabel, *AverageBatteryAmpLabel;
    
    UIProgressView *batteryPercentageProgressBar;
    
    
    NSNotification *lowBattery;

}

-(id) initWithFrame:(CGRect)frame Data: (VescData*) datax;

-(void) reloadView;
-(void) partialReloadView;

@end
