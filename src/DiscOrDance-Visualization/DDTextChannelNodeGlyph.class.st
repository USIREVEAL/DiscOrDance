"
I am a glyph for representing a Discord text channel as a box.
"
Class {
	#name : #DDTextChannelNodeGlyph,
	#superclass : #DDChannelNodeGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #rendering }
DDTextChannelNodeGlyph >> shapeForRoassal [
	^ RSBox new
]
