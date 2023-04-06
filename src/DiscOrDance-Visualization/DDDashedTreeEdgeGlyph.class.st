"
I am a dashed version of the DDTreeEdgeGlyph.
"
Class {
	#name : #DDDashedTreeEdgeGlyph,
	#superclass : #DDThinTreeEdgeGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #rendering }
DDDashedTreeEdgeGlyph >> shapeForRoassal [
	^ super shapeForRoassal dashArray: #(4 16).
]
