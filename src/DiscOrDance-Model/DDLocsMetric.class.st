"
I am a metric mapping the number of lines of code in a CodeBlock.
"
Class {
	#name : #DDLocsMetric,
	#superclass : #DDNumericMetric,
	#category : #'DiscOrDance-Model-Metrics'
}

{ #category : #accessing }
DDLocsMetric class >> description [
	^ 'Number of lines of code in a code block'
]

{ #category : #accessing }
DDLocsMetric class >> selectorOrBlock [
	^ [ :node | node locs ].
]

{ #category : #accessing }
DDLocsMetric class >> shortName [
	^ 'LINES_OF_CODE'
]
