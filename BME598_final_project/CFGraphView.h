//
//  CFGraphView.h
//  BME598_final_project
//
//  I will automagically adjust to whatever size I'm given and redraw the data
//  all pretty-like.
//
//
//  Created by philippe faucon on 4/17/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XivelyTimepoint.h"
#import "XivelyData.h"

@interface CFGraphView : UIView

// what are we going to be drawing?
@property XivelyData *data;

@end
