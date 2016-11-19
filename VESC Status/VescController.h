//
//  VescController.h
//  BeanVESC
//
//  Created by Ben Harraway on 13/09/2015.
//  Copyright (c) 2015 Gourmet Pixel Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

// VESC defines
typedef enum {
    COMM_FW_VERSION = 0,
    COMM_JUMP_TO_BOOTLOADER,
    COMM_ERASE_NEW_APP,
    COMM_WRITE_NEW_APP_DATA,
    COMM_GET_VALUES,
    COMM_SET_DUTY,
    COMM_SET_CURRENT,
    COMM_SET_CURRENT_BRAKE,
    COMM_SET_RPM,
    COMM_SET_POS,
    COMM_SET_DETECT,
    COMM_SET_SERVO_POS,
    COMM_SET_MCCONF,
    COMM_GET_MCCONF,
    COMM_SET_APPCONF,
    COMM_GET_APPCONF,
    COMM_SAMPLE_PRINT,
    COMM_TERMINAL_CMD,
    COMM_PRINT,
    COMM_ROTOR_POSITION,
    COMM_EXPERIMENT_SAMPLE,
    COMM_DETECT_MOTOR_PARAM,
    COMM_REBOOT,
    COMM_ALIVE,
    COMM_GET_DECODED_PPM,
    COMM_GET_DECODED_ADC,
    COMM_GET_DECODED_CHUK,
    COMM_FORWARD_CAN
} COMM_PACKET_ID;

typedef enum {
    FAULT_CODE_NONE = 0,
    FAULT_CODE_OVER_VOLTAGE,
    FAULT_CODE_UNDER_VOLTAGE,
    FAULT_CODE_DRV8302,
    FAULT_CODE_ABS_OVER_CURRENT,
    FAULT_CODE_OVER_TEMP_FET,
    FAULT_CODE_OVER_TEMP_MOTOR,
    FAULT_CODE_NO_DATA
} mc_fault_code;

typedef struct {
    float v_in;
    float temp_mos1;
    float temp_mos2;
    float temp_mos3;
    float temp_mos4;
    float temp_mos5;
    float temp_mos6;
    float temp_pcb;
    float current_motor;
    float current_in;
    float rpm;
    float duty_now;
    float amp_hours;
    float amp_hours_charged;
    float watt_hours;
    float watt_hours_charged;
    int tachometer;
    int tachometer_abs;
    mc_fault_code fault_code;
} mc_values;

struct bldcMeasure {
    float temp_mos1;
    float temp_mos2;
    float temp_mos3;
    float temp_mos4;
    float temp_mos5;
    float temp_mos6;
    float temp_pcb;
    float avgMotorCurrent;
    float avgInputCurrent;
    float dutyCycleNow;
    long rpm;
    float inpVoltage;
    float ampHours;
    float ampHoursCharged;
    float wattHours;
    float wattHoursCharged;
    long tachometer;
    long tachometerAbs;
    mc_fault_code fault_code;
} ; //bldc_values

#define measureNames    @[@"Temp  Mos 1", @"Avg Motor Current", @"Avg Input Current", @"Duty Cycle Now", @"RPM", @"Input Voltage", @"Amp Hours", @"Amp Hours Charged", @"Watt Hours", @"Watt Hours Charged", @"Tachometer", @"Tachometer ABS"]

@interface VescController : NSObject {
    
}

//- (void) SetCurrent:(double)val;
//- (void) SetRpm:(double)val;
//- (void) SetDuty:(double)val;
//- (void) SetBrake:(double)val;
//- (void) Release;
//- (void) FullBrake;
//- (void) GetValues;

- (NSData *) dataForCommand:(int)command val:(double)val;

- (NSData *)dataForGetValues:(int)command val:(double)val;

- (int) process_incoming_bytes:(NSData *)incomingData;
- (struct bldcMeasure) ProcessReadPacket;
- (void) resetPacket;

@end
