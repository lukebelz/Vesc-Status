//
//  Data.h
//  VESC Status
//
//  Created by Heya on 11/1/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VescData : NSObject {

    NSString *dataPath;
    
    int selectedBoard;
    
    // Data Arrays
    NSMutableArray *timeData, *voltageDataY, *batteryAmpDataY, *motorAmpDataY, *tempDataY, *speedDataY;

    int maxSpeed;
    double tripTime;
    float avgSpeed, avgMotorAmp, avgBatteryAmp, avgTemp, tripDistance, maxBatteryAmp, maxMotorAmp, maxTemp;
    
    // Setting variables
    int wheelDiameter;
    float maxBatteryVoltage, minBatteryVoltage, batteryVoltageRange, currentBatteryPecentage;
    NSString *tempUnit, *distanceUnit, *speedUnit;
    
    // Time variable
    long long startRecordingTime;
    long long timeBefore, timeNow;
    
    float voltageNow, motorAmpNow, batteryAmpNow, tempNow;
    int speedNow, faultCodeNow;
    
}

- (id) initWithDataPath: (NSString*) dataPath_;

-(void) startTimer;
-(void) resetData;

-(void) setWheelDiameter: (int) wheelDiameterIn;
-(void) setMaxBatteryVoltage: (int) maxBatteryVoltageIn;
-(void) setTempUnit: (NSString*) tempUnitIn;
-(void) setSpeedUnit: (NSString*) speedUnitIn;
-(void) setDistanceUnit: (NSString*) distanceUnitIn;
-(void) setSelectedBoard: (int) board;
-(void) updateDataWithRPM: (long) rpm Voltage: (float) voltage BatteryAmp: (float) batteryAmp MotorAmp: (float) motorAmp Temp: (float) temp FaultCode: (int) faultCode;
-(void) backgroundUpdateDataWithRPM: (long) rpm Voltage: (float) voltage BatteryAmp: (float) batteryAmp MotorAmp: (float) motorAmp Temp: (float) temp FaultCode: (int) faultCode;
-(void) saveData;
-(void) loadData: (NSString*) pathToData;
-(NSMutableArray*) getTimeData;
-(NSMutableArray*) getVoltageData;
-(NSMutableArray*) getBatteryAmpData;
-(NSMutableArray*) getMotorAmpData;
-(NSMutableArray*) getTempData;
-(NSMutableArray*) getSpeedData;

-(NSString*) getTempUnit;
-(NSString*) getDistanceUnit;
-(NSString*) getSpeedUnit;

-(double) getTripTime;

-(float) getVoltageNow;
-(float) getCurrentBatteryPecentage;
-(float) getMotorAmpNow;
-(float) getBatteryAmpNow;
-(float) getTempNow;
-(int) getFaultCodeNow;

-(int) getSpeed;
-(NSString*) getTime;
-(float) getDistance;
-(int) getMaxSpeed;
-(float) getAvgSpeed;
-(int) getMaxMotorAmp;
-(float) getAvgMotorAmp;
-(int) getMaxBatteryAmp;
-(float) getAvgBatteryAmp;
-(int) getMaxTemp;
-(float) getAvgTemp;
@end
