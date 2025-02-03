#import <Cocoa/Cocoa.h>



void showImage(unsigned char *c_buffer) {
    @autoreleasepool {
        [NSApplication sharedApplication];
        NSImage *image = nil;
        NSLog(@"from objc: %d", c_buffer[0]);

        unsigned char *buffer = c_buffer + 1;

        unsigned char *planes[3];
        planes[0] = buffer;
        planes[1] = buffer + 1024;
        planes[2] = buffer + 2048;

        NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc]
            initWithBitmapDataPlanes:planes
            pixelsWide:32
            pixelsHigh:32
            bitsPerSample:8
            samplesPerPixel:3
            hasAlpha:NO
            isPlanar:YES
            colorSpaceName:NSDeviceRGBColorSpace
            bitmapFormat:NSBitmapFormatAlphaNonpremultiplied
            bytesPerRow:32
            bitsPerPixel:8
        ];
        NSWindow *window = [[NSWindow alloc]
            initWithContentRect:NSMakeRect(0, 0, 200, 200)
            styleMask:(NSWindowStyleMaskTitled |
                       NSWindowStyleMaskClosable |
                       NSWindowStyleMaskResizable)
            backing:NSBackingStoreBuffered
            defer:NO
        ];
        [window makeKeyAndOrderFront:nil];

        if (bitmapRep) {
            CGImageRef cgImage = [bitmapRep CGImage];
            image = [[NSImage alloc] initWithCGImage:cgImage size:NSMakeSize(150, 150)];
        } else {
            NSLog(@"Failed to retrieve CGImage");
            return;
        }

        if (image) {
            NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 200, 200)];
            imageView.image = image;
            [window.contentView addSubview:imageView];
        } else {
            NSLog(@"Failed to load image");
            return;
        }
        [NSApp run];
    }
}
