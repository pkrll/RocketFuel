/*!
 *  @class Status Item Controller
 *  @brief Manages the status item and the menu.
 *  @version 2.0.0
 *  @author Ardalan Samimi
 *  @copyright Saturn Five
 */
@interface RFStatusItemController : NSObject

@property (nonatomic, readonly, getter = isSleepModeOn) BOOL sleepMode;
- (void)requestTermination;

@end
