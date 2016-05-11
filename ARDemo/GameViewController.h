#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface GameViewController : GLKViewController

- (void)updateCameraData:(void*)address bytesPerRow:(size_t)bytesPerRow width:(size_t)width height:(size_t)height;

@end
