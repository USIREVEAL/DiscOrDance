"
I am a view that highlights the informative content in different channels of a Discord server.

I show connections between channels and categories.

I map metrics for number of messages contained in the channels to their size.
"
Class {
	#name : #DDStructureActivityViewSpec,
	#superclass : #DDStructureLabeledViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDStructureActivityViewSpec >> initialize [
	super initialize.
	self entityClasses remove: DDServer.
	self name: 'Channel activity view';
		layoutClass: RSTreeLayout;
		metricMappings: { 
			DDTextChannel -> {
				DDContainedMessagesMetric -> #devNull .
				DDNormalizedContainedMessagesMetric -> #width .
				DDNormalizedContainedMessagesMetric -> #height } .
		}
]
