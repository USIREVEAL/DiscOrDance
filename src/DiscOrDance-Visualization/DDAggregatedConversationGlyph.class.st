"
I am a glyph representing a conversation.

I show Authors, Code Blocks, and Messages in an aggregated representation.
I show participants to the conversation, their messages and participation rate, and the code at the core of the conversation.
"
Class {
	#name : #DDAggregatedConversationGlyph,
	#superclass : #DDNodeGlyph,
	#instVars : [
		'authorGlyphs',
		'messageGlyphs'
	],
	#category : #'DiscOrDance-Visualization-Glyphs'
}

{ #category : #'private - utility' }
DDAggregatedConversationGlyph >> authorGlyph: aDDAuthor withSize: baseSize [
	| authorShape authorName |
	authorShape := aDDAuthor hasAvatar
		ifTrue: [ RSBitmap new form: aDDAuthor avatar; yourself. ]
		ifFalse: [ RSBox new color: Color blue; yourself. ].
		"ifFalse: [ RSBitmap new form: PolymorphSystemSettings pharoLogoForm; yourself ]"
	authorShape
		extent: baseSize @ baseSize.
	authorName := RSLabel new
		text: aDDAuthor name;
		color: Color darkGray;
		fontSize: 20;
		y: baseSize / 2.0 + 15.0.
	authorName width: authorName width + 30.0.
	^ RSComposite new
		shapes: { authorShape . authorName };
		model: aDDAuthor;
		color: #white;
		border: (RSBorder new width: 1.0; color: #black; yourself);
		adjustToChildren;
		padding: 5.0;
		@ RSPopup;
		@ RSDraggable;
		yourself.

]

{ #category : #'private - utility' }
DDAggregatedConversationGlyph >> authorsComposite: messagesRadius [
	| authors sortedAuthors |
	authors := RSComposite new.
	sortedAuthors := DDAuthor alphaSorted: (self entity messages collect: #author) asSet asOrderedCollection.
	authorGlyphs := sortedAuthors collect: [ :each | | baseSize |
		baseSize := ((self entity messages select: [ :msg | msg author = each ]) size) * 10.0 + 15.0.
		self authorGlyph: each withSize: baseSize ].

	authorGlyphs ifNotEmpty: [ | maxGlyphSize |
		maxGlyphSize := (authorGlyphs collect: #extent) max max.
		RSWeightedCircleLayout new
			radius: messagesRadius * 0.65 + (maxGlyphSize / 2.0);
			on: authorGlyphs.
		authors
			shapes: authorGlyphs;
			color: Color transparent. ]
	ifEmpty: [ authors color: Color red. ].
	authors adjustToChildren.
	^ authors
]

{ #category : #'private - utility' }
DDAggregatedConversationGlyph >> authorshipEdges [
	| bezierLines |
	bezierLines := messageGlyphs collect: [ :messageGlyph | | authorGlyph |
		authorGlyph := authorGlyphs detect: [ :ag | ag model = messageGlyph model author ].
		RSBezier new
			"withVerticalAttachPoint;"
			from: authorGlyph;
			to: messageGlyph;
			controlPointsController: (
				RSBlockCPController new
					block: [ :aLine |
						| mid |
   						mid := (authorGlyph position + messageGlyph position) / 2.
						{(authorGlyph position) . 
						(authorGlyph position x @ mid y) .
						(messageGlyph position x @ mid y) .
						(messageGlyph position)} ];
					yourself);
			yourself. ].
	^ bezierLines.
]

{ #category : #'private - utility' }
DDAggregatedConversationGlyph >> circularWeightedComposite: aBagOfElements withRadius: radius [
	| container glyphs |
	container := RSComposite new.
	glyphs := (aBagOfElements asSet collect: [ :each |
			RSBox new
				model: each;
				color: Color veryLightGray;
				size: 7.0 * (aBagOfElements occurrencesOf: each);
				@ RSPopup;
				@ RSDraggable;
				@ (RSLabeled new text: each asString; fontSize: 20.0; yourself );
				yourself. ]) asArray.
	glyphs ifNotEmpty: [ RSCircleLayout new radius: radius; on: glyphs ].
	container
		shapes: glyphs;
		adjustToChildren;
		color: Color transparent.
	^ container
]

{ #category : #'private - utility' }
DDAggregatedConversationGlyph >> codeClassesComposite [
	^ self elementsComposite: #codeClasses withRadius: 150.0.
]

{ #category : #'private - utility' }
DDAggregatedConversationGlyph >> codeComposite [
	| code codeBlocks |
	code := RSComposite new.
	codeBlocks := (self entity sourceCode collect: [ :each |
			RSBox new
				model: each;
				"width: each size;
				height: each locs;"
				width: 30;
				height: 20;
				color: Color green;
				@ RSPopup;
				@ RSDraggable;
				yourself. ]) asArray.
	codeBlocks ifNotEmpty: [
		RSGridLayout on: codeBlocks.
		code shapes: codeBlocks.
		code adjustToChildren.
		code color: Color transparent. ]
	ifEmpty: [ code := RSEllipse new color: Color red; model: 'No code'; @ RSPopup; @ RSDraggable; yourself. ].
	^ code
]

{ #category : #'private - utility' }
DDAggregatedConversationGlyph >> codeElementsComposite [
	^ self elementsComposite: #codeElements withRadius: 100.0.
]

{ #category : #'private - utility' }
DDAggregatedConversationGlyph >> codeLiteralsComposite [
	^ self elementsComposite: #codeLiterals withRadius: 100.0.
]

{ #category : #'private - utility' }
DDAggregatedConversationGlyph >> codeMethodsComposite [
	^ self elementsComposite: #codeMethods withRadius: 300.0.
]

{ #category : #'private - utility' }
DDAggregatedConversationGlyph >> elementsComposite: aSelector withRadius: radius [
	| elements |
	elements := (self entity perform: aSelector) asBag.
	^ self circularWeightedComposite: elements withRadius: radius

]

{ #category : #'private - utility' }
DDAggregatedConversationGlyph >> messageComposite [
	| messages sortedMessages |
	messages := RSComposite new.
	sortedMessages := DDMessage authorSorted: self entity messages.
	messageGlyphs := (sortedMessages collect: [ :each | RSEllipse new model: each; color: Color darkGray; @ RSPopup; @ RSDraggable; yourself. ]) asArray.
	messageGlyphs ifNotEmpty: [ 
		RSCircleLayout on: messageGlyphs.
		messages
			shapes: messageGlyphs;
			adjustToChildren;
			color: Color transparent. ]
	ifEmpty: [ messages color: Color red. ].
	^ messages
]

{ #category : #rendering }
DDAggregatedConversationGlyph >> shapeForRoassal [
	| newComposite code messages authors authorEdges messagesRadius newContainer codeLiterals codeLiteralsRadius codeMethods codeMethodsRadius codeClasses classesRadius |
	"codeLiterals := self codeLiteralsComposite.
	codeLiteralsRadius := codeLiterals width."
	codeMethods := self codeMethodsComposite.
	codeMethodsRadius := codeMethods width.
	codeClasses := self codeClassesComposite.
	classesRadius := codeClasses width.
	code := self codeComposite.
	"codeElements := self codeElementsComposite."
	messages := self messageComposite.
	messagesRadius := messages width.
	authors := self authorsComposite: messagesRadius.	

	newContainer := RSComposite new.
	newContainer
		shapes: { authors . messages . code . "codeLiterals ." codeMethods . codeClasses };
		color: Color transparent;
		borderColor: #black;
		adjustToChildren;
		padding: newContainer width / 10.0 + 5.0.
	authorEdges := self authorshipEdges.
	newContainer addAllShapes: authorEdges.
	{ authors . messages . code . "codeLiterals ." codeMethods . codeClasses } asOrderedCollection do: #pushFront.

	"(authors children size = 1) ifTrue: [
		RSVerticalLineLayout on: newContainer shapes.
		newContainer adjustToChildren. ]."
	newComposite := RSComposite new.
	newComposite
		shapes: { newContainer };
		adjustToChildren;
		padding: 5.0.
	self
		width: newComposite width;
		height: newComposite height;
		color: Color transparent.
	^ newComposite
]
