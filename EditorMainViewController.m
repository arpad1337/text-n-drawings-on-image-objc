#import "EditorMainViewController.h"
#import "AVHexColor.h"
#import "EditorPresetTableViewController.h"
#import "Helper.h"

@interface EditorMainViewController () {
    AVCaptureSession *_session;
    AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;
    AVCaptureStillImageOutput *_stillImageOutput;
    UIImage *_croppedImageWithoutOrientation;
    UIImagePickerController *_imgPicker;
    BOOL _isFrontCamera, _isFlashOn, _isFlashAuto;
    AVCaptureDevice *_frontCamera;
    AVCaptureDevice *_backCamera;
    UIImage *_croppedImage;
    AVCaptureDeviceInput *_currentInput;
}

@end

@implementation EditorMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.captureView.backgroundColor = [Helper sharedHelper].secondaryColor;
    self.buttonsView.backgroundColor = [Helper sharedHelper].secondaryColor;
    _isFrontCamera = NO;
    _isFlashOn = NO;
    _isFlashAuto = YES;
    _imgPicker = [[UIImagePickerController alloc] init];
    _imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imgPicker.delegate = self;
    _imgPicker.allowsEditing = YES;
    _imgPicker.navigationBar.translucent = NO;
    self.title = @"Let's Capture!";

}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initalizeCamera];
    self.title = @"Let's Capture!";
}

-(void)hideCaptureView {
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:4.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.captureView.alpha = 0.0;                     }
                     completion:^(BOOL finished){
                         
                     }];
    [UIView commitAnimations];
}

-(void)initalizeCamera {
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = AVCaptureSessionPresetPhoto;
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    [_captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	_captureVideoPreviewLayer.frame = self.cameraImageView.bounds;
    [self.cameraImageView.layer addSublayer:_captureVideoPreviewLayer];
    for(AVCaptureDevice *d in [AVCaptureDevice devices]){
        if ([d hasMediaType:AVMediaTypeVideo]) {
            if([d position] == AVCaptureDevicePositionBack){
                _backCamera = d;
            } else {
                _frontCamera = d;
            }
        }
    }
    [self addInputToSession];
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    
    [_session addOutput:_stillImageOutput];
    
	[_session startRunning];
    
    [self hideCaptureView];
}

-(void)addInputToSession{
    if(_isFrontCamera){
        _currentInput = [AVCaptureDeviceInput deviceInputWithDevice:_frontCamera error:nil];
        self.cameraImageView.transform = CGAffineTransformIdentity;
    } else {
        _currentInput = [AVCaptureDeviceInput deviceInputWithDevice:_backCamera error:nil];
        self.cameraImageView.transform = CGAffineTransformIdentity;
    }
    [_session addInput:_currentInput];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)toogleCamera:(id)sender {
    _isFrontCamera = !_isFrontCamera;
    [_session removeInput:_currentInput];
    [self addInputToSession];
    if(_isFrontCamera) {
        self.flashButton.enabled = NO;
    } else {
        self.flashButton.enabled = YES;
    }
}
- (IBAction)toggleFlash:(id)sender {
    if(!_isFrontCamera){
        [_backCamera lockForConfiguration:nil];
        if(_isFlashOn){
            [self.flashButton setImage:[UIImage imageNamed:@"editorIconFlashOff"] forState:UIControlStateNormal];
            [_backCamera setFlashMode:AVCaptureFlashModeOff];
            _isFlashOn = !_isFlashOn;
        } else {
            if(_isFlashAuto) {
                [self.flashButton setImage:[UIImage imageNamed:@"editorIconFlashOn"] forState:UIControlStateNormal];
                [_backCamera setFlashMode:AVCaptureFlashModeOn];
                _isFlashAuto = NO;
            } else {
                _isFlashAuto = YES;
                [self.flashButton setImage:[UIImage imageNamed:@"editorIconFlashAuto"] forState:UIControlStateNormal];
                [_backCamera setFlashMode:AVCaptureFlashModeAuto];
                _isFlashOn = !_isFlashOn;
            }
        }
        [_backCamera unlockForConfiguration];
    }
}
- (IBAction)captureImage:(id)sender {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections) {
        
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            [self processImage:[UIImage imageWithData:imageData]];
        }
    }];
}

- (UIImage*)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)processImage:(UIImage*)image {
    UIImage *smallImage = [self imageWithImage:image scaledToWidth:640.0f];
    CGRect cropRect = CGRectMake(0, 105, 640, 640);
    CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
    UIImage *ci = nil;
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationLandscapeLeft:
            ci = [[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationLeft];
            break;
        case UIDeviceOrientationLandscapeRight:
            ci = [[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationRight];
            break;
            
        case UIDeviceOrientationFaceUp:
            ci = [[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationUp];
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            ci = [[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationDown];
            break;
            
        default:
            ci = [UIImage imageWithCGImage:imageRef];
            break;
    }
    CGImageRelease(imageRef);
    
    if(_isFrontCamera) {
        _croppedImage = [[UIImage alloc] initWithCGImage:ci.CGImage scale:1 orientation:UIImageOrientationUpMirrored];
    } else
    {
        _croppedImage = ci;
    }
    
    [self performSegueWithIdentifier:@"ToEditorGeneratePresets" sender:self];
}

-(UIImage*)mirrorImage:(UIImage*)image {
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, -1, 1);
    
    CGContextConcatCTM(context, t);
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (IBAction)openGallery:(id)sender {
    [_session stopRunning];
    [self presentViewController:_imgPicker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (info) {
        UIImage* outputImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (outputImage == nil) {
            outputImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        if (outputImage) {
            _croppedImage = outputImage;
            [self dismissViewControllerAnimated:YES completion:nil];
            [self performSegueWithIdentifier:@"ToEditorGeneratePresets" sender:self];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [_imgPicker dismissViewControllerAnimated:YES completion:nil];
    [_session startRunning];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqual:@"ToEditorGeneratePresets"]){
        self.title = @"";
        EditorPresetTableViewController *c = (EditorPresetTableViewController*)segue.destinationViewController;
        c.croppedImage = _croppedImage;
    }
}

- (IBAction)closeEditor:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
