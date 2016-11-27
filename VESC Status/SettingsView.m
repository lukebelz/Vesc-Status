//
//  SettingsView.m
//  VESC Status
//
//  Created by Heya on 10/25/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import "SettingsView.h"

@implementation SettingsView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    if (self) {
        Structures *strct = [[Structures alloc] init];
        
        settingsPath = [NSString stringWithFormat:@"%@/settings.txt", [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
        
        [self addSubview:[strct createLabelWtihX:0 Y:0 Width:self.frame.size.width Height:50 Font:@"Avenir" FontSize:20 Text:@"Settings" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
        
        // Notification On/Off
        [self addSubview:[strct createLabelWtihX:-40 Y:40 Width:(self.frame.size.width/2)-20 Height:40 Font:@"Avenir" FontSize:12 Text:@"Push Notifications: " TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
        
        notificationSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"On", @"Off", nil]];
        notificationSegmentedControl.frame = CGRectMake(self.frame.size.width/2-140, 50, 100, 25);
        notificationSegmentedControl.selectedSegmentIndex = notifications;
        [self addSubview:notificationSegmentedControl];
        
        // Unit system
        [self addSubview:[strct createLabelWtihX:-40 Y:75 Width:self.frame.size.width/2 Height:40 Font:@"Avenir" FontSize:12 Text:@"Unit System: " TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
        
        unitSystemSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"US", @"Metric", nil]];
        unitSystemSegmentedControl.frame = CGRectMake(self.frame.size.width/2-140, 85, 100, 25);
        unitSystemSegmentedControl.selectedSegmentIndex = systemUnit;
        [self addSubview:unitSystemSegmentedControl];
        
        // Selected board
        [self addSubview:[strct createLabelWtihX:235 Y:50 Width:self.frame.size.width/2 Height:40 Font:@"Avenir" FontSize:12 Text:@"Use Board: " TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
        
        selectedBoardSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"1", @"2", @"3", @"4", nil]];
        selectedBoardSegmentedControl.frame = CGRectMake(self.frame.size.width/2+130, 60, 100, 25);
        selectedBoardSegmentedControl.selectedSegmentIndex = selectedBoard;
        [self addSubview:selectedBoardSegmentedControl];
        
        // Board 1
        [self addSubview:[strct createLabelWtihX:0 Y:110 Width:self.frame.size.width/2 Height:40 Font:@"Avenir" FontSize:16 Text:@"Board 1" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
        
        [self addSubview:[strct createLabelWtihX:-20 Y:128 Width:self.frame.size.width/2 Height:40 Font:@"Avenir" FontSize:12 Text:@"Wheel Diameter: " TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
        
        wheelDiameterText1 = [[UITextField alloc] initWithFrame:CGRectMake(40, 130, self.frame.size.width/2, 40)];
        [wheelDiameterText1 setFont:[UIFont fontWithName:@"Avenir" size:12]];
        [wheelDiameterText1 setText:[NSString stringWithFormat:@"%d", wheelDiameter1]];
        [wheelDiameterText1 setTextAlignment:NSTextAlignmentCenter];
        [wheelDiameterText1 setReturnKeyType:UIReturnKeyDone];
        wheelDiameterText1.delegate = self;
        [self addSubview:wheelDiameterText1];
        
        [self addSubview:[strct createLabelWtihX:65 Y:130 Width:self.frame.size.width/2 Height:40 Font:@"Avenir" FontSize:12 Text:@"mm" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
        
        battery1SegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"6s", @"7s", @"8s", @"9s", @"10s", @"11s", @"12s", nil]];
        battery1SegmentedControl.frame = CGRectMake((self.frame.size.width/4)-100, 160, 200, 25);
        battery1SegmentedControl.selectedSegmentIndex = battery1;
        [self addSubview:battery1SegmentedControl];
        
        // Board 2
        [self addSubview:[strct createLabelWtihX:0 Y:190 Width:self.frame.size.width/2 Height:40 Font:@"Avenir" FontSize:16 Text:@"Board 2" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
        
        [self addSubview:[strct createLabelWtihX:-20 Y:208 Width:self.frame.size.width/2 Height:40 Font:@"Avenir" FontSize:12 Text:@"Wheel Diameter: " TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
        
        wheelDiameterText2 = [[UITextField alloc] initWithFrame:CGRectMake(40, 210, self.frame.size.width/2, 40)];
        [wheelDiameterText2 setFont:[UIFont fontWithName:@"Avenir" size:12]];
        [wheelDiameterText2 setText:[NSString stringWithFormat:@"%d", wheelDiameter2]];
        [wheelDiameterText2 setTextAlignment:NSTextAlignmentCenter];
        [wheelDiameterText2 setReturnKeyType:UIReturnKeyDone];
        wheelDiameterText2.delegate = self;
        [self addSubview:wheelDiameterText2];
        
        [self addSubview:[strct createLabelWtihX:65 Y:210 Width:self.frame.size.width/2 Height:40 Font:@"Avenir" FontSize:12 Text:@"mm" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
        
        battery2SegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"6s", @"7s", @"8s", @"9s", @"10s", @"11s", @"12s", nil]];
        battery2SegmentedControl.frame = CGRectMake((self.frame.size.width/4)-100, 240, 200, 25);
        battery2SegmentedControl.selectedSegmentIndex = battery2;
        [self addSubview:battery2SegmentedControl];
        
        // Board 3
        [self addSubview:[strct createLabelWtihX:290 Y:110 Width:self.frame.size.width/2 Height:40 Font:@"Avenir" FontSize:16 Text:@"Board 3" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
        
        [self addSubview:[strct createLabelWtihX:270 Y:128 Width:self.frame.size.width/2 Height:40 Font:@"Avenir" FontSize:12 Text:@"Wheel Diameter: " TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
        
        wheelDiameterText3 = [[UITextField alloc] initWithFrame:CGRectMake(330, 130, self.frame.size.width/2, 40)];
        [wheelDiameterText3 setFont:[UIFont fontWithName:@"Avenir" size:12]];
        [wheelDiameterText3 setText:[NSString stringWithFormat:@"%d", wheelDiameter3]];
        [wheelDiameterText3 setTextAlignment:NSTextAlignmentCenter];
        [wheelDiameterText3 setReturnKeyType:UIReturnKeyDone];
        wheelDiameterText3.delegate = self;
        [self addSubview:wheelDiameterText3];
        
        [self addSubview:[strct createLabelWtihX:355 Y:130 Width:self.frame.size.width/2 Height:40 Font:@"Avenir" FontSize:12 Text:@"mm" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
        
        battery3SegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"6s", @"7s", @"8s", @"9s", @"10s", @"11s", @"12s", nil]];
        battery3SegmentedControl.frame = CGRectMake((self.frame.size.width/4)+190, 160, 200, 25);
        battery3SegmentedControl.selectedSegmentIndex = battery3;
        [self addSubview:battery3SegmentedControl];
        
        // Board 4
        [self addSubview:[strct createLabelWtihX:290 Y:190 Width:self.frame.size.width/2 Height:40 Font:@"Avenir" FontSize:16 Text:@"Board 4" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
        
        [self addSubview:[strct createLabelWtihX:270 Y:208 Width:self.frame.size.width/2 Height:40 Font:@"Avenir" FontSize:12 Text:@"Wheel Diameter: " TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
        
        wheelDiameterText4 = [[UITextField alloc] initWithFrame:CGRectMake(330, 210, self.frame.size.width/2, 40)];
        [wheelDiameterText4 setFont:[UIFont fontWithName:@"Avenir" size:12]];
        [wheelDiameterText4 setText:[NSString stringWithFormat:@"%d", wheelDiameter4]];
        [wheelDiameterText4 setTextAlignment:NSTextAlignmentCenter];
        [wheelDiameterText4 setReturnKeyType:UIReturnKeyDone];
        wheelDiameterText4.delegate = self;
        [self addSubview:wheelDiameterText4];
        
        [self addSubview:[strct createLabelWtihX:355 Y:210 Width:self.frame.size.width/2 Height:40 Font:@"Avenir" FontSize:12 Text:@"mm" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
        
        battery4SegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"6s", @"7s", @"8s", @"9s", @"10s", @"11s", @"12s", nil]];
        battery4SegmentedControl.frame = CGRectMake((self.frame.size.width/4)+190, 240, 200, 25);
        battery4SegmentedControl.selectedSegmentIndex = battery4;
        [self addSubview:battery4SegmentedControl];
        
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}

-(void) saveSettings {
    systemUnit = (int) unitSystemSegmentedControl.selectedSegmentIndex;
    notifications = (int) notificationSegmentedControl.selectedSegmentIndex+1;
    selectedBoard = (int) selectedBoardSegmentedControl.selectedSegmentIndex+1;
    wheelDiameter1 = [wheelDiameterText1.text intValue];
    wheelDiameter2 = [wheelDiameterText2.text intValue];
    wheelDiameter3 = [wheelDiameterText3.text intValue];
    wheelDiameter4 = [wheelDiameterText4.text intValue];
    battery1 = (int) battery1SegmentedControl.selectedSegmentIndex+6;
    battery2 = (int) battery2SegmentedControl.selectedSegmentIndex+6;
    battery3 = (int) battery3SegmentedControl.selectedSegmentIndex+6;
    battery4 = (int) battery4SegmentedControl.selectedSegmentIndex+6;
    
    [[NSString stringWithFormat:@"%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d", systemUnit, selectedBoard, wheelDiameter1, wheelDiameter2, wheelDiameter3, wheelDiameter4, battery1, battery2, battery3, battery4, notifications] writeToFile:settingsPath atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil]; // Write settings
    
    [SVProgressHUD showSuccessWithStatus:@"Settings Saved"];
}

-(void) loadSettings {
    
    NSArray *settingsArray = [[NSString stringWithContentsOfFile:settingsPath encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
    
    
    unitSystemSegmentedControl.selectedSegmentIndex = systemUnit = [settingsArray[0] intValue];
    selectedBoard = [settingsArray[1] intValue];
    selectedBoardSegmentedControl.selectedSegmentIndex = selectedBoard - 1;
    wheelDiameterText1.text = [NSString stringWithFormat:@"%d", wheelDiameter1 = [settingsArray[2] intValue]];
    wheelDiameterText2.text = [NSString stringWithFormat:@"%d", wheelDiameter2 = [settingsArray[3] intValue]];
    wheelDiameterText3.text = [NSString stringWithFormat:@"%d", wheelDiameter3 = [settingsArray[4] intValue]];
    wheelDiameterText4.text = [NSString stringWithFormat:@"%d", wheelDiameter4 = [settingsArray[5] intValue]];
    battery1 = [settingsArray[6] intValue];
    battery2 = [settingsArray[7] intValue];
    battery3 = [settingsArray[8] intValue];
    battery4 = [settingsArray[9] intValue];
    battery1SegmentedControl.selectedSegmentIndex = battery1 - 6;
    battery2SegmentedControl.selectedSegmentIndex = battery2 - 6;
    battery3SegmentedControl.selectedSegmentIndex = battery3 - 6;
    battery4SegmentedControl.selectedSegmentIndex = battery4 - 6;
    if([settingsArray count] == 11) { // temporary so users can update. remove in the future!
        notifications = [settingsArray[10] intValue];
        notificationSegmentedControl.selectedSegmentIndex = notifications - 1;
    }
}

-(int) getWheelDiameter {
    switch(selectedBoard) {
        case 2:
            return wheelDiameter2;
        case 3:
            return wheelDiameter3;
        case 4:
            return wheelDiameter4;
        default:
            return wheelDiameter1;
    }
}

-(int) getMaxBatteryVoltage {
    switch(selectedBoard) {
        case 2:
            return battery2;
        case 3:
            return battery3;
        case 4:
            return battery4;
        default:
            return battery1;
    }
}

-(int) getSelectedBoard {
    return selectedBoard;
}

-(NSString*) getSpeedUnit {
    if(systemUnit == 0) {
        return @"mph";
    }
    return @"kph";
}

-(NSString*) getDistanceUnit {
    if(systemUnit == 0) {
        return @"miles";
    }
    return @"km";
}

-(NSString*) getTempUnit {
    if(systemUnit == 0) {
        return @"°F";
    }
    return @"°C";
}

-(int) getNotifications {
    return notifications;
}

@end
