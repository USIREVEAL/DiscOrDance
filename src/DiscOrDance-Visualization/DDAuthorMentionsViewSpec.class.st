"
I am an author mentions view spec.
I show authors connected by edges representing mentioning relations.

"
Class {
	#name : #DDAuthorMentionsViewSpec,
	#superclass : #DDViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDAuthorMentionsViewSpec >> initialize [
	super initialize.
	self name: 'Author mentions';
		layoutClass: RSCircleLayout;
		entityClasses: { DDAuthor . DDUserMention } asSet;
		glyphMappings: {
			(DDAuthor -> VZCircleNodeGlyph) .
			(DDUserMention -> VZEdgeGlyph)};
		metricMappings: {
			DDUserMention -> {
				DDMentionsMetric -> #devNull .
				DDNormalizedMentionsMetric -> #width }
		};
		entityFilter: [ :entities |
			entities reject: [ :each |
				each isNode and: [ each edges isEmpty ]]]
]
