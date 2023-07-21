//
//  B2dBlock.m
//  Trilobite
//
//  Created by jasonb on 13/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "B2dBlock.h"
#import "B2dJoint.h"



// private interface
@interface B2dBlock() 
int m_width;
int m_height;

@end



@implementation B2dBlock

- (id) init {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
	return self;
}

-(void) initStaticBlock:(b2World*)world x:(float)x y:(float)y width:(float)width height:(float)height {
	m_width = width;
	m_height = height;
	m_b2world = world;
	// body definition
	b2BodyDef bodyDef;
	bodyDef.position.Set(x, y); // center of shape
	// shape definition
	b2PolygonDef shapeDef;
	shapeDef.SetAsBox(width/2.0f, height/2.0f); // box from origin
	// allocate memory
	m_body = world->CreateBody(&bodyDef);
	m_body->CreateShape(&shapeDef);
}

-(void) initDynamicBlock:(b2World*)world x:(float)x y:(float)y width:(float)width height:(float)height {
	m_width = width;
	m_height = height;
	m_b2world = world;
	// body definition
	b2BodyDef bodyDef;
	bodyDef.position.Set(x, y); // center of shape
	// shape definition
	b2PolygonDef shapeDef;
	shapeDef.density = 1.0f; // Set the box density to be non-zero, so it will be dynamic.
	shapeDef.friction = 0.3f; // Override the default friction.
	shapeDef.SetAsBox(width/2.0f, height/2.0f); // box from origin
	// allocate memory
	m_body = world->CreateBody(&bodyDef);
	m_body->CreateShape(&shapeDef);
	m_body->SetMassFromShapes(); // mass from shape
}


// attach a new block on the outside of this block
-(B2dBlock*) attachDynamicBlock:(b2World*)world dir:(int)dir width:(float)width height:(float)height {
	// calculate position for new block
	b2Vec2 p = m_body->GetWorldCenter();
	float xx = p.x;
	float yy = p.y;
	
	switch(dir)
	{
		case 0: // top
			yy = yy+(m_height/2.0f)+(height/2.0f);
			break;
		case 1: // bottom
			yy = yy-(m_height/2.0f)-(height/2.0f);
			break;
		case 2: // left
			xx = xx-(m_width/2.0f)-(width/2.0f);
			break;
		case 3: // right
			xx = xx+(m_width/2.0f)+(width/2.0f);
			break;
	}
	
	// allocate
	B2dBlock *newBlock = [[B2dBlock alloc] init];
	[newBlock initDynamicBlock:m_b2world x:xx y:yy width:width height:height];
	return newBlock;
}

-(B2dBlock*)attachDynamicBlock:(b2World*)world creature:(Creature&)creature {
	// calculate position for new block
	b2Vec2 p = m_body->GetWorldCenter();
	float bx = p.x;
	float by = p.y;
	float jx = p.x;
	float jy = p.y;
	
	switch(creature.dir)
	{
		case 0: // top
			by = by+(m_height/2.0f)+(creature.height/2.0f);
			jy = jy+(m_height/2.0f);
			break;
		case 1: // bottom
			by = by-(m_height/2.0f)-(creature.height/2.0f);
			jy = jy-(m_height/2.0f);
			break;
		case 2: // left
			bx = bx-(m_width/2.0f)-(creature.width/2.0f);
			jx = jx-(m_width/2.0f);
			break;
		case 3: // right
			bx = bx+(m_width/2.0f)+(creature.width/2.0f);
			jx = jx+(m_width/2.0f);
			break;
	}
	
	// allocate block
	B2dBlock *newBlock = [[B2dBlock alloc] init];
	[newBlock initDynamicBlock:m_b2world x:bx y:by width:creature.width height:creature.height];
	[self addChild:newBlock];
	
	// allocate joint
	B2dJoint *newJoint = [[B2dJoint alloc] init];
	b2Vec2 joinPos = b2Vec2(jx, jy);
	[newJoint initRevoluteJoint:m_b2world b1:self b2:newBlock point:joinPos lower:creature.lower_angle upper:creature.upper_angle speed:creature.speed];
	[self addChild:newJoint];
		
	return newBlock;
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
		[self drawShape:shape xf:xf color:b2Color(0.5f, 0.9f, 0.5f)];
	}
	else if(m_body->IsSleeping())
	{
		[self drawShape:shape xf:xf color:b2Color(0.5f, 0.5f, 0.9f)];
	}
	else
	{
		[self drawShape:shape xf:xf color:b2Color(0.9f, 0.9f, 0.9f)];		
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
	glColor4f(color.r, color.g, color.b,0.5f);
	glDrawArrays(GL_TRIANGLE_FAN, 0, vertexCount);
	
	// line
	glColor4f(color.r, color.g, color.b,1);
	glDrawArrays(GL_LINE_LOOP, 0, vertexCount);
	
	
	glDisableClientState(GL_VERTEX_ARRAY);
}


- (void) drawSegment:(const b2Vec2&)p1 p2:(const b2Vec2&)p2 color:(const b2Color&)color {	
	glEnableClientState(GL_VERTEX_ARRAY);
	
	glColor4f(color.r, color.g, color.b,1);
	GLfloat glVertices[] = {p1.x,p1.y,p2.x,p2.y};
	glVertexPointer(2, GL_FLOAT, 0, glVertices);
	glDrawArrays(GL_LINES, 0, 2);
	
	glDisableClientState(GL_VERTEX_ARRAY);
}

- (void) drawPoint:(const b2Vec2&)p size:(float32)size color:(const b2Color&)color {
	glEnableClientState(GL_VERTEX_ARRAY);
	
	glColor4f(color.r, color.g, color.b,1);
	glPointSize(size);
	GLfloat glVertices[] = {p.x,p.y};
	glVertexPointer(2, GL_FLOAT, 0, glVertices);
	glDrawArrays(GL_POINTS, 0, 1);
	glPointSize(1.0f);
	
	glDisableClientState(GL_VERTEX_ARRAY);
}

-(void) dealloc{
	m_b2world->DestroyBody(m_body);
	m_b2world = nil;
	m_body = nil;
	
	[super dealloc]; // super (always last)
}


-(b2Body*)getBody {
	return m_body;
}


@end
