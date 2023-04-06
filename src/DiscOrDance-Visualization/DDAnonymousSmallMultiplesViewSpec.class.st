"
I am an anonymous version of the small multiples view.
"
Class {
	#name : #DDAnonymousSmallMultiplesViewSpec,
	#superclass : #DDSmallMultiplesViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDAnonymousSmallMultiplesViewSpec >> initialize [
	super initialize.
	self name: 'Author activity sparklines - anonymous';
		layoutClass: RSCellLayout;
		glyphMappings:
			{ (DDAuthor -> DDAnonymousSparklineGlyph) }.
]
