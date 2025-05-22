#import "EditorMakePostViewController.h"
#import "PresetLabelView.h"
#import <CoreText/CoreText.h>
#import "AVHexColor.h"
#import "ACEDrawingView.h"
#import "EditorChangeMethodViewController.h"
#import "Helper.h"

#define MAXLENGTH 140 // text

@interface EditorMakePostViewController () <ACEDrawingViewDelegate> {
    UIView* _labelContainer;
    PresetLabelView* _labelView;
    ACEDrawingView* _drawingView;
    BOOL _isDrawingMode;
}

@end

@implementation EditorMakePostViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _drawingView = [[ACEDrawingView alloc] initWithFrame:self.backgroundImageView.frame];
    
    _drawingView.delegate = self;
    
    _drawingView.lineColor = [UIColor blackColor];
    _drawingView.drawTool = ACEDrawingToolTypePen;
    _drawingView.lineWidth = 4;
    
    _isDrawingMode = NO;
    
    [self.editorFrameView addSubview:_drawingView];
    
    [self updateButtonStatus];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.messageColorPicker.delegate = self;
    self.drawingColorPicker.delegate = self;
    
    self.view.backgroundColor = [AVHexColor colorWithHex:0x28BBB9];
    
    UIView *doneContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIButton* doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.backgroundColor = [Helper sharedHelper].secondaryColor;
    doneButton.tintColor = [UIColor whiteColor];
    [doneButton addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchDown];
    
    [doneContainer addSubview:doneButton];
    
    self.messageInputTextView.inputAccessoryView = doneContainer;
    
    // Do any additional setup after loading the view.
    [self.backgroundImageView setImage:self.croppedImage];
    NSAttributedString* attString = [[NSAttributedString alloc] initWithString:self.label attributes:self.attributes];
    _labelView = [[PresetLabelView alloc] initWithFrame:self.backgroundImageView.frame];
    
    NSLog(@"%@", NSStringFromCGRect(self.backgroundImageView.frame));
    
    _labelView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    _labelView.opaque = NO;
    [_labelView setAttString:attString];
    [_labelView setAttributes:self.attributes];
    
    _labelContainer = [[UIView alloc] initWithFrame:self.backgroundImageView.frame];
    [_labelContainer addSubview:_labelView];
    
    [self.editorFrameView addSubview:_labelContainer];
    
    self.backgroundImageView.userInteractionEnabled = YES;
    [self setUpGestures];
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%@", textView.text);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSUInteger oldLength = [textView.text length];
    NSUInteger replacementLength = [text length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [text rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= MAXLENGTH || returnKey;
}

-(void)dismissKeyboard:(UIButton*)btn {
    self.messageInputTextView.hidden = YES;
    [self.messageInputTextView resignFirstResponder];
    [_labelView setLabel:self.messageInputTextView.text];
}

-(void)setUpGestures {
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [tap setNumberOfTapsRequired:2];
    [_labelContainer addGestureRecognizer:tap];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    [_labelContainer  addGestureRecognizer:pinch];
    
    UIRotationGestureRecognizer *twoFingersRotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(pinchRotate:)];
    [_labelContainer addGestureRecognizer:twoFingersRotate];
    
    UILongPressGestureRecognizer* lt = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTouch:)];
    [lt setMinimumPressDuration:0.1];
    [_labelContainer addGestureRecognizer:lt];
}

-(void)tap:(UITapGestureRecognizer*)tap {
    NSLog(@"Tapped");
    [self.messageInputTextView becomeFirstResponder];
    self.messageInputTextView.hidden = NO;
}

-(void)longTouch:(UILongPressGestureRecognizer*)lt {
    
    NSLog(@"long touch");
    switch (lt.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"lt started");
            _labelView.referenceTransform = _labelView.transform;
            _labelView.startPoint = CGPointMake(_labelView.center.x - [lt locationInView:_labelContainer].x, _labelView.center.y - [lt locationInView:_labelContainer].y);

            break;
        case UIGestureRecognizerStateChanged: {
            
            CGFloat nx = (_labelView.startPoint.x + [lt locationInView:_labelContainer].x);
            CGFloat ny = (_labelView.startPoint.y + [lt locationInView:_labelContainer].y);
            
            if(ny >= -_labelView.frame.size.height && ny <= _labelView.frame.size.height * 3
               && nx <= _labelView.frame.size.width* 3 && nx >= -_labelView.frame.size.width) {
                _labelView.center = CGPointMake(nx, ny);
            }
        }
            
        default:
            break;
    }

}

-(void)pinchRotate:(UIRotationGestureRecognizer*)rotate
{
    switch (rotate.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            _labelView.referenceTransform = _labelView.transform;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            _labelView.transform = CGAffineTransformRotate(_labelView.referenceTransform, ([rotate rotation] * 55) * M_PI/180);
            break;
        }
            
        default:
            break;
    }
        
}

-(void)pinch:(UIPinchGestureRecognizer*)pinch
{
    
    switch (pinch.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            _labelView.referenceTransform = _labelView.transform;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGFloat nw = pinch.scale * _labelView.origFrame.size.width;
            CGFloat nh = pinch.scale * _labelView.origFrame.size.height;
            
            if(nh <= 5000 && nw <= 5000 && nh >= 50 && nw >= 50) {
            
            _labelView.bounds = CGRectMake(
                                          _labelView.origFrame.origin.x + -(nw - _labelView.origFrame.size.width) / 2, _labelView.origFrame.origin.y +  -(nh - _labelView.origFrame.size.height) / 2, pinch.scale * _labelView.origFrame.size.width, pinch.scale * _labelView.origFrame.size.height);
            CTFontRef font = _labelView.font;
            CTFontRef scaledFont = CTFontCreateCopyWithAttributes(font, _labelView.originalFontSize* pinch.scale, NULL, CTFontCopyFontDescriptor(font));
            
            _labelView.font = scaledFont;
            
                
            }
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            _labelView.origFrame = _labelView.bounds;
            _labelView.originalFontSize = CTFontGetSize(_labelView.font);
            [_labelView setNeedsDisplay];
            break;
        }
            
        default:
            break;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)colorPicker:(ColorPicker *)colorpicker didChangeColor:(UIColor *)color {
    if([colorpicker isEqual:self.messageColorPicker]) {
        [_labelView setFontColor:color];
    } else if([colorpicker isEqual:self.drawingColorPicker]) {
        _drawingView.lineColor = color;
    }
}

-(void)setScaleFactor:(UIView*)view {
    view.contentScaleFactor = 2.0;
    if(view.subviews.count > 0)
    {
        for (uint i = 0; i < view.subviews.count; i++) {
            [self setScaleFactor:view.subviews[i]];
        }
    }
}

-(UIImage*)screenshotFromView:(UIView*)view {
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"scale: %f", screenshot.scale);
    
    return screenshot;
}

- (IBAction)switchDrawing:(id)sender {
    _isDrawingMode = !_isDrawingMode;
    if(_isDrawingMode) {
        [self.editorFrameView bringSubviewToFront:_drawingView];
    } else {
        [self.editorFrameView bringSubviewToFront:_labelContainer];
    }
}

#pragma mark Drawing

- (void)updateButtonStatus
{
    self.undoButton.enabled = [_drawingView canUndo];
    self.redoButton.enabled = [_drawingView canRedo];
}

- (IBAction)undo:(id)sender
{
    [_drawingView undoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)redo:(id)sender
{
    [_drawingView redoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)clear:(id)sender
{
    [_drawingView clear];
    [self updateButtonStatus];
}
- (IBAction)compose:(id)sender {
    
}

-(void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool {
    [self updateButtonStatus];
}


- (IBAction)createPost:(id)sender {
    [self performSegueWithIdentifier:@"ToChangeMethodFromEditorMakePost" sender:nil];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"ToChangeMethodFromEditorMakePost"]) {
        [Helper sharedHelper].editorBackground = self.croppedImage;
        [Helper sharedHelper].editorLayer = [self screenshotFromView:self.editorFrameView];
        [Helper sharedHelper].editorThumbnail = [self screenshotFromView:self.postFrameView];
    }
}


@end
