//
//  DataView.m
//  VESC Status
//
//  Created by Heya on 10/25/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import "DataView.h"

@implementation DataView

-(id) initWithFrame:(CGRect)frame Data: (VescData*) datax {
    
    self = [super initWithFrame:frame];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    if (self) {
        Structures *strct = [[Structures alloc] init];
        
        data = datax;
        
        // Position and size variables
        int boxWidth = (self.frame.size.width/2)-40;
        int boxHeight1 = (self.frame.size.height/3)-30;
        int boxHeight2 = (self.frame.size.height/3)-10;
        
        int boxCenter = boxWidth/2;
        int offset = boxCenter+5;
        int batteryStatusOffset = boxCenter+35;
        
        int fontSizeTitle = 12;
        int fontSizeText1 = 14;
        int fontSizeText2 = 14;
        
        int boxX1 = 20;
        int boxX2 = self.frame.size.width-boxWidth-20;
        
        int boxY1 = 15;
        int boxY2 = boxY1+boxHeight1+10;
        int boxY3 = boxY1+boxHeight1+boxHeight2+20;
        
        int y2 = 25;
        int y3 = 42;
        int y4 = 59;
        
        // Create background objects
    
        // Trip View
        UIView *tripDataView = [strct createBoxWtihX:boxX1 Y:boxY1 Width:boxWidth Height:boxHeight1 Text:@"Trip Data" FontSize:fontSizeTitle];
        
        UILabel *tripTimeLabel = [strct createLabelWtihX:0 Y:y2 Width:boxCenter Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Time:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        
        TimeLabel = [strct createLabelWtihX:offset Y:y2 Width:offset Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"N/A" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        UILabel *tripDistanceLabel = [strct createLabelWtihX:0 Y:y3 Width:boxCenter Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Distance:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        
        DistanceLabel = [strct createLabelWtihX:offset Y:y3 Width:offset Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"N/A" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        // Battery Status View
        UIView *batteryStatusView = [strct createBoxWtihX:boxX2 Y:boxY1 Width:boxWidth Height:boxHeight1 Text:@"Battery Status" FontSize:fontSizeTitle];
        
        UILabel *currentVoltageLabel = [strct createLabelWtihX:0 Y:y2 Width:boxCenter Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Voltage:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        
        CurrentVoltageLabel = [strct createLabelWtihX:offset Y:y2 Width:offset Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Unknown" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        batteryPercentageProgressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(batteryStatusOffset-100, y3+6, 100, fontSizeText2)];
        [batteryPercentageProgressBar setProgress:[data getCurrentBatteryPecentage]];
        batteryPercentageProgressBar.transform = CGAffineTransformMakeScale(1.0f, 5.0f);
        CurrentBatteryPercentageLabel = [strct createLabelWtihX:batteryStatusOffset+10 Y:y3 Width:batteryStatusOffset Height:fontSizeText2 Font:@"Avenir" FontSize:fontSizeText2 Text:@"0%" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        // Motor View
        UIView *motorDataView = [strct createBoxWtihX:boxX1 Y:boxY2 Width:boxWidth Height:boxHeight2 Text:@"Motor Data" FontSize:fontSizeTitle];
        
        UILabel *currentMotorAmpLabel = [strct createLabelWtihX:0 Y:y2 Width:boxCenter Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Current:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        CurrentMotorAmpLabel = [strct createLabelWtihX:offset Y:y2 Width:offset Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Unknown" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        UILabel *averageMotorAmpLabel = [strct createLabelWtihX:0 Y:y3 Width:boxCenter Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Avg:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        AverageMotorAmpLabel = [strct createLabelWtihX:offset Y:y3 Width:offset Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"N/A" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        UILabel *maxMotorAmpLabel = [strct createLabelWtihX:0 Y:y4 Width:boxCenter Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Max:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        MaxMotorAmpLabel = [strct createLabelWtihX:offset Y:y4 Width:offset Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"N/A" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        // Battery View
        UIView *batteryDataView = [strct createBoxWtihX:boxX1 Y:boxY3 Width:boxWidth Height:boxHeight2 Text:@"Battery Data" FontSize:fontSizeTitle];
        
        UILabel *currentBatteryAmpLabel = [strct createLabelWtihX:0 Y:y2 Width:boxCenter Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Current:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        CurrentBatteryAmpLabel = [strct createLabelWtihX:offset Y:y2 Width:offset Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Unknown" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        UILabel *averageBatteryAmpLabel = [strct createLabelWtihX:0 Y:y3 Width:boxCenter Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Avg:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        AverageBatteryAmpLabel = [strct createLabelWtihX:offset Y:y3 Width:offset Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"N/A" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        UILabel *maxBatteryAmpLabel = [strct createLabelWtihX:0 Y:y4 Width:boxCenter Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Max:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        MaxBatteryAmpLabel = [strct createLabelWtihX:offset Y:y4 Width:offset Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"N/A" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        // Speed View
        UIView *speedDataView = [strct createBoxWtihX:boxX2 Y:boxY2 Width:boxWidth Height:boxHeight2 Text:@"Speed Data" FontSize:fontSizeTitle];
        
        UILabel *currentSpeedLabel = [strct createLabelWtihX:0 Y:y2 Width:boxCenter Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Current:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        CurrentSpeedLabel = [strct createLabelWtihX:offset Y: y2 Width:offset Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Unknown" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        UILabel *averageSpeedLabel = [strct createLabelWtihX:0 Y:y3 Width:boxCenter Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Avg:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        AvgSpeedLabel = [strct createLabelWtihX:offset Y:y3 Width:offset Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"N/A" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        UILabel *maxSpeedLabel = [strct createLabelWtihX:0 Y:y4 Width:boxCenter Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Max:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        MaxSpeedLabel = [strct createLabelWtihX:offset Y:y4 Width:offset Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"N/A" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        // Temperature View
        UIView *tempDataView = [strct createBoxWtihX:boxX2 Y:boxY3 Width:boxWidth Height:boxHeight2 Text:@"Temp Data" FontSize:fontSizeTitle];
        
        UILabel *currentTempLabel = [strct createLabelWtihX:0 Y:y2 Width:boxCenter Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Current:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        
        CurrentTempLabel = [strct createLabelWtihX:offset Y:y2 Width:offset Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Unknown" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        UILabel *averageTempLabel = [strct createLabelWtihX:0 Y:y3 Width:boxCenter Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Avg:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        
        AverageTempLabel = [strct createLabelWtihX:offset Y:y3 Width:offset Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"N/A" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        UILabel *maxTempLabel = [strct createLabelWtihX:0 Y:y4 Width:boxCenter Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Max:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        
        MaxTempLabel = [strct createLabelWtihX:offset Y:y4 Width:offset Height:fontSizeText1 Font:@"Avenir" FontSize:fontSizeText1 Text:@"N/A" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];

        // Fault Code
        CurrentFaultCodeLabel = [strct createLabelWtihX:0 Y:245 Width:250 Height:50 Font:@"Avenir" FontSize:fontSizeText1 Text:@"Fault Code: Unknown" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        
        // Trip View
        [self addSubview:tripDataView];
        [tripDataView addSubview:tripTimeLabel];
        [tripDataView addSubview:TimeLabel];
        [tripDataView addSubview:tripDistanceLabel];
        [tripDataView addSubview:DistanceLabel];
        
        // Battery Status View
        [self addSubview:batteryStatusView];
        [batteryStatusView addSubview: currentVoltageLabel];
        [batteryStatusView addSubview:CurrentVoltageLabel];
        [batteryStatusView addSubview:batteryPercentageProgressBar];
        [batteryStatusView addSubview:CurrentBatteryPercentageLabel];
        
        // Motor View
        [self addSubview:motorDataView];
        [motorDataView addSubview:currentMotorAmpLabel];
        [motorDataView addSubview:CurrentMotorAmpLabel];
        [motorDataView addSubview:averageMotorAmpLabel];
        [motorDataView addSubview:AverageMotorAmpLabel];
        [motorDataView addSubview:maxMotorAmpLabel];
        [motorDataView addSubview:MaxMotorAmpLabel];
        
        // Battery View
        [self addSubview:batteryDataView];
        [batteryDataView addSubview:currentBatteryAmpLabel];
        [batteryDataView addSubview:CurrentBatteryAmpLabel];
        [batteryDataView addSubview:averageBatteryAmpLabel];
        [batteryDataView addSubview:AverageBatteryAmpLabel];
        [batteryDataView addSubview:maxBatteryAmpLabel];
        [batteryDataView addSubview:MaxBatteryAmpLabel];
        
        // Speed View
        [self addSubview:speedDataView];
        [speedDataView addSubview:maxSpeedLabel];
        [speedDataView addSubview:MaxSpeedLabel];
        [speedDataView addSubview:averageSpeedLabel];
        [speedDataView addSubview:AvgSpeedLabel];
        [speedDataView addSubview:currentSpeedLabel];
        [speedDataView addSubview:CurrentSpeedLabel];
        
        // Temp View
        [self addSubview:tempDataView];
        [tempDataView addSubview:currentTempLabel];
        [tempDataView addSubview:CurrentTempLabel];
        [tempDataView addSubview:averageTempLabel];
        [tempDataView addSubview:AverageTempLabel];
        [tempDataView addSubview:maxTempLabel];
        [tempDataView addSubview:MaxTempLabel];
        
        //[self addSubview:CurrentFaultCodeLabel];
    }
    
    return self;
}

-(void) reloadView {
    [self partialReloadView];
    [TimeLabel setText:[NSString stringWithFormat:@"%@", [data getTime]]];
    [DistanceLabel setText:[NSString stringWithFormat:@"%.02f %@", [data getDistance], [data getDistanceUnit]]];
    [MaxSpeedLabel setText:[NSString stringWithFormat:@"%d %@", [data getMaxSpeed], [data getSpeedUnit]]];
    [AvgSpeedLabel setText:[NSString stringWithFormat:@"%.02f %@", [data getAvgSpeed], [data getSpeedUnit]]];
    [MaxMotorAmpLabel setText:[NSString stringWithFormat:@"%d amps", [data getMaxMotorAmp]]];
    [AverageMotorAmpLabel setText:[NSString stringWithFormat:@"%.02f amps", [data getAvgMotorAmp]]];
    [MaxBatteryAmpLabel setText:[NSString stringWithFormat:@"%d amps", [data getMaxBatteryAmp]]];
    [AverageBatteryAmpLabel setText:[NSString stringWithFormat:@"%.02f amps", [data getAvgBatteryAmp]]];
    [MaxTempLabel setText:[NSString stringWithFormat:@"%d %@", [data getMaxTemp], [data getTempUnit]]];
    [AverageTempLabel setText:[NSString stringWithFormat:@"%0.1f %@", [data getAvgTemp], [data getTempUnit]]];
}

-(void) partialReloadView {
    [CurrentVoltageLabel setText:[NSString stringWithFormat:@"%0.1f volts", [data getVoltageNow]]];
    [batteryPercentageProgressBar setProgress:[data getCurrentBatteryPecentage]/100];
    [CurrentBatteryPercentageLabel setText:[NSString stringWithFormat:@"%0.1f%%", [data getCurrentBatteryPecentage]]];
    [CurrentBatteryAmpLabel setText:[NSString stringWithFormat:@"%0.1f amps", [data getBatteryAmpNow]]];
    [CurrentMotorAmpLabel setText:[NSString stringWithFormat:@"%0.1f amps", [data getMotorAmpNow]]];
    [CurrentTempLabel setText:[NSString stringWithFormat:@"%0.1f %@", [data getTempNow], [data getTempUnit]]];
    [CurrentSpeedLabel setText:[NSString stringWithFormat:@"%d %@", [data getSpeed], [data getSpeedUnit]]];
    [CurrentFaultCodeLabel setText:[NSString stringWithFormat:@"%d", [data getFaultCodeNow]]];
}


@end
