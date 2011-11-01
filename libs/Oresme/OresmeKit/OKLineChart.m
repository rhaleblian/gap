/*
   Project: OresmeKit

   Copyright (C) 2011 Free Software Foundation

   Author: multix

   Created: 2011-09-08 15:09:20 +0200 by multix

   This application is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This application is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
*/

#import <Foundation/Foundation.h>
#import <AppKit/NSBezierPath.h>

#import "OKLineChart.h"
#import "OKSeries.h"

@implementation OKLineChart

-(void)drawRect: (NSRect)rect
{
  NSRect boundsRect;
  unsigned i, j;
  float oneXUnit;
  float oneYUnit;
  float availableHeight;
  float availableWidth;
  float rangeToRepresent;
  float axisLevel;

  /* the super method will have calculated the limits */
  [super drawRect: rect];
  boundsRect = [self bounds];
  availableHeight = boundsRect.size.height * 0.9;
  availableWidth = boundsRect.size.width * 0.9;
  rangeToRepresent = graphMaxYVal - graphMinYVal;
  oneYUnit = availableHeight / rangeToRepresent;
  oneXUnit = availableWidth / graphMaxXVal;

  /* draw axes */
  axisLevel = 0;
  if (graphMinYVal < 0)
    axisLevel = -oneYUnit * graphMinYVal;
  NSLog(@"x-y unit: %f-%f:, axisLevel; %f", oneXUnit, oneYUnit, axisLevel);
  [axisColor set];
  [NSBezierPath strokeRect: NSMakeRect(0, axisLevel, boundsRect.size.width, 0)];
  [NSBezierPath strokeRect: NSMakeRect(0, 0, 0, boundsRect.size.height)];

  /* draw units */
  for (i = 0; i < graphMaxXVal; i++)
    {
      float x;

      x = i * oneXUnit;
      [NSBezierPath strokeRect: NSMakeRect(x, axisLevel-1, 0, 2)];
    }
  for (i = 0; i < graphMaxYVal; i++)
    {
      float y;

      y = i * oneYUnit;
      [NSBezierPath strokeRect: NSMakeRect(0, y, 1, 0)];
    }

  for (i = 0; i < [seriesArray count]; i++)
    {
      NSBezierPath *path;
      OKSeries *series;
      float x;
      float y;
      NSPoint p;

      series = [seriesArray objectAtIndex: i];
      if ([series count] > 0)
	{
	  path = [[NSBezierPath alloc] init];
	  [[series color] set];
	  x = 0;
	  y = axisLevel + [[series objectAtIndex: 0] floatValue] * oneYUnit;
	  p = NSMakePoint(x, y);
	  [path moveToPoint: p];
	  x += oneXUnit;
	  for (j = 1; j < [series count]; j++)
	    {
	      y = axisLevel + [[series objectAtIndex: j] floatValue] * oneYUnit;
	      p = NSMakePoint(x, y);
	      [path lineToPoint: p];
	      x += oneXUnit;
	    }
	  [path stroke];
	  [path release];
	}
    }
}


@end