//
//  Structures.m
//  VESC Status
//
//  Created by Luke Belz on 10/15/16
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import "Structures.h"

@implementation Structures

-(UILabel *) createLabelWtihX: (CGFloat) x Y: (CGFloat) y Width: (CGFloat) width Height: (CGFloat) height Font: (NSString*) font FontSize: (CGFloat) fontSize Text: (NSString*) text TextColor: (UIColor*) color TextAlignment: (NSTextAlignment) alignment {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [label setFont:[UIFont fontWithName:font size:fontSize]];
    [label setText:text];
    [label setTextColor: color];
    [label setTextAlignment:alignment];
    return label;
}

-(UIButton *) createButtonWtihX: (CGFloat) x Y: (CGFloat) y Width: (CGFloat) width Height: (CGFloat) height Font: (NSString*) font FontSize: (CGFloat) fontSize Title: (NSString*) title TitleColor: (UIColor*) titleColor Action: (SEL) action {
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:font size:fontSize]];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(CPTMutableLineStyle *) createPlotLineStyleWithWidth: (CGFloat) width LineColor: (UIColor*) lineColor {
    CPTMutableLineStyle *PlotLineStyle = [[CPTMutableLineStyle lineStyle] mutableCopy];
    [PlotLineStyle setLineWidth:width];
    [PlotLineStyle setLineColor:[CPTColor colorWithCGColor:[lineColor CGColor]]];
    return PlotLineStyle;
}

-(UIView*) createRectWtihX: (CGFloat) x Y: (CGFloat) y Width: (CGFloat) width Height: (CGFloat) height Color: (UIColor*) color {
    UIView* rect = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [rect setBackgroundColor:color];
    return rect;
}

-(UIView*) createBoxWtihX: (CGFloat) x Y: (CGFloat) y Width: (CGFloat) width Height: (CGFloat) height Text: (NSString*) text FontSize: (int) fontSize {

    UIColor *backgroundColor = [UIColor lightGrayColor];
    UIColor *borderColor = [UIColor grayColor];
    
    UIView *rect = [self createRectWtihX:x Y:y Width:width Height:height Color:backgroundColor];

    [rect.layer setCornerRadius:30.0f];

    // border
    [rect.layer setBorderColor:borderColor.CGColor];
    [rect.layer setBorderWidth:1.5f];
    
    UILabel *header = [self createLabelWtihX:0 Y:5 Width:width Height:fontSize Font:@"Avenir" FontSize:fontSize Text:text TextColor: [UIColor redColor] TextAlignment:NSTextAlignmentCenter];

    [rect addSubview:header];
    // drop shadow
   /* [rect.layer setShadowColor:[UIColor blackColor].CGColor];
    [rect.layer setShadowOpacity:0.8];
    [rect.layer setShadowRadius:3.0];
    [rect.layer setShadowOffset:CGSizeMake(2.0, 2.0)];*/
    return rect;
}

@end
