"
I am a view that highlights the informative content in different channels of a Discord server.

I show connections between channels and categories.

I map metrics for number of messages contained in the channels to their height.
"
Class {
	#name : #DDStructureActivityVerticalTreeViewSpec,
	#superclass : #DDStructureLabeledViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDStructureActivityVerticalTreeViewSpec >> initialize [
	super initialize.
	self entityClasses remove: DDServer.
	self name: 'Channel activity vertical view';
		layoutClass: RSTreeLayout;
		metricMappings: { 
			DDTextChannel -> {
				DDContainedMessagesMetric -> #devNull .
				DDActiveAuthorsMetric -> #devNull .
				DDNormalizedContainedMessagesMetric -> #height .
				DDNormalizedActiveAuthorsMetric -> #width } .
		}
]
