
@class RFStatusItemView;
/*!
 *  @protocol RFStatusItemViewDelegate
 *  @brief The Status Item View delegate.
 *  @version 1.0.1
 *  @author Ardalan Samimi
 *  @copyright Saturn Five
 */
@protocol RFStatusItemViewDelegate <NSObject>

- (void)statusItemView:(RFStatusItemView *)view
   didReceiveLeftClick:(NSEvent *)theEvent;
- (void)statusItemView:(RFStatusItemView *)view
  didReceiveRightClick:(NSEvent *)theEvent;

@end
/*!
 *  @protocol RFStatusItemView
 *  @brief The Status Item View.
 *  @version 1.0.0
 *  @author Ardalan Samimi
 *  @copyright Saturn Five
 */
@interface RFStatusItemView : NSView

@property (weak) id delegate;
@property (nonatomic) BOOL highlightMode;
@property (nonatomic, strong) NSImage *image;

- (instancetype)initWithStatusItem:(NSStatusItem *)item;
- (void)openMenu:(NSMenu *)menu;

@end
