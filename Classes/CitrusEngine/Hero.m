//
//  Hero.m
//  ChipmunkWrapper
//
//  Created by Aymeric Lamboley on 05/03/12.
//  Copyright (c) 2012 Sodeso. All rights reserved.
//

#import "Hero.h"
#import "CitrusEngine.h"

@implementation Hero

@synthesize animation, sensorOnGround, velocityX, move, usingBouclier, usingAutoDrive;

- (id) initWithName:(NSString *)paramName params:(NSDictionary *)params {
    
    if (self = [super initWithName:paramName params:params]) {
        
        [self simpleInit];
    }
    
    return self;
}

- (id) initWithName:(NSString *)paramName params:(NSDictionary *)params andGraphic:(SPDisplayObject *)displayObject {
    
    if (self = [super initWithName:paramName params:params andGraphic:displayObject]) {
        
        [self simpleInit];
    }
    
    return self;
}

- (void) simpleInit {
    
    [body setMoment:INFINITY];
    
    bulle = [[AnimationSequence alloc] initWithTextureAtlas:[SPTextureAtlas atlasWithContentsOfFile:@"bulle.xml"] andAnimations:[NSArray arrayWithObjects:@"bulle", nil] andFirstAnimation:@"bulle"];
    
    usingBouclier = NO;
    usingAutoDrive = NO;
    
    move = TRUE;
    
    velocityX = 30;
    
    isOnGround = FALSE;
    
    jumpHeight = -175;
    jumpAcceleration = 5;
    jumpDeceleration = 7;
    
    [ce.state addEventListener:@selector(touched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    
    [space addCollisionHandlerBetween:@"sensorGround" andTypeB:@"platform" target:self begin:@selector(onGround) preSolve:NULL postSolve:NULL separate:@selector(endGround)];
}

- (void) destroy {
    
    [body removeShape:sensorOnGround];
    sensorOnGround = nil;
    
    [space removeCollisionHandlerFor:@"sensorGround" andTypeB:@"platform"];
    
    [ce.state removeEventListener:@selector(touched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    
    [super destroy];
}

- (void) hurt {
    
    [(AnimationSequence *)graphic colorClignote];
}

- (void) touched:(SPTouchEvent *) event {
    
    SPTouch *begin = [[event touchesWithTarget:ce.state andPhase:SPTouchPhaseBegan] anyObject];
    
    if (begin) {
        touchScreen = TRUE;
        
    }
    
    SPTouch *end = [[event touchesWithTarget:ce.state andPhase:SPTouchPhaseEnded] anyObject];
    
    if (end) {
        touchScreen = FALSE;
    }
    
}

- (void) startBouclier {
    
    timerBouclier = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(endBouclier:) userInfo:nil repeats:NO];
    
    usingBouclier = YES;
    [graphic addChild:bulle];
}

- (void) endBouclier:(NSTimer *) timer {
    
    timerBouclier = nil;
    usingBouclier = NO;
    [graphic removeChild:bulle];
}

- (void) startAutoDrive {
    
    timerAutoDrive = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(endAutoDrive:) userInfo:nil repeats:NO];
    
    usingAutoDrive = YES;
    graphic.alpha = 0.5;
}

- (void) endAutoDrive:(NSTimer *)timer {
    
    timerAutoDrive = nil;
    usingAutoDrive = NO;
    graphic.alpha = 1;
}

- (void) updateAnimation {
    
    NSString *prevAnim = animation;

    if ([animation isEqualToString:@"passage_piege"]) {
        
        prevAnim = @"pasImportant";
        animation = @"passage_piege";
        loopAnimation = NO;
        
    } else if (touchScreen) {
        
        if ([body velocity].y < 0) {
            
            animation = @"saut";
            loopAnimation = YES;
        } else {
            animation = @"haut";
            loopAnimation = FALSE;
        }
        
    } else if (body.velocity.y > 0) {
        
        animation = @"descente";
        loopAnimation = YES;
        
    } else if (body.velocity.x > 0) {
        
        animation = @"base";
        loopAnimation = YES;
        
    } else {
        
        animation = @"fin";
        loopAnimation = FALSE;
    }
    
    //change animation :
    if (![prevAnim isEqualToString:animation]) {

        if ([graphic isKindOfClass:[AnimationSequence class]]) {
            [(AnimationSequence *)graphic changeAnimation:animation withLoop:loopAnimation];
        }
    }
}

- (void) update {
    
    [super update];
    
    cpVect velocity = [body velocity];
    
    velocity.x = velocityX;
    
    if (touchScreen) {
        
        if (isOnGround) {
            
            velocity.y = jumpHeight;
            
        } else if (velocity.y < 0) {
            
            velocity.y -= jumpAcceleration;
            
        } else {
            
            velocity.y -= jumpDeceleration;
        }
    }
    
    if (move == 0)
      velocityX = 0;
    
    [body setVelocity:velocity];

    [self updateAnimation];
}

- (void) createShape {
    
    [super createShape];
    
    sensorOnGround = [body addRectangleWithWidth:10 height:10 offset:cpv(0, heightBody / 2)];
    
    [sensorOnGround addToSpace];
}

- (void) defineShape {
    
    [super defineShape];
    
    [shape setCollisionType:@"hero"];
    
    [sensorOnGround setSensor:YES];
    [sensorOnGround setCollisionType:@"sensorGround"];
}

- (void) onGround {
    isOnGround = YES;
}

- (void) endGround {
    isOnGround = FALSE;
}

@end
