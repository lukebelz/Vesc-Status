//
//  SettingsView.h
//  VESC Status
//
//  Created by Heya on 10/25/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Structures.h"
#import "SVProgressHUD.h"

@interface SettingsView : UIView <UITextFieldDelegate> {
    
    NSString *settingsPath;
    int systemUnit;
    int notifications;
    int selectedBoard;
    int wheelDiameter1, wheelDiameter2, wheelDiameter3, wheelDiameter4;
    int battery1, battery2, battery3, battery4;
    
    
    // Settings view variable
    UITextField *wheelDiameterText1, *wheelDiameterText2, *wheelDiameterText3, *wheelDiameterText4;
    UISegmentedControl *unitSystemSegmentedControl, *notificationSegmentedControl, *selectedBoardSegmentedControl, *battery1SegmentedControl, *battery2SegmentedControl, *battery3SegmentedControl, *battery4SegmentedControl;
}

-(void) saveSettings;
-(void) loadSettings;

-(NSString*) getSpeedUnit;
-(NSString*) getDistanceUnit;
-(NSString*) getTempUnit;

-(int) getWheelDiameter;
-(int) getMaxBatteryVoltage;
-(int) getSelectedBoard;

-(int) getNotifications;

@end
