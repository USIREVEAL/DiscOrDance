"
I am a metric mapping the maximum number of messages sent in a single day by a DDAuthor.
"
Class {
	#name : #DDMaxDailySentMessagesMetric,
	#superclass : #DDNumericMetric,
	#category : #'DiscOrDance-Model-Metrics'
}

{ #category : #accessing }
DDMaxDailySentMessagesMetric class >> description [
	^ 'Number of max messages sent in a single day by an author'
]

{ #category : #accessing }
DDMaxDailySentMessagesMetric class >> selectorOrBlock [
	^ [ :node | (node messagesByDay collect: #size) max ].
]

{ #category : #accessing }
DDMaxDailySentMessagesMetric class >> shortName [
	^ 'MAX_DAILY_SENT_MESSAGES'
]
