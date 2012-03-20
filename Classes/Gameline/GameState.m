//
//  GameState.m
//  Gameline
//
//  Created by Aymeric Lamboley on 24/02/12.
//  Copyright (c) 2012 Sodeso. All rights reserved.
//

#import "GameState.h"
#import "CitrusObject.h"
#import "PhysicsObject.h"
#import "Platform.h"
#import "Hero.h"
#import "AnimationSequence.h"
#import "BigPicture.h"
#import "Sensor.h"
#import "SXParticleSystem.h"
#import "Particle.h"
#import "ParticleJaune.h"

@implementation GameState

- (id) init {
    
	if (self = [super init]) {
        
        gameWidth = 2868;
        
        //[self showHideDebugDraw];
        
        CitrusObject *parallaxe1 = [[CitrusObject alloc] initWithName:@"bg" params:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"0", @"0", @"0.1", nil] forKeys:[NSArray arrayWithObjects:@"x:", @"y:", @"parallax:", nil]] andGraphic:[SPImage imageWithContentsOfFile:@"parallaxe2.png"]];
        [self addObject:parallaxe1];
        
        BigPicture *parallaxe2 = [[BigPicture alloc] initWithName:@"bg" params:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"0", @"0", @"1", nil] forKeys:[NSArray arrayWithObjects:@"x:", @"y:", @"parallax:", nil]] andPictures:[NSArray arrayWithObjects:@"parallaxe1_1.png", @"parallaxe1_2.png", @"parallaxe1_3.png", nil]];
        [self addObject:parallaxe2];
        
        Platform *platformBot = [[Platform alloc] initWithName:@"platform" params:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", gameWidth / 2], @"320", [NSString stringWithFormat:@"%f", gameWidth], @"10", @"TRUE", nil] forKeys:[NSArray arrayWithObjects:@"x:", @"y:", @"width:", @"height:", @"isStatic:", nil]]];
        [self addObject:platformBot];
        
        Platform *platformTop = [[Platform alloc] initWithName:@"platform" params:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", gameWidth / 2], @"0", [NSString stringWithFormat:@"%f", gameWidth], @"10", @"TRUE", nil] forKeys:[NSArray arrayWithObjects:@"x:", @"y:", @"width:", @"height:", @"isStatic:", nil]]];
        [self addObject:platformTop];
        
        AnimationSequence *mc = [[AnimationSequence alloc] initWithTextureAtlas:[SPTextureAtlas atlasWithContentsOfFile:@"Hero.xml"] andAnimations:[NSArray arrayWithObjects:@"walk", @"jump", @"idle", nil] andFirstAnimation:@"idle"];
        
        Hero *hero = [[Hero alloc] initWithName:@"hero" params:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"20", @"50", @"20", @"20", nil] forKeys:[NSArray arrayWithObjects:@"x:", @"y:", @"width:", @"height:", nil]] andGraphic:mc];
        [self addObject:hero];
        
        ParticleJaune *particle3 = [[ParticleJaune alloc] initWithName:@"particle" params:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"500", @"50", @"20", @"20", nil] forKeys:[NSArray arrayWithObjects:@"x:", @"y:", @"width:", @"height:", nil]] andGraphic:[SXParticleSystem particleSystemWithContentsOfFile:@"jauneParticle.pex"]];
        [self addObject:particle3];
        
        Sensor *sensor = [[Sensor alloc] initWithName:@"sensor" params:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"250", @"150", @"50", @"30", nil] forKeys:[NSArray arrayWithObjects:@"x:", @"y:", @"width:", @"height:", nil]]];
        [self addObject:sensor];
        
        [self setupCamera:hero andOffset:CGPointMake(hero.width / 2, 0) andBounds:CGRectMake(0, 0, gameWidth, 1000) andEasing:CGPointMake(0.25, 0.05)];
        
        
        
        //[self graphismSoutenance:[NSArray arrayWithObjects:@"soutenance1.png", @"soutenance2.png", @"soutenance3.png", nil]];
        
        /*
         Rouge = Orange - Jaune = Violet - Bleu
         Bleu = Vert - Jaune = Violet -Rouge
         Jaune = Orange - Rouge = Vert - Bleu
         Orange = Rouge + Jaune
         Vert = Jaune + Bleu
         Violet = Bleu + Rouge
         */
	}
    
	return self;
}

- (void) graphismSoutenance:(NSArray *) pictures {
    
    graphismEcranSoutenance =  [[SPSprite alloc] init];
    graphismEcranSoutenance.x = 0;
    graphismEcranSoutenance.y = 0;
    
    for (NSString *picture in pictures) {
        
        SPImage *img = [SPImage imageWithContentsOfFile:picture];
        [graphismEcranSoutenance addChild:img];
        
        img.x = graphismEcranSoutenance.x;
        img.y = graphismEcranSoutenance.y;
        
        graphismEcranSoutenance.x += img.width;
    }
    
    [self.stage addChild:graphismEcranSoutenance];
    
    graphismEcranSoutenance.rotation = SP_D2R(90);
    graphismEcranSoutenance.x = 320;
    
    
    [graphismEcranSoutenance addEventListener:@selector(touchedFake:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
}

- (void) touchedFake:(SPTouchEvent *) event {
    
    SPTouch *begin = [[event touchesWithTarget:graphismEcranSoutenance andPhase:SPTouchPhaseBegan] anyObject];
    
    if (begin) {
        
        SPTween *tween = [SPTween tweenWithTarget:graphismEcranSoutenance time:0.7f];
        [tween animateProperty:@"y" targetValue:graphismEcranSoutenance.y - 480];
        [self.stage.juggler addObject:tween];
    }
    
}

@end
