"
I am a compact version of the compact small multiples view.
"
Class {
	#name : #DDSuperCompactSmallMultiplesViewSpec,
	#superclass : #DDCompactSmallMultiplesViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDSuperCompactSmallMultiplesViewSpec >> initialize [
	super initialize.
	self name: 'Author activity sparklines - supercompact';
		layoutClass: RSCellLayout;
		glyphMappings:
			{ DDAuthor -> DDSuperCompactSparklineGlyph }.
]
