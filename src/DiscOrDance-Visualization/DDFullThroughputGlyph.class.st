"
I am a glyph representing a structural node with its throughput chart.
I consider averages of messages, sentences, and words per unit time in a sliding-window-based binned way.
"
Class {
	#name : #DDFullThroughputGlyph,
	#superclass : #DDThroughputGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #'as yet unclassified' }
DDFullThroughputGlyph class >> plotTypes [
	^ {
		#messages -> Color red .
		Color red -> #messages .
		#lines -> Color green .
		Color green -> #lines .
		#words -> Color blue .
		Color blue -> #words } asDictionary.

]

{ #category : #adding }
DDFullThroughputGlyph >> addAllPlots: anRSChart [
	#(
	words #wordCount
	lines #lineCount
	messages #messageCount) pairsDo: [ :label :selector | | plt |
		plt := self plot: selector.
		plt color: (self class plotTypes at: label).
		anRSChart addPlot: plt.
	].

]

{ #category : #rendering }
DDFullThroughputGlyph >> addPopup: anRSChart [
	| popup |
	popup := RSPopupDecoration new.
	anRSChart addDecoration: popup.
	popup chartPopupBuilder: (RSBlockChartPopupBuilder new
		rowShapeBlock: [ :plt :point | | series seriesName value date group |
			series := RSCircle new color: plt color.
			seriesName := RSLabel new text: (self class plotTypes at: plt color).
			value := RSLabel new text: (point y round: 2); bold.
			date := RSLabel new text: 'on: ' , (self dateFromInteger: point x) ddmmyyyy.
			group := { series . value . seriesName . date } asGroup.
			RSGridLayout new lineItemsCount: 4; on: group.
			group asShape
		]).

]

{ #category : #accessing }
DDFullThroughputGlyph >> title [
	^ 'Messages, lines, words' , ' - ' , self entity name
]
