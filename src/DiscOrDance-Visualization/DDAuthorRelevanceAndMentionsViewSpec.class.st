"
I am an author mentions view spec.
I show authors connected by edges representing mentioning relations.
Each author has size mapped to its number of sent messages.

"
Class {
	#name : #DDAuthorRelevanceAndMentionsViewSpec,
	#superclass : #DDViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDAuthorRelevanceAndMentionsViewSpec >> initialize [
	super initialize.
	self name: 'Author mentions with relevance';
		layoutClass: RSCircleLayout;
		entityClasses: { DDAuthor . DDUserMention } asSet;
		glyphMappings: {
			(DDAuthor -> VZCircleNodeGlyph) .
			(DDUserMention -> VZEdgeGlyph)
		};
		metricMappings: {
			DDUserMention -> {
				DDMentionsMetric -> #devNull .
				DDNormalizedMentionsMetric -> #width } .
			DDAuthor -> {
				DDSentMessagesMetric -> #devNull . 
				DDNormalizedSentMessagesMetric -> #width . 
				DDNormalizedSentMessagesMetric -> #height }
		}
]
