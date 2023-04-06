"
I am a view spec showing classes augmented with number of mentions in messages.
"
Class {
	#name : #DDCompactCodeAugmentedSimplifiedViewSpec,
	#superclass : #DDCompactCodeAugmentedViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDCompactCodeAugmentedSimplifiedViewSpec >> initialize [
	super initialize.
	self name: 'Class links view - augmented - simple';
		layoutClass: RSFlowLayout;
		entityClasses:
			{ DDClassNode } asSet;
		glyphMappings:
			{ DDClassNode -> DDSimpleLabeledNodeGlyph };
		sortingBlock: [ :entities | | classes others |
			classes := entities select: [ :each | each isKindOf: DDClassNode ].
			others := entities reject: [ :each | each isKindOf: DDClassNode ].
			classes sort: [ :a :b | a edges size > b edges size ].
			(classes , others).
		]
]
