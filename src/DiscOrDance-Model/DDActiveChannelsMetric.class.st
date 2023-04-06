"
I am a metric.
I map the number of channels in which a DDAuthor is active.
"
Class {
	#name : #DDActiveChannelsMetric,
	#superclass : #DDNumericMetric,
	#category : #'DiscOrDance-Model-Metrics'
}

{ #category : #accessing }
DDActiveChannelsMetric class >> description [
	^ 'Number of channels in which an author has been active'
]

{ #category : #accessing }
DDActiveChannelsMetric class >> selectorOrBlock [
	^ [ :node | node activeChannels size ]
]

{ #category : #accessing }
DDActiveChannelsMetric class >> shortName [
	^ 'ACTIVE_CHANNELS'
]
