/*!
 *  @class RFMenu
 *  @brief A Custom Menu.
 *  @version 1.0.0
 *  @author Ardalan Samimi
 *  @copyright Saturn Five
 */
@interface RFMenu : NSMenu

@property (nonatomic, strong) NSMenuItem *autoStartMenu;
@property (nonatomic, strong) NSMenuItem *aboutAppMenu;
@property (nonatomic, strong) NSMenuItem *durationMenu;
@property (nonatomic, strong) NSMenuItem *shutdownMenu;

- (instancetype)initMainMenuWithTitle:(NSString *)title;
- (instancetype)initSubMenuWithTitle:(NSString *)title;
- (void)addItemWithTitle:(NSString *)title
                     tag:(int)tag
                selector:(SEL)selector
                  target:(id)sender;
- (void)resetStateForMenuItems;

@end
