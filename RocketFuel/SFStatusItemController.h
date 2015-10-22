/*!
 *  @class SFStatusItemController
 *  @brief The Status Item controller.
 *  @discussion This class creates the status item menu icon and the menu and menu items that goes along with it.
 *  @version 1.0.0
 *  @author Ardalan Samimi
 *  @copyright Saturn Five
 */
@interface SFStatusItemController : NSObject

+ (instancetype)init;
- (BOOL)isSleepModeOn;
- (void)requestTermination;

@end
