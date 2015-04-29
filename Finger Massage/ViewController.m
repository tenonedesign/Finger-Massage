

#import "ViewController.h"
#import "CGMassage.h"

@interface ViewController()
@property (strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MassageSettings" ofType:@"plist"]]];
	
	self.timer = [NSTimer scheduledTimerWithTimeInterval:[defaults floatForKey:@"massageInterval"] target:self selector:@selector(doActuation) userInfo:nil repeats:NO];
}


- (NSTimeInterval)intervalForSpeedSliderValue:(float)value {
	// invert slider sense
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSTimeInterval min = [defaults doubleForKey:@"massageMinInterval"];
	NSTimeInterval max = [defaults doubleForKey:@"massageMaxInterval"];
	float invertedValue = 1 - value;
	return invertedValue * (max - min) + min;
}

- (int)patternForIntensity:(int)intensity {
	// 8 valid pattern values are 0x1-0x6 and 0x0f-0x10
	if (intensity == 0) {
		return 15;
	}
	if (intensity == 3) {
		return 6;
	}
	return intensity;
}


- (void)doActuation {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	float speedSliderValue = [defaults floatForKey:@"massageSpeedSliderValue"];
	int intensity = (int)[defaults integerForKey:@"massageIntensitySliderValue"];
	
	NSTimeInterval interval = [self intervalForSpeedSliderValue:speedSliderValue];
	int pattern = [self patternForIntensity:intensity];
	
	[self actuateWithPattern:pattern];
	
	self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(doActuation) userInfo:nil repeats:NO];
}

- (void)actuateWithPattern:(int)pattern {
	CGSConnection cid = CGSMainConnectionID();
	CGSActuateDeviceWithPattern(cid, 0x0, pattern, 0x0);
}
@end
