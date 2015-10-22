/*!
 *  @class SFRocketFuel
 *  @brief The Rocket Fuel object.
 *  @discussion The Rocket Fuel class prevents sleep using command line tool caffeinate.
 *  @version 1.0.0
 *  @author Ardalan Samimi
 *  @copyright Saturn Five
 */
@interface SFRocketFuel : NSObject
/*!
 *  @brief Returns whether Rocket Fuel is preventing sleep.
 *  @return YES if caffeinate is running, otherwise NO.
 */
@property (nonatomic, getter = isSleepModeOn, readonly) BOOL sleepMode;
/*!
 *  @brief Creates an instance of the Rocket Fuel class.
 */
+ (instancetype)engage;
/*!
 *  @brief Toggle sleep prevention mode.
 *  @discussion To check whether sleep mode is one, use property isSleepModeOn.
 */
- (void)toggleSleepMode;

@end
