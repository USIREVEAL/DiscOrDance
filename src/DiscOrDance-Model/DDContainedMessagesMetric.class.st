"
I am a metric mapping the number of messages contained in a DDTextChannel.
"
Class {
	#name : #DDContainedMessagesMetric,
	#superclass : #DDNumericMetric,
	#category : #'DiscOrDance-Model-Metrics'
}

{ #category : #accessing }
DDContainedMessagesMetric class >> description [
	^ 'Number of messages contained in a text channel'
]

{ #category : #accessing }
DDContainedMessagesMetric class >> selectorOrBlock [
	^ [ :node | node messages size ].
]

{ #category : #accessing }
DDContainedMessagesMetric class >> shortName [
	^ 'CONTAINED_MESSAGES'
]
