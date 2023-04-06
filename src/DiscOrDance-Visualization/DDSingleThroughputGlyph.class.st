"
I am a glyph representing a structural node with its throughput chart.
I consider averages of the given selector per unit time in a sliding-window-based binned way.
"
Class {
	#name : #DDSingleThroughputGlyph,
	#superclass : #DDThroughputGlyph,
	#instVars : [
		'selector'
	],
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #adding }
DDSingleThroughputGlyph >> addAllPlots: anRSChart [
	anRSChart addPlot: (self plot: self selector).

]

{ #category : #rendering }
DDSingleThroughputGlyph >> addPopup: anRSChart [
	| popup |
	popup := RSPopupDecoration new.
	anRSChart addDecoration: popup.
	popup chartPopupBuilder: (RSBlockChartPopupBuilder new
		rowShapeBlock: [ :plt :point | | value date group |
			value := RSLabel new text: (point y round: 2); bold.
			date := RSLabel new text: 'on: ' , (self dateFromInteger: point x) ddmmyyyy.
			group := { value . date } asGroup.
			RSGridLayout new lineItemsCount: 2; on: group.
			group asShape
		 ]).

]

{ #category : #accessing }
DDSingleThroughputGlyph >> selector [
	^ selector
]

{ #category : #accessing }
DDSingleThroughputGlyph >> selector: aSelector [
	selector := aSelector
]

{ #category : #accessing }
DDSingleThroughputGlyph >> title [
	^ self selector , ' - ' , self entity name
]
