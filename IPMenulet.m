//
//  IPMenulet.m
//  iTunes Current Track
//
//  Created by Evan D. Hoffman on 10/13/11.
//  Copyright 2011. All rights reserved.
//

#import "IPMenulet.h"
#import "iTunes.h"

@implementation IPMenulet

-(void)dealloc
{
    [statusItem release];
    [theMenu release];
    [currentTrackMenuItem release];
    [currentArtistMenuItem release];
    [currentAlbumMenuItem release];
    [super dealloc];
}

- (void)awakeFromNib
{
    iTunes = (iTunesApplication *)[[SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"] retain];

    // Listen for track changes
    NSDistributedNotificationCenter *dnc = [NSDistributedNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(updateSongTitle:) name:@"com.apple.iTunes.playerInfo" object:nil];
    [dnc addObserver:self selector:@selector(updateWikipedia:) name:@"com.apple.iTunes.playerInfo" object:nil];

    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [statusItem setHighlightMode:YES];
    [statusItem setTitle:[NSString stringWithString:@"♪"]];
    [statusItem setEnabled:YES];
    [statusItem setToolTip:@"Song Title Menulet"];

    // Build date
    NSString * buildDate = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"DDBuildDate"];

    // Menu display
    [statusItem setMenu:theMenu];
    currentTrackMenuItem = [[NSMenuItem alloc]
        initWithTitle:@"<No Information>"
               action:@selector(updateSongTitle:)
        keyEquivalent:@""];
    currentArtistMenuItem = [[NSMenuItem alloc]
        initWithTitle:@"<No Information>"
               action:@selector(updateSongTitle:)
        keyEquivalent:@""];
    currentAlbumMenuItem = [[NSMenuItem alloc]
        initWithTitle:@"<No Information>"
               action:@selector(updateSongTitle:)
        keyEquivalent:@""];

    currentTrackFileName = [[NSMenuItem alloc]
        initWithTitle:@"<No Information>"
               action:@selector(updateSongTitle:)
        keyEquivalent:@""];

    currentTrackYear = [[NSMenuItem alloc]
        initWithTitle:@"<No Information>"
               action:@selector(updateSongTitle:)
        keyEquivalent:@""];

    currentTrackFileSize = [[NSMenuItem alloc]
        initWithTitle:@"<No Information>"
               action:@selector(updateSongTitle:)
        keyEquivalent:@""];

    currentTrackLength = [[NSMenuItem alloc]
        initWithTitle:@"<No Information>"
               action:@selector(updateSongTitle:)
        keyEquivalent:@""];

    currentTrackBitrate = [[NSMenuItem alloc]
        initWithTitle:@"<No Information>"
               action:@selector(updateSongTitle:)
        keyEquivalent:@""];
    buildDateItem = [[NSMenuItem alloc]
        initWithTitle:[NSString stringWithFormat:@"Build date: %@",buildDate]
               action:@selector(updateSongTitle:)
        keyEquivalent:@""];

    [currentTrackMenuItem setTarget:self];
    [currentArtistMenuItem setTarget:self];
    [currentAlbumMenuItem setTarget:self];
    [currentTrackFileName setTarget:self];
    [currentTrackYear setTarget:self];
    [currentTrackFileSize setTarget:self];
    [currentTrackLength setTarget:self];
    [currentTrackBitrate setTarget:self];

    [buildDateItem setTarget:self];

    [theMenu insertItem:currentTrackMenuItem atIndex:1];
    [theMenu insertItem:currentArtistMenuItem atIndex:3];
    [theMenu insertItem:currentAlbumMenuItem atIndex:5];
    [theMenu insertItem:currentTrackYear atIndex:7];
    [theMenu insertItem:currentTrackLength atIndex:9];
    [theMenu insertItem:currentTrackFileName atIndex:12];
    [theMenu insertItem:currentTrackFileSize atIndex:14];
    [theMenu insertItem:currentTrackBitrate atIndex:16];
    [theMenu insertItem:buildDateItem atIndex:17];

    // Update the song info immediately so we don't have to wait for the track to change.
    [self updateSongTitle:nil];

    // Update wikipedia window
    [self updateWikipedia:nil];
}

-(void)updateSongTitle:(NSNotification *)notification
{
    if (iTunes != NULL && [iTunes isRunning]) {
        iTunesTrack *currentTrack = [iTunes currentTrack];
        NSString *trackLocation = @"?";

        if (currentTrack != NULL) {
            trackLocation = [NSString stringWithFormat:@"%@",[currentTrack kind]];

            switch ([iTunes playerState]) {
                case iTunesEPlSStopped:
                  [statusItem setTitle:@"♪◼"];
                  break;
                case iTunesEPlSPaused:
                 [statusItem setTitle:@"♪‖"];
                 break;
                case iTunesEPlSPlaying:
                  [statusItem setTitle:@"♪▶"];
                  break;
                default:
                  [statusItem setTitle:@"♪"];
                  break;
            }

            [currentTrackMenuItem setTitle:([currentTrack name] == nil) ? @"" : [NSString stringWithString:[currentTrack name]]];
            [currentArtistMenuItem setTitle:([currentTrack name] == nil) ? @"" : [NSString stringWithString:[currentTrack artist]]];
            [currentAlbumMenuItem setTitle:([currentTrack name] == nil) ? @"" : [NSString stringWithString:[currentTrack album]]];
            [currentTrackYear setTitle:([currentTrack year] > 0) ? [NSString stringWithFormat:@"%d",[currentTrack year]] : @"?"];
            [currentTrackLength setTitle:([currentTrack time] == nil) ? @"?" : [NSString stringWithString:[currentTrack time]]];
            [currentTrackFileName setTitle:([currentTrack name] == nil) ? @"" : [NSString stringWithFormat:@"%@ - %@",[currentTrack className],trackLocation]];
            [currentTrackFileSize setTitle:([currentTrack size] > 0) ? [NSString stringWithFormat:@"%0.2f MB",([currentTrack size]/1048576.0)] : @"?"];
            [currentTrackBitrate setTitle:([currentTrack name] == nil) ? @"" : [NSString stringWithFormat:@"%d kbps",[currentTrack bitRate]]];
        } else {
            [statusItem setTitle: [NSString stringWithString:@"♪!"]];
            [currentTrackMenuItem setTitle:@"<Unable to determine current track>"];
            [currentArtistMenuItem setTitle:@""];
            [currentAlbumMenuItem setTitle:@""];
            [currentTrackYear setTitle:@""];
            [currentTrackLength setTitle:@""];
            [currentTrackFileName setTitle:@""];
            [currentTrackFileSize setTitle:@""];
            [currentTrackBitrate setTitle:@""];
        }

    } else {
        [statusItem setTitle: [NSString stringWithString:@"♪?"]];
        [currentTrackMenuItem setTitle:@"<iTunes not running>"];
        [currentArtistMenuItem setTitle:@""];
        [currentAlbumMenuItem setTitle:@""];
        [currentTrackYear setTitle:@""];
        [currentTrackLength setTitle:@""];
        [currentTrackFileName setTitle:@""];
        [currentTrackFileSize setTitle:@""];
        [currentTrackBitrate setTitle:@""];
    }
}

-(void)updateWikipedia:(NSNotification *)notification
{
    if (iTunes != NULL && [iTunes isRunning] && [panel isVisible]) {
        if ([iTunes playerState] == iTunesEPlSPlaying) {
            iTunesTrack *currentTrack = [iTunes currentTrack];
            [webView setMainFrameURL:[NSString stringWithFormat:@"http://google.com/search?sourceid=navclient&btnI=1&q=wikipedia+%@+%@", [currentTrack artist], [currentTrack album]]];
            [panel setTitle: [currentTrack album]];
        }
    }
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//            [panel setTitle: [webView stringByEvaluatingJavaScriptFromString: @"document.title"]];
//}

-(IBAction)toggleWikipedia:(id)sender
{
    if ([panel isVisible]) {
        [panel orderOut:nil];
        return;
    }

    [panel makeKeyAndOrderFront:nil];
}


@end
