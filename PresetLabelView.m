#import "PresetLabelView.h"

@implementation PresetLabelView {

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.origFrame = frame;
    }
    return self;
}

-(void)setLabel:(NSString *)label {
    self.attString = [[NSAttributedString alloc] initWithString:label attributes:self.attributes];
}

-(void)setAttString:(NSAttributedString *)attString {
    _label = [attString string];
    _attString = attString;
    
    NSLog(@"%@", [_attString string]);
    
    [self setNeedsDisplay];
}
-(void)setAttributes:(NSDictionary *)attributes {
    _font = (__bridge CTFontRef)([attributes objectForKey:(NSString*)kCTFontAttributeName]);
    _originalFontSize = CTFontGetSize(_font);
    _attributes = attributes;
}
-(void)setFont:(CTFontRef)font
{
    CFMutableAttributedStringRef tempString = CFAttributedStringCreateMutableCopy(CFAllocatorGetDefault(), _attString.length, (CFMutableAttributedStringRef)_attString);
    CFAttributedStringSetAttribute(tempString, CFRangeMake(0, _attString.length), kCTFontAttributeName, font);
    _attString = (__bridge NSAttributedString*)tempString;
    _font = font;
    NSMutableDictionary* d = [[NSMutableDictionary alloc] initWithDictionary:self.attributes];
    [d setObject:(__bridge id)(font) forKey:(NSString*)kCTFontAttributeName];
    _attributes = (NSDictionary*)d;
    CFRelease(tempString);
}

-(void)setFontColor:(UIColor*)color {
    NSMutableDictionary* d = [self.attributes mutableCopy];
    [d setObject:(id)color.CGColor forKey:(NSString *)(kCTForegroundColorAttributeName)];
    _attributes = (NSDictionary*)d;
    _attString = [[NSAttributedString alloc] initWithString:_label attributes:_attributes];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
        
    NSLog(@"b: %@", NSStringFromCGRect(self.bounds));
    NSLog(@"f: %@", NSStringFromCGRect(self.frame));

    
    self.position = CGPointMake( _origFrame.size.width / 2 + _origFrame.origin.x, _origFrame.size.height / 2 - _origFrame.origin.y);
    
    NSLog(@"center 1: %@", NSStringFromCGPoint(self.position));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
        
    CGContextSetTextMatrix(context, CGAffineTransformIdentity); // 2-1
    CGContextTranslateCTM(context, 0, _origFrame.size.height); // 3-1
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetShouldSmoothFonts(context, NO);
    
    CGMutablePathRef path = CGPathCreateMutable(); // 5-2
        //CGPathAddRect(path, NULL, CGRectMake(10, 10, 300, 300));
    
    NSLog(@"%@", [_attString string]);

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attString); // 7-2
    
    CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [_attString length]), NULL, CGSizeMake(_origFrame.size.width, CGFLOAT_MAX), NULL);
        
    CGFloat top = _originalFontSize > fitSize.height ? self.position.y - _originalFontSize / 2 : self.position.y - fitSize.height / 2;
    
    CGPathAddRect(path, NULL, CGRectMake(self.position.x - fitSize.width / 2, top, fitSize.width, fitSize.height));
        
    CTFrameRef theFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [_attString length]), path, NULL); // 8-2    
    
    if([self.attributes objectForKey:@"background"]) {
        UIColor* bgColor = [self.attributes objectForKey:@"background"];
        CGRect backgroundContainer = CGRectMake(self.position.x - fitSize.width / 2 - fitSize.width * 0.03f, self.position.y - (fitSize.height / 2) - fitSize.height * 0.02f, fitSize.width + fitSize.width * 0.06f, fitSize.height + fitSize.height * 0.04f);
        CGContextSetFillColorWithColor(context, bgColor.CGColor);
        CGContextFillRect(context, backgroundContainer);
    }
        
    CFRelease(framesetter); // 9-2
    CFRelease(path); // 10-2
    
    CTFrameDraw(theFrame, context); // 11-2
        
    CFRelease(theFrame); // 12-2
    
}


@end
