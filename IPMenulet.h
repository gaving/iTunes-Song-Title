//
//  IPMenulet.h
//  iTunes Current Track
//
//  Created by Evan D. Hoffman on 10/13/11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "iTunes.h"

@interface IPMenulet : NSObject {
    iTunesApplication *iTunes;

    IBOutlet NSMenu *theMenu;
    IBOutlet WebView *webView;
    IBOutlet NSPanel *panel;

    NSStatusItem *statusItem;
    NSMenuItem *currentTrackMenuItem;
    NSMenuItem *currentArtistMenuItem;
    NSMenuItem *currentAlbumMenuItem;

    NSMenuItem *currentTrackFileName;
    NSMenuItem *currentTrackFileSize;
    NSMenuItem *currentTrackYear;
    NSMenuItem *currentTrackLength;
    NSMenuItem *currentTrackBitrate;

    NSMenuItem *buildDateItem;
}

-(IBAction)updateSongTitle:(id)sender;
-(IBAction)updateWikipedia:(id)sender;
-(IBAction)toggleWikipedia:(id)sender;

@end
