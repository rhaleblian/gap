/*
 Project: Graphos
 GRBezierPathEditor.m

 Copyright (C) 2000-2008 GNUstep Application Project

 Author: Enrico Sersale (original GDRaw implementation)
 Author: Ing. Riccardo Mottola

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

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "GRBezierControlPoint.h"
#import "GRBezierPath.h"
#import "GRPathEditor.h"

@class GRDocView;

@interface GRBezierPathEditor : GRObjectEditor
{
    BOOL groupSelected;
    BOOL editSelected;
    BOOL isdone;
    BOOL isvalid;
    float zmFactor;
}

- (id)initEditor:(GRBezierPath *)anObject;


- (BOOL)isdone;
- (void)setIsDone:(BOOL)status;

- (void)selectAsGroup;
- (void)selectForEditing;
- (BOOL)isGroupSelected;
- (BOOL)isEditSelected;
- (BOOL)isSelect;

- (void)unselectOtherControls:(GRBezierControlPoint *)cp;

- (void)setIsValid:(BOOL)value;
- (BOOL)isValid;


- (NSPoint)moveBezierHandleAtPoint:(NSPoint)p;
- (void)moveBezierHandleAtPoint:(NSPoint)oldp toPoint:(NSPoint)newp;

@end

