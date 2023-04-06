"
I am a more compact version of a compact sparkline glyph.
I am also left alignable with glyphs like me.
"
Class {
	#name : #DDSuperCompactSparklineGlyph,
	#superclass : #DDCompactSparklineGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #rendering }
DDSuperCompactSparklineGlyph >> hasDecorations [
	^ false
]

{ #category : #rendering }
DDSuperCompactSparklineGlyph >> leftAlignable [
	^ true
]

{ #category : #rendering }
DDSuperCompactSparklineGlyph >> showName [
	^ false
]
