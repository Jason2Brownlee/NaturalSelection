/* cocos2d for iPhone
 *
 * http://code.google.com/p/cocos2d-iphone
 *
 * Copyright (C) 2009 Matt Oswald
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the 'cocos2d for iPhone' license.
 *
 * You will find a copy of this license within the cocos2d for iPhone
 * distribution inside the "LICENSE" file.
 *
 */

#import "AtlasSpriteManager.h"
#import "AtlasSprite.h"

#pragma mark -
#pragma mark AltasSprite

enum {
	kIndexNotInitialized = 0xffffffff,
};

@interface AtlasSprite (Private)
-(void)updateTextureCoords;
-(void) initAnimationDictionary;
@end

@implementation AtlasSprite

@synthesize dirtyColor, dirtyPosition;
@synthesize atlasIndex = _atlasIndex;
@synthesize textureRect = _rect;
@synthesize autoCenterFrames = _autoCenterFrames;

+(id)spriteWithRect:(CGRect)rect spriteManager:(AtlasSpriteManager*)manager
{
	return [[[self alloc] initWithRect:rect spriteManager:manager] autorelease];
}

-(id)initWithRect:(CGRect)rect spriteManager:(AtlasSpriteManager*)manager
{
	if( (self = [super init])) {
		_textureAtlas = [manager atlas];	// weak reference. Don't release
		
		_atlasIndex = kIndexNotInitialized;

		dirtyPosition = YES;
		dirtyColor = NO;			// optimization. If the color is not changed gl_color_array is not send to the GPU
		
		// RGB and opacity
		_r = _g = _b = _opacity = 255;
		
		animations = nil;		// lazy alloc
		[self setTextureRect:rect];
		
		// default transform anchor: center
		transformAnchor = CGPointMake( rect.size.width / 2, rect.size.height /2 );
		
		_autoCenterFrames = NO;
	}

	return self;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %08X | Rect = (%.2f,%.2f,%.2f,%.2f) | tag = %i>", [self class], self, _rect.origin.x, _rect.origin.y, _rect.size.width, _rect.size.height, tag];
}

- (void) dealloc
{
	[animations release];
	[super dealloc];
}

-(void) initAnimationDictionary
{
	animations = [[NSMutableDictionary dictionaryWithCapacity:2] retain];
}

-(void)setTextureRect:(CGRect) rect
{
	_rect = rect;

	[self updateTextureCoords];
	
	// Don't update Atlas if index == -1. issue #283
	if( _atlasIndex != kIndexNotInitialized)
		[self updateAtlas];
	else
		dirtyPosition = YES;
}

-(void)updateTextureCoords
{
	float atlasWidth = _textureAtlas.texture.pixelsWide;
	float atlasHeight = _textureAtlas.texture.pixelsHigh;

	float left = _rect.origin.x / atlasWidth;
	float right = (_rect.origin.x + _rect.size.width) / atlasWidth;
	float top = _rect.origin.y / atlasHeight;
	float bottom = (_rect.origin.y + _rect.size.height) / atlasHeight;

	ccQuad2 newCoords = {
		left, bottom,
		right, bottom,
		left, top,
		right, top,
	};

	_texCoords = newCoords;
}

-(void) updateColor
{
	ccColorB colorQuad = { _r, _g, _b, _opacity};
	[_textureAtlas updateColorWithColorQuad:&colorQuad atIndex:_atlasIndex];
	dirtyColor = NO;
}

-(void)updatePosition
{
	// algorithm from pyglet ( http://www.pyglet.org ) 

	// if not visible
	// then everything is 0
	if( ! visible ) {		
		ccQuad3 newVertices = {
			0,0,0,
			0,0,0,
			0,0,0,
			0,0,0,			
		};
		
		_vertexCoords = newVertices;
	}
	
	// rotation ? -> update: rotation, scale, position
	else if( rotation ) {
		float x1 = -transformAnchor.x * scaleX;
		float y1 = -transformAnchor.y * scaleY;

		float x2 = x1 + _rect.size.width * scaleX;
		float y2 = y1 + _rect.size.height * scaleY;
		float x = position.x;
		float y = position.y;
		
		float r = (float)-CC_DEGREES_TO_RADIANS(rotation);
		float cr = cosf(r);
		float sr = sinf(r);
		float ax = x1 * cr - y1 * sr + x;
		float ay = x1 * sr + y1 * cr + y;
		float bx = x2 * cr - y1 * sr + x;
		float by = x2 * sr + y1 * cr + y;
		float cx = x2 * cr - y2 * sr + x;
		float cy = x2 * sr + y2 * cr + y;
		float dx = x1 * cr - y2 * sr + x;
		float dy = x1 * sr + y2 * cr + y;

		ccQuad3 newVertices = 
					{ax, ay, 0,
					bx, by, 0,
					dx, dy, 0,
					cx, cy, 0};
		_vertexCoords = newVertices;		
	}
	
	// scale ? -> update: scale, position
	else if(scaleX != 1 || scaleY != 1)
	{
		float x = position.x;
		float y = position.y;
		
		float x1 = (x- transformAnchor.x * scaleX);
		float y1 = (y- transformAnchor.y * scaleY);
		float x2 = (x1 + _rect.size.width * scaleX);
		float y2 = (y1 + _rect.size.height * scaleY);
		ccQuad3 newVertices = {
			x1,y1,0,
			x2,y1,0,
			x1,y2,0,
			x2,y2,0,
		};

		_vertexCoords = newVertices;	
	}
	
	// update position
	else {
		float x = position.x;
		float y = position.y;
		
		float x1 = (x-transformAnchor.x);
		float y1 = (y-transformAnchor.y);
		float x2 = (x1 + _rect.size.width);
		float y2 = (y1 + _rect.size.height);
		ccQuad3 newVertices = {
			x1,y1,0,
			x2,y1,0,
			x1,y2,0,
			x2,y2,0,
		};
		
		_vertexCoords = newVertices;
	}

	[_textureAtlas updateQuadWithTexture:&_texCoords vertexQuad:&_vertexCoords atIndex:_atlasIndex];
	dirtyPosition = NO;
	return;
}

-(void)updateAtlas
{
	[_textureAtlas updateQuadWithTexture:&_texCoords vertexQuad:&_vertexCoords atIndex:_atlasIndex];
}

-(void)insertInAtlasAtIndex:(NSUInteger)index
{
	_atlasIndex = index;
	[_textureAtlas insertQuadWithTexture:&_texCoords vertexQuad:&_vertexCoords atIndex:_atlasIndex];
}

//
// CocosNode property overloads
//
#pragma mark AltasSprite - property overloads
-(void)setPosition:(CGPoint)pos
{
	[super setPosition:pos];
	dirtyPosition = YES;
}

-(void)setRotation:(float)rot
{
	[super setRotation:rot];
	dirtyPosition = YES;
}

-(void)setScaleX:(float) sx
{
	[super setScaleX:sx];
	dirtyPosition = YES;
}

-(void)setScaleY:(float) sy
{
	[super setScaleY:sy];
	dirtyPosition = YES;
}

-(void)setScale:(float) s
{
	[super setScale:s];
	dirtyPosition = YES;
}

-(void)setTransformAnchor:(CGPoint)anchor
{
	[super setTransformAnchor:anchor];
	dirtyPosition = YES;
}

-(void)setRelativeTransformAnchor:(BOOL)relative
{
	CCLOG(@"relativeTransformAnchor is ignored in AtlasSprite");
}

-(void)setVisible:(BOOL)v
{
	[super setVisible:v];
	dirtyPosition = YES;
}

//
// Composition overload
//
-(id) addChild:(CocosNode*)child z:(int)z tag:(int) aTag
{
	NSAssert(NO, @"AtlasSprite can't have children");
	return nil;
}

//
// Opacity protocol
//
-(void) setOpacity:(GLubyte) anOpacity
{
	_opacity = anOpacity;
	dirtyColor = YES;
}
-(GLubyte)opacity
{
	return _opacity;
}

//
// RGB protocol
//
-(void) setRGB: (GLubyte)r :(GLubyte)g :(GLubyte)b
{
	_r = r;
	_g = g;
	_b = b;
	dirtyColor = YES;
}
-(GLubyte) r
{
	return _r;
}
-(GLubyte) g
{
	return _g;
}
-(GLubyte) b
{
	return _b;
}

//
// CocosNodeSize protocol
//
-(CGSize)contentSize
{
	return _rect.size;
}

//
// CocosNodeFrames protocol
//
-(void) setDisplayFrame:(id)newFrame
{
	AtlasSpriteFrame *frame = (AtlasSpriteFrame*)newFrame;
	CGRect rect = [frame rect];

	if( _autoCenterFrames ) {
		self.transformAnchor = CGPointMake(rect.size.width/2, rect.size.height/2);
		dirtyPosition = YES;
	}

	[self setTextureRect: rect];	
}

-(void) setDisplayFrame: (NSString*) animationName index:(int) frameIndex
{
	if( ! animations )
		[self initAnimationDictionary];
	
	AtlasAnimation *a = [animations objectForKey: animationName];
	AtlasSpriteFrame *frame = [[a frames] objectAtIndex:frameIndex];
	
	CGRect rect = [frame rect];
	
	if( _autoCenterFrames ) {
		self.transformAnchor = CGPointMake(rect.size.width/2, rect.size.height/2);
		dirtyPosition = YES;
	}
	
	[self setTextureRect: rect];
	
}

-(BOOL) isFrameDisplayed:(id)frame 
{
	AtlasSpriteFrame *spr = (AtlasSpriteFrame*)frame;
	CGRect r = [spr rect];
	return CGRectEqualToRect(r, _rect);
}

-(id) displayFrame
{
	return [AtlasSpriteFrame frameWithRect:_rect];
}
// XXX: duplicated code. Sprite.m and AtlasSprite.m share this same piece of code
-(void) addAnimation: (id<CocosAnimation>) anim
{
	// lazy alloc
	if( ! animations )
		[self initAnimationDictionary];
	
	[animations setObject:anim forKey:[anim name]];
}
// XXX: duplicated code. Sprite.m and AtlasSprite.m share this same piece of code
-(id<CocosAnimation>)animationByName: (NSString*) animationName
{
	NSAssert( animationName != nil, @"animationName parameter must be non nil");
    return [animations objectForKey:animationName];
}
@end


#pragma mark -
#pragma mark AltasAnimation

@implementation AtlasAnimation
@synthesize name, delay, frames;

+(id) animationWithName:(NSString*)aname delay:(float)d frames:rect1,...
{
	va_list args;
	va_start(args,rect1);
	
	id s = [[[self alloc] initWithName:aname delay:d firstFrame:rect1 vaList:args] autorelease];
	
	va_end(args);
	return s;
}

+(id) animationWithName:(NSString*)aname delay:(float)d
{
	return [[[self alloc] initWithName:aname delay:d] autorelease];
}

-(id) initWithName:(NSString*)t delay:(float)d
{
	return [self initWithName:t delay:d firstFrame:nil vaList:nil];
}

/* initializes an AtlasAnimation with an AtlasSpriteManager, a name, and the frames from AtlasSpriteFrames */
-(id) initWithName:(NSString*)t delay:(float)d firstFrame:(AtlasSpriteFrame*)frame vaList:(va_list)args
{
	if( (self=[super init]) ) {
	
		name = t;
		frames = [[NSMutableArray array] retain];
		delay = d;
		
		if( frame ) {
			[frames addObject:frame];
			
			AtlasSpriteFrame *frame2 = va_arg(args, AtlasSpriteFrame*);
			while(frame2) {
				[frames addObject:frame2];
				frame2 = va_arg(args, AtlasSpriteFrame*);
			}	
		}
	}
	return self;
}

-(void) dealloc
{
	CCLOG( @"deallocing %@",self);
	[frames release];
	[super dealloc];
}

-(void) addFrameWithRect:(CGRect)rect
{
	AtlasSpriteFrame *frame = [AtlasSpriteFrame frameWithRect:rect];
	[frames addObject:frame];
}
@end

#pragma mark -
#pragma mark AtlasSpriteFrame
@implementation AtlasSpriteFrame
@synthesize rect;

+(id) frameWithRect:(CGRect)frame
{
	return [[[self alloc] initWithRect:(CGRect)frame] autorelease];
}
-(id) initWithRect:(CGRect)frame
{
	if( ([super init]) ) {
		rect = frame;
	}
	return self;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %08X | Rect = (%.2f,%.2f,%.2f,%.2f)>", [self class], self,
			rect.origin.x,
			rect.origin.y,
			rect.size.width,
			rect.size.height];
}

- (void) dealloc
{
	CCLOG( @"deallocing %@",self);
	[super dealloc];
}
@end

