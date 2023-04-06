"
I am an abstract superclass of throughput chart glyphs.
"
Class {
	#name : #DDThroughputGlyph,
	#superclass : #DDChartGlyph,
	#instVars : [
		'messages',
		'xMin',
		'xMax',
		'smoothDays'
	],
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #adding }
DDThroughputGlyph >> addAllPlots: anRSChart [
	^ self subclassResponsibility.
]

{ #category : #adding }
DDThroughputGlyph >> addChartDecorations: anRSChart [
	"anRSChart addDecoration: DDDateDifferenceHorizontalTick new."
	anRSChart addDecoration: (RSHorizontalTick new labelConversion: [ :val | (self dateFromInteger: val) ddmmyyyy ]).
	anRSChart addDecoration: RSVerticalTick new integerWithCommas.
	"anRSChart addDecoration: RSYMarkerDecoration new."

]

{ #category : #adding }
DDThroughputGlyph >> addPopup: anRSChart [
	^ self subclassResponsibility.
]

{ #category : #rendering }
DDThroughputGlyph >> chartForRoassal [
	| chart |

	chart := RSChart new.
	chart extent: 400@200.
	chart title: self title.

	self addPopup: chart.
	self addAllPlots: chart.
	self addChartDecorations: chart.
	
	^ chart

]

{ #category : #adding }
DDThroughputGlyph >> dateFromInteger: anInteger [
	^ (Date today + (self xMin + anInteger - 2 + (self smoothDays // 2)) days) asDate
]

{ #category : #accessing }
DDThroughputGlyph >> messages [
	^ messages ifNil: [ messages := self entity messagesByDate ]
]

{ #category : #accessing }
DDThroughputGlyph >> messages: aCollectionOfDDMessages [
	messages := aCollectionOfDDMessages
]

{ #category : #testing }
DDThroughputGlyph >> needPlaceholderGlyph [
	^ self entity hasMessages not
]

{ #category : #rendering }
DDThroughputGlyph >> plot: selectorOrBlock [
	| x plotData newPlotData |

	x := 1 to: self xMax - self xMin + 2.
	plotData := OrderedCollection new.

	x do: [ :eachDay |
		self messages at: (self dateFromInteger: eachDay) translateToUTC
			ifPresent: [ :msgs | plotData add: ((msgs collect: selectorOrBlock) sum) ]
			ifAbsent: [ plotData add: 0 ].
	].

	(self smoothDays = 1)
		ifTrue: [ newPlotData := plotData ]
		ifFalse: [ | window |
			window := self smoothDays.
			newPlotData := OrderedCollection new.
			x := 1 to: (x size - window + 1).
			newPlotData addAll: (x collect: [ :eachEntry |
				((plotData copyFrom: eachEntry to: eachEntry + window - 1) sum / window) asFloat ]).
		].

	^ RSLinePlot new x: x y: newPlotData; fmt: '-'

]

{ #category : #accessing }
DDThroughputGlyph >> smoothDays [
	^ smoothDays ifNil: [ smoothDays := 1 ]
]

{ #category : #accessing }
DDThroughputGlyph >> smoothDays: anObject [
	smoothDays := anObject
]

{ #category : #accessing }
DDThroughputGlyph >> title [
	^ self subclassResponsibility.
]

{ #category : #accessing }
DDThroughputGlyph >> xMax [
	^ xMax	 ifNil: [ xMax := (self entity lastMessage createdAt - Date today) days ]

]

{ #category : #accessing }
DDThroughputGlyph >> xMax: anInteger [
	xMax := anInteger
]

{ #category : #accessing }
DDThroughputGlyph >> xMin [
	^ xMin	 ifNil: [ xMin := (self entity firstMessage createdAt - Date today) days ]
]

{ #category : #accessing }
DDThroughputGlyph >> xMin: anInteger [
	xMin := anInteger
]
