#import "ColorPicker.h"

@implementation ColorPicker {
    UIImage* _sliderBackground;
    UIImage* _slider;
    CGFloat _sliderPosition;
    CGFloat _pos;
    UILongPressGestureRecognizer* _gs;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _sliderBackground = [UIImage imageNamed:@"picker"];
        _slider = [UIImage imageNamed:@"pickerSelector"];
        [self setBackgroundColor:[UIColor clearColor]];
        //self.bounds = CGRectMake(6, 6, self.bounds.size.width - 6, self.bounds.size.height-6);
        _sliderPosition = 11;
        self.currentColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        _gs = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleMove:)];
        [_gs setMinimumPressDuration:0];
        [self addGestureRecognizer:_gs];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _sliderBackground = [UIImage imageNamed:@"picker"];
        _slider = [UIImage imageNamed:@"pickerSelector"];
        [self setBackgroundColor:[UIColor clearColor]];
        //self.bounds = CGRectMake(6, 6, self.bounds.size.width - 6, self.bounds.size.height-6);
        _sliderPosition = 11;
        self.currentColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        _gs = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleMove:)];
        [_gs setMinimumPressDuration:0];
        [self addGestureRecognizer:_gs];
    }
    return self;
}

-(void)handleMove:(UILongPressGestureRecognizer*)gs {
    switch (gs.state) {
        case UIGestureRecognizerStateChanged: {
            _pos = [gs locationInView:self].x;
            if(_pos > 10 && _pos < self.frame.size.width - 10) {
                _sliderPosition = _pos;
                self.currentColor = [self colorOfPoint:CGPointMake(_sliderPosition, 10)];
                [self setNeedsDisplay];
                [self sendColorToDelegate];
            }
            break;
        }
        default:
            break;
    }
}

-(void)sendColorToDelegate {
    if([self.delegate respondsToSelector:@selector(colorPicker:didChangeColor:)]) {
        [self.delegate colorPicker:self didChangeColor:self.currentColor];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


- (UIColor *) colorOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
        
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, CGRectMake(10, 5, self.frame.size.width - 10, self.frame.size.height -10), _sliderBackground.CGImage);
    
    CGRect iconRect = CGRectMake(_sliderPosition - 11, 0, 20, 20);
    
    CGContextDrawImage(context, iconRect, _slider.CGImage);
    
    CGContextClipToMask(context, iconRect, _slider.CGImage);
    
    CGContextSetFillColorWithColor(context, self.currentColor.CGColor);
    
    CGContextFillRect(context, iconRect);
}


@end
