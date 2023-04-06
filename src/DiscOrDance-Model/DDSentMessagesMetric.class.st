"
I am a metric mapping the number of messages sent by a DDAuthor
"
Class {
	#name : #DDSentMessagesMetric,
	#superclass : #DDNumericMetric,
	#category : #'DiscOrDance-Model-Metrics'
}

{ #category : #accessing }
DDSentMessagesMetric class >> description [
	^ 'Number of messages sent by an author'
]

{ #category : #accessing }
DDSentMessagesMetric class >> selectorOrBlock [
	^ [ :node | node sentMessages size ].
]

{ #category : #accessing }
DDSentMessagesMetric class >> shortName [
	^ 'SENT_MESSAGES'
]
