"
I am a conversation.

I am composed of a sequence of messages that are time or reply related to one another.
Messages in me share a topic.
"
Class {
	#name : #DDConversation,
	#superclass : #DDNode,
	#instVars : [
		'start',
		'end',
		'messages'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #sorting }
DDConversation class >> timeSorted: aCollectionOfDDConversation [
	^ aCollectionOfDDConversation sorted: [ :a :b | a start createdAt < b start createdAt ].
]

{ #category : #'adding item' }
DDConversation >> add: aDDMessage [
	start ifNil: [ self start: aDDMessage ].
	messages add: aDDMessage.
	self end: aDDMessage.
]

{ #category : #'accessing-code' }
DDConversation >> classes [
	<vzContextMenu>
	self wordCloud: [ :keywords | keywords ] withWords: ( self sourceCode flatCollect: #codeClasses ).
]

{ #category : #'accessing-code' }
DDConversation >> codeClasses [
	^ self sourceCode flatCollect: #codeClasses.

]

{ #category : #'accessing-code' }
DDConversation >> codeElements [
	| codeLiterals codeVariables codeMethods |
	codeLiterals := OrderedCollection new.
	codeVariables := OrderedCollection new.
	codeMethods := OrderedCollection new.
	self sourceCode do: [ :eachCode |
		codeLiterals addAll: eachCode codeLiterals.
		codeVariables addAll: eachCode codeVariables.
		codeMethods addAll: eachCode codeMethods.
	].
	^ codeLiterals , codeVariables , codeMethods
]

{ #category : #'accessing-code' }
DDConversation >> codeLiterals [
	^ self sourceCode flatCollect: #codeLiterals.

]

{ #category : #'accessing-code' }
DDConversation >> codeMethods [
	^ self sourceCode flatCollect: #codeMethods.

]

{ #category : #'accessing-code' }
DDConversation >> codeWordCloud [
	<vzContextMenu>
	self wordCloud: [ :keywords | keywords ] withWords: self codeElements.
]

{ #category : #accessing }
DDConversation >> end [
	^ end
]

{ #category : #accessing }
DDConversation >> end: aDDMessage [
	end := aDDMessage
]

{ #category : #acccessing }
DDConversation >> getCompleteTranscript [
	"Return a complete transcript of this conversation with timestamp, author, content."
	| entries |
	entries := (DDMessage timeSorted: self messages) collect: [ :each |
			each createdAt asDateAndTime asStringYMDHM , ' UTC - ' , each author name , ' - ' , each content asString. ].
	^ (String cr) join: entries

]

{ #category : #initialization }
DDConversation >> initialize [
	messages := OrderedCollection new.
]

{ #category : #visualizing }
DDConversation >> inspectCodeAST [
	<vzContextMenu>
	self sourceCode do: [ :each | each parsedAST inspect ].
]

{ #category : #testing }
DDConversation >> involvesCode [
	^ self messages anySatisfy: [ :each | each hasSourceCode ]
]

{ #category : #testing }
DDConversation >> isEmpty [
	^ messages isEmpty or: [ self participatingAuthors isEmpty ].
]

{ #category : #accessing }
DDConversation >> messages [
	^ messages
]

{ #category : #accessing }
DDConversation >> messages: anOrderedCollectionOfDDMessage [
	messages := anOrderedCollectionOfDDMessage
]

{ #category : #accessing }
DDConversation >> name [
	| msgs auths |
	msgs := self messages size.
	auths := self participatingAuthors size.
	(msgs = 1) ifTrue: [ ^ 'Single message from ' , (self participatingAuthors asOrderedCollection at: 1) name ].
	(auths = 1) ifTrue: [ ^ msgs asString , ' messages from ' , (self participatingAuthors asOrderedCollection at: 1) name ].
	^ msgs asString , ' messages between ' , auths asString , ' different authors.'.
]

{ #category : #visualizing }
DDConversation >> openInDiscord [
	<vzContextMenu>
	self start openInDiscord
]

{ #category : #accessing }
DDConversation >> participatingAuthors [
	^ (self messages collect: #author) asSet
]

{ #category : #accessing }
DDConversation >> sourceCode [
	^ self messages flatCollect: #sourceCode
]

{ #category : #accessing }
DDConversation >> span [
	^ self end createdAt asDateAndTime - self start createdAt asDateAndTime
]

{ #category : #accessing }
DDConversation >> start [
	^ start
]

{ #category : #accessing }
DDConversation >> start: aDDMessage [
	start := aDDMessage
]

{ #category : #visualizing }
DDConversation >> transcript [
	<vzContextMenu>
	self getCompleteTranscript inspect
]

{ #category : #visualizing }
DDConversation >> wordCloud: keywordFilterBlock [
	| keywords |
	keywords := self messages flatCollect: #keywords.
	self wordCloud: keywordFilterBlock withWords: keywords.
]

{ #category : #visualizing }
DDConversation >> wordCloud: keywordFilterBlock withWords: aCollectionOfKeywords [
	| canvas filteredKeywords labels maxSize sizes |
	canvas := RSCanvas new @ RSCanvasController.
	filteredKeywords := (keywordFilterBlock value: aCollectionOfKeywords) asBag.
	
	labels := filteredKeywords asSet collect: [ :each |
		RSLabel new model: each;
			text: each;
			yourself. ].
	labels := labels sorted: [ :a :b |
		(filteredKeywords occurrencesOf: a model) > (filteredKeywords occurrencesOf: b model) ].
	canvas addAll: labels.
	RSNormalizer fontSize
		from: 10;
		to: 100;
		shapes: labels;
		normalize: [ :each | filteredKeywords occurrencesOf: each ].
	sizes := (labels asOrderedCollection collect: #fontSize).
	maxSize := sizes
		ifEmpty: [ 10.0 ]
		ifNotEmpty: [ sizes max ].
	RSFlowLayout new gapSize: 0.4 * maxSize; on: labels.
	canvas openWithTitle: 'Conversation word-cloud'.
]

{ #category : #visualizing }
DDConversation >> wordCloudAll [
	<vzContextMenu>
	self wordCloud: [ :keywords | keywords ]
]

{ #category : #visualizing }
DDConversation >> wordCloudCleaned [
	<vzContextMenu>
	| domainWords |
	self wordCloud: [ :keywords | | newKeywords newKeywordsBag stopwords |
		self flag: #FIXME. "Should use server's domain information, not default ones."
		"DDDomain new stopwords do: [ :each | keywords remove: each ifAbsent: [] ]."
		stopwords := DDDomain new stopwords asSet.
		newKeywords := keywords reject: [ :each | stopwords includes: each asLowercase  ].
		newKeywords := newKeywords reject: [ :each | each matchesRegex: '[-<>]*\\d+(\\.\\d+)?-<>]*' ].
		newKeywords := newKeywords reject: [ :each | each size < 3 ].
		DDDomain new punctuation do: [ :each | newKeywords remove: each ifAbsent: [] ].
		
		"Remove all single occurring keywords"
		newKeywordsBag := newKeywords asBag.
		newKeywords removeAllSuchThat: [ :each | (newKeywordsBag occurrencesOf: each) = 1 ].
		
		"Remove server and channel names"
		domainWords := { 
			self start containerChannel name asLowercase.
			self start containerChannel server name asLowercase }.
		newKeywords := newKeywords reject: [ :each | domainWords includes: each asLowercase  ].

		"Remove mentions"
		newKeywords := newKeywords reject: [ :each | each matchesRegex: '<[#!@]\d+>'].
		
		newKeywords
	]
]

{ #category : #visualizing }
DDConversation >> wordCloudNoStopWords [
	<vzContextMenu>
	self wordCloud: [ :keywords | | stopwords newKeywords |
		self flag: #FIXME. "Should use server's domain information, not default ones."
		"DDDomain new stopwords do: [ :each | keywords remove: each ifAbsent: [] ]."
		stopwords := DDDomain new stopwords asSet.
		newKeywords := keywords reject: [ :each | stopwords includes: each asLowercase  ].
		newKeywords
	]
]
