//
//  SpeedometerView.m
//  VESC Status
//
//  Created by Heya on 11/18/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import "SpeedometerView.h"

@implementation SpeedometerView

-(id) initWithFrame:(CGRect)frame Data: (VescData*) datax {
    
    self = [super initWithFrame:frame];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    if (self) {
        Structures *strct = [[Structures alloc] init];
        
        data = datax;
        
        [self addSubview:[strct createLabelWtihX:0 Y:0 Width:self.frame.size.width Height:50 Font:@"Avenir" FontSize:20 Text:@"Speedometer" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
        
        speedLabel = [strct createLabelWtihX:(self.frame.size.width/2)-200 Y:60 Width:250 Height:200 Font:@"Avenir" FontSize:220 Text:[NSString stringWithFormat:@"%d", [data getSpeed]] TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        
        unitLabel = [strct createLabelWtihX:(self.frame.size.width/2)+100 Y:80 Width:200 Height:200 Font:@"Avenir" FontSize:50 Text:[NSString stringWithFormat:@"%@", [data getSpeedUnit]] TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        [self addSubview:speedLabel];
        [self addSubview:unitLabel];
        
    }
    return self;
}

-(void) setSpeed {
    [speedLabel setText:[NSString stringWithFormat:@"%d", [data getSpeed]]];
    [unitLabel setText:[NSString stringWithFormat:@"%@", [data getSpeedUnit]]];
}

@end
