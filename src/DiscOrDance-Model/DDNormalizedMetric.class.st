"
I am a DDMetric that can be normalized when a min and max are specified class side.
"
Class {
	#name : #DDNormalizedMetric,
	#superclass : #DDMetric,
	#classInstVars : [
		'min',
		'max',
		'nonNormalizedMetric'
	],
	#category : #'DiscOrDance-Model-Metrics - Normalized'
}

{ #category : #accessing }
DDNormalizedMetric class >> description [
	^ 'Normalized ' , nonNormalizedMetric description.
]

{ #category : #accessing }
DDNormalizedMetric class >> lowerBound [
	^ 0.0
]

{ #category : #accessing }
DDNormalizedMetric class >> max [
	^ max ifNil: [ max := 0 ]
]

{ #category : #accessing }
DDNormalizedMetric class >> max: aNumber [
	max := aNumber
]

{ #category : #accessing }
DDNormalizedMetric class >> min [
	^ min ifNil: [ min := 0 ]
]

{ #category : #accessing }
DDNormalizedMetric class >> min: aNumber [
	min := aNumber
]

{ #category : #accessing }
DDNormalizedMetric class >> minValue [
	^ 5
]

{ #category : #accessing }
DDNormalizedMetric class >> nonNormalizedMetricClass [
	^ self subclassResponsibility.
]

{ #category : #accessing }
DDNormalizedMetric class >> normalize: aNumber [
	"Linear normalization between a lower and an upper bounds"

	| range boundRange |
	
	range := self max - self min.
	boundRange := self upperBound - self lowerBound.
	
	^ (((aNumber asFloat - self min) / range) * boundRange) + self lowerBound
]

{ #category : #accessing }
DDNormalizedMetric class >> selectorOrBlock [
	^ self nonNormalizedMetricClass selectorOrBlock
]

{ #category : #accessing }
DDNormalizedMetric class >> shortName [
	^ 'NORMALIZED_' , self nonNormalizedMetricClass shortName
]

{ #category : #accessing }
DDNormalizedMetric class >> upperBound [
	^ 100.0
]

{ #category : #accessing }
DDNormalizedMetric class >> value: aVZEntity [
	| rawValue normalizedValue |
	rawValue := super value: aVZEntity.
	normalizedValue := (self normalize: rawValue) + self minValue.
	aVZEntity metrics at: self put: normalizedValue.
	^ normalizedValue
]
