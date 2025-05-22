#import <UIKit/UIKit.h>

@interface ColorPicker : UIControl

@property (nonatomic, strong) UIColor* currentColor;
@property (nonatomic, assign) id delegate;

@end

@protocol ColorPickerDelegate

-(void)colorPicker:(ColorPicker*)colorpicker
    didChangeColor:(UIColor*)color;

@end
