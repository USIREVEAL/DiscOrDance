"
I am a normalized version of DDFirstMessageOffsetDateMetric.
"
Class {
	#name : #DDNormalizedFirstMessageOffsetDateMetric,
	#superclass : #DDNormalizedDurationMetric,
	#category : #'DiscOrDance-Model-Metrics - Normalized'
}

{ #category : #accessing }
DDNormalizedFirstMessageOffsetDateMetric class >> nonNormalizedMetricClass [
	^ DDFirstMessageOffsetDateMetric
]

{ #category : #accessing }
DDNormalizedFirstMessageOffsetDateMetric class >> upperBound [
	^ 600.0
]
