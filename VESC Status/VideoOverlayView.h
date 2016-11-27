//
//  VideoOverlayView.h
//  VESC Status
//
//  Created by Heya on 11/22/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Structures.h"
#import "VescData.h"
#import "GraphsView.h"
#import "CurrentValuesView.h"
#import "CurrentTripView.h"

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SVProgressHUD.h"
#import "GPUImage.h"

#import "AVFrameDrawer.h"
#import "AVCameraPainter.h"

@interface VideoOverlayView : UIView {
    // Data Structure
    VescData *data;
    
    GraphsView *graphsView;
    CurrentValuesView *currentValuesView;
    CurrentTripView *currentTripView;
    
    GPUImageView *cameraPreview;
    AVCameraPainter *painter;
    AVFrameDrawer *frameDrawer;
    
    NSURL *outUrl;
    
    UIButton *recordButton;
    
    UIImageView *graphsViewImageView;
    UIImage *graphsViewImage;
    
    UIImageView *currentValuesViewImageView;
    UIImage *currentValuesViewImage;
    
    UIImageView *currentTripViewImageView;
    UIImage *currentTripViewImage;
    
    UIView *completOverlayView;
}

@property __weak UIImageView *weakGraphsViewImageView;

-(id) initWithFrame:(CGRect)frame Data: (VescData*) datax GraphsView: (GraphsView*) graphsViewIn ValuesView: (CurrentValuesView*) valuesViewIn TripView: (CurrentTripView*) tripViewIn;

@end
