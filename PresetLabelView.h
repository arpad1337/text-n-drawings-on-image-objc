#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface PresetLabelView : UIView

@property (strong, nonatomic) NSAttributedString* attString;
@property (strong, nonatomic) NSDictionary* attributes;
@property (nonatomic) CTFontRef font;
@property (nonatomic) CGFloat originalFontSize;
@property (nonatomic) CGPoint position;
@property (nonatomic) CGAffineTransform referenceTransform;
@property (nonatomic) CGRect origFrame;
@property (nonatomic) NSString* label;
@property (nonatomic) CGPoint startPoint;

-(void)setFontColor:(UIColor*)color;

@end
