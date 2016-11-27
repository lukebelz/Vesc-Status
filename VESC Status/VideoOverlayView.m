//
//  VideoOverlayView.m
//  VESC Status
//
//  Created by Heya on 11/22/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import "VideoOverlayView.h"

@implementation VideoOverlayView

static CGFloat targetWidth = 1920;
static CGFloat targetHeight = 1080;

static NSUInteger videoDurationInSec = 60*60;

-(id) initWithFrame:(CGRect)frame Data: (VescData*) datax GraphsView: (GraphsView*) graphsViewIn ValuesView: (CurrentValuesView*) valuesViewIn TripView: (CurrentTripView*) tripViewIn {
    
    self = [super initWithFrame:frame];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    if (self) {
        Structures *strct = [[Structures alloc] init];
        
        data = datax;
        
        graphsView = graphsViewIn;
        currentValuesView = valuesViewIn;
        currentTripView = tripViewIn;
        
        [self addSubview:[strct createLabelWtihX:(self.frame.size.width/2)-60 Y:0 Width:150 Height:50 Font:@"Avenir" FontSize:20 Text:@"Video Overlay" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentLeft]];
        
        // Graphs Image View
        graphsViewImage = [self flipImage:[self imageWithView: graphsView]];
        graphsViewImageView = [[UIImageView alloc] initWithImage:graphsViewImage];
        graphsViewImageView.frame = CGRectMake(0, (targetHeight-graphsViewImage.size.height), graphsViewImage.size.width, graphsViewImage.size.height);
        
        // Current Values Image View
        currentValuesViewImage = [self flipImage:[self imageWithView: graphsView]];
        currentValuesViewImageView = [[UIImageView alloc] initWithImage:graphsViewImage];
        currentValuesViewImageView.frame = CGRectMake((targetWidth-graphsViewImage.size.width), (targetHeight-graphsViewImage.size.height), graphsViewImage.size.width, graphsViewImage.size.height);
        
        // Current Trip View
        currentTripViewImage = [self flipImage:[self imageWithView: graphsView]];
        currentTripViewImageView = [[UIImageView alloc] initWithImage:graphsViewImage];
        currentTripViewImageView.frame = CGRectMake((graphsViewImage.size.width/2)+400, -140, graphsViewImage.size.width, graphsViewImage.size.height);
        
        // Complete Overlay View
        completOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, targetWidth, targetHeight)];
        [completOverlayView addSubview:graphsViewImageView];
        [completOverlayView addSubview:currentValuesViewImageView];
        [completOverlayView addSubview:currentTripViewImageView];
        
        [NSTimer scheduledTimerWithTimeInterval:0.25
                                         target:self
                                       selector:@selector(updateImages:)
                                       userInfo:nil
                                        repeats:YES];
        
    }
    
    // Create camera preview
    [self createCameraPreview];
    
    // Add record button
    [self addRecordButton];
    
    // Init capture session and pass it to preview
    [self initCameraCapture];
    
   // [recordButton addTarget:self action:@selector(recordButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationLandscapeLeft:
            painter.camera.outputImageOrientation = UIInterfaceOrientationMaskLandscape;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            painter.camera.outputImageOrientation = UIInterfaceOrientationMaskPortraitUpsideDown;
            break;
            
        default:
            break;
    };
}

- (UIImage *)flipImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(image.size);
    CGContextDrawImage(UIGraphicsGetCurrentContext(),CGRectMake(0.,0., image.size.width, image.size.height),image.CGImage);
    UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
}

-(void) updateImages: (NSNotification *)nObject {
    graphsViewImage = [self flipImage:[self imageWithView: graphsView]];
    [graphsViewImageView setImage:graphsViewImage];
    
    currentValuesViewImage = [self flipImage:[self imageWithView: currentValuesView]];
    [currentValuesViewImageView setImage:currentValuesViewImage];
    
    currentTripViewImage = [self flipImage:[self imageWithView: currentTripView]];
    [currentTripViewImageView setImage:currentTripViewImage];
}

#pragma mark - Record button

-(void) startStopRecording {
    if(painter.isRecording) {
        [self stopCameraCapture];
    } else {
        [self startCameraCapture];
    }
}

#pragma mark -
#pragma mark - Initialize camera preview view

-(void) createCameraPreview
{
    float frameWidth = (targetWidth*(self.frame.size.height-40))/targetHeight;
    cameraPreview = [[GPUImageView alloc] initWithFrame:CGRectMake((self.frame.size.width/2)-(frameWidth/2), 40, frameWidth, self.frame.size.height-40)];

    cameraPreview.fillMode = kGPUImageFillModePreserveAspectRatio;
    
    [self insertSubview:cameraPreview atIndex:0];
}

#pragma mark -
#pragma mark - Initialize camera capture

-(void) initCameraCapture
{
    // create video painter
    painter = [[AVCameraPainter alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
    
    painter.shouldCaptureAudio = YES;
    painter.camera.outputImageOrientation = UIInterfaceOrientationMaskPortraitUpsideDown;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    // context initialization - block (we dont want to overload class in this example)
    void (^contextInitialization)(CGContextRef context, CGSize size) = ^(CGContextRef context, CGSize size) {
        
        //CGRect rect = testView.frame;
        
        //CGContextAddRect(context, rect);
        
        //CGContextShow
    };
    
    // create overlay + some code
    frameDrawer = [[AVFrameDrawer alloc] initWithSize:CGSizeMake(targetWidth, targetHeight)
                               contextInitailizeBlock:contextInitialization];
    
    __weak typeof(self) weakSelf = self;
    
    frameDrawer.contextUpdateBlock = ^BOOL(CGContextRef context, CGSize size, CMTime time) {
    
        [completOverlayView.layer renderInContext:context];
        
        //CGContextDrawImage(context,CGRectMake(50, 50, 200, 150), graphsViewImage.CGImage);
        
        //[testView.layer renderInContext:context];
        
        return YES;
    };
    
    // setup composer, preview and painter all together
    [painter.composer addTarget:cameraPreview];
    
    [painter setOverlay:frameDrawer];
    
    [painter startCameraCapture];
}

#pragma mark -
#pragma mark - Handler camera capture

-(void) startCameraCapture
{
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"file.mov"];
    outUrl = [NSURL fileURLWithPath:path];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:path error:nil];
    
    NSLog(@"Recording ...");
    
    [painter startCameraRecordingWithURL:outUrl size:CGSizeMake(targetWidth, targetHeight)];
    
    int64_t stopDelay = (int64_t)(videoDurationInSec * NSEC_PER_SEC);
    dispatch_time_t autoStopTime = dispatch_time(DISPATCH_TIME_NOW, stopDelay);
    
    dispatch_after(autoStopTime, dispatch_get_main_queue(), ^{
        [self stopCameraCapture];
    });
    
    [recordButton setBackgroundColor:[UIColor redColor]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startStopRecordingFromVideo" object:nil];
}

-(void) stopCameraCapture
{
    if(!painter.isRecording) {
        return;
    }
    
    NSURL *movieUrl = outUrl;
    
    [painter stopCameraRecordingWithCompetionHandler:^(){
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            NSLog(@"Recorded :/");
            [SVProgressHUD showWithStatus:@"Exporting..."];
            
            [recordButton setBackgroundColor:[UIColor greenColor]];
            
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            if ([assetsLibrary videoAtPathIsCompatibleWithSavedPhotosAlbum:movieUrl]) {
                [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:movieUrl completionBlock:^(NSURL *assetURL, NSError *error){
                    
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        [SVProgressHUD showSuccessWithStatus:@"Video Saved"];
                    });
                    
                }];
            }
        });
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startStopRecordingFromVideo" object:nil];
}

-(void) addRecordButton {
    recordButton = [[UIButton alloc] initWithFrame:CGRectMake(80, (self.frame.size.height/2)-10, 60, 60)];
    
    [recordButton setBackgroundColor:[UIColor greenColor]];
    
    [recordButton.layer setCornerRadius:30.0f];
    
    [recordButton addTarget:self action:@selector(startStopRecording) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview: recordButton];
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
