//
//  FXNotifications.h
//
//  Version 1.0.2
//
//  Created by Nick Lockwood on 20/11/2013.
//  Copyright (c) 2013 Charcoal Design
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/FXNotifications
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//


#import <Foundation/Foundation.h>

@interface NSNotificationCenter (FXNotifications)

- (void)addObserver:(id)observer
            forName:(NSString *)name
             object:(id)object
              queue:(NSOperationQueue *)queue
         usingBlock:(void (^)(NSNotification *note, __weak id observer))block;

@end
