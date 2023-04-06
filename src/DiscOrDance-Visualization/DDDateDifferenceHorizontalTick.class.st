"
I am an horizontal tick for charts.
I represent dates as difference from today in days and show their lables appropriately.
"
Class {
	#name : #DDDateDifferenceHorizontalTick,
	#superclass : #RSHorizontalTick,
	#category : #'DiscOrDance-Visualization-Chart'
}

{ #category : #initialization }
DDDateDifferenceHorizontalTick >> initialize [
	super initialize.
	self labelConversion: [ :val | (Date today + val days) asDate ddmmyyyy ].

]
