"
I am a semi-transparent version of DDVerySmallGlyph.

When small size still has overlappings, this glyph should help in a better visual understanding of stacking entities.
"
Class {
	#name : #DDVerySmallOverlappingGlyph,
	#superclass : #DDVerySmallGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #initialization }
DDVerySmallOverlappingGlyph >> initialize [
	super initialize.
	self color: Color transparent.
]

{ #category : #rendering }
DDVerySmallOverlappingGlyph >> shapeForRoassal [
	| innerShape |
	innerShape := RSBox new
		width: self width;
		height: self height;
		color: (Color r: 1 g: 0 b: 0 alpha: 0.2);
		border: (RSBorder new
						width: 0.5;
						color: (Color r: 1 g: 0 b: 1 alpha: 0.35)).

	^ RSComposite new
		model: self entity;
		shapes: { innerShape };
		adjustToChildren;
		yourself.

]
