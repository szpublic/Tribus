//
//  TaedioAspire.m
//  ChipmunkWrapper
//
//  Created by Aymeric Lamboley on 31/05/12.
//  Copyright (c) 2012 Sodeso. All rights reserved.
//

#import "TaedioAspire.h"
#import "CitrusEngine.h"

@implementation TaedioAspire

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

- (void) update {
    
    [super update];
    
    if (!hero) {
        
        hero = [ce.state getObjectByName:@"hero"];
        
    } else {
        
        if (hero.x - hero.width > body.position.x) {
            
            self.kill = YES;
        }
    }
}

- (void) defineShape {
    
    [super defineShape];
    
    [shape setSensor:YES];
    [shape setCollisionType:@"taedioAspire"];
}

- (void) simpleInit {
    
    [super.space addCollisionHandlerBetween:@"hero" andTypeB:@"taedioAspire" target:self begin:@selector(collisionStart) preSolve:NULL postSolve:NULL separate:@selector(collisionEnd)];
}

- (void) collisionStart {
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"ecranFumee" object:nil];
    
}

@end
