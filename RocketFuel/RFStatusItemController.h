/*!
 *  @class Status Item Controller
 *  @brief Manages the status item and the menu.
 *  @version 2.3.0
 *  @author Ardalan Samimi
 *  @copyright Saturn Five
 */
@interface RFStatusItemController : NSObject

@property (nonatomic, readonly, getter = isActive) BOOL active;
- (void)requestActivationForDuration:(NSInteger)duration;
- (void)requestActivation;
- (void)requestTermination;

@end
