/*!
 *  @class RFApplication
 *  @brief A subclass of NSApplication.
 *  @version 1.0.0
 *  @author Ardalan Samimi
 *  @copyright Saturn Five
 */
@interface RFApplication : NSApplication {
    NSNumber *isActivated;
}

- (NSNumber *)isActivated;

@end
