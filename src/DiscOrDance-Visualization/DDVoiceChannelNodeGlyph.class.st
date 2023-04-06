"
I am a glyph representing a voice channel as a grey circle.
"
Class {
	#name : #DDVoiceChannelNodeGlyph,
	#superclass : #DDChannelNodeGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #rendering }
DDVoiceChannelNodeGlyph >> shapeForRoassal [
	^ RSEllipse new
]
