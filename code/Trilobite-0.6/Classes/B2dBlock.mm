//
//  B2dBlock.m
//  Trilobite
//
//  Created by jasonb on 13/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "B2dBlock.h"
#import "B2dJoint.h"


@implementation B2dBlock

- (id) init {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
	appendages = nil;
	m_color = b2Color(1.0f, 0.0f, 0.0f);
	return self;
}

-(void)appendagesAlloc {
	appendages = [[NSMutableArray arrayWithCapacity:3] retain];
}

-(void) initBlock:(b2World*)world x:(float)x y:(float)y width:(float)width height:(float)height dynamic:(BOOL)dynamic sensor:(BOOL)sensor {
	m_width = width;
	m_height = height;
	m_b2world = world;
	// body definition
	b2BodyDef bodyDef;
	bodyDef.position.Set(x, y); // center of shape
	// shape definition
	b2PolygonDef shapeDef;
	if(dynamic) {
		shapeDef.density = 1.0f; // Set the box density to be non-zero, so it will be dynamic.
		shapeDef.friction = 0.3f; // Override the default friction.
	}
	// sensor
	shapeDef.isSensor = sensor;
	shapeDef.SetAsBox(width/2.0f, height/2.0f); // box from origin	
	// allocate memory
	m_body = world->CreateBody(&bodyDef);
	m_shape = m_body->CreateShape(&shapeDef);
	if(dynamic) {
		m_body->SetMassFromShapes(); // mass from shape
	}
}


-(void) initStaticBlock:(b2World*)world x:(float)x y:(float)y width:(float)width height:(float)height {
	[self initBlock:world x:x y:y width:width height:height dynamic:NO sensor:NO];
}

-(void) initWorldBoundaryBlock:(b2World*)world x:(float)x y:(float)y width:(float)width height:(float)height {
	[self initBlock:world x:x y:y width:width height:height dynamic:NO sensor:NO];
	visible = NO;
}

-(void) initDynamicBlock:(b2World*)world x:(float)x y:(float)y width:(float)width height:(float)height {
	[self initBlock:world x:x y:y width:width height:height dynamic:YES sensor:NO];
}

-(B2dBlock*)attachDynamicBlock:(b2World*)world creature:(creature_t*)creature {
	// calculate position for new block
	b2Vec2 p = m_body->GetWorldCenter();
	float bx = p.x;
	float by = p.y;
	float jx = p.x;
	float jy = p.y;
	
	switch(creature->dir)
	{
		case 0: // top
			by = by+(m_height/2.0f)+(creature->height/2.0f);
			jy = jy+(m_height/2.0f);
			break;
		case 1: // bottom
			by = by-(m_height/2.0f)-(creature->height/2.0f);
			jy = jy-(m_height/2.0f);
			break;
		case 2: // left
			bx = bx-(m_width/2.0f)-(creature->width/2.0f);
			jx = jx-(m_width/2.0f);
			break;
		case 3: // right
			bx = bx+(m_width/2.0f)+(creature->width/2.0f);
			jx = jx+(m_width/2.0f);
			break;
	}
		
	// allocate block
	B2dBlock *newBlock = [[[B2dBlock alloc] init] autorelease];	
	[newBlock initDynamicBlock:m_b2world x:bx y:by width:creature->width height:creature->height];
	[self addChild:newBlock];
	
	// prepare appendages
	if(!appendages) {
		[self appendagesAlloc];
	}
	// store child appendages
	[appendages addObject:newBlock];

	// attach via a joint (belongs to child)
	b2Vec2 joinPos = b2Vec2(jx, jy);
	[newBlock join:self pos:joinPos creature:creature];
			
	return newBlock;
}

// joint affects this block, therefore belongs to this block (drawing, memroy, etc)
-(void)join:(B2dBlock*)parentBlock pos:(b2Vec2)pos creature:(creature_t*)creature {
	B2dJoint *m_joint = [[[B2dJoint alloc] init] autorelease];
	[m_joint initRevoluteJoint:m_b2world b1:parentBlock b2:self point:pos lower:creature->lower_angle upper:creature->upper_angle speed:creature->speed];
	[self addChild:m_joint];
}

-(void) onEnter {
	[super onEnter];
}

-(void) draw {
	[super draw];
		
	// draw shape
	b2Shape *shape = m_body->GetShapeList(); // only one shape
	const b2XForm& xf = m_body->GetXForm();
	
	if(m_body->IsStatic())
	{
		[self drawShape:shape xf:xf color:m_color];
	}
	else if(m_body->IsSleeping())
	{
		[self drawShape:shape xf:xf color:m_color];
	}
	else
	{
		[self drawShape:shape xf:xf color:m_color];		
	}
	
}



-(void) drawShape:(b2Shape*)shape xf:(const b2XForm&)xf color:(const b2Color&)color {
		
	switch (shape->GetType())
	{
			// others...
			
		case e_polygonShape:
		{
			b2PolygonShape* poly = (b2PolygonShape*)shape;
			int32 vertexCount = poly->GetVertexCount();
			const b2Vec2* localVertices = poly->GetVertices();
			
			b2Assert(vertexCount <= b2_maxPolygonVertices);
			b2Vec2 vertices[b2_maxPolygonVertices];
			
			for (int32 i = 0; i < vertexCount; ++i)
			{
				vertices[i] = b2Mul(xf, localVertices[i]);
			}			
			[self drawSolidPolygon:vertices vertexCount:vertexCount color:color];			
		}
			break;						
	}
}

-(void) drawSolidPolygon:(const b2Vec2*)vertices vertexCount:(int32)vertexCount color:(const b2Color&)color{
	glEnableClientState(GL_VERTEX_ARRAY);
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	
	// fill
	glColor4f(color.r, color.g, color.b, 0.8f);
	glDrawArrays(GL_TRIANGLE_FAN, 0, vertexCount);
	
	// line
	glColor4f(color.r, color.g, color.b,1);
	glDrawArrays(GL_LINE_LOOP, 0, vertexCount);
	
	
	glDisableClientState(GL_VERTEX_ARRAY);
}


-(void)setColor:(b2Color)color {
	m_color = color;
}


-(void)runThink {

	for (id child in children) {
		[child runThink];
	}
}

-(void) dealloc{
	NSLog(@"dealloc B2dBlock");
		
	//
	// When a body is destroyed, all shapes and joints attached to the body are automatically destroyed.
	// 
	
	// shape
	m_body->DestroyShape(m_shape);
	m_shape = nil;
	// body
	m_b2world->DestroyBody(m_body);
	m_body = nil;	
	// world
	m_b2world = nil;
	
	// children
	if(appendages) {
		[appendages removeAllObjects];	
		[appendages release];
		appendages = nil;
	}
	
	// child nodes (blocks and joints)
	[self removeAllChildrenWithCleanup:YES];	
	// parent	
	[super dealloc];
}


-(b2Body*)getBody {
	return m_body;
}


@end
