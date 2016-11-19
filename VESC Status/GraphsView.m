//
//  self.m
//  VESC Status
//
//  Created by Heya on 10/25/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import "GraphsView.h"

@implementation GraphsView

-(id) initWithFrame:(CGRect)frame Data: (VescData*) datax {
    
    self = [super initWithFrame:frame];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    if (self) {
        Structures *strct = [[Structures alloc] init];
        
        data = datax;
        
        [self addSubview:[strct createLabelWtihX:(self.frame.size.width/2)-40 Y:0 Width:80 Height:50 Font:@"Avenir" FontSize:20 Text:@"Graphs" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft]];
        
        // Red Square
        [self addSubview:[strct createRectWtihX:20 Y:20 Width:20 Height:20 Color:[UIColor redColor]]];
        [self addSubview:[strct createLabelWtihX:50 Y:20 Width:100 Height:20 Font:@"Avenir" FontSize:12 Text:@"Voltage" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft]];
        
        // Purple Square
        [self addSubview:[strct createRectWtihX:20 Y:50 Width:20 Height:20 Color:[UIColor purpleColor]]];
        [self addSubview:[strct createLabelWtihX:50 Y:50 Width:100 Height:20 Font:@"Avenir" FontSize:12 Text:@"Tempeture" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft]];
        graphsFCLabel = [strct createLabelWtihX:110 Y:50 Width:100 Height:20 Font:@"Avenir" FontSize:12 Text:@"(°F)" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        [self addSubview:graphsFCLabel];
        
        // Orange Square
        [self addSubview:[strct createRectWtihX:self.frame.size.width-120 Y:20 Width:20 Height:20 Color:[UIColor orangeColor]]];
        [self addSubview:[strct createLabelWtihX:self.frame.size.width-90 Y:20 Width:100 Height:20 Font:@"Avenir" FontSize:12 Text:@"Motor (amps)" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft]];
        
        // Green Square
        [self addSubview:[strct createRectWtihX:self.frame.size.width-120 Y:50 Width:20 Height:20 Color:[UIColor greenColor]]];
        [self addSubview:[strct createLabelWtihX:self.frame.size.width-90 Y:50 Width:100 Height:20 Font:@"Avenir" FontSize:12 Text:@"Battery (amps)" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft]];
        
        // Blue Square
        [self addSubview:[strct createRectWtihX:(self.frame.size.width/2)-60 Y:50 Width:20 Height:20 Color:[UIColor blueColor]]];
        [self addSubview:[strct createLabelWtihX:(self.frame.size.width/2)-30 Y:50 Width:100 Height:20 Font:@"Avenir" FontSize:12 Text:@"Speed" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft]];
        graphsMPHKPHLabel = [strct createLabelWtihX:(self.frame.size.width/2)+8 Y:50 Width:100 Height:20 Font:@"Avenir" FontSize:12 Text:@"(mph)" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        [self addSubview:graphsMPHKPHLabel];
        
        // We need a hostview, you can create one in IB (and create an outlet) or just do this:
        CPTGraphHostingView* hostView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, self.frame.size.height-50)];
        [self addSubview: hostView];
        
        // Create a CPTGraph object and add to hostView
        speedGraph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
        hostView.hostedGraph = speedGraph;
        
        // Get the (default) plotspace from the graph so we can set its x/y ranges
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) speedGraph.defaultPlotSpace;
        
        CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithInt:0] length:[NSNumber numberWithInt:80]];
        plotSpace.globalYRange = globalYRange;
        CPTPlotRange *globalxRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithInt:0] length:[NSNumber numberWithInt:60*60*60*51]];
        plotSpace.globalXRange = globalxRange;
        
        // Note that these CPTPlotRange are defined by START and LENGTH (not START and END) !!
        [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0] length:[NSNumber numberWithFloat:80]]];
        [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0] length:[NSNumber numberWithFloat:20.0]]];
        
        // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
        
        voltagePlot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
        voltagePlot.identifier = @"voltage";
        voltagePlot.dataSource = self;
        
        batteryAmpPlot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
        batteryAmpPlot.identifier = @"batteryAmp";
        batteryAmpPlot.dataSource = self;
        
        motorAmpPlot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
        motorAmpPlot.identifier = @"motorAmp";
        motorAmpPlot.dataSource = self;
        
        tempPlot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
        tempPlot.identifier = @"temp";
        tempPlot.dataSource = self;
        
        speedPlot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
        speedPlot.identifier = @"speed";
        speedPlot.dataSource = self;
        
        // Fix the axises labeling and formatting
        [[speedGraph plotAreaFrame] setPaddingLeft:25.0f];
        [[speedGraph plotAreaFrame] setPaddingTop:10.0f];
        [[speedGraph plotAreaFrame] setPaddingBottom:20.0f];
        [[speedGraph plotAreaFrame] setPaddingRight:10.0f];
        [[speedGraph plotAreaFrame] setBorderLineStyle:nil];
        
        NSNumberFormatter *axisFormatter = [[NSNumberFormatter alloc] init];
        [axisFormatter setMinimumIntegerDigits:1];
        [axisFormatter setMaximumFractionDigits:0];
        
        CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
        [textStyle setFontSize:12.0f];
        
        CPTXYAxisSet *axisSet = (CPTXYAxisSet *)[speedGraph axisSet];
        
        CPTXYAxis *xAxis = [axisSet xAxis];
        [xAxis setMajorIntervalLength:[NSNumber numberWithInt: 1]];
        [xAxis setMinorTickLineStyle:nil];
        [xAxis setLabelingPolicy:CPTAxisLabelingPolicyFixedInterval];
        [xAxis setLabelTextStyle:textStyle];
        [xAxis setLabelFormatter:axisFormatter];
        
        CPTXYAxis *yAxis = [axisSet yAxis];
        [yAxis setMajorIntervalLength:[NSNumber numberWithInt: 10]];
        [yAxis setMinorTickLineStyle:nil];
        [yAxis setLabelingPolicy:CPTAxisLabelingPolicyFixedInterval];
        [yAxis setLabelTextStyle:textStyle];
        [yAxis setLabelFormatter:axisFormatter];
        
        CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
        gridLineStyle.lineColor = [CPTColor grayColor];
        gridLineStyle.lineWidth = 0.6f;
        [yAxis setMajorGridLineStyle: gridLineStyle];
        
        // Prevent the axises from disappearing when scrolling
        axisSet.yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
        axisSet.xAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
        
        // Enable user interaction
        [[speedGraph defaultPlotSpace] setAllowsUserInteraction:TRUE];
        
        // Create styles for lines
        [voltagePlot setDataLineStyle:[strct createPlotLineStyleWithWidth:2.0f LineColor:[UIColor redColor]]];
        [batteryAmpPlot setDataLineStyle:[strct createPlotLineStyleWithWidth:2.0f LineColor:[UIColor greenColor]]];
        [motorAmpPlot setDataLineStyle:[strct createPlotLineStyleWithWidth:2.0f LineColor:[UIColor orangeColor]]];
        [tempPlot setDataLineStyle:[strct createPlotLineStyleWithWidth:2.0f LineColor:[UIColor purpleColor]]];
        [speedPlot setDataLineStyle:[strct createPlotLineStyleWithWidth:2.0f LineColor:[UIColor blueColor]]];
        
        // Add plots to graph
        [speedGraph addPlot:voltagePlot toPlotSpace:speedGraph.defaultPlotSpace];
        [speedGraph addPlot:batteryAmpPlot toPlotSpace:speedGraph.defaultPlotSpace];
        [speedGraph addPlot:motorAmpPlot toPlotSpace:speedGraph.defaultPlotSpace];
        [speedGraph addPlot:tempPlot toPlotSpace:speedGraph.defaultPlotSpace];
        [speedGraph addPlot:speedPlot toPlotSpace:speedGraph.defaultPlotSpace];
    }
    return self;
}

-(void) reloadView {
    //Reload Plots
    [voltagePlot reloadData];
    [batteryAmpPlot reloadData];
    [motorAmpPlot reloadData];
    [tempPlot reloadData];
    [speedPlot reloadData];
    
    //Reload Unit Labels
    [graphsFCLabel setText:[NSString stringWithFormat:@"(%@)", [data getTempUnit]]];
    [graphsMPHKPHLabel setText:[NSString stringWithFormat:@"(%@)", [data getSpeedUnit]]];
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
    return [[data getTimeData] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger) index {
    if(fieldEnum == CPTScatterPlotFieldX) {
        return [NSNumber numberWithFloat: [[[data getTimeData] objectAtIndex:index] floatValue]];
    } else {
        if ([[plot identifier] isEqual:@"voltage"]) {
            return [NSNumber numberWithFloat: [[[data getVoltageData] objectAtIndex:index] floatValue]];
        } else if ([[plot identifier] isEqual:@"batteryAmp"]) {
            return [NSNumber numberWithFloat: [[[data getBatteryAmpData] objectAtIndex:index] floatValue]];
        } else if ([[plot identifier] isEqual:@"motorAmp"]) {
            return [NSNumber numberWithFloat: [[[data getMotorAmpData] objectAtIndex:index] floatValue]];
        } else if ([[plot identifier] isEqual:@"temp"]) {
            float temp = [[[data getTempData] objectAtIndex:index] floatValue];
            return [NSNumber numberWithFloat: temp];
        } else {
            return [NSNumber numberWithFloat: [[[data getSpeedData] objectAtIndex:index] floatValue]];
        }
    }
}

@end
