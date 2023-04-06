"
I am an author view spec.
I show author contributions by mapping metrics to width and heights of the glyphs representing authors.

"
Class {
	#name : #DDAuthorWithMergedViewSpec,
	#superclass : #DDAuthorViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDAuthorWithMergedViewSpec >> initialize [
	super initialize.
	self name: 'Author contribution - with merged authors';
		metricMappings:
			{ DDAuthor -> {
				DDSentMessagesMetric -> #devNull .
				DDActiveChannelsMetric -> #devNull .
				DDNormalizedSentMessagesMetric -> #width .
				DDNormalizedActiveChannelsMetric -> #height .
				DDActiveColorMergedMetric -> #color } }.
]
