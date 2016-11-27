//
//  Data.m
//  VESC Status
//
//  Created by Heya on 11/1/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import "VescData.h"

@implementation VescData

- (id) initWithDataPath: (NSString*) dataPath_ {
    dataPath = dataPath_;
    
    [self resetData];
    return self;
}

-(void) updateBattPercent {
    currentBatteryPecentage = ((voltageNow - minBatteryVoltage)/batteryVoltageRange)*100;
}

-(void) updateMax {
    // Update maxSpeed
    if(speedNow > maxSpeed) {
        maxSpeed = speedNow;
    }
    
    // Update maxBatteryAmp
    if(batteryAmpNow > maxBatteryAmp) {
        maxBatteryAmp = batteryAmpNow;
    }
    
    // Update maxMotorAmp
    if(motorAmpNow > maxMotorAmp) {
        maxMotorAmp = motorAmpNow;
    }
    
    // Update maxTemp
    if(tempNow > maxTemp) {
        maxTemp = tempNow;
    }
}

-(void) startTimer {
    startRecordingTime = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
}

-(void) resetData {
    maxSpeed = 0;
    tripTime = 0;
    avgSpeed = 0;
    tripDistance = 0;
    avgMotorAmp = 0;
    avgBatteryAmp = 0;
    avgTemp = 0;
    maxBatteryAmp = 0;
    maxMotorAmp = 0;
    maxTemp = 0;
    startRecordingTime = 0;
    timeBefore = 0;
    timeNow = 0;
    voltageNow = 0;
    motorAmpNow = 0;
    batteryAmpNow = 0;
    tempNow = 0;
    speedNow = 0;
    faultCodeNow = 0;
    
    [self resetDataArray];
}

#pragma mark - Convert Functions

- (float) mmToFeet: (int *)mm {
    return 0.00328084*(*mm);
}

- (int) mphToKph: (int)mph {
    return 1.609344*(mph);
}

- (float) FToC: (float *)F {
    return (*F-32)/1.8;
}

- (float) CToF: (float *)C {
    return (*C*1.8)+32;
}

#pragma mark - Calculation Functions

-(float) calculateDistance {
    float deltaX = ((float)(timeNow-timeBefore))/1000/60/60;
    return (deltaX*speedNow);
}

- (int) calculateSpeed:(long *)rpm {
    int curRpm = (int) *rpm/7;
    float diameter = [self mmToFeet: &wheelDiameter];
    return (diameter*3.14*curRpm*60)/5280;
}

- (float) calculateAvgSpeed {
    float total = 0;
    for(NSNumber *speed in speedDataY) {
        total +=  [speed floatValue];
    }
    return total/[speedDataY count];
}

- (float) calculateAvgMotorAmp {
    float total = 0;
    for(NSNumber *amps in motorAmpDataY) {
        total +=  [amps floatValue];
    }
    return total/[speedDataY count];
}

- (float) calculateAvgBatteryAmp {
    float total = 0;
    for(NSNumber *amps in batteryAmpDataY) {
        total +=  [amps floatValue];
    }
    return total/[speedDataY count];
}

- (float) calculateAvgTemp {
    float total = 0;
    for(NSNumber *temps in tempDataY) {
        total +=  [temps floatValue];
    }
    return total/[speedDataY count];
}

-(float) calculateTime {
    float timeInMS = timeNow - startRecordingTime;
    return timeInMS/1000;
}

#pragma mark - Format Functions

-(NSString *) formatTime: (int) time {
    int seconds = time % 60;
    int minutes = (time/60) % 60;
    int hours = time / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

-(NSString*) formatArrayForSaving: (NSMutableArray*) array {
    NSString* data = @"";
    for(NSNumber *obj in array) {
        data = [NSString stringWithFormat:@"%@|%@", data, obj];
    }
    return data;
}

#pragma mark - Data Array Functions

-(void) addData {
    [timeData addObject:[NSNumber numberWithFloat: tripTime]];
    [voltageDataY addObject:[NSNumber numberWithFloat: voltageNow]];
    [batteryAmpDataY addObject:[NSNumber numberWithFloat: batteryAmpNow]];
    [motorAmpDataY addObject:[NSNumber numberWithFloat: motorAmpNow]];
    [tempDataY addObject:[NSNumber numberWithFloat: tempNow]];
    [speedDataY addObject:[NSNumber numberWithInt: speedNow]];
}

-(void) resetDataArray {
    timeData = [NSMutableArray array];
    voltageDataY = [NSMutableArray array];
    batteryAmpDataY = [NSMutableArray array];
    motorAmpDataY = [NSMutableArray array];
    tempDataY = [NSMutableArray array];
    speedDataY = [NSMutableArray array];
}

#pragma mark - Setter Functions

-(void) setWheelDiameter: (int) wheelDiameterIn {
    wheelDiameter = wheelDiameterIn;
}

-(void) setMaxBatteryVoltage: (int) maxBatteryVoltageIn {
    maxBatteryVoltage = maxBatteryVoltageIn*4.2;
    minBatteryVoltage = maxBatteryVoltageIn*3.2;
    batteryVoltageRange = maxBatteryVoltage - minBatteryVoltage;
}

-(void) setTempUnit: (NSString*) tempUnitIn {
    tempUnit = tempUnitIn;
}

-(void) setSpeedUnit: (NSString*) speedUnitIn {
    speedUnit = speedUnitIn;
}

-(void) setDistanceUnit: (NSString*) distanceUnitIn {
    distanceUnit = distanceUnitIn;
}

-(void) setSelectedBoard: (int) board {
    selectedBoard = board;
}

-(void) updateDataWithRPM: (long) rpm Voltage: (float) voltage BatteryAmp: (float) batteryAmp MotorAmp: (float) motorAmp Temp: (float) temp FaultCode: (int) faultCode {
    
    // Update Now Variables
    voltageNow = voltage;
    batteryAmpNow = batteryAmp;
    motorAmpNow = motorAmp;
    tempNow = [self CToF: &temp];
    faultCodeNow = faultCode;
    speedNow = [self calculateSpeed: &rpm];
    timeNow = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    
    // Convert if in Metric
    if([speedUnit isEqualToString:@"kph"]) {
        tempNow = [self FToC: &temp];
        speedNow = [self mphToKph: speedNow];
    }
    
    // Update calculated variables
    avgSpeed = [self calculateAvgSpeed];
    avgMotorAmp = [self calculateAvgMotorAmp];
    avgBatteryAmp = [self calculateAvgBatteryAmp];
    avgTemp = [self calculateAvgTemp];
    
    tripTime = [self calculateTime];
    tripDistance += [self calculateDistance];
    
    timeBefore = timeNow;
    
    // Add new data to arrays
    [self addData];
    
    // Update max variables
    [self updateMax];
    
    // Update voltage percentage
    [self updateBattPercent];
}


-(void) backgroundUpdateDataWithRPM: (long) rpm Voltage: (float) voltage BatteryAmp: (float) batteryAmp MotorAmp: (float) motorAmp Temp: (float) temp FaultCode: (int) faultCode {
    
    // Update Now Variables
    voltageNow = voltage;
    batteryAmpNow = batteryAmp;
    motorAmpNow = motorAmp;
    tempNow = [self CToF: &temp];
    faultCodeNow = faultCode;
    speedNow = [self calculateSpeed: &rpm];
    
    // Convert if in Metric
    if([speedUnit isEqualToString:@"kph"]) {
        tempNow = [self FToC: &temp];
        speedNow = [self mphToKph: speedNow];
    }
    
    // Update voltage percentage
    [self updateBattPercent];
}

- (void) saveData {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDateFormatter *timeFormatter=[[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    NSString *time = [timeFormatter stringFromDate:[NSDate date]];
    //NSMutableArray *timeData, *voltageDataY, *batteryAmpDataY, *motorAmpDataY, *tempDataY, *speedDataY;
    NSString *timeData_ = [self formatArrayForSaving: timeData];
    NSString *voltageData_ = [self formatArrayForSaving: voltageDataY];
    NSString *batteryAmpData_ = [self formatArrayForSaving: batteryAmpDataY];
    NSString *motorAmpData_ = [self formatArrayForSaving: motorAmpDataY];
    NSString *tempData_ = [self formatArrayForSaving: tempDataY];
    NSString *speedData_ = [self formatArrayForSaving: speedDataY];
    
    [[NSString stringWithFormat:@"%d\n%@\n%f\n%f\n%f\n%d\n%f\n%f\n%f\n%f\n%f\n%f\n%@\n%@\n%@\n%@\n%@\n%@", selectedBoard, date, tripTime, tripDistance, avgSpeed, maxSpeed, maxBatteryAmp, avgBatteryAmp, maxMotorAmp, avgMotorAmp, maxTemp, avgTemp, timeData_, voltageData_, batteryAmpData_, motorAmpData_, tempData_, speedData_] writeToFile:[NSString stringWithFormat:@"%@Board %d on %@ at %@. For: %@ Dis: %0.2f %@.txt", dataPath, selectedBoard, date, time, [self formatTime:tripTime], tripDistance, distanceUnit] atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil]; // Write settings
}

-(void) loadData: (NSString*) pathToData {
    NSArray *dataArray = [[NSString stringWithContentsOfFile:pathToData encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
    
    tripTime = [dataArray[2] floatValue];
    tripDistance = [dataArray[3] floatValue];
    avgSpeed = [dataArray[4] floatValue];
    maxSpeed = [dataArray[5] intValue];
    maxBatteryAmp = [dataArray[6] intValue];
    avgBatteryAmp = [dataArray[7] floatValue];
    maxMotorAmp = [dataArray[8] intValue];
    avgMotorAmp = [dataArray[9] floatValue];
    maxTemp = [dataArray[10] intValue];
    avgTemp = [dataArray[11] floatValue];
    timeData = [NSMutableArray arrayWithArray: [dataArray[12] componentsSeparatedByString:@"|"]];
    [timeData removeObjectAtIndex:0];
    voltageDataY = [NSMutableArray arrayWithArray: [dataArray[13] componentsSeparatedByString:@"|"]];
    [voltageDataY removeObjectAtIndex:0];
    batteryAmpDataY = [NSMutableArray arrayWithArray: [dataArray[14] componentsSeparatedByString:@"|"]];
    [batteryAmpDataY removeObjectAtIndex:0];
    motorAmpDataY = [NSMutableArray arrayWithArray: [dataArray[15] componentsSeparatedByString:@"|"]];
    [motorAmpDataY removeObjectAtIndex:0];
    tempDataY = [NSMutableArray arrayWithArray: [dataArray[16] componentsSeparatedByString:@"|"]];
    [tempDataY removeObjectAtIndex:0];
    speedDataY = [NSMutableArray arrayWithArray: [dataArray[17] componentsSeparatedByString:@"|"]];
    [speedDataY removeObjectAtIndex:0];
}

#pragma mark - Getter Functions

// Get Data Arrays
-(NSMutableArray*) getTimeData {
    return timeData;
}

-(NSMutableArray*) getVoltageData {
    return voltageDataY;
}

-(NSMutableArray*) getBatteryAmpData {
    return batteryAmpDataY;
}

-(NSMutableArray*) getMotorAmpData {
    return motorAmpDataY;
}

-(NSMutableArray*) getTempData {
    return tempDataY;
}

-(NSMutableArray*) getSpeedData {
    return speedDataY;
}

// Get Units
-(NSString*) getTempUnit {
    return tempUnit;
}

-(NSString*) getDistanceUnit {
    return distanceUnit;
}

-(NSString*) getSpeedUnit {
    return speedUnit;
}

// Get Raw Data

-(double) getTripTime {
    return tripTime;
}

// Get Live Data

-(float) getVoltageNow {
    return voltageNow;
}

-(float) getCurrentBatteryPecentage {
    return currentBatteryPecentage;
}

-(float) getMotorAmpNow {
    return motorAmpNow;
}

-(float) getBatteryAmpNow {
    return batteryAmpNow;
}

-(float) getTempNow {
    return tempNow;
}

-(int) getFaultCodeNow {
    return faultCodeNow;
}

-(int) getSpeed {
    return speedNow;
}

-(NSString*) getTime {
    return [self formatTime: tripTime];
}

-(float) getDistance {
    return tripDistance;
}

-(int) getMaxSpeed {
    return maxSpeed;
}

-(float) getAvgSpeed {
    return avgSpeed;
}

-(int) getMaxMotorAmp {
    return maxMotorAmp;
}

-(float) getAvgMotorAmp {
    return avgMotorAmp;
}

-(int) getMaxBatteryAmp {
    return maxBatteryAmp;
}

-(float) getAvgBatteryAmp {
    return avgBatteryAmp;
}

-(int) getMaxTemp {
    return maxTemp;
}

-(float) getAvgTemp {
    return avgTemp;
}

@end
