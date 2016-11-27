//
//  CurrentValuesView.m
//  VESC Status
//
//  Created by Heya on 11/25/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import "CurrentValuesView.h"

@implementation CurrentValuesView

-(id) initWithFrame:(CGRect)frame Data: (VescData*) datax {
    
    self = [super initWithFrame:frame];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    if (self) {
        Structures *strct = [[Structures alloc] init];
        
        data = datax;
        
        // Position and size variables
        int y1 = 0;
        int y2 = 60;
        int y3 = 120;
        int y4 = 180;
        int y5 = 240;
        
        int x1 = 0;
        int x2 = 250;
        int x3 = 410;
        
        int width = 225;
        
        int fontSize = 50;
        
        // Battery Status
        UILabel *currentVoltageLabel = [strct createLabelWtihX:x1 Y:y1 Width:width Height:fontSize Font:@"Avenir" FontSize:fontSize Text:@"Battery:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        
        CurrentVoltageLabel = [strct createLabelWtihX:x2 Y:y1 Width:width Height:fontSize Font:@"Avenir" FontSize:fontSize Text:@"Unkn" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        CurrentBatteryPercentageLabel = [strct createLabelWtihX:x3 Y:y1 Width:width Height:fontSize Font:@"Avenir" FontSize:fontSize Text:@"0%" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        UILabel *currentMotorAmpLabel = [strct createLabelWtihX:x1 Y:y2 Width:width Height:fontSize Font:@"Avenir" FontSize:fontSize Text:@"Motor:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        CurrentMotorAmpLabel = [strct createLabelWtihX:x2 Y:y2 Width:width Height:fontSize Font:@"Avenir" FontSize:fontSize Text:@"Unknown" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        UILabel *currentBatteryAmpLabel = [strct createLabelWtihX:x1 Y:y3 Width:width Height:fontSize Font:@"Avenir" FontSize:fontSize Text:@"Battery:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        CurrentBatteryAmpLabel = [strct createLabelWtihX:x2 Y:y3 Width:width Height:fontSize Font:@"Avenir" FontSize:fontSize Text:@"Unknown" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        UILabel *currentSpeedLabel = [strct createLabelWtihX:x1 Y:y4 Width:width Height:fontSize Font:@"Avenir" FontSize:fontSize Text:@"Speed:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        CurrentSpeedLabel = [strct createLabelWtihX:x2 Y: y4 Width:width Height:fontSize Font:@"Avenir" FontSize:fontSize Text:@"Unknown" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        UILabel *currentTempLabel = [strct createLabelWtihX:x1 Y:y5 Width:width Height:fontSize Font:@"Avenir" FontSize:fontSize Text:@"Temp:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        CurrentTempLabel = [strct createLabelWtihX:x2 Y:y5 Width:width Height:fontSize Font:@"Avenir" FontSize:fontSize Text:@"Unknown" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        
        // Battery Status View
        [self addSubview: currentVoltageLabel];
        [self addSubview:CurrentVoltageLabel];
        [self addSubview:CurrentBatteryPercentageLabel];
        
        // Motor View
        [self addSubview:currentMotorAmpLabel];
        [self addSubview:CurrentMotorAmpLabel];
        
        // Battery View
        [self addSubview:currentBatteryAmpLabel];
        [self addSubview:CurrentBatteryAmpLabel];
        
        
        // Speed View
        [self addSubview:currentSpeedLabel];
        [self addSubview:CurrentSpeedLabel];
        
        // Temp View
        [self addSubview:currentTempLabel];
        [self addSubview:CurrentTempLabel];
    }
    
    return self;
}

-(void) reloadView {
    [CurrentVoltageLabel setText:[NSString stringWithFormat:@"%0.1f v", [data getVoltageNow]]];
    [CurrentBatteryPercentageLabel setText:[NSString stringWithFormat:@"%0.1f%%", [data getCurrentBatteryPecentage]]];
    [CurrentBatteryAmpLabel setText:[NSString stringWithFormat:@"%0.1f amps", [data getBatteryAmpNow]]];
    [CurrentMotorAmpLabel setText:[NSString stringWithFormat:@"%0.1f amps", [data getMotorAmpNow]]];
    [CurrentTempLabel setText:[NSString stringWithFormat:@"%0.1f %@", [data getTempNow], [data getTempUnit]]];
    [CurrentSpeedLabel setText:[NSString stringWithFormat:@"%d %@", [data getSpeed], [data getSpeedUnit]]];
    [CurrentFaultCodeLabel setText:[NSString stringWithFormat:@"%d", [data getFaultCodeNow]]];
}

@end
