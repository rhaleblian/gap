/* 
   Project: FTP

   Copyright (C) 2005 Riccardo Mottola

   Author: Riccardo Mottola

   Created: 2005-03-30
   
   Application Controller

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

#define connectionModeKey @"connectionMode" 

#import <AppKit/AppKit.h>
#import "ftpclient.h"
#import "localclient.h"
#import "fileTable.h"

#include <sys/time.h>

@interface AppController : NSObject
{
    IBOutlet NSWindow            *mainWin;
    IBOutlet NSTableView         *localView;
    IBOutlet NSTableView         *remoteView;
    IBOutlet NSPopUpButton       *localPath;
    IBOutlet NSPopUpButton       *remotePath;
    IBOutlet NSButton            *buttDownload;
    IBOutlet NSButton            *buttUpload;
    IBOutlet NSTextField         *infoMessage;
    IBOutlet NSTextField         *infoSpeed;
    IBOutlet NSTextField         *infoSize;
    IBOutlet NSProgressIndicator *progBar;
    
    IBOutlet NSWindow     *logWin;
    IBOutlet NSTextView   *logTextField;
    
    IBOutlet NSPanel      *connectPanel;
    IBOutlet NSTextField  *connAddress;
    IBOutlet NSTextField  *connPort;
    IBOutlet NSTextField  *connUser;
    IBOutlet NSTextField  *connPass;
    IBOutlet NSButton     *connAnon;

    IBOutlet NSPanel     *prefPanel;
    IBOutlet NSMatrix    *portType;
    
    fileTable   *localTableData;
    fileTable   *remoteTableData;
    ftpclient   *ftp;
    localclient *local;

    @private connectionModes    connMode;
    @private struct timeval     beginTimeVal;
    @private struct timeval     lastTimeVal;
    @private unsigned long long transferSize;
    @private BOOL               threadRunning;
}

+ (void)initialize;

- (id)init;
- (void)dealloc;

- (void)awakeFromNib;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotif;
- (BOOL)applicationShouldTerminate:(id)sender;
- (void)applicationWillTerminate:(NSNotification *)aNotif;
- (BOOL)application:(NSApplication *)application openFile:(NSString *)fileName;

- (void)updatePath :(NSPopUpButton *)path :(NSArray *)pathArray;

- (IBAction)changePathFromMenu:(id)sender;
- (void)listDoubleClick:(id)sender;
- (IBAction)downloadButton:(id)sender;
- (IBAction)uploadButton:(id)sender;
- (IBAction)localDelete:(id)sender;
- (IBAction)remoteDelete:(id)sender;

- (void)setTransferBegin:(NSString *)name :(unsigned long long)size;
- (void)setTransferProgress:(unsigned long)bytes;
- (void)setTransferEnd:(unsigned long)bytes;

- (IBAction)disconnect:(id)sender;

- (IBAction)showPrefPanel:(id)sender;
- (IBAction)prefSave:(id)sender;
- (IBAction)prefCancel:(id)sender;

- (IBAction)showFtpLog:(id)sender;
- (void)appendTextToLog:(NSString *)textChunk;

- (IBAction)showConnPanel:(id)sender;
- (IBAction)connectConn:(id)sender;
- (IBAction)cancelConn:(id)sender;
- (IBAction)anonymousConn:(id)sender;

- (void)showAlertDialog:(NSString*)message;

/* accessor */
- (connectionModes)connectionMode;
@end

@interface fileTransmitParms : NSObject
{
    @public fileElement *file;
    @public localclient *localClient;
    @public int         depth;
}
@end
