"
I am a view spec showing classes augmented with number of mentions in messages with linked elements, where these classes are mentioned.
"
Class {
	#name : #DDCompactCodeAugmentedViewSpec,
	#superclass : #DDCodeAugmentedViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDCompactCodeAugmentedViewSpec >> initialize [
	super initialize.
	self glyphMappings at: DDClassNode put: DDSimpleLabeledNodeGlyph.
	self name: 'Class links view - augmented - complete';
		layoutClass: RSHorizontalTreeLayout;
		metricMappings: { 
			DDClassNode -> {
				DDClassReferencesMetric -> #devNull .
				DDNormalizedClassReferencesMetric -> #width .
				DDNormalizedClassReferencesMetric -> #height }
		};
		entityFilter: [ :entities | | classes others |
			others := entities reject: [ :each | each isKindOf: DDClassNode ].
			classes := entities select: [ :each | each isKindOf: DDClassNode ].
			classes := classes select: [ :each | each edges isNotEmpty ].
			(classes , others)
		].
]
