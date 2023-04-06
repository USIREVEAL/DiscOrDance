"
I am an author view spec.
I show author contributions by mapping metrics to width and heights of the glyphs representing authors.

"
Class {
	#name : #DDAuthorViewSpec,
	#superclass : #DDViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDAuthorViewSpec >> initialize [
	super initialize.
	self name: 'Author contribution';
		layoutClass: RSFlowLayout;
		entityClasses:
			{ DDAuthor } asSet;
		glyphMappings:
			{ (DDAuthor -> VZNodeGlyph) };
		metricMappings:
			{ DDAuthor -> {
				DDSentMessagesMetric -> #devNull .
				DDActiveChannelsMetric -> #devNull .
				DDNormalizedSentMessagesMetric -> #width .
				DDNormalizedActiveChannelsMetric -> #height .
				DDActiveColorMetric -> #color } };
		sortingBlock: [ :entities | | others authors |
			others := entities reject: [ :each | each isKindOf: DDAuthor].
			authors := DDAuthor activitySorted: (entities select: [ :each | each isKindOf: DDAuthor ]).
			(authors , others) ]
]
