"
I am a category in a Discord server.

I am a top level container of channels.
I know authors who have been sending messages in my channels.

I cannot contain sub-categories but only channels.

"
Class {
	#name : #DDCategory,
	#superclass : #DDStructuralNode,
	#instVars : [
		'parent',
		'channels'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #initialization }
DDCategory class >> createFromDS: aDSCategory withParent: aParent [
	| newCategory dsChannels |
	newCategory := self new.
	newCategory id: aDSCategory id.
	newCategory parent: aParent.
	newCategory name: aDSCategory name.
	dsChannels := aDSCategory subordinateChannels.
	dsChannels
		do: [ :eachDSChannel | | newChannel |
			newChannel := DDChannel createFromDS: eachDSChannel withParent: newCategory.
			newCategory channels add: newChannel ]
		displayingProgress: [ :each | 'Analysing channel ', each name asString ].
	^ newCategory
]

{ #category : #accessing }
DDCategory >> channels [
	^ channels
]

{ #category : #accessing }
DDCategory >> channels: anObject [
	channels := anObject
]

{ #category : #accessing }
DDCategory >> getAuthors [
	"Return the set of Authors active in at least one channel of this category."
	| authors |
	authors := Set new.
	(channels collect: [ :eachChannel | eachChannel authors ]) do: [ :each | authors addAll: each ].
	^ authors.
]

{ #category : #accessors }
DDCategory >> getContainerServer [
	^ self parent.
]

{ #category : #accessing }
DDCategory >> getMessagesByAuthor [
	"Return the number of messages sent in the category by each author."
	| count |
	count := 	Bag new.
	(channels collect: [ :eachChannel | eachChannel getMessagesByAuthor ]) do: [ :each | count addAll: each ].
	^ count.
]

{ #category : #'accessing structure variables' }
DDCategory >> glyph [
	^ RSBox new
		model: self;
		height: 20;
		width: 50;
		color: Color gray;
		@ RSDraggable;
		@ RSPopup.

]

{ #category : #initialization }
DDCategory >> initialize [
	super initialize.
	name := ''.
	channels := OrderedCollection new.
]

{ #category : #accessing }
DDCategory >> maxMessagesInChannels [
	^ (channels collect: [ :each | each messages size ]) max.
]

{ #category : #'context menu - charting' }
DDCategory >> messageIntervals [
	^ self channels flatCollect: #messageIntervals.
]

{ #category : #accessing }
DDCategory >> messages [
	^ self channels flatCollect: #messages.
]

{ #category : #accessing }
DDCategory >> parent [
	^ parent
]

{ #category : #accessing }
DDCategory >> parent: anObject [
	parent := anObject
]

{ #category : #visualization }
DDCategory >> radialView: anRSCanvas [
	| shapes compositeView textChannelShapes voiceChannelShapes categoryShape |

	textChannelShapes := self textChannels
		collect: [ :each | each glyph ].
	voiceChannelShapes := self voiceChannels
		collect: [ :each | each glyph ].
	categoryShape := self glyph.
	
	shapes := OrderedCollection new.
	shapes add: categoryShape.
	shapes addAll: (textChannelShapes , voiceChannelShapes).
	
	RSNormalizer size
		from: 10;
		to: 100;
		shapes: (textChannelShapes collect: [ :each | each shapes at:1 ]);
		normalize: #numberOfMessages.

	RSNormalizer size
		from: 10;
		to: 100;
		shapes: textChannelShapes;
		normalize: #numberOfMessages.

	self flag: #TODO "Implement a better layouting strategy inside the composite shape (i.e. Category in the center, other elements on an outer circle)".
	RSForceBasedLayout new charge: -700; on: shapes.

	"RSRadialTreeLayout new on: shapes."

	compositeView := RSComposite new.
	compositeView model: self.
	compositeView shapes:	shapes.
	compositeView padding: 10.
	"compositeView updateLinesON."
	compositeView color: (Color red alpha: 0.15).

	RSLineBuilder line
		canvas: anRSCanvas;
		color: Color red;
		shapes: shapes;
		connectFrom: [ categoryShape model ]
		toAll: [ (textChannelShapes, voiceChannelShapes) collect: #model ].

	^ compositeView
]

{ #category : #accessing }
DDCategory >> server [
	^ self parent
]

{ #category : #accessing }
DDCategory >> textChannels [
	^ self channels select: [ :each | each isTextChannel ]
]

{ #category : #accessing }
DDCategory >> voiceChannels [
	^ self channels reject: [ :each | each isTextChannel ]
]
