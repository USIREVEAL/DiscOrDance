"
I am a metric mapping the difference between today and the date of the first message of a DDNode.
"
Class {
	#name : #DDFirstMessageDateDifferenceMetric,
	#superclass : #DDDurationMetric,
	#category : #'DiscOrDance-Model-Metrics'
}

{ #category : #accessing }
DDFirstMessageDateDifferenceMetric class >> description [
	^ 'Time difference of first message from today'
]

{ #category : #accessing }
DDFirstMessageDateDifferenceMetric class >> selectorOrBlock [
	^ [ :node |
			node hasMessages
				ifFalse: [ 0 asDuration ]
				ifTrue: [ node firstMessage createdAt - DateAndTime now ] ].
]

{ #category : #accessing }
DDFirstMessageDateDifferenceMetric class >> shortName [
	^ 'FIRST_MESSAGE_DATE_DIFFERENCE'
]
