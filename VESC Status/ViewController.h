//
//  ViewController.h
//  VESC Status
//
//  Created by Luke Belz on 10/15/16
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OneSignal/OneSignal.h>

@import CoreBluetooth;
@import QuartzCore;

#import "VescController.h"
#import "CorePlot-CocoaTouch.h"
#import "Structures.h"
#import "DataView.h"
#import "GraphsView.h"
#import "SettingsView.h"
#import "RideHistoryListView.h"
#import "VescData.h"
#import "AccelerationTimerView.h"
#import "SpeedometerView.h"

#define UART_SERVICE_UUID      @"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
#define RX_CHARACTERISTIC_UUID @"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
#define TX_CHARACTERISTIC_UUID @"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
#define DEVICE_INFO_UUID @"180A"
#define HARDWARE_REVISION_UUID @"2A27"

@class VescData;
@class DataView;
@class GraphsView;
@class SettingsView;
@class RideHistoryListView;
@class AccelerationTimerView;
@class SpeedometerView;

@interface ViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate> {
    
    // Path for Saved Rides
    NSString *dataPath;
    
    // Push Notification Variables
    NSString *userId;
    
    // View variables
    int hieghtFromTop;
    
    // Top bar variables
    UILabel *lblAppStatus;
    UIButton *btnStartStopRecording, *goToLeft, *goToRight, *goToSettings, *goToAcceleration, *goToRideHistoryList, *goToSpeedometer;
    
    // Status variables
    BOOL isRecording, isSettingsOpen, isGraphsOpen, isToolsOpen, isAccelerationOpen, isRideHistoryListOpen, isSpeedometerOpen, isBluetoothReady,sentPercentWarning;
    
    // View variables
    DataView *dataView;
    SettingsView *settingsView;
    GraphsView *graphsView;
    RideHistoryListView *rideHistoryListView;
    AccelerationTimerView *accelerationTimerView;
    SpeedometerView *speedometerView;
    UIView *toolsView;
    
    // Data Structure
    VescData *data;
}

@property (nonatomic, retain) VescController *aVescController;

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral     *UARTPeripheral;

@property (nonatomic, strong) CBCharacteristic *txCharacteristic, *rxCharacteristic;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

