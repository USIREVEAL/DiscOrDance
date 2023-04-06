"
I am an edge glyph between conversations.
"
Class {
	#name : #DDNextConversationEdgeGlyph,
	#superclass : #DDEdgeGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #rendering }
DDNextConversationEdgeGlyph >> shapeForRoassal [
	^ super shapeForRoassal dashArray: #(4 16).
]
