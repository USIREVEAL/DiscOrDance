"
I am a metric mapping the difference between dates of the first and last message in a channel.
"
Class {
	#name : #DDActivitySpanMetric,
	#superclass : #DDDurationMetric,
	#category : #'DiscOrDance-Model-Metrics'
}

{ #category : #accessing }
DDActivitySpanMetric class >> description [
	^ 'Time difference between first and last message of an entity'
]

{ #category : #accessing }
DDActivitySpanMetric class >> selectorOrBlock [
	^ [ :node |
			node hasMessages
				ifFalse: [ 0 asDuration ]
				ifTrue: [ node lastMessage createdAt - node firstMessage createdAt ] ].
]

{ #category : #accessing }
DDActivitySpanMetric class >> shortName [
	^ 'ACTIVITY_SPAN'
]
