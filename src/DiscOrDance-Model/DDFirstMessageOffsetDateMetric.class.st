"
I am a metric mapping the difference between the date of the first message of a DDNode and the last message in the server.
"
Class {
	#name : #DDFirstMessageOffsetDateMetric,
	#superclass : #DDDurationMetric,
	#category : #'DiscOrDance-Model-Metrics'
}

{ #category : #accessing }
DDFirstMessageOffsetDateMetric class >> description [
	^ 'Time difference of first message from last server message'
]

{ #category : #accessing }
DDFirstMessageOffsetDateMetric class >> selectorOrBlock [
	^ [ :node |
			node hasMessages
				ifFalse: [ 0 asDuration ]
				ifTrue: [ node firstMessage createdAt - node server lastMessage createdAt ] ].
]

{ #category : #accessing }
DDFirstMessageOffsetDateMetric class >> shortName [
	^ 'FIRST_MESSAGE_DATE_OFFSET'
]
