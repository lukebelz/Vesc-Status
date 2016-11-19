//
//  VescController.m
//  BeanVESC
//
//  Created by Ben Harraway on 13/09/2015.
//  Copyright (c) 2015 Gourmet Pixel Ltd. All rights reserved.
//

#import "VescController.h"

@implementation VescController

// CRC Table
const uint16_t crc16_tab[] = { 0x0000, 0x1021, 0x2042, 0x3063, 0x4084,
    0x50a5, 0x60c6, 0x70e7, 0x8108, 0x9129, 0xa14a, 0xb16b, 0xc18c, 0xd1ad,
    0xe1ce, 0xf1ef, 0x1231, 0x0210, 0x3273, 0x2252, 0x52b5, 0x4294, 0x72f7,
    0x62d6, 0x9339, 0x8318, 0xb37b, 0xa35a, 0xd3bd, 0xc39c, 0xf3ff, 0xe3de,
    0x2462, 0x3443, 0x0420, 0x1401, 0x64e6, 0x74c7, 0x44a4, 0x5485, 0xa56a,
    0xb54b, 0x8528, 0x9509, 0xe5ee, 0xf5cf, 0xc5ac, 0xd58d, 0x3653, 0x2672,
    0x1611, 0x0630, 0x76d7, 0x66f6, 0x5695, 0x46b4, 0xb75b, 0xa77a, 0x9719,
    0x8738, 0xf7df, 0xe7fe, 0xd79d, 0xc7bc, 0x48c4, 0x58e5, 0x6886, 0x78a7,
    0x0840, 0x1861, 0x2802, 0x3823, 0xc9cc, 0xd9ed, 0xe98e, 0xf9af, 0x8948,
    0x9969, 0xa90a, 0xb92b, 0x5af5, 0x4ad4, 0x7ab7, 0x6a96, 0x1a71, 0x0a50,
    0x3a33, 0x2a12, 0xdbfd, 0xcbdc, 0xfbbf, 0xeb9e, 0x9b79, 0x8b58, 0xbb3b,
    0xab1a, 0x6ca6, 0x7c87, 0x4ce4, 0x5cc5, 0x2c22, 0x3c03, 0x0c60, 0x1c41,
    0xedae, 0xfd8f, 0xcdec, 0xddcd, 0xad2a, 0xbd0b, 0x8d68, 0x9d49, 0x7e97,
    0x6eb6, 0x5ed5, 0x4ef4, 0x3e13, 0x2e32, 0x1e51, 0x0e70, 0xff9f, 0xefbe,
    0xdfdd, 0xcffc, 0xbf1b, 0xaf3a, 0x9f59, 0x8f78, 0x9188, 0x81a9, 0xb1ca,
    0xa1eb, 0xd10c, 0xc12d, 0xf14e, 0xe16f, 0x1080, 0x00a1, 0x30c2, 0x20e3,
    0x5004, 0x4025, 0x7046, 0x6067, 0x83b9, 0x9398, 0xa3fb, 0xb3da, 0xc33d,
    0xd31c, 0xe37f, 0xf35e, 0x02b1, 0x1290, 0x22f3, 0x32d2, 0x4235, 0x5214,
    0x6277, 0x7256, 0xb5ea, 0xa5cb, 0x95a8, 0x8589, 0xf56e, 0xe54f, 0xd52c,
    0xc50d, 0x34e2, 0x24c3, 0x14a0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405,
    0xa7db, 0xb7fa, 0x8799, 0x97b8, 0xe75f, 0xf77e, 0xc71d, 0xd73c, 0x26d3,
    0x36f2, 0x0691, 0x16b0, 0x6657, 0x7676, 0x4615, 0x5634, 0xd94c, 0xc96d,
    0xf90e, 0xe92f, 0x99c8, 0x89e9, 0xb98a, 0xa9ab, 0x5844, 0x4865, 0x7806,
    0x6827, 0x18c0, 0x08e1, 0x3882, 0x28a3, 0xcb7d, 0xdb5c, 0xeb3f, 0xfb1e,
    0x8bf9, 0x9bd8, 0xabbb, 0xbb9a, 0x4a75, 0x5a54, 0x6a37, 0x7a16, 0x0af1,
    0x1ad0, 0x2ab3, 0x3a92, 0xfd2e, 0xed0f, 0xdd6c, 0xcd4d, 0xbdaa, 0xad8b,
    0x9de8, 0x8dc9, 0x7c26, 0x6c07, 0x5c64, 0x4c45, 0x3ca2, 0x2c83, 0x1ce0,
    0x0cc1, 0xef1f, 0xff3e, 0xcf5d, 0xdf7c, 0xaf9b, 0xbfba, 0x8fd9, 0x9ff8,
    0x6e17, 0x7e36, 0x4e55, 0x5e74, 0x2e93, 0x3eb2, 0x0ed1, 0x1ef0 };

//- (void) SetCurrent:(double)val  {SendCommand(COMM_SET_CURRENT, val);}
//- (void) SetRpm:(double)val	   {SendCommand(COMM_SET_RPM, val);}
//- (void) SetDuty:(double)val     {SendCommand(COMM_SET_DUTY, val);}
//- (void) SetBrake:(double)val    {SendCommand(COMM_SET_CURRENT_BRAKE, val);}
//- (void) Release               {[self SetCurrent:0];}
//- (void) FullBrake             {[self SetDuty:0];}
//- (void) GetValues             {SendCommand(COMM_GET_VALUES, -1);}


int16_t buffer_get_int16(const uint8_t *buffer, int32_t *index) {
    int16_t res =	((uint16_t) buffer[*index]) << 8 |
    ((uint16_t) buffer[*index + 1]);
    *index += 2;
    return res;
}

int32_t buffer_get_int32(const uint8_t *buffer, int32_t *index) {
    int32_t res =	((uint32_t) buffer[*index]) << 24 |
    ((uint32_t) buffer[*index + 1]) << 16 |
    ((uint32_t) buffer[*index + 2]) << 8 |
    ((uint32_t) buffer[*index + 3]);
    *index += 4;
    return res;
}

float buffer_get_float16(const uint8_t *buffer, float scale, int32_t *index) {
    return (float)buffer_get_int16(buffer, index) / scale;
}

float buffer_get_float32(const uint8_t *buffer, float scale, int32_t *index) {
    return (float)buffer_get_int32(buffer, index) / scale;
}

uint16_t crc16(const uint8_t *buf, uint32_t len)
{
    uint32_t i;
    uint16_t cksum = 0;
    for (i = 0; i < len; i++)
    {
        cksum = crc16_tab[(((cksum >> 8) ^ *buf++) & 0xFF)] ^ (cksum << 8);
    }
    return cksum;
}

void buffer_append_uint16(uint8_t* buffer, uint16_t number, int32_t *index)
{
    buffer[(*index)++] = number >> 8;
    buffer[(*index)++] = number;
}

void buffer_append_int32(uint8_t* buffer, int32_t number, int32_t *index)
{
    buffer[(*index)++] = number >> 24;
    buffer[(*index)++] = number >> 16;
    buffer[(*index)++] = number >> 8;
    buffer[(*index)++] = number;
}

double roundDouble(double x)
{
    return x < 0.0 ? ceil(x - 0.5) : floor(x + 0.5);
}

void buffer_append_double32(uint8_t* buffer, double number, double scale, int32_t *index)
{
    buffer_append_int32(buffer, (int32_t)(roundDouble(number * scale)), index);
}

void WriteArray(uint8_t* arr, int32_t num)
{
//    for(int32_t i=0;i<num;i++) outputSerial.write(arr[i]);
}


- (NSData *) dataForCommand:(int)command val:(double)val {
    unsigned char buff[10];
    int32_t ind = 0;
    
    buff[ind++] = 2;
    buff[ind++] = 5;
    buff[ind++] = command;
    
    if(command == COMM_SET_RPM) {
        buffer_append_int32(buff, (int32_t)val, &ind);
        
    } else {
        double scale;
        if(command == COMM_SET_DUTY) scale = 100000.0;
        else scale = 1000;
        
        buffer_append_double32(buff, val, scale, &ind);
    }
    
    uint16_t crc = crc16(buff + 2, 5);
    buff[ind++] = crc >> 8;
    buff[ind++] = crc;
    
    buff[ind++] = 3;
    
    NSData* data = [NSData dataWithBytes:(const void *)buff length:sizeof(buff)];
    return data;
}

- (NSData *)dataForGetValues:(int)command val:(double)val {
    unsigned char buff[6];
    int32_t ind = 0;
    
    buff[ind++] = 2;
    buff[ind++] = 1; // This is the length of the payload. Just one in this case.
    buff[ind++] = COMM_GET_VALUES;
    
    uint16_t crc = crc16(buff + 2,  ind - 2);
    
    buff[ind++] = crc >> 8;
    buff[ind++] = crc;
    
    buff[ind++] = 3;
    
    // 214 @84 3
    NSData* data = [NSData dataWithBytes:(const void *)buff length:sizeof(buff)];
    return data;    
}


// Packet Processing....
// Mostly from Vedder and RollingGecko - thanks guys!!!
// www.vedder.se
// https://github.com/RollingGecko/VescUartControl
// Full credit to them
// Horrible code and mistakes added by me!

int counter = 0;
int endMessage = 256;
bool messageRead = false;
uint8_t messageReceived[256];
int lenPayload = 0;
uint8_t payload[256];

- (int) process_incoming_bytes:(NSData *)incomingData {
    const uint8_t *bytes = incomingData.bytes;
    for (int i = 0; i < incomingData.length; i++) {
        messageReceived[counter++] = bytes[i];
        
        if (counter == 2) {//case if state of 'counter' with last read 1
            
            switch (messageReceived[0])
            {
                case 2:
                    endMessage = messageReceived[1] + 5; //Payload size + 2 for sice + 3 for SRC and End.
                    lenPayload = messageReceived[1];
                    break;
                case 3:
                    //ToDo: Add Message Handling > 255 (starting with 3)
                    break;
                default:
                    break;
            }
            
        }
        
        if (counter >= sizeof(messageReceived))
        {
            break;
        }
        
        if (counter == endMessage && messageReceived[endMessage - 1] == 3) {//+1: Because of counter++ state of 'counter' with last read = "endMessage"
            messageReceived[endMessage] = 0;
            messageRead = true;
            
            break; //Exit if end of message is reached, even if there is still more data in buffer.
        }
    }
    
    bool unpacked = false;
    if (messageRead) {
        unpacked = UnpackPayload(messageReceived, endMessage, messageReceived[1]);
    }
    
    if (unpacked) {
        return lenPayload; //Message was read
        
    } else {
        return 0; //No Message Read
    }
}

bool UnpackPayload(uint8_t* message, int lenMes, int lenPay) {
    uint16_t crcMessage = 0;
    uint16_t crcPayload = 0;
    //Rebuild src:
    crcMessage = message[lenMes - 3] << 8;
    crcMessage &= 0xFF00;
    crcMessage += message[lenMes - 2];
    
    memcpy(payload, &message[2], message[1]);
    
    crcPayload = crc16(payload, message[1]);
    
    if (crcPayload == crcMessage) {
        return true;
    } else {
        return false;
    }
}

- (struct bldcMeasure) ProcessReadPacket {
    COMM_PACKET_ID packetId;
    int32_t ind = 0;
    struct bldcMeasure values;
    
    packetId = (COMM_PACKET_ID)payload[0];

    uint8_t payload2[256];
    memcpy(payload2, payload + 1, sizeof(payload)-1);
    
    switch (packetId)
    {
        case COMM_GET_VALUES:
            ind = 0;
            
            values.temp_mos1 = buffer_get_float16(payload2, 10.0, &ind);
            values.temp_mos2 = buffer_get_float16(payload2, 10.0, &ind);
            values.temp_mos3 = buffer_get_float16(payload2, 10.0, &ind);
            values.temp_mos4 = buffer_get_float16(payload2, 10.0, &ind);
            values.temp_mos5 = buffer_get_float16(payload2, 10.0, &ind);
            values.temp_mos6 = buffer_get_float16(payload2, 10.0, &ind);
            values.temp_pcb = buffer_get_float16(payload2, 10.0, &ind);

            values.avgMotorCurrent = buffer_get_float32(payload2, 100.0, &ind);
            values.avgInputCurrent = buffer_get_float32(payload2, 100.0, &ind);
            values.dutyCycleNow = buffer_get_float16(payload2, 1000.0, &ind);
            values.rpm = buffer_get_int32(payload2, &ind);
            values.inpVoltage = buffer_get_float16(payload2, 10.0, &ind);
            values.ampHours = buffer_get_float32(payload2, 10000.0, &ind);
            values.ampHoursCharged = buffer_get_float32(payload2, 10000.0, &ind);
            values.wattHours = buffer_get_float32(payload2, 10000.0, &ind);
            values.wattHoursCharged = buffer_get_float32(payload2, 10000.0, &ind);
            values.tachometer = buffer_get_int32(payload2, &ind);
            values.tachometerAbs = buffer_get_int32(payload2, &ind);
            values.fault_code = (mc_fault_code)payload2[ind++];
            
            [self resetPacket];
            return values;
            break;
            
        default:
            [self resetPacket];
            values.fault_code = FAULT_CODE_NO_DATA;
            return values;
            break;
    }
    
}

- (void) resetPacket {
    messageRead = false;
    counter = 0;
    endMessage = 256;
    
    for (int i=0;i<255;++i) {
        messageReceived[i] = 0;
        payload[i] = 0;
    }
}


@end
