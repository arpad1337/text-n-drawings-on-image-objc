#import "PresetTableViewCell.h"
#import "PresetLabelView.h"

@implementation PresetTableViewCell {
    PresetLabelView* _labelView;
}

- (void)awakeFromNib
{
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.bounds.size.width);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell:(UIImage*)filteredImage withLabel:(NSString*)label andAttributes:(NSDictionary*)attr {
    NSAttributedString* attString = [[NSAttributedString alloc] initWithString:label attributes:attr];
    [self.backgroundImageView setImage:filteredImage];
    if(!_labelView) {
        _labelView = [[PresetLabelView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        _labelView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _labelView.opaque = NO;
        [self addSubview:_labelView];
    }
    [_labelView setAttString:attString];
    [_labelView setAttributes:attr];
}
@end

