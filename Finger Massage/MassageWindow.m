

#import "MassageWindow.h"

@implementation MassageWindow


- (void)awakeFromNib {
    self.titlebarAppearsTransparent = YES;
    self.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
}
@end
