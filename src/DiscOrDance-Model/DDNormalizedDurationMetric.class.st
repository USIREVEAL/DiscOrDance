"
I am an abstract superclass of normalized metrics related to time differences (asDuration)
"
Class {
	#name : #DDNormalizedDurationMetric,
	#superclass : #DDNormalizedNodeMetric,
	#category : #'DiscOrDance-Model-Metrics - Normalized'
}

{ #category : #accessing }
DDNormalizedDurationMetric class >> normalize: aDuration [
	"Linear normalization of aDuration between a lower and an upper bounds"

	| range boundRange |
	
	range := self max days - self min days.
	(range = 0) ifTrue: [ ^ self lowerBound ].
	boundRange := self upperBound - self lowerBound.
	
	^ (((aDuration days - self min days) / range) * boundRange) + self lowerBound
]
