"
I am a compact version of the small multiples view.
"
Class {
	#name : #DDCompactSmallMultiplesViewSpec,
	#superclass : #DDSmallMultiplesViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDCompactSmallMultiplesViewSpec >> initialize [
	super initialize.
	self name: 'Author activity sparklines - compact';
		layoutClass: RSCellLayout;
		glyphMappings:
			{ (DDAuthor -> DDCompactSparklineGlyph) }.
]
