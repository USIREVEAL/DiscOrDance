"
I am a metric mapping code size.
"
Class {
	#name : #DDCodeSizeMetric,
	#superclass : #DDNumericMetric,
	#category : #'DiscOrDance-Model-Metrics'
}

{ #category : #accessing }
DDCodeSizeMetric class >> description [
	^ 'Size of code in a CodeBlock'
]

{ #category : #accessing }
DDCodeSizeMetric class >> selectorOrBlock [
	^ [ :node | node size ].
]

{ #category : #accessing }
DDCodeSizeMetric class >> shortName [
	^ 'CODE_SIZE'
]
