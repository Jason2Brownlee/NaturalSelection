//
//  Creature.mm
//  Trilobite
//
//  Created by jasonb on 25/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Creature.h"


@implementation Creature

-(id)init {
	if( ! (self=[super init]) ) {
		return nil;
	}	
	return self;
}


-(id)initAtStartPosition:(b2World*)world pos:(b2Vec2)pos {
	if(!(self=[self init]) ) {
		return nil;
	}
		
	m_b2world = world;
	// create the world
	[self createCreature:pos];	
	
	return self;
}

-(void)createCreature:(b2Vec2)pos {}

-(b2Vec2)currentCreaturePosition {
	return b2Vec2(0.0f,0.0f);
}

-(void)onEnter {
	// joint think
	float thinkTimeSeconds = 0.0f;
	[self schedule:@selector(creatureThink:) interval:thinkTimeSeconds];
	
	[super onEnter];
}
-(void)onExit {
	[self unschedule:@selector(creatureThink:)];
	[super onExit];
}

-(void)creatureThink:(ccTime)deltaTime {

}

-(void)draw {
	[super draw];
}



-(void)dealloc{
	[super dealloc]; // super (always last)
}

@end
