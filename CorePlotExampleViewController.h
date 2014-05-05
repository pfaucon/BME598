#import <UIKit/UIKit.h>

#import "CorePlot-CocoaTouch.h"
#import "XivelyManager.h"
#import "XivelyData.h"
#import "XivelyTimepoint.h"

@interface CorePlotExampleViewController : UIViewController <CPTPlotDataSource,UIAlertViewDelegate>


@property (nonatomic) XivelyManager *dataManager;
@property (nonatomic) XivelyData *currentData;

@end