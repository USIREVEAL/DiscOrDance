"
I am a vertical edge that is orthogonal and tries to show nicely in tree layouts.
"
Class {
	#name : #DDTreeEdgeGlyph,
	#superclass : #DDEdgeGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #rendering }
DDTreeEdgeGlyph >> setPropertiesForGlyph [
	super setPropertiesForGlyph.
	self shape withVerticalAttachPoint.
]

{ #category : #rendering }
DDTreeEdgeGlyph >> shapeForRoassal [
	^ RSPolyline new
		controlPointsController: DDTreeCPAPController new;
		yourself.
]
