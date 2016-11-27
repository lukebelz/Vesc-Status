//
//  AccelerationTimerView.m
//  VESC Status
//
//  Created by Heya on 11/3/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import "AccelerationTimerView.h"

@implementation AccelerationTimerView

- (id) initWithFrame:(CGRect)frame Data: (VescData*) datax {
    self = [super initWithFrame:frame];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerStarted) name:@"accelerationStarted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerFinished) name:@"accelerationFinished" object:nil];
    
    data = datax;
    Structures *strct = [[Structures alloc] init];
    
    startRecordingTime = 0;
    timerRunning = false;
    
    [self addSubview:[strct createLabelWtihX:0 Y:0 Width:self.frame.size.width Height:50 Font:@"Avenir" FontSize:20 Text:@"Acceleration Timer" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
    
    status = [strct createLabelWtihX:0 Y:40 Width:self.frame.size.width Height:60 Font:@"Avenir" FontSize:15 Text:@"Status: Ready and Waiting" TextColor:[UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
    
    speed = [strct createLabelWtihX:0 Y:110 Width:self.frame.size.width Height:60 Font:@"Avenir" FontSize:18 Text:@"Time: N/A" TextColor:[UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
    
    startButton = [strct createButtonWtihX:(self.frame.size.width/2)-40 Y:200 Width:80 Height:50 Font:@"Avenir" FontSize:16 Title:@"Start" TitleColor:[UIColor blackColor] Action:@selector(startTimer)];
    [startButton setBackgroundColor:[UIColor greenColor]];
    
    [self addSubview:status];
    [self addSubview:speed];
    [self addSubview:startButton];
    
    return self;
}

-(void) startTimer {
    NSLog(@"Timer Started");
    timerRunning = true;
    [startButton setAlpha:0];
    [status setText:@"Status: Waiting for acceleration"];
    [self performSelector:@selector(checkSpeed) withObject:nil afterDelay:0.01];
}

-(void) timerStarted {
    startRecordingTime = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    [status setText:@"Status: Acceleration Detected"];
}

-(void) timerFinished {
    timerRunning = false;
    [status setText:@"Status: Acceleration Complete!"];
    long long stopRecordingTime = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    float totalTime = (stopRecordingTime - startRecordingTime);
    NSLog(@"start: %lld", startRecordingTime);
    NSLog(@"stop: %lld", stopRecordingTime);
    NSLog(@"totalTime: %f", totalTime);
    [speed setText:[NSString stringWithFormat:@"Speed: %0.3f seconds", totalTime/1000]];
    [startButton setAlpha:1];
    [status setText:@"Status: Ready and Waiting"];
}

-(void) checkSpeed {
    if([data getSpeed] > 0 && [data getSpeed] < 3) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"accelerationStarted" object:nil];
    }
    if([data getSpeed] > 20) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"accelerationFinished" object:nil];
    }
    if(timerRunning) {
        [self performSelector:@selector(checkSpeed) withObject:nil afterDelay:0.01];
    }
}
@end
