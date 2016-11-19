//
//  GraphsView.h
//  VESC Status
//
//  Created by Heya on 10/25/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Structures.h"
#import "VescData.h"

@interface GraphsView : UIView <CPTPlotDataSource> {
    
    // Data Structure
    VescData *data;
    
    // Graphs view variables
    CPTGraph *speedGraph;
    CPTScatterPlot *speedPlot, *voltagePlot, *batteryAmpPlot, *motorAmpPlot, *tempPlot;
    UILabel *graphsMPHKPHLabel, *graphsFCLabel;
    
}

-(id) initWithFrame:(CGRect)frame Data: (VescData*) datax;

-(void) reloadView;

@end
