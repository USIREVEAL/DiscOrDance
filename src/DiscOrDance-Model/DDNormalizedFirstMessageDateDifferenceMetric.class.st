"
I am a normalized version of DDFirstMessageDateDifferenceMetric.
"
Class {
	#name : #DDNormalizedFirstMessageDateDifferenceMetric,
	#superclass : #DDNormalizedDurationMetric,
	#category : #'DiscOrDance-Model-Metrics - Normalized'
}

{ #category : #accessing }
DDNormalizedFirstMessageDateDifferenceMetric class >> nonNormalizedMetricClass [
	^ DDFirstMessageDateDifferenceMetric
]

{ #category : #accessing }
DDNormalizedFirstMessageDateDifferenceMetric class >> upperBound [
	^ 600.0
]
