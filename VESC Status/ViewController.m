//
//  ViewController.m
//  VESC Status
//
//  Created by Luke Belz on 10/15/16
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
    
@end

@implementation ViewController

#define SEND_SERIAL_DATA_INTERVAL 0.25 // Seconds between sending commands

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hieghtFromTop = 25;
    
    dataPath = [NSString stringWithFormat:@"%@/data/", [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    
    // Check if data directory exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        // Directory does not exist so create it
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // Initial class objects
    Structures *strct = [[Structures alloc] init];
    data = [[VescData alloc] initWithDataPath:dataPath];
    
    // Setup required objects
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newVESCvalues:) name:@"newVESCvalues" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPastData:) name:@"loadPastData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startStopRecordingFromVideo:) name:@"startStopRecordingFromVideo" object:nil];
    
    // Create status label
    lblAppStatus = [strct createLabelWtihX:100 Y:5 Width:self.view.frame.size.width-200 Height:25 Font:@"Avenir" FontSize:12 Text:@"Starting Bluetooth" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:lblAppStatus];
    
    // Create start/stop button
    btnStartStopRecording = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-145, 5, 40, 30)];
    [btnStartStopRecording setBackgroundColor:[UIColor greenColor]];
    [btnStartStopRecording addTarget:self action:@selector(startStopRecording) forControlEvents:UIControlEventTouchUpInside];
    btnStartStopRecording.alpha = 0;
    btnStartStopRecording.layer.cornerRadius = 15;
    //[self.view addSubview:btnStartStopRecording];
    
    // Data Panel
    dataView = [[DataView alloc] initWithFrame:CGRectMake(0, hieghtFromTop, self.view.frame.size.width, self.view.frame.size.height-hieghtFromTop) Data: data];
    [self.view addSubview:dataView];
    
    // Create panel buttons
    goToLeft = [strct createButtonWtihX:0 Y:0 Width:110 Height:34 Font:@"Avenir" FontSize:12 Title:@"Open Tools" TitleColor:[UIColor blackColor] Action:@selector(openCloseTools)];
    goToRight = [strct createButtonWtihX:self.view.frame.size.width-100 Y:0 Width:100 Height:34 Font:@"Avenir" FontSize:12 Title:@"Open Graphs" TitleColor:[UIColor blackColor] Action:@selector(openCloseGraphs)];
    
    // Add panel buttons to the view
    [self.view addSubview:goToLeft];
    [self.view addSubview:goToRight];
    
    // Graphs Panel
    graphsView = [[GraphsView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-hieghtFromTop) Data: data];
    [self.view addSubview:graphsView];
    
    // Tools Panel
    toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-hieghtFromTop)];
    
    [toolsView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    [self.view addSubview:toolsView];
    
    [toolsView addSubview:[strct createLabelWtihX:(self.view.frame.size.width/2)-40 Y:0 Width:80 Height:50 Font:@"Avenir" FontSize:20 Text:@"Tools" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft]];
    
    goToSettings = [strct createButtonWtihX:(self.view.frame.size.width/2)-60 Y:45 Width:100 Height:34 Font:@"Avenir" FontSize:12 Title:@"Open Settings" TitleColor:[UIColor blackColor] Action:@selector(openCloseSettings)];
    
    goToRideHistoryList = [strct createButtonWtihX:(self.view.frame.size.width/2)-80 Y:80 Width:140 Height:34 Font:@"Avenir" FontSize:12 Title:@"Open Ride History" TitleColor:[UIColor blackColor] Action:@selector(openCloseRideHistoryList)];
    
    goToAcceleration = [strct createButtonWtihX:(self.view.frame.size.width/2)-80 Y:115 Width:140 Height:34 Font:@"Avenir" FontSize:12 Title:@"Open Acceleration Timer" TitleColor:[UIColor blackColor] Action:@selector(openCloseAcceleration)];
    goToAcceleration.alpha = 0;
    
    goToSpeedometer = [strct createButtonWtihX:(self.view.frame.size.width/2)-80 Y:150 Width:140 Height:34 Font:@"Avenir" FontSize:12 Title:@"Open Speedometer" TitleColor:[UIColor blackColor] Action:@selector(openCloseSpeedometer)];
    goToSpeedometer.alpha = 0;
    
    goToVideoOverlay = [strct createButtonWtihX:(self.view.frame.size.width/2)-80 Y:185 Width:140 Height:34 Font:@"Avenir" FontSize:12 Title:@"Open Video Overlay" TitleColor:[UIColor blackColor] Action:@selector(openCloseVideoOverlay)];
    goToVideoOverlay.alpha = 0;
    
    // Add panel buttons to the view
    [toolsView addSubview:goToSettings];
    [toolsView addSubview:goToRideHistoryList];
    [toolsView addSubview:goToAcceleration];
    [toolsView addSubview:goToSpeedometer];
    [toolsView addSubview:goToVideoOverlay];

    // Settings Panel
    settingsView = [[SettingsView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-hieghtFromTop)];
    [self.view addSubview:settingsView];
    
    // Load settings
    [settingsView loadSettings];
    
    // Ride History List Panel
    rideHistoryListView = [[RideHistoryListView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-hieghtFromTop) DataPath:dataPath];
    [self.view addSubview:rideHistoryListView];

    // Acceleration Panel
    accelerationTimerView = [[AccelerationTimerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-hieghtFromTop) Data: data];
    [accelerationTimerView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    [self.view addSubview:accelerationTimerView];

    // Speedometer Panel
    speedometerView = [[SpeedometerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-hieghtFromTop) Data: data];
    [speedometerView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    [self.view addSubview:speedometerView];
    
    NSLog(@"%f | %f", self.view.frame.size.height, self.view.frame.size.width);
    
    // Current Values View
    currentValuesView = [[CurrentValuesView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 568, 320-hieghtFromTop) Data: data];
    [currentValuesView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    [self.view addSubview:currentValuesView];
    
    // Current Trip View
    currentTripView = [[CurrentTripView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 568, 320-hieghtFromTop) Data: data];
    [currentTripView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    [self.view addSubview:currentTripView];
    
    // Video Overlay Panel
    videoOverlayView = nil;
    
    // Update current settings in dataView
    [self updateSettingsInViews];
    
    [self.view addSubview:btnStartStopRecording];
    
    // Set bool variables
    isRecording = NO;
    isSettingsOpen = NO;
    isGraphsOpen = NO;
    isToolsOpen = NO;
    isAccelerationOpen = NO;
    isRideHistoryListOpen = NO;
    isSpeedometerOpen = NO;
    isBluetoothReady = NO;
    isVideoOverlayOpen = NO;
    
    sentPercentWarning = NO;
    
    // Init a VESC Controller
    _aVescController = [[VescController alloc] init];
    
    [_aVescController dataForGetValues:0 val:0];
    
    // Init Bluetooth
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    if([settingsView getNotifications] == 1) {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [OneSignal initWithLaunchOptions:appDelegate.launchOptionsSaved appId:@"4a313ea2-8e54-4f52-ba60-2fa81bd30482"];
        
        [OneSignal IdsAvailable:^(NSString* userId_, NSString* pushToken) {
            userId = userId_;
        }];
    }
}

-(void) alertBatteryStatus {
    float curBattPercent = [data getCurrentBatteryPecentage];
    if(curBattPercent > 99  && !sentPercentWarning) {
        if([settingsView getNotifications] == 1) {
            [OneSignal postNotification:@{@"contents" : @{@"en": @"Battery is 100% Full!"}, @"include_player_ids": @[userId]}];
        }
        sentPercentWarning = YES;
    }
    
    if(curBattPercent > 48 && [data getCurrentBatteryPecentage] < 50 && !sentPercentWarning) {
        if([settingsView getNotifications] == 1) {
            [OneSignal postNotification:@{@"contents" : @{@"en": @"50% of Battery Left..."}, @"include_player_ids": @[userId]}];
        }
        sentPercentWarning = YES;
    }
    
    if(curBattPercent > 18 && [data getCurrentBatteryPecentage] < 20 && !sentPercentWarning) {
        if([settingsView getNotifications] == 1) {
            [OneSignal postNotification:@{@"contents" : @{@"en": @"20% of Battery Left..."}, @"include_player_ids": @[userId]}];
        }
        sentPercentWarning = YES;
    }
    
    if((curBattPercent < 98  && curBattPercent > 52) || (curBattPercent < 22  && curBattPercent > 46) || curBattPercent < 16) {
        sentPercentWarning = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setReady {
    btnStartStopRecording.alpha = 1;
    goToAcceleration.alpha = 1;
    goToSpeedometer.alpha = 1;
    goToVideoOverlay.alpha = 1;
    
    isBluetoothReady = YES;
}

-(void) setNotReady {
    btnStartStopRecording.alpha = 0;
    goToAcceleration.alpha = 0;
    goToSpeedometer.alpha = 0;
    goToVideoOverlay.alpha = 0;
    
    isBluetoothReady = NO;
    
    if(isRecording) {
        [self stopRecording];
    }
}

- (void) UART_Ready {
    [lblAppStatus setText:@"Bluetooth OK and UART Ready"];
    [UIView animateWithDuration:0.2 animations:^(void){
        [self setReady];
    }];
    
    [self performSelector:@selector(doGetValues) withObject:nil afterDelay:0.3];
}

- (void) startStopRecording {
    if (!isRecording) {
        [self startRecording];
        [graphsView resetGraph];
    } else {
        [self stopRecording];
        [graphsView stopGraphTimer];
    }

}

-(void) startStopRecordingFromVideo:(NSNotification *)nObject {
    [self startStopRecording];
}

- (void) startRecording {
    [btnStartStopRecording setBackgroundColor:[UIColor redColor]];
    
    isRecording = YES;
    goToLeft.alpha = 0;
    
    _dataArray = [[NSMutableArray alloc] init];
    
    [data resetData];
    
    [data startTimer];
}

- (void) stopRecording {
    [btnStartStopRecording setBackgroundColor:[UIColor greenColor]];
    
    isRecording = NO;
    goToLeft.alpha = 1;
    
    [data saveData];
    
    [rideHistoryListView updateRideHistoryList];
    
    [SVProgressHUD showSuccessWithStatus:@"Ride Saved Successfully"];
    
}

-(void) loadPanel: (UIView*) panel {
    [UIView animateWithDuration:0.2 animations:^(void){
        panel.frame = CGRectMake(panel.frame.origin.x, hieghtFromTop, panel.frame.size.width, panel.frame.size.height);
    }];
}

-(void) closePanel: (UIView*) panel {
    [UIView animateWithDuration:0.2 animations:^(void){
        panel.frame = CGRectMake(panel.frame.origin.x, self.view.frame.size.height, panel.frame.size.width, panel.frame.size.height);
    }];
    
    if(panel == settingsView) {
        [settingsView saveSettings];
        [self updateSettingsInViews];
    }
}

- (void) openCloseGraphs {
    if (!isGraphsOpen) {
        [self loadPanel:graphsView];
        isGraphsOpen = YES;
        goToLeft.alpha=0;
        [goToRight setTitle:@"Close Graphs" forState:UIControlStateNormal];
    } else {
        [self closePanel:graphsView];
        isGraphsOpen = NO;
        if(!isRecording)
            goToLeft.alpha=1;
        [goToRight setTitle:@"Open Graphs" forState:UIControlStateNormal];
    }
}

- (void) openCloseTools {
    if (!isToolsOpen) {
        [self loadPanel:toolsView];
        isToolsOpen = YES;
        
        btnStartStopRecording.alpha = 0;
        
        goToRight.alpha = 0;
        [goToLeft setTitle:@"Close Tools" forState:UIControlStateNormal];
    } else {
        [self closePanel:toolsView];
        isToolsOpen = NO;
        
        if(isBluetoothReady) {
            btnStartStopRecording.alpha = 1;
        }
        
        goToRight.alpha=1;
        [goToLeft setTitle:@"Open Tools" forState:UIControlStateNormal];
    }
    
}

- (void) openCloseSettings {
    if (!isSettingsOpen) {
        [self loadPanel:settingsView];
        isSettingsOpen = YES;
        [goToLeft addTarget:self action:@selector(openCloseSettings) forControlEvents:UIControlEventTouchUpInside];
        [goToLeft setTitle:@"Close Settings" forState:UIControlStateNormal];
    } else {
        [self closePanel:settingsView];
        isSettingsOpen = NO;
        [goToLeft removeTarget:self action:@selector(openCloseSettings) forControlEvents:UIControlEventTouchUpInside];
        [self openCloseTools];
    }
}

- (void) openCloseRideHistoryList {
    if (!isRideHistoryListOpen) {
        [self loadPanel:rideHistoryListView];
        isRideHistoryListOpen = YES;
        [goToLeft addTarget:self action:@selector(openCloseRideHistoryList) forControlEvents:UIControlEventTouchUpInside];
        [goToLeft setTitle:@"Close History" forState:UIControlStateNormal];
    } else {
        [self closePanel:rideHistoryListView];
        isRideHistoryListOpen = NO;
        [goToLeft removeTarget:self action:@selector(openCloseRideHistoryList) forControlEvents:UIControlEventTouchUpInside];
        [self openCloseTools];
    }
}

- (void) openCloseAcceleration {
    if (!isAccelerationOpen) {
        [self loadPanel:accelerationTimerView];
        isAccelerationOpen = YES;
        [goToLeft addTarget:self action:@selector(openCloseAcceleration) forControlEvents:UIControlEventTouchUpInside];
        [goToLeft setTitle:@"Close Timer" forState:UIControlStateNormal];
    } else {
        [self closePanel:accelerationTimerView];
        isAccelerationOpen = NO;
        [goToLeft removeTarget:self action:@selector(openCloseAcceleration) forControlEvents:UIControlEventTouchUpInside];
        [self openCloseTools];
    }
}

- (void) openCloseSpeedometer {
    if (!isSpeedometerOpen) {
        [self loadPanel:speedometerView];
        isSpeedometerOpen = YES;
        [goToLeft addTarget:self action:@selector(openCloseSpeedometer) forControlEvents:UIControlEventTouchUpInside];
        [goToLeft setTitle:@"Close Speedomter" forState:UIControlStateNormal];
    } else {
        [self closePanel:speedometerView];
        isSpeedometerOpen = NO;
        [goToLeft removeTarget:self action:@selector(openCloseSpeedometer) forControlEvents:UIControlEventTouchUpInside];
        [self openCloseTools];
    }
}

- (void) openCloseVideoOverlay {
    if (!isVideoOverlayOpen) {
        
        // add view
        videoOverlayView = [[VideoOverlayView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-hieghtFromTop) Data: data GraphsView: graphsView ValuesView: currentValuesView TripView: currentTripView];
        [videoOverlayView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
        [self.view addSubview:videoOverlayView];
        //
        
        [self loadPanel:videoOverlayView];
        isVideoOverlayOpen = YES;
        [goToLeft addTarget:self action:@selector(openCloseVideoOverlay) forControlEvents:UIControlEventTouchUpInside];
        [goToLeft setTitle:@"Close Video" forState:UIControlStateNormal];
    } else {
        [self closePanel:videoOverlayView];
        
        // remove veiw
        [videoOverlayView removeFromSuperview];
        videoOverlayView = nil;
        //
        
        isVideoOverlayOpen = NO;
        [goToLeft removeTarget:self action:@selector(openCloseVideoOverlay) forControlEvents:UIControlEventTouchUpInside];
        [self openCloseTools];
    }
}

- (void) doGetValues {
    NSData *dataToSend = [_aVescController dataForGetValues:COMM_GET_VALUES val:0];
    if (dataToSend && _txCharacteristic) [_UARTPeripheral writeValue:dataToSend forCharacteristic:_txCharacteristic type:CBCharacteristicWriteWithResponse];
    
    [self performSelector:@selector(getValuesTimeOut) withObject:nil afterDelay:3.0];
}

-(void) loadPastData:(NSNotification *)nObject {
    [self openCloseRideHistoryList];
    
    [data loadData:nObject.object];
    
    [graphsView reloadView];
    [dataView reloadView];
}

- (void) newVESCvalues:(NSNotification *)nObject {
    NSLog(@"Got Values!");
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getValuesTimeOut) object:nil];
    
    NSData *myData = [nObject object];
    
    struct bldcMeasure newData;
    [myData getBytes:&newData length:sizeof(newData)];
    
    [lblAppStatus setText:@"VESC Communication OK"];
    
    if(isRecording){
        // Get VESC variables
        [data updateDataWithRPM:newData.rpm Voltage: newData.inpVoltage BatteryAmp:newData.avgInputCurrent MotorAmp:newData.avgMotorCurrent Temp:newData.temp_mos1 FaultCode:1];
        
        [dataView reloadView];
        [graphsView reloadView];
        
        [currentValuesView reloadView];
        [currentTripView reloadView];
    } else {
        [data backgroundUpdateDataWithRPM:newData.rpm Voltage: newData.inpVoltage BatteryAmp:newData.avgInputCurrent MotorAmp:newData.avgMotorCurrent Temp:newData.temp_mos1 FaultCode:1];
        
        [dataView partialReloadView];
        
        [speedometerView setSpeed];
    }
    
    [self alertBatteryStatus];
}

#pragma mark - Current Time Calculations

- (NSString *) getFaultCode:(unsigned int *)faultCode {
    if(*faultCode == FAULT_CODE_NO_DATA) {
        return [NSString stringWithFormat:@"%u", *faultCode];
    }
    return @"None";
}

- (float) calculateMosfetTempAvg:(float *)mosfetTemps {
    return (mosfetTemps[0]+mosfetTemps[1]+mosfetTemps[2]+mosfetTemps[3]+mosfetTemps[4]+mosfetTemps[5])/2;
}

-(void) updateSettingsInViews {
    [data setWheelDiameter: [settingsView getWheelDiameter]];
    [data setMaxBatteryVoltage: [settingsView getMaxBatteryVoltage]];
    [data setTempUnit: [settingsView getTempUnit]];
    [data setSpeedUnit: [settingsView getSpeedUnit]];
    [data setDistanceUnit: [settingsView getDistanceUnit]];
    [data setSelectedBoard: [settingsView getSelectedBoard]];
}


#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

- (void) appendStringToLogFile:(NSString *)logLine {
    
    logLine = [logLine stringByAppendingString:@"\n"];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentTXTPath    = [documentsDirectory stringByAppendingPathComponent:@"VESC_LOG.TXT"]; // I know capitalized name sucks but tell arduino ... this is to make it compatible with other data loggers / video overlayers made previously
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSLog(@"path: %@", documentTXTPath);
    if(![fileManager fileExistsAtPath:documentTXTPath]) {
        
//        NSError *error;
//        &error;
//        NSLog error ...
        [logLine writeToFile:documentTXTPath atomically:YES encoding:NSASCIIStringEncoding error:0];
    } else {
        NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
        [myHandle seekToEndOfFile];
        [myHandle writeData:[logLine dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

- (void) getValuesTimeOut {
    [self setNotReady];
    
    if (_UARTPeripheral == nil) {
        [lblAppStatus setText:@"VESC Communication timeout. Dropped connection."];
    } else {
        [lblAppStatus setText:@"VESC Communication timeout.  Retrying..."];
        [self performSelector:@selector(doGetValues) withObject:nil afterDelay:3.0];
    }
}

#pragma mark - CBCentralManagerDelegate

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [lblAppStatus setText:@"Bluetooth: Peripheral connected"];
    
    _txCharacteristic = nil;
    _rxCharacteristic = nil;
    
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [lblAppStatus setText:@"Bluetooth: Peripheral disconnected"];
    
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    _txCharacteristic = nil;
    _rxCharacteristic = nil;
    _UARTPeripheral = nil;
    [_aVescController resetPacket];
    
    // Start scanning for it again
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if ([localName length] > 0) {
        [lblAppStatus setText:@"Bluetooth: Peripheral discovered"];
        NSLog(@"Found the UART preipheral: %@", localName);
        _UARTPeripheral = peripheral;
        
        peripheral.delegate = self;
        [_centralManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];

        [_centralManager stopScan];
    }
}

// method called whenever the device state changes.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    // Determine the state of the peripheral
    
    if ([central state] == CBCentralManagerStatePoweredOff) {
        [lblAppStatus setText:@"CoreBluetooth BLE hardware is powered off"];
    }
    else if ([central state] == CBCentralManagerStatePoweredOn) {
        [lblAppStatus setText:@"CoreBluetooth BLE hardware is powered on and ready"];
        
        NSArray *services = @[[CBUUID UUIDWithString:UART_SERVICE_UUID]];  //, [CBUUID UUIDWithString:DEVICE_INFO_UUID]];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber  numberWithBool:YES], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
        
        [_centralManager scanForPeripheralsWithServices:services options:options];
        [lblAppStatus setText:@"Scanning...."];
        
        [self setNotReady];
    }
    else if ([central state] == CBCentralManagerStateUnauthorized) {
        [lblAppStatus setText:@"CoreBluetooth BLE state is unauthorized"];
    }
    else if ([central state] == CBCentralManagerStateUnknown) {
        [lblAppStatus setText:@"CoreBluetooth BLE state is unknown"];
    }
    else if ([central state] == CBCentralManagerStateUnsupported) {
        [lblAppStatus setText:@"CoreBluetooth BLE hardware is unsupported on this platform"];
    }
}


#pragma mark - CBPeripheralDelegate

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [lblAppStatus setText:@"Discovered UART Services"];
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if ([service.UUID isEqual:[CBUUID UUIDWithString:UART_SERVICE_UUID]])  {
        NSLog(@"Discovered UART service characteristics");
        [lblAppStatus setText:@"Discovered UART Characteristics"];
        
        for (CBCharacteristic *aChar in service.characteristics) {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:TX_CHARACTERISTIC_UUID]]) {
                NSLog(@"Found TX service");
                _txCharacteristic = aChar;
                NSLog(@"Tx char %@", aChar);
                
                if (_rxCharacteristic != nil) [self UART_Ready];
                
            } else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:RX_CHARACTERISTIC_UUID]]) {
                NSLog(@"Found RX service");
                _rxCharacteristic = aChar;
                [_UARTPeripheral setNotifyValue:YES forCharacteristic:_rxCharacteristic];
                
                if (_txCharacteristic != nil) [self UART_Ready];
            }
        }
        
        if (_txCharacteristic == nil && _rxCharacteristic == nil) {
            [lblAppStatus setText:@"RX and TX not discovered. Closing connection."];
            [_centralManager cancelPeripheralConnection:_UARTPeripheral];
        }
        
    } else if ([service.UUID isEqual:[CBUUID UUIDWithString:DEVICE_INFO_UUID]]) {
        NSLog(@"Discovered Device Info");
        
        for (CBCharacteristic *aChar in service.characteristics)
        {
            NSLog(@"Found device service: %@", aChar.UUID);
            [_UARTPeripheral readValueForCharacteristic:aChar];
        }
    }
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error receiving notification for characteristic %@: %@", characteristic, error);
        return;
    }
    
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TX_CHARACTERISTIC_UUID]]) { // 1
        // TX
        //NSLog(@"TX update value");
        
    } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:RX_CHARACTERISTIC_UUID]]) {
        // RX
        //NSLog(@"RX update value: %@", characteristic.value);
        
        if ([_aVescController process_incoming_bytes:characteristic.value] > 0) {
            struct bldcMeasure values = [_aVescController ProcessReadPacket];
            
            NSData *myData = [NSData dataWithBytes:&values length:sizeof(values)];
            
            // Add this VESC data, with Date as an array
            [_dataArray addObject:@[[NSDate date], myData]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newVESCvalues" object:myData];
            
            if (values.fault_code == FAULT_CODE_NO_DATA) {
                NSLog(@"Error");
            } else {
                //NSLog(@"RPM: %ld", values.rpm);
            }
            //if (isRecording)
            [self doGetValues];
        }
    } else {
        // Got some data, not sure what to do with it (probably the device service/information)
        NSString *inStr = @"";
        const uint8_t *bytes = characteristic.value.bytes;
        for (int i = 0; i < characteristic.value.length; i++) {
            inStr = [inStr stringByAppendingFormat:@"0x%02x, ", bytes[i]];
        }
        NSLog(@"inStr: %@", inStr);
    
        
        NSLog(@"antani: %@", characteristic.UUID);
        //NSLog(@"antani: %@", characteristic.value);
        
        NSString *inStr2 = @"";
        for (int i = 0; i < characteristic.value.length; i++) {
            inStr2 = [inStr2 stringByAppendingFormat:@"%c", bytes[i]];
        }
        NSLog(@"antani val: %@", inStr2);
        
    }
}

@end
