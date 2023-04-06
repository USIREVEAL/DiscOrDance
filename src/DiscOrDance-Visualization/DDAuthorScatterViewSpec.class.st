"
I am an author scatterplot.
I map on x the activity of an author (number of sent messages) and on y the number of channels in which it is active.
"
Class {
	#name : #DDAuthorScatterViewSpec,
	#superclass : #DDViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDAuthorScatterViewSpec >> initialize [
	super initialize.
	self name: 'Author scatterplot-like contribution';
		"layoutClass: RSNoLayout;"
		entityClasses:
			{ DDAuthor } asSet;
		glyphMappings:
			{ (DDAuthor -> DDVerySmallOverlappingGlyph) };
		metricMappings:
			{ DDAuthor -> {
				DDSentMessagesMetric -> #devNull .
				DDActiveChannelsMetric -> #devNull .
				DDNormalizedSentMessagesMetric -> #x .
				DDNormalizedActiveChannelsMetric -> #y } }
]
