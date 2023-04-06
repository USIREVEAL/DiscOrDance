"
I am a glyph shouwing a sparkline of the activity of a DDAuthor.
"
Class {
	#name : #DDSparklineGlyph,
	#superclass : #DDChartGlyph,
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #rendering }
DDSparklineGlyph >> chartForRoassal [
	| maxDaysDifference maxMessages chart plot values |

	values := self entity messageCreationDates collect: [ :each | (each - Date today) days ].
	self flag: #FIXME. "Quick hack to avoid errors in binning, it is not shown anyway since we use bins up to 0."
	values add: 1.
	self color: Color transparent.

	maxDaysDifference := (DDNormalizedFirstMessageDateDifferenceMetric min truncateTo: 1 day) days.
	maxMessages := DDNormalizedMaxDailySentMessagesMetric max.

	chart := RSChart new.
	plot := RSHistogramPlot new x: values.
	plot bins: (maxDaysDifference to: 0).

	"plot binningStrategy: RSSturgesBinning new."
	chart addPlot: plot.
	self hasDecorations ifTrue: [
		chart addDecoration: (RSVerticalTick new integer; fontSize: 12; yourself).
		chart addDecoration:
			(DDDateDifferenceHorizontalTick new
				numberOfTicks: 4;
				fontSize: 12;
				yourself).
	].

	chart
		minValueX: maxDaysDifference - 1;
		maxValueX: 0;
		minValueY: 0;
		maxValueY: maxMessages;
		extent: 400 @ 80.

	"(Date today + ((maxDaysDifference - 1) days)) traceCr."

	self showName ifTrue: [
		self leftAlignable
			ifTrue: [ chart xlabel: self entity name offset: (0 @ -102) ]
			ifFalse: [ chart xlabel: self entity name offset: (-235 - (self entity name size * 5.2)) @ -40 ].
	].
	^ chart
]

{ #category : #testing }
DDSparklineGlyph >> hasDecorations [
	^ true
]

{ #category : #accessing }
DDSparklineGlyph >> height [
	^ self shape height
]

{ #category : #rendering }
DDSparklineGlyph >> leftAlignable [
	^ false
]

{ #category : #testing }
DDSparklineGlyph >> needPlaceholderGlyph [
	^ self entity hasMessages not
]

{ #category : #rendering }
DDSparklineGlyph >> showName [
	^ true
]

{ #category : #accessing }
DDSparklineGlyph >> width [
	^ self shape width
]
