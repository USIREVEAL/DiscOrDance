"
I am an abstract node representing structural elements in the server architecture (categories, channels etc.).
"
Class {
	#name : #DDStructuralNode,
	#superclass : #DDNode,
	#instVars : [
		'id'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #accessing }
DDStructuralNode >> firstMessage [
	^ self timeSortedMessages first
]

{ #category : #testing }
DDStructuralNode >> hasMessages [
	^ self messages isNotEmpty
]

{ #category : #accessing }
DDStructuralNode >> id [
	^ id
]

{ #category : #accessing }
DDStructuralNode >> id: anObject [
	id := anObject
]

{ #category : #accessing }
DDStructuralNode >> lastMessage [
	^ self timeSortedMessages last
]

{ #category : #'context menu - charting' }
DDStructuralNode >> messageIntervals [
	self subclassResponsibility.
]

{ #category : #'context menu - charting' }
DDStructuralNode >> messageIntervalsHistogram12h [
	<vzContextMenu>

	self messageIntervalsHistogram: 12
]

{ #category : #'context menu - charting' }
DDStructuralNode >> messageIntervalsHistogram1h [
	<vzContextMenu>

	self messageIntervalsHistogram: 1
]

{ #category : #'context menu - charting' }
DDStructuralNode >> messageIntervalsHistogram24h [
	<vzContextMenu>

	self messageIntervalsHistogram: 24
]

{ #category : #'context menu - charting' }
DDStructuralNode >> messageIntervalsHistogram6h [
	<vzContextMenu>

	self messageIntervalsHistogram: 6
]

{ #category : #'context menu - charting' }
DDStructuralNode >> messageIntervalsHistogram: filterAfterHours [
	| c plot intervals |

	intervals := self messageIntervals collect: #asMinutes.
	"Remove outliers (more than filterAfterHours hours after, for better clarity"
	intervals := intervals reject: [ :each | each > (60 * filterAfterHours) ].
	(intervals isEmpty) ifTrue: [ ^ self inform: 'No messages found.' ].
	c := RSChart new.
	plot := RSHistogramPlot new x: intervals.
	c addPlot: plot.
	c addDecoration: RSVerticalTick new.
	c addDecoration: RSHorizontalTick new.
	c extent: 300@100.
	c open.
]

{ #category : #accessing }
DDStructuralNode >> messages [
	self subclassResponsibility.
]

{ #category : #accessing }
DDStructuralNode >> messagesByDate [
	^ self timeSortedMessages groupedBy: [ :message | message createdAt asDate ]
]

{ #category : #'accessing - statistics' }
DDStructuralNode >> numberOfMessages [
	^ self messages size
]

{ #category : #'context menu - charting' }
DDStructuralNode >> openLinesThroughputChart [
	<vzContextMenu>
	self hasMessages
		ifFalse: [ self inform: 'Selected entity has no activity.' ]
		ifTrue: [ self throughputChart: #lineCount ].
]

{ #category : #'context menu - charting' }
DDStructuralNode >> openMessagesThroughputChart [
	<vzContextMenu>
	self hasMessages
		ifFalse: [ self inform: 'Selected entity has no activity.' ]
		ifTrue: [ self throughputChart: #messageCount ].
]

{ #category : #'context menu - charting' }
DDStructuralNode >> openMonthlySmoothedThroughputChart [
	<vzContextMenu>
	self hasMessages
		ifFalse: [ self inform: 'Selected entity has no activity.' ]
		ifTrue: [ self throughputChartSmoothed: 30 ].
]

{ #category : #'context menu - charting' }
DDStructuralNode >> openThroughputChart [
	<vzContextMenu>
	self hasMessages
		ifFalse: [ self inform: 'Selected entity has no activity.' ]
		ifTrue: [ self throughputChart ].
]

{ #category : #'context menu - charting' }
DDStructuralNode >> openWeeklySmoothedThroughputChart [
	<vzContextMenu>
	self hasMessages
		ifFalse: [ self inform: 'Selected entity has no activity.' ]
		ifTrue: [ self throughputChartSmoothed: 7 ].
]

{ #category : #'context menu - charting' }
DDStructuralNode >> openWordsThroughputChart [
	<vzContextMenu>
	self hasMessages
		ifFalse: [ self inform: 'Selected entity has no activity.' ]
		ifTrue: [ self throughputChart: #wordCount ].
]

{ #category : #charting }
DDStructuralNode >> throughputChart [
	| chart |
	chart := DDFullThroughputGlyph new
		entity: self;
		chartForRoassal.
	chart build.
	chart canvas openWithTitle: 'Messages, lines, words - ' , self printString.
]

{ #category : #charting }
DDStructuralNode >> throughputChart: selector [
	| chart |
	chart := DDSingleThroughputGlyph new
		entity: self;
		selector: selector;
		chartForRoassal.
	chart build.
	chart canvas openWithTitle: selector , ' - ' , self printString.
]

{ #category : #charting }
DDStructuralNode >> throughputChartSmoothed: numberOfDays [
	| chart |
	chart := DDFullThroughputGlyph new
		entity: self;
		smoothDays: numberOfDays;
		chartForRoassal.
	chart build.
	chart canvas openWithTitle: 'Messages, lines, words (smooth: ', numberOfDays printString , ') - ' , self printString.
]

{ #category : #accessing }
DDStructuralNode >> timeSortedMessages [
	^ DDMessage timeSorted: self messages.
]
