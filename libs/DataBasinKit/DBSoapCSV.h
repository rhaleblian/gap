/*
  Project: DataBasin

  Copyright (C) 2008-2014 Free Software Foundation

  Author: Riccardo Mottola

  Created: 2011-11-08 22:44:45 +0100 by multix

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Library General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free
  Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
  Boston, MA 02111 USA.
*/

#import <Foundation/Foundation.h>

#import <WebServices/WebServices.h>
#import "DBCSVWriter.h"
#import "DBCSVReader.h"

@class DBSObject;
@class DBSoap;

@protocol DBProgressProtocol;
@protocol DBLoggerProtocol;

@interface DBSoapCSV : NSObject
{
  id<DBLoggerProtocol> logger;
  DBSoap *db;
}

- (void)setDBSoap: (DBSoap *)dbs;
- (void)query :(NSString *)queryString queryAll:(BOOL)all toWriter:(DBCSVWriter *)writer progressMonitor:(id<DBProgressProtocol>)p;
- (void)queryIdentify :(NSString *)queryString queryAll:(BOOL)all fromReader:(DBCSVReader *)reader toWriter:(DBCSVWriter *)writer withBatchSize:(int)bSize progressMonitor:(id<DBProgressProtocol>)p;
- (NSMutableArray *)create :(NSString *)objectName fromReader:(DBCSVReader *)reader progressMonitor:(id<DBProgressProtocol>)p;
- (NSMutableArray *)update :(NSString *)objectName fromReader:(DBCSVReader *)reader progressMonitor:(id<DBProgressProtocol>)p;
- (NSMutableArray *)deleteFromReader:(DBCSVReader *)reader progressMonitor:(id<DBProgressProtocol>)p;
- (void)describeSObject: (NSString *)objectType toWriter:(DBCSVWriter *)writer;


@end


