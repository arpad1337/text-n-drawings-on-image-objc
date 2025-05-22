#import "EditorPresetTableViewController.h"
#import "PresetTableViewCell.h"
#import "GPUImageToneCurveFilter.h"
#import <CoreText/CoreText.h>
#import "EditorMakePostViewController.h"

@interface EditorPresetTableViewController () {
    NSArray *_presets;
    GPUImageToneCurveFilter *_curveFilter;
    NSString* _selectedPreset;
    NSMutableDictionary* _images;
}

@end

@implementation EditorPresetTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _presets = [NSArray arrayWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"LibreBaskerville-Italic", @"font", [NSNumber numberWithFloat:22.0f], @"size", [UIColor blackColor], @"color", [UIColor colorWithWhite:1 alpha:0.8], @"background", nil ]
                 , @"text", @"#NOFILTER Libre", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-black", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"LibreBaskerville-Regular", @"font", [NSNumber numberWithFloat:22.0f], @"size", [UIColor whiteColor], @"color", [UIColor colorWithWhite:0 alpha:0.8], @"background", nil ]
                 , @"text", @"#NOFILTER Libre-black", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-white", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"QuattrocentoSans", @"font", [NSNumber numberWithFloat:26.0f], @"size", [UIColor blackColor], @"color", [UIColor colorWithWhite:1 alpha:1], @"background", nil ]
                 , @"text", @"#nofilter #white", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-anton", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"Anton", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"SWAG", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-tif", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"JennaSue", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Tifani", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-pea", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"PeaBeeferelli", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Pea", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-francia", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"FrancoisOne-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Francia", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-bebas", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"BebasNeue", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"NE BASSZÁ BE", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-just", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"JustTheWayYouAre", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Dzsászt dö véj jú ár", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-coelho", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"TheOnlyException", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Paulo Coelho", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-cheddar", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"CheddarJack", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor purpleColor], @"color", nil ]
                 , @"text", @"Cheese", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-sunshine", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"SunshineInMySoul", @"font", [NSNumber numberWithFloat:36.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Soul", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-arc", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"ArchivoBlack-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"arhív", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-booo", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"Boogaloo-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Booo", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-booo", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"Boogaloo-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Booo", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-bowl1", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"BowlbyOne", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Bowling He", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-bowl2", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"BowlbyOneSC-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Bowling Ha", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-cabin1", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"CabinSketch-Bold", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Kabin 1", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-cabin2", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"CabinSketch-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Kabin 2", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-carter", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"CarterOne", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Carter", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-csebisev", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"CevicheOne-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Csebisev egyenlőtlenség", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-olaj", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"ChelaOne-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Olaj", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-hehehe", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"Chicle-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"hehehe", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-koncert", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"ConcertOne-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"koncert", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-firka", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"FingerPaint-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Firka", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-wibly", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"FreckleFace-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Wibly Wobly", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-holly", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"HoltwoodOneSC", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Hálivúd", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-hand", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"JustAnotherHand-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Hend in da ér", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-booom", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"Kavoon-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Kaboom", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-wave", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"Knewave-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Wave", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-lilita", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"LilitaOne", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Lilita", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-londrina", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"LondrinaSolid-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Szennyes", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-ramazotti", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"RammettoOne-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Ramazotti", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-cowboy", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"Ranchers-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Kávbój", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-rubik", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"RubikOne-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Ernő", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-salsa", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"Salsa-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Salsa", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-seymour", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"SeymourOne", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Szimúr", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-sf", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"SueEllenFrancisco", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"San Francisco", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-tauri", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"TauriRegular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Tauri", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-titan", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"TitanOne", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Titán", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-ultra", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"Ultra", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"ultra", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"nofilter-wendy", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"WendyOne-Regular", @"font", [NSNumber numberWithFloat:32.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Wendy Testaburger", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"01", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"Designio", @"font", [NSNumber numberWithFloat:36.0f], @"size", [UIColor whiteColor], @"color", [UIColor colorWithWhite:0 alpha:0.3], @"background", nil ]
                 , @"text", @"Hip Ster", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"02", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"Young&Beautiful", @"font", [NSNumber numberWithFloat:42.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"Summertime", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"03", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"OpenSans-Light", @"font", [NSNumber numberWithFloat:42.0f], @"size", [UIColor blackColor], @"color", nil ]
                 , @"text", @"What", @"title", nil]
                ,
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"04", @"filter",
                 [NSDictionary dictionaryWithObjectsAndKeys: @"OpenSans-Light", @"font", [NSNumber numberWithFloat:17.0f], @"size", [UIColor whiteColor], @"color", nil ]
                 , @"text", @"OMG", @"title", nil]
                ,
                nil
                ];
    
    _images = [[NSMutableDictionary alloc] init];
    
    UINib *nib = [UINib nibWithNibName:@"PresetTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:kPresetCellReuseIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _presets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PresetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPresetCellReuseIdentifier forIndexPath:indexPath];
    
    UIImage* currentImage;
    
    NSDictionary* currentPreset = _presets[indexPath.row];
    NSDictionary* textProp = [currentPreset objectForKey:@"text"];
    
    NSString* filter = [currentPreset valueForKey:@"filter"];
    if(![filter hasPrefix:@"nofilter"]) {
        _curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:filter];
        currentImage=  [_curveFilter imageByFilteringImage:self.croppedImage];
    } else {
        currentImage = self.croppedImage;
    }
    
    CGFloat size = [[textProp valueForKey:@"size"] doubleValue];
    
    UIColor* ucolor = [textProp objectForKey:@"color"];
    
    CTTextAlignment paragraphAlignment = kCTCenterTextAlignment;
    CTParagraphStyleSetting paragraphSettings[1] = {{kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &paragraphAlignment}};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)[textProp valueForKey:@"font"], size, NULL); // 1-2
    NSDictionary *attrDictionary = [NSDictionary
                                    dictionaryWithObjectsAndKeys: (__bridge id)fontRef,
                                    (NSString *)kCTFontAttributeName,
                                    (id)[ucolor CGColor],
                                    (NSString *)(kCTForegroundColorAttributeName),
                                    (__bridge id)paragraphStyle,
                                    (NSString*)kCTParagraphStyleAttributeName,
                                    (id)[textProp objectForKey:@"background"],
                                    @"background",
                                    nil]; // 2-2
    CFRelease(fontRef);
    
    NSDictionary* filterData = [[NSDictionary alloc] initWithObjectsAndKeys:currentImage, @"filteredImage", attrDictionary, @"attributes", [currentPreset valueForKey:@"title"], @"title", nil];
    
    [_images setObject:filterData forKey:filter];
    
    [cell configureCell:currentImage withLabel:[currentPreset valueForKey:@"title"] andAttributes:attrDictionary];
        
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedPreset = [_presets[indexPath.row] valueForKey:@"filter"];
    [self performSegueWithIdentifier:@"ToEditorMakePost" sender:nil];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqual:@"ToEditorMakePost"]) {
        EditorMakePostViewController* c = (EditorMakePostViewController*)segue.destinationViewController;
        NSDictionary* meta = [_images objectForKey:_selectedPreset];
        c.croppedImage = [meta objectForKey:@"filteredImage"];
        c.attributes = [meta objectForKey:@"attributes"];
        c.label = [meta valueForKey:@"title"];
    }
}


@end
