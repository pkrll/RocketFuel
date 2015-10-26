@class RocketFuel;

@protocol RocketFuelDelegate <NSObject>

- (void)rocketFuel:(RocketFuel *)rocketFuel
   didChangeStatus:(BOOL)sleepMode;

@end
/*!
 *  @class RocketFuel
 *  @brief The RocketFuel Object.
 *  @version 1.2.0
 *  @author Ardalan Samimi
 *  @copyright Saturn Five
 */
@interface RocketFuel : NSObject
/*!
 *  @brief Returns whether Rocket Fuel is preventing sleep.
 *  @return YES if caffeinate is running, otherwise NO.
 */
@property (nonatomic, readonly) BOOL active;
/*!
 *  @brief The duration in seconds for which RocketFuel is to be active.
 */
@property (nonatomic) NSInteger duration;
/*!
 *  @brief The delegate adopting the Rocket Fuel protocol.
 */
@property (weak) id delegate;
/*!
 *  @brief Creates an instance of the Rocket Fuel class.
 */
+ (instancetype)engage;
/*!
 *  @brief Toggle sleep prevention mode.
 *  @discussion To check whether sleep mode is one, use property isSleepModeOn.
 */
- (void)toggleSleepMode;
/*!
 *  @brief Terminate sleep prevention.
 */
- (void)terminate;

@end
