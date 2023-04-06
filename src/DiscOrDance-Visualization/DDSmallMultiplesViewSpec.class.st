"
I am a spec to visualize multiple authors as their activity sparklines.
"
Class {
	#name : #DDSmallMultiplesViewSpec,
	#superclass : #DDViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDSmallMultiplesViewSpec >> initialize [
	super initialize.
	self name: 'Author activity sparklines';
		layoutClass: RSGridLayout;
		entityClasses: { DDAuthor } asSet;
		glyphMappings:
			{ (DDAuthor -> DDSparklineGlyph) };
		sortingBlock: [ :entities | | others authors |
			others := entities reject: [ :each | each isKindOf: DDAuthor].
			authors := DDAuthor alphaSorted: (entities select: [ :each | each isKindOf: DDAuthor ]).
			(authors , others) ]
]
