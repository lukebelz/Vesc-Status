//
//  Structures.h
//  VESC Status
//
//  Created by Luke Belz on 10/15/16
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface Structures : NSObject

-(UILabel *) createLabelWtihX: (CGFloat) x Y: (CGFloat) y Width: (CGFloat) width Height: (CGFloat) height Font: (NSString*) font FontSize: (CGFloat) fontSize Text: (NSString*) text TextColor: (UIColor*) color TextAlignment: (NSTextAlignment) alignment;

-(UIButton *) createButtonWtihX: (CGFloat) x Y: (CGFloat) y Width: (CGFloat) width Height: (CGFloat) height Font: (NSString*) font FontSize: (CGFloat) fontSize Title: (NSString*) title TitleColor: (UIColor*) titleColor Action: (SEL) action;

-(CPTMutableLineStyle *) createPlotLineStyleWithWidth: (CGFloat) width LineColor: (UIColor*) lineColor;

-(UIView*) createRectWtihX: (CGFloat) x Y: (CGFloat) y Width: (CGFloat) width Height: (CGFloat) height Color: (UIColor*) color;

-(UIView*) createBoxWtihX: (CGFloat) x Y: (CGFloat) y Width: (CGFloat) width Height: (CGFloat) height Text: (NSString*) text FontSize: (int) fontSize;

@end
