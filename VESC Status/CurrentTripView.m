//
//  CurrentTripView.m
//  VESC Status
//
//  Created by Heya on 11/25/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import "CurrentTripView.h"

@implementation CurrentTripView

-(id) initWithFrame:(CGRect)frame Data: (VescData*) datax {
    
    self = [super initWithFrame:frame];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    if (self) {
        Structures *strct = [[Structures alloc] init];
        
        data = datax;
        
        // Position and size variables
        int y1 = 20;
        int y2 = 80;
        
        int x1 = 0;
        int x2 = 280;
        
        int width = 250;
        
        int fontSize = 50;
        
        // Create background objects
        
        UILabel *tripTimeLabel = [strct createLabelWtihX:x1 Y:y1 Width:width Height:fontSize Font:@"Avenir" FontSize:fontSize Text:@"Time:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        
        TimeLabel = [strct createLabelWtihX:x2 Y:y1 Width:width Height:fontSize Font:@"Avenir" FontSize:fontSize Text:@"N/A" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        UILabel *tripDistanceLabel = [strct createLabelWtihX:x1 Y:y2 Width:width Height:fontSize Font:@"Avenir" FontSize:fontSize Text:@"Distance:" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentRight];
        
        DistanceLabel = [strct createLabelWtihX:x2 Y:y2 Width:width Height:fontSize Font:@"Avenir" FontSize:fontSize Text:@"N/A" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        
        // Trip View
        [self addSubview:tripTimeLabel];
        [self addSubview:TimeLabel];
        [self addSubview:tripDistanceLabel];
        [self addSubview:DistanceLabel];
    }
    
    return self;
}

-(void) reloadView {
    [TimeLabel setText:[NSString stringWithFormat:@"%@", [data getTime]]];
    [DistanceLabel setText:[NSString stringWithFormat:@"%.02f %@", [data getDistance], [data getDistanceUnit]]];
}

@end

