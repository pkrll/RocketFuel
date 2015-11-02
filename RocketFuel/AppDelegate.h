/*!
 *  @class AppDelegate
 *  @brief The Application Delegate.
 *  @version 1.1.1
 *  @author Ardalan Samimi
 *  @copyright Saturn Five
 */
@interface AppDelegate : NSObject <NSApplicationDelegate>

- (NSNumber *)isActive;
- (void)toggleRocketFuel;
- (void)activateWithDuration:(NSInteger)duration;

@end
