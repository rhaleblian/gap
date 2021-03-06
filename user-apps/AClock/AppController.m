/*
 Project: AClock
 AppController.m

 Copyright (C) 2003-2017 GNUstep Application Project

 Author: Alexander Malmberg
         Banlu Kemiyatorn 
         G�rkan Seng�n
         Ing. Riccardo Mottola <rm@gnu.org>

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
 Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#import <AppKit/AppKit.h>
#import "AppController.h"
#import "NSColorExtensions.h"

@implementation AppController
static NSUserDefaults *defaults;
static Clock* clicon = nil;
static BOOL useCuckoo = NO;
static BOOL useRing = NO;
static NSInteger lastHourOfDay = -1;
BOOL keepSoundPlaying = YES;
static int rounds = 0;		// how often to play a sound
static int rounds_done = 0;	// how often a sound was played already

+ (void) initialize
{
	defaults = [NSUserDefaults standardUserDefaults];
}

- (void) setSecondHandColor: (id)sender
{

	NSColor *col = [sender color];
	[_clock setSecondHandColor:col];
	[bigClock setSecondHandColor:col];
	[defaults setObject:[col stringRepresentation] forKey:@"SecondHandColor"];
	[defaults synchronize];
}

- (void) setHandColor: (id)sender
{
	NSColor *col = [sender color];
	[_clock setHandsColor:col];
	[bigClock setHandsColor:col];
	[defaults setObject:[col stringRepresentation] forKey:@"HandsColor"];
	[defaults synchronize];
}

- (void)sound:(NSSound *)sound didFinishPlaying:(BOOL)aBool{
  if (rounds_done < rounds - 1) {
	rounds_done++;
	[sound play];
  } else {
  	keepSoundPlaying = NO;
	rounds_done=0;
	rounds=0;
	[sound release];
  }
}

- (IBAction) setCuckoo: (id) sender
{
	useCuckoo = [sender intValue]?YES:NO;
	[defaults setObject:useCuckoo?@"YES":@"NO" forKey:@"Cuckoo"];
	[defaults synchronize];
	lastHourOfDay = -1;
}

- (IBAction) setRing: (id) sender
{
	useRing = [sender intValue]?YES:NO;
	if (useRing) {
		NSSound *ring = [[NSSound alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"ring.wav" ofType:nil] byReference: NO];
		rounds=1;
		rounds_done=0;
		[ring setDelegate: self];
		[ring play];
	}
	[defaults setObject:useRing?@"YES":@"NO" forKey:@"Ring"];
	[defaults synchronize];
}

- (IBAction) stopRing: (id)sender
{
	[alarmWindow close];
}

- (IBAction) setRingLoop: (id) sender
{
	float f = [sender floatValue];
	NSString *str;
	if (f < 0.1) str = [NSString stringWithFormat:@"Ring Once"];
	else if (f < 0.25) str = [NSString stringWithFormat:@"3 Rings"];
	else if (f < 0.5) str = [NSString stringWithFormat:@"5 Rings"];
	else if (f < 0.75) str = [NSString stringWithFormat:@"10 Rings"];
	else if (f < 0.95) str = [NSString stringWithFormat:@"20 Rings"];
	else str = [NSString stringWithFormat:@"Ring Forever"];
	[ringText setStringValue:str];

	[defaults setObject:[sender stringValue] forKey:@"RingLoop"];
	[defaults synchronize];
}

- (IBAction) setShowsAMPM: (id)sender
{
	[_clock setShowsAMPM:[sender intValue]?YES:NO];
	[bigClock setShowsAMPM:[sender intValue]?YES:NO];
	[defaults setObject:[sender intValue]?@"YES":@"NO" forKey:@"ShowsAMPM"];
	[defaults synchronize];
}

- (IBAction) setIncreasesVolume: (id)sender
{
	[defaults setObject:[sender intValue]?@"YES":@"NO" forKey:@"IncreasesVolume"];
	[defaults synchronize];
}

- (IBAction) setNumberType: (id)sender
{
	[_clock setNumberType:[sender indexOfSelectedItem]];
	[bigClock setNumberType:[sender indexOfSelectedItem]];
	[defaults setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[sender indexOfSelectedItem]] forKey:@"NumberType"];
	[defaults synchronize];
}

- (IBAction) setSecond: (id)sender
{
	[_clock setSecond:[sender intValue]?YES:NO];
	[bigClock setSecond:[sender intValue]?YES:NO];
	[defaults setObject:[sender intValue]?@"YES":@"NO" forKey:@"Second"];
	[defaults synchronize];
}

- (void) setShadow:(id)sender
{
	[_clock setShadow:[sender intValue]?YES:NO];
	[bigClock setShadow:[sender intValue]?YES:NO];
	[defaults setObject:[sender intValue]?@"YES":@"NO" forKey:@"Shadow"];
	[defaults synchronize];
}


- (void) setFaceTransparency: (id)sender
{
	[_clock setFaceTransparency:[sender floatValue]];
	[bigClock setFaceTransparency:[sender floatValue]];
	[defaults setObject:[sender stringValue] forKey:@"FaceTransparency"];
	[defaults synchronize];
}


- (void) setFaceColor: (id)sender
{
	NSColor *col = [sender color];
	[_clock setFaceColor:col];
	[bigClock setFaceColor:col];
	[defaults setObject:[col stringRepresentation] forKey:@"FaceColor"];
	[defaults synchronize];
}

- (void) setMarkColor: (id)sender
{
	NSColor *col = [sender color];
	[_clock setMarksColor:col];
	[bigClock setMarksColor:col];
	[defaults setObject:[col stringRepresentation] forKey:@"MarksColor"];
	[defaults synchronize];
}


- (void) setFrameColor: (id)sender
{
	NSColor *col = [sender color];
	[_clock setFrameColor:col];
	[bigClock setFrameColor:col];
	[defaults setObject:[col stringRepresentation] forKey:@"FrameColor"];
	[defaults synchronize];
}

static NSTimer* ringer = nil;
static int extracount;
static float volume = 1.0;
static float volume_append = 1.0;

- (void) ring
{
	if ([alarmWindow isVisible] && extracount)
	{
		NSSound *ring = [[NSSound alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"ring.wav" ofType:nil] byReference: NO];
		[ring setVolume: volume];
		rounds=1;
		rounds_done=0;
		[ring play];
		extracount--;
		volume += volume_append;
		if (volume > 1.0) volume = 1.0;
	}
	else {
		[ringer invalidate];
		ringer = nil;
	}

}

- (IBAction) clockUpdate: (id)sender
{
	double st,et;
	id src,des;

	if (sender == bigClock)
	{
		src = bigClock;
		des = _clock;
	}
	else
	{
		src = _clock;
		des = bigClock;
	}

	st = [src handsTime];
	et = [src alarmInterval];

	if (et < st && ringer == nil)
	{
		[alarmClock setHandsTime:st];
		[alarmClock setShowsArc:NO];
		[alarmWindow orderFrontRegardless];
		if (useRing)
		{
			NSInvocation *inv;
			float f;
			inv = [NSInvocation invocationWithMethodSignature:
							 [self methodSignatureForSelector:@selector(ring)]];
			[inv setSelector:@selector(ring)];
			[inv setTarget:self];
			extracount = 0;

			volume = 1.0;

			f = [ringSlider floatValue];
			if (f < 0.1) extracount = 1;
			else if (f < 0.25) extracount = 3;
			else if (f < 0.5) extracount = 5;
			else if (f < 0.75) extracount = 10;
			else if (f < 0.95) extracount = 20;
			else {
				extracount = -1;
				if ([incsVolume intValue])
				{
					volume = 0.1;
				}
			}

			if (extracount != -1 && [incsVolume intValue])
			{
				volume = 1.0/(extracount > 10?10:extracount);
			}

			volume_append = volume;

			[self ring];
			ringer = [NSTimer scheduledTimerWithTimeInterval:5.0 invocation:inv repeats:YES];
		}
	}

	[des setHandsTimeNoAlarm:st];
	[des setShowsArc:[src showsArc]];
	[des setAlarmInterval:[src alarmInterval]];

}


- (void) openPreferences: (id)sender
{
	[prefPanel orderFront: self];
}

-(void) applicationWillFinishLaunching: (NSNotification *)not
{
	NSMenu *menu, *m;
	NSWindow *win;
	unsigned int width, height;
	menu = [NSMenu new];
	m = [NSMenu new];

	/* Info */
	[m addItemWithTitle: _(@"Info...")
		action: @selector(orderFrontStandardInfoPanel:)
		keyEquivalent: nil];
	[m addItemWithTitle: _(@"Preferences...")
		action: @selector(openPreferences:)
		keyEquivalent: nil];
	[menu setSubmenu: m forItem: [menu addItemWithTitle: _(@"Info") action:NULL keyEquivalent:nil]];
	[m release];

	[menu addItemWithTitle: _(@"Quit")
		action: @selector(terminate:)
		keyEquivalent: @"q"];

	[NSApp setMainMenu: menu];
	[menu release];

	[[NSUserDefaults standardUserDefaults]
	    registerDefaults:[NSDictionary dictionaryWithObject:@"NO" forKey:@"Cuckoo"]];
	[[NSUserDefaults standardUserDefaults]
	    registerDefaults:[NSDictionary dictionaryWithObject:@"NO" forKey:@"Ring"]];
	[[NSUserDefaults standardUserDefaults]
	    registerDefaults:[NSDictionary dictionaryWithObject:@"0.0" forKey:@"RingLoop"]];
	[[NSUserDefaults standardUserDefaults]
	    registerDefaults:[NSDictionary dictionaryWithObject:@"YES" forKey:@"IncreasesVolume"]];


	win = [NSApp iconWindow];
	width = [[win contentView] bounds].size.width;
	height = [[win contentView] bounds].size.height;

	_clock = [[Clock alloc] initWithFrame: NSMakeRect(1, 1, width - 2, height - 2)];
	[[win contentView] addSubview:_clock];

	[_clock setTarget:self];
	[_clock setAction:@selector(clockUpdate:)];

	{ /* initialize the clock so it won't flick */
		NSCalendarDate *d = [NSCalendarDate date];
		double time;
		time = [d hourOfDay] * 3600 + [d minuteOfHour] * 60 + [d secondOfMinute];
		[_clock setHandsTimeNoAlarm: time];
		[bigClock setHandsTimeNoAlarm: time];

	}

	[[NSUserDefaults standardUserDefaults]
	    registerDefaults:[NSDictionary dictionaryWithObject:@"0.5" forKey:@"RefreshRate"]];
}

- (void) tick
{
  NSCalendarDate *d = [NSCalendarDate date];
  NSTimeInterval g = [d timeIntervalSinceReferenceDate];
  double time;
  NSInteger hod = [d hourOfDay];

  if (useCuckoo && lastHourOfDay != hod)
    {
      int h12clock = hod % 12;
      rounds = h12clock?h12clock:12;
      [self playCuckoo];
      lastHourOfDay = hod;
      if ([defaults boolForKey: @"ShowsDate"])
	[_clock setDate:d];
    }
  if ([_clock showsAMPM])
    {
      [_clock setShowsAMPM:YES];
    }

  if (doFloor)
    {
      time = hod * 3600 + [d minuteOfHour] * 60 + [d secondOfMinute];
    }
  else
    {
      time = hod * 3600 + [d minuteOfHour] * 60 + [d secondOfMinute] + (g - floor(g));
    }

  [_clock setHandsTime: time];
  [bigClock setHandsTime: time];
  [clicon setHandsTime: time];
}

static int cstate = -1;
NSTimer *ctimer;
- (void) cuckoo
{
	if (cstate > -1)
	{
		cstate--;
		[_clock setCuckooState:cstate%20];
	}
	else
	{
		[_clock setCuckooState:-1];
		[ctimer invalidate];
		ctimer = nil;
	}
}


- (void) playCuckoo
{
	if (cstate == -1)
	{
		NSSound *cuckoo = [[NSSound alloc] initWithContentsOfFile: 
			[[NSBundle mainBundle] pathForResource:@"cuckoo.wav" ofType:nil] byReference: NO];
		NSInvocation *inv;
		cstate = 20 * rounds;
		keepSoundPlaying = YES;
		[cuckoo setDelegate:self];
		
		[cuckoo play];
		inv = [NSInvocation invocationWithMethodSignature:
						 [self methodSignatureForSelector:@selector(cuckoo)]];
		[inv setSelector:@selector(cuckoo)];
		[inv setTarget:self];
		ctimer=[NSTimer scheduledTimerWithTimeInterval:0.05 invocation:inv repeats:YES];

	}

}

- (void) setFrequency: (id)sender
{
	NSInvocation *inv;
	float fr, fx, fy;
	inv = [NSInvocation invocationWithMethodSignature:
		[self methodSignatureForSelector:@selector(tick)]];
	[inv setSelector:@selector(tick)];
	[inv setTarget:self];

	fr = [sender floatValue];
	fx = 1.0;
	fy = 1.0;

	while (fx > fr)
	{
		fx -= 0.25;
		fy /= 2;
	}

	if (fx > 0.8) doFloor = YES;
	else doFloor = NO;

	[timer invalidate];
	timer=[NSTimer scheduledTimerWithTimeInterval:fy invocation:inv repeats:YES];

	[freqText setStringValue:[NSString stringWithFormat:@"%0.0f/sec", 1.0/fy]];

	[defaults setObject:[sender stringValue] forKey:@"RefreshRate"];
	[defaults synchronize];
}

- (void) applicationDidFinishLaunching: (NSNotification *)not
{
	id defaults = [NSUserDefaults standardUserDefaults];
	NSInvocation *inv;

	inv = [NSInvocation invocationWithMethodSignature:
		[self methodSignatureForSelector:@selector(tick)]];
	[inv setSelector:@selector(tick)];
	[inv setTarget:self];

	[faceColorW setColor:[_clock faceColor]];
	[ampmSwitch setIntValue:[_clock showsAMPM]];
	useCuckoo = [defaults boolForKey:@"Cuckoo"];
	useRing = [defaults boolForKey:@"Ring"];
	[cuckooSwitch setIntValue:useCuckoo];
	[ringSwitch setIntValue:useRing];
	[shadowSwitch setIntValue:[_clock shadow]];
	[transSlider setFloatValue:[_clock faceTransparency]];
	[handColorW setColor:[_clock handsColor]];
	[secColorW setColor:[_clock secondHandColor]];
	[frameColorW setColor:[_clock frameColor]];
	[markColorW setColor:[_clock marksColor]];
	[secondSwitch setIntValue:[_clock second]];
	[numberPopUp selectItemAtIndex:[_clock numberType]];

	[freqSlider setFloatValue:[defaults floatForKey: @"RefreshRate"]];
	[self setFrequency:freqSlider];
	[ringSlider setFloatValue:[defaults floatForKey: @"RingLoop"]];
	[self setRingLoop:ringSlider];
	[incsVolume setIntValue:[defaults boolForKey: @"IncreasesVolume"]];
	[self setIncreasesVolume:incsVolume];

	/* prevent starting cuckoo */
	lastHourOfDay = [[NSCalendarDate date] hourOfDay];

	if ([defaults boolForKey: @"ShowsDate"])
			 [_clock setDate:[NSCalendarDate date]];
	timer=[NSTimer scheduledTimerWithTimeInterval:[defaults floatForKey: @"RefreshRate"] invocation:inv repeats:YES];


	if ([defaults boolForKey: @"autolaunch"]) {
	    [NSApp hide: self];
	}
}

@end

@interface InfoClock : Clock
@end

@implementation InfoClock
- (NSView*) hitTest: (NSPoint)aPoint
{
	return nil;
}


@end


@interface NSApplication (AClock)
- (void) orderFrontStandardInfoPanelWithOptions: (NSDictionary *) dict;
@end

@implementation NSApplication (AClock)
- (void) orderFrontStandardInfoPanelWithOptions: (NSDictionary *) dict;
{
#if GNUSTEP
	if (_infoPanel == nil)
	{
		_infoPanel = [[GSInfoPanel alloc] initWithDictionary: dict];

		if (clicon == nil)
		{
			NSEnumerator *en = [[[_infoPanel contentView] subviews] objectEnumerator];
			id view;
			while ((view = [en nextObject]))
			{
				if ([view isMemberOfClass:[NSButton class]])
				{
					id image = [view image];

					if (image == [NSApp applicationIconImage] || image == [NSImage imageNamed: @"NSApplicationIcon"])
					{
						NSRect frame = [view frame];
						frame.origin = NSZeroPoint;

						clicon = [[InfoClock alloc] initWithFrame: frame];
						[clicon setShowsArc:NO];
						[view setTitle:@""];
						[view setImage:nil];
						[view addSubview:clicon];
						break;
					}
				}
			}
		}
	}

	[_infoPanel setTitle: NSLocalizedString (@"Info", 
			@"Title of the Info Panel")];

	[_infoPanel orderFront: self];
#endif
}

@end
