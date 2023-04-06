"
I am a normalized version of the DDContainedMessagesMetric.
"
Class {
	#name : #DDNormalizedContainedMessagesMetric,
	#superclass : #DDNormalizedNodeMetric,
	#category : #'DiscOrDance-Model-Metrics - Normalized'
}

{ #category : #accessing }
DDNormalizedContainedMessagesMetric class >> nonNormalizedMetricClass [
	^ DDContainedMessagesMetric
]

{ #category : #accessing }
DDNormalizedContainedMessagesMetric class >> upperBound [
	^ 400.0
]
