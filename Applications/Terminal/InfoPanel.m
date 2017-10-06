/*
  Class:               InfoPanel
  Inherits from:       NSObject
  Class descritopn:    Panel to show information about application.
                       Called from menu Info->Info Panel...

  Copyright (C) 2017 Sergii Stoian

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#import "InfoPanel.h"
#import "Controller.h"
#import "Defaults.h"

@implementation InfoPanel : NSObject

- (void)activatePanel
{
  Defaults   *prefs;
  
  if (titlePanel == nil)
    {
      [NSBundle loadNibNamed:@"SetTitlePanel" owner:self];
    }

  prefs = [[NSApp delegate] preferencesForWindow:[NSApp mainWindow] live:YES];
  if (!prefs)
    prefs = [[NSApp delegate] preferencesForWindow:[NSApp mainWindow] live:NO];
  
  titleBarMask = [prefs titleBarElementsMask];
  [titleField setStringValue:[prefs customTitle]];

  [titlePanel makeKeyAndOrderFront:self];
  // [NSApp runModalForWindow:titlePanel];
}

- (void)awakeFromNib
{
  [titlePanel makeFirstResponder:titleField];

  [[NSNotificationCenter defaultCenter]
    addObserver:self
       selector:@selector(mainWindowDidChange:)
           name:NSWindowDidBecomeMainNotification
         object:nil];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super dealloc];
}

//--- Notifications and delagates
- (void)mainWindowDidChange:(NSNotification *)notif
{
  Defaults *prefs;

  prefs = [[NSApp delegate] preferencesForWindow:[notif object] live:YES];
  if (!prefs)
    prefs = [[NSApp delegate] preferencesForWindow:[notif object] live:NO];
  
  // Main window is not terminal window
  if (prefs == nil) return;

  // Main terminal window left unchanged
  if (mainWindow == [notif object]) return;
  
  mainWindow = [notif object];
  titleBarMask = [prefs titleBarElementsMask];
  [titleField setStringValue:[prefs customTitle]];
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
  // [titleField resignFirstResponder];
  [titlePanel makeFirstResponder:setBtn];
}
@end
