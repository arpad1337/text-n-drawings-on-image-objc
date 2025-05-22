#import <UIKit/UIKit.h>
#import "ColorPicker.h"

@interface EditorMakePostViewController : UIViewController <UITextViewDelegate,
ColorPickerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) UIImage* croppedImage;
@property (strong, nonatomic) NSDictionary* attributes;
@property (strong, nonatomic) NSString* label;
@property (weak, nonatomic) IBOutlet UITextView *messageInputTextView;

@property (weak, nonatomic) IBOutlet ColorPicker *messageColorPicker;
@property (weak, nonatomic) IBOutlet ColorPicker *drawingColorPicker;

@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *redoButton;

@property (weak, nonatomic) IBOutlet UIView *editorFrameView;

@property (weak, nonatomic) IBOutlet UIView *postFrameView;

@end
