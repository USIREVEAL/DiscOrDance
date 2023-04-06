"
I am a view that highlights the activity timelines of channels of a Discord server.

I show connections between channels and categories.

I map metrics for first message sent on a channel on the y position and activity span on the height.
"
Class {
	#name : #DDChannelActivityTimelineViewSpec,
	#superclass : #DDStructureLabeledViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs'
}

{ #category : #initialization }
DDChannelActivityTimelineViewSpec >> initialize [
	super initialize.
	self entityClasses removeAll: {DDServer . DDVoiceChannel }.
	self glyphMappings at: DDStructuralEdge put: DDThinTreeEdgeGlyph.

	self name: 'Channel activity span timeline';
		layoutClass: RSTreeLayout;
		metricMappings: { 
			DDTextChannel -> {
				DDContainedMessagesMetric -> #devNull .
				DDActivitySpanMetric -> #devNull .
				DDFirstMessageDateDifferenceMetric -> #devNull .
				DDNormalizedFirstMessageOffsetDateMetric -> #y .
				DDNormalizedActivitySpanMetric -> #height } .
		}.

	self entityFilter: [ :entities | entities reject: [ :each | (each isKindOf: DDTextChannel) and: [ each hasMessages not ] ] ].
]
