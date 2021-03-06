/*
   Project: StepSync
   FileObject.m

   Copyright (C) 2017 Free Software Foundation

   Author: Riccardo Mottola

   Created: 2017-02-05

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

#import "FileObject.h"

@implementation FileObject

- (void)setFileAttributes:(NSDictionary *)attr
{
  size = [attr fileSize];
  createdDate = [attr fileCreationDate];
  modifiedDate = [attr fileModificationDate];
}

- (NSString *)absolutePath
{
  return absolutePath;
}

- (void)setAbsolutePath:(NSString *)path
{
  if (absolutePath != path)
    {
      [absolutePath release];
      absolutePath = path;
      [absolutePath retain];
    }
}


- (NSString *)relativePath
{
  return relativePath;
}

- (void)setRelativePath:(NSString *)path
{
  if (relativePath != path)
    {
      [relativePath release];
      relativePath = path;
      [relativePath retain];
    }
}

- (unsigned long long)size
{
  return size;
}

- (NSDate *)createdDate
{
  return createdDate;
}

- (NSDate *)modifiedDate
{
  return modifiedDate;
}

- (NSString *)description
{
  NSString *d;

  d = [NSString stringWithFormat:@"%@", relativePath];
  return d;
}

@end
