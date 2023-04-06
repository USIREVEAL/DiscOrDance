"
I am a glyph for edges with a vertical attach point.
I am suitable for tree layouts.
"
Class {
	#name : #DDVerticalEdgeGlyph,
	#superclass : #DDEdgeGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #rendering }
DDVerticalEdgeGlyph >> setPropertiesForGlyph [
	super setPropertiesForGlyph.
	self shape withVerticalAttachPoint.
]
