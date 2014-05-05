    //
//  CorePlotExampleViewController.m
//  BME598_final_project
//
//  Created by philippe faucon on 4/17/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "CorePlotExampleViewController.h"

#define NUMBER_OF_HOURS 1

@interface CorePlotExampleViewController ()
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *hostView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *graphSelector;

@property (strong, nonatomic) IBOutlet UITextField *setTemperatureTextField;

@property int delayAlerts;
@property (nonatomic)  NSDate *delayStart;
@end

@implementation CorePlotExampleViewController
{
    CPTXYGraph *graph;
}

-(void) configureData
{
    NSLog(@"max and min timestamps: %@ : %@", self.dataManager.temperature.maxTime, self.dataManager.temperature.minTime);
    
    NSString *selected = [self.graphSelector titleForSegmentAtIndex:self.graphSelector.selectedSegmentIndex];
    if([@"Temperature" compare:selected options:NSCaseInsensitiveSearch] == 0)
    {
        self.currentData = self.dataManager.temperature;
    }
    else
    {
        self.currentData = self.dataManager.humidity;
    }

}

- (IBAction)updatePlot:(id)sender {
    // if the user selects a different tab we should reload our data to showthe proper thing
    [self.dataManager requestUpdateWithCallback:^{
        
        [self configureData];
        [self updateData];
        [self.hostView.hostedGraph reloadData];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.dataManager requestUpdateWithCallback:^{
        [self updateData];
        [self updateData];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateData)
                                                 name:@"XivelyManagerDataUpdate"
                                               object:nil];
    
    // if the data manager gets a new temperature see if it is in range
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkTempOutOfRange)
                                                 name:@"XivelyManagerDataUpdate"
                                               object:nil];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateData];
}

-(void)updateData
{
    NSLog(@"Updating data!\n");
    [self configureData];
    [graph reloadData];
    //[self initializePlot];
    
    NSTimeInterval oneHour = 60 * 60;
    
    //NSDate *refDate = self.currentData.minTime;
    NSDate *refDate = [self.currentData.currentTimepoint.timestamp dateByAddingTimeInterval:-oneHour * NUMBER_OF_HOURS];
    
    // Invert graph view to compensate for iOS coordinates
    CGAffineTransform verticalFlip = CGAffineTransformMakeScale(1,-1);
    self.view.transform = verticalFlip;
    
    // allocate the graph within the current view bounds
    graph = [[CPTXYGraph alloc] initWithFrame: self.view.bounds];
    
    // assign theme to graph
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:theme];
    
    // Setting the graph as our hosting layer
    CPTGraphHostingView *hostingView = self.hostView;
    
    hostingView.hostedGraph = graph;
    
    // setup a plot space for the plot to live in
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    NSTimeInterval xLow = 0.0f;
    // sets the range of x values
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow)
                                                    length:CPTDecimalFromFloat(oneHour * NUMBER_OF_HOURS)];
    // sets the range of y values
    
    int miny = MIN(self.currentData.minValue-3,0);
    int maxy = MAX(self.currentData.maxValue+3,30);
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(miny)
                                                    length:CPTDecimalFromFloat(maxy)];
    
    // plotting style is set to line plots
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 2.0f;
    
    // X-axis parameters setting
    CPTXYAxisSet *axisSet = (id)graph.axisSet;
    axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(oneHour/4);
    axisSet.xAxis.minorTicksPerInterval = 0;
    axisSet.xAxis.orthogonalCoordinateDecimal = CPTDecimalFromString(@"1"); //added for date, adjust x line
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.minorTickLength = 5.0f;
    axisSet.xAxis.majorTickLength = 7.0f;
    axisSet.xAxis.labelOffset = 3.0f;
    
    axisSet.xAxis.title = @"time of day";
    axisSet.xAxis.titleOffset = -15;
    
    
    NSString *selected = [self.graphSelector titleForSegmentAtIndex:self.graphSelector.selectedSegmentIndex];

    axisSet.yAxis.title = selected;
    axisSet.yAxis.titleOffset = -20;
    
    // added for date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateStyle = kCFDateFormatterShortStyle;
    //dateFormatter.dateStyle = kCFDateFormatterNoStyle;
    //dateFormatter.timeStyle = kCFDateFormatter;
    [dateFormatter setDateFormat:@"HH:mm"];
    CPTTimeFormatter *timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    timeFormatter.referenceDate = refDate;
    axisSet.xAxis.labelFormatter = timeFormatter;
    
    // Y-axis parameters setting
    axisSet.yAxis.majorIntervalLength = CPTDecimalFromString(@"5");
    axisSet.yAxis.minorTicksPerInterval = 2;
    axisSet.yAxis.orthogonalCoordinateDecimal = CPTDecimalFromFloat(oneHour); // added for date, adjusts y line
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 7.0f;
    axisSet.yAxis.labelOffset = 3.0f;
    
    
    // This actually performs the plotting
    CPTScatterPlot *xSquaredPlot = [[CPTScatterPlot alloc] init];
    
    CPTMutableLineStyle *dataLineStyle = [CPTMutableLineStyle lineStyle];
    xSquaredPlot.identifier = @"Date Plot";
    
    dataLineStyle.lineWidth = 1.0f;
    dataLineStyle.lineColor = [CPTColor whiteColor];
    xSquaredPlot.dataLineStyle = dataLineStyle;
    xSquaredPlot.dataSource = self;
    
    CPTPlotSymbol *greenCirclePlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    greenCirclePlotSymbol.fill = [CPTFill fillWithColor:[CPTColor greenColor]];
    greenCirclePlotSymbol.size = CGSizeMake(2.0, 2.0);
    xSquaredPlot.plotSymbol = greenCirclePlotSymbol;
    
    // add plot to graph
    graph.paddingBottom = 10;
    graph.paddingLeft = 10;
    graph.paddingRight = 10;
    graph.paddingTop = 10;
    
    graph.plotAreaFrame.paddingRight = 20;
    
    [graph addPlot:xSquaredPlot];
    
    CGAffineTransform normalFlip = CGAffineTransformMakeScale(1,1);
    self.view.transform = normalFlip;
}

#pragma mark - Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
    // add a point at the beginning of time, and one at the end of time
    return self.currentData.timePoints.count +2;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    index = index-1;
    NSTimeInterval oneHour = 60 * 60;
    // This method is actually called twice per point in the plot, one for the X and one for the Y value
    if(fieldEnum == CPTScatterPlotFieldX)
    {
        if(self.currentData.timePoints.count <2)
            return [NSNumber numberWithDouble:0];
        if(index ==-1)
            return [NSNumber numberWithDouble:0];
        if(index == self.currentData.timePoints.count)
            return [NSNumber numberWithDouble:oneHour*NUMBER_OF_HOURS];
        
        double timestamp = [((XivelyTimepoint *)self.currentData.timePoints[index]).timestamp timeIntervalSince1970];
        double baseline = [[[NSDate date] dateByAddingTimeInterval:-oneHour*NUMBER_OF_HOURS ] timeIntervalSince1970];
        return [NSNumber numberWithDouble:(timestamp-baseline)];
    } else {
        if(self.currentData.timePoints.count <2)
            return [NSNumber numberWithDouble:self.currentData.currentTimepoint.value];
        if(index ==-1)
            return [NSNumber numberWithDouble:((XivelyTimepoint *)self.currentData.timePoints[1]).value];
        if(index == self.currentData.timePoints.count)
            return [NSNumber numberWithDouble:((XivelyTimepoint *)self.currentData.timePoints[index-1]).value];
        return [NSNumber numberWithDouble:((XivelyTimepoint *)self.currentData.timePoints[index]).value];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)setDesiredTemperature:(id)sender {
    [self.dataManager setDesiredTemperature:self.setTemperatureTextField.text.doubleValue];
}


//if the temperature is above 37c then inform the attending nurse
-(void) checkTempOutOfRange
{
    
    BOOL outOfRange = NO;
    NSString *errorMsg = @"All clear!";
    
    if([XivelyManager sharedInstance].temperature.currentTimepoint.value >37)
    {
        outOfRange = true;
        errorMsg = @"the incubator is too hot!";
    }
    
    //it should be around 36.5, but we don't have a heating element so it will be cooler than that
    if([XivelyManager sharedInstance].temperature.currentTimepoint.value <25)
    {
        outOfRange = true;
        errorMsg = @"the incubator is too cold!";
    }
    
    if(outOfRange && [[NSDate date] timeIntervalSinceDate:self.delayStart] >60)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incubator temp out of range!" message:errorMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"snooze alerts", nil];
        [alert show];
    }
    
}

#pragma mark - Alert View Delegation

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == alertView.firstOtherButtonIndex)
    {
        self.delayAlerts = 10;
        self.delayStart = [NSDate date];
    }
}

#pragma mark - lazy instantiator
-(XivelyManager *) dataManager
{
    //if we weren't told which manager to use then use the global (only) one
    if(!_dataManager) _dataManager = [XivelyManager sharedInstance];
    return _dataManager;
}

-(NSDate *) delayStart
{
    if(!_delayStart) _delayStart = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    return _delayStart;
}

@end
