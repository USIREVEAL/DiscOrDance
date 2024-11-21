"
I am a Discord channel.

I know authors who have been sending messages in me and their messages.
I have a topic.
I know my parent category or container server (in case I am a top-level channel).
"
Class {
	#name : #DDChannel,
	#superclass : #DDStructuralNode,
	#instVars : [
		'parent',
		'topic',
		'messages',
		'authors',
		'containerServer',
		'canReadMessages',
		'conversations',
		'messageIntervals'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #accessing }
DDChannel class >> allMessages: aDSChannel [
	"Return all the messages by retrieving them in blocks of fixed size as supported by the REST api implementation"
	
	| allDSMessages olderMessages |

	self logIntention: aDSChannel withLimit: -1.

	allDSMessages := OrderedCollection new.
	olderMessages := aDSChannel messages.
	allDSMessages addAll: olderMessages.

	[ olderMessages isEmpty ]
	whileFalse: [
		self logDownloaded: allDSMessages inChannel: aDSChannel.
		olderMessages := aDSChannel queryMessagesBefore: (olderMessages at: (olderMessages size)).	
		allDSMessages addAll: olderMessages.
	].
	
	self logFinalDownloaded: allDSMessages inChannel: aDSChannel.
	^ allDSMessages.

]

{ #category : #accessing }
DDChannel class >> allMessages: aDSChannel withLimit: messageLimit [
	"Retrieve the last messageLimit messages in aDSChannel."
	
	| allDSMessages firstBatch firstBatchSize |

	self logIntention: aDSChannel withLimit: messageLimit.
	allDSMessages := OrderedCollection new.

	firstBatch := aDSChannel messages.
	firstBatchSize := firstBatch size.
	(firstBatchSize = 0) ifTrue: [
		self logFinalDownloaded: allDSMessages inChannel: aDSChannel.
		^ allDSMessages ].
	
	(messageLimit <= firstBatchSize ) ifTrue: [
		allDSMessages addAll: (firstBatch first: messageLimit).
	]
	ifFalse: [ | olderMessages maxRemaining |
		olderMessages := firstBatch.
		allDSMessages addAll: olderMessages.
		maxRemaining := messageLimit - firstBatchSize.
		[ maxRemaining > 0 ] whileTrue: [
			self logDownloaded: allDSMessages inChannel: aDSChannel.
			olderMessages := aDSChannel queryMessagesBefore: (olderMessages at: (olderMessages size)).
			(olderMessages isEmpty)
			ifTrue: [
				self logFinalDownloaded: allDSMessages inChannel: aDSChannel.
				^ allDSMessages ].
			( olderMessages size <= maxRemaining )
			ifTrue: [ 
				allDSMessages addAll: olderMessages.
				maxRemaining := maxRemaining - (olderMessages size).
			]
			ifFalse: [ 
				allDSMessages addAll: (olderMessages first: maxRemaining).
				maxRemaining := 0.
			].
		].
	].
	self logFinalDownloaded: allDSMessages inChannel: aDSChannel.
	^ allDSMessages.

]

{ #category : #'as yet unclassified' }
DDChannel class >> checkPermissions: aDSChannel [
	self flag: #FIXME "Check explicitly for permissions instead of resorting to errors".
	[ aDSChannel messages. ]
	on: DSUnauthorizedOperationError
	do: [
		self flag: #TODO "Add the channel and some extra information to a final quality report as a possible problem".
		Transcript show: 'Inconsistent permissions for channel ' , (aDSChannel name); cr.
		Transcript show: 'Channel ' , (aDSChannel name) , ' is visible to the bot but messages cannot be read.' ; cr.
		DDPossiblePermissionInconsistency signal.
	]
]

{ #category : #initialization }
DDChannel class >> createFromDS: aDSChannel withParent: aParent [
	| newChannel |
	newChannel := aDSChannel isGuildTextChannel
		ifTrue: [ DDTextChannel new ]
		ifFalse: [ DDVoiceChannel new ].
	newChannel id: aDSChannel id.
	newChannel parent: aParent.
	newChannel name: aDSChannel name.
	aDSChannel isGuildTextChannel
		ifTrue: [ | allDSMessages |
			newChannel topic: aDSChannel topic.
			[
				self checkPermissions: aDSChannel.
				allDSMessages := aParent getContainerServer globalConfiguration limitMessages
					ifTrue: [ self
							allMessages: aDSChannel
							withLimit: aParent getContainerServer globalConfiguration messagesPerChannel ]
					ifFalse: [ self allMessages: aDSChannel ].
				allDSMessages
					do: [ :eachDSMessage |
						"Filter messages sent after snapshot starting time and date"
						(eachDSMessage timestamp asDateAndTime <= aParent getContainerServer snapshotDate)
							ifTrue: [
								newChannel messages
									add: (DDMessage createFromDS: eachDSMessage inChannel: newChannel)
							].
					].
				newChannel linkReplies.
			]
				on: DDPossiblePermissionInconsistency
				do: [ newChannel canReadMessages: false ]
			].
	^ newChannel
]

{ #category : #default }
DDChannel class >> defaultConversationBreakTime [
	"Time between two messages to be considered in a conversation flow."
	^ Duration hours: 2
]

{ #category : #logging }
DDChannel class >> logDownloaded: aCollection inChannel: aDSChannel [
	Transcript show: aDSChannel name , ': ';
		show: 'Downloaded ' , (aCollection size asString);
		show: ' messages so far.'; cr.

]

{ #category : #logging }
DDChannel class >> logFinalDownloaded: aCollection inChannel: aDSChannel [
	Transcript show: aDSChannel name , ': ';
		show: 'Downloaded a total of ' , (aCollection size asString);
		show: ' messages.'; cr.

]

{ #category : #logging }
DDChannel class >> logIntention: aDSChannel withLimit: messageLimit [
	Transcript show: 'Downloading messages in ' , aDSChannel name;
		show: ' (limit: ' , messageLimit asString;
		show: ')'; cr.

]

{ #category : #adding }
DDChannel >> addAuthor: anAuthor [
	(self isAuthorActive: anAuthor)
		ifTrue: [ ^ self ].
	authors add: anAuthor.
	self containerServer addActiveAuthor: anAuthor
]

{ #category : #adding }
DDChannel >> addMessage: aMessage [
	messages ifNil: [messages := OrderedCollection new].
	messages add: aMessage

]

{ #category : #converting }
DDChannel >> asJSON [
	^ String streamContents: [ :stream |
		(NeoJSONWriter on: stream)
			prettyPrint: true;
			for: DateAndTime customDo: [ :mapping | mapping encoder:
				#printString ];
			for: DDMessage customDo: [ :mapping | mapping encoder: #asJSONDictionary ];
			for: DDTopic customDo: [ :mapping | mapping encoder: #asJSONDictionary ];
			for: DDAttachment customDo: [ :mapping | mapping encoder: #asJSONDictionary ];
			nextPut: self asJSONDictionary.
	].
]

{ #category : #converting }
DDChannel >> asJSONDictionary [
	| topics |
	topics := OrderedCollection new.
	topics add: (DDTopic new description: (self topic ifNil: ['N/A'])).
	^ { #id -> self id .
		#path -> (self fullyQualifiedName: '/') .
		#topics -> topics .
		#messages -> self messages } asDictionary
]

{ #category : #accessing }
DDChannel >> authors [
	^ authors
]

{ #category : #accessing }
DDChannel >> authors: anObject [
	authors := anObject
]

{ #category : #accessing }
DDChannel >> canReadMessages [
	^ canReadMessages.
]

{ #category : #accessing }
DDChannel >> canReadMessages: aBoolean [
	canReadMessages := aBoolean.
]

{ #category : #accessing }
DDChannel >> containerServer [
	"Retrieve and return the server containing this channel in his hierarchy. The server is searched only once and then the result is stored, so subsequent calls will return the initial server unless it is invalidated (e.g. by setting containerServer to nil) - TODO provide invalidation mechanism, see comments below in code." 
	self flag: #FIXME "This implementation doesn't allow for recomputation of container server".
	containerServer ifNil: [ 
		containerServer := self parent.
		[ containerServer isKindOf: DDServer ] whileFalse: [ containerServer := containerServer parent ].
		self flag: #TODO "Add a check to see if a proper parent server is obtainable, otherwise reply in an appropriate way.".
	].
	^ containerServer.
]

{ #category : #accessing }
DDChannel >> conversations [
	conversations ifNil: [ self inferConversations ].
	^ conversations
]

{ #category : #exporting }
DDChannel >> exportChannel [
	<vzContextMenu>
	self exportToJSON
]

{ #category : #exporting }
DDChannel >> exportToJSON [
	DDModel ensureChannelDumpsDirectoryExists.
	(DDModel defaultChannelDumpsDirectory / ((self fullyQualifiedName) , '_messages_dump.json')) writeStreamDo: [ :stream | stream nextPutAll: self asJSON ].
]

{ #category : #accessing }
DDChannel >> fullyQualifiedName [
	^ self fullyQualifiedName: '_'.
]

{ #category : #accessing }
DDChannel >> fullyQualifiedName: separator [
	| fqn |
	fqn := (parent isKindOf: DDCategory)
		ifTrue: [ separator join: { self server name . self parent name . self name } ]
		ifFalse: [ separator join: { self server name . self name } ].
	^ fqn copyReplaceAll: ' ' with: '-'.
]

{ #category : #accessing }
DDChannel >> getAuthor: anAuthor [ 
	^ authors like: anAuthor.
]

{ #category : #accessing }
DDChannel >> getMessageWithId: messageId [
	^ self messages
		detect: [ :each |
			each id = messageId ]
		ifNone: [ nil ].
]

{ #category : #accessing }
DDChannel >> getMessagesByAuthor [
	"Return the number of messages sent in the channel by each author."
	^ Bag new.
]

{ #category : #inferring }
DDChannel >> inferConversations [
	| sortedMessages lastConversation |
	conversations := OrderedCollection new.
	lastConversation := DDConversation new.
	sortedMessages := DDMessage timeSorted: self messages.
	1 to: (sortedMessages size - 1) do: [ :index | | previous next |
		next := sortedMessages at: (index + 1).
		previous := sortedMessages at: index. 
		(next isInConversationWith: previous) ifFalse: [
			conversations add: lastConversation.
			lastConversation := DDConversation new. ].
		lastConversation add: next.
	].

]

{ #category : #initialization }
DDChannel >> initialize [
	super initialize.
	messages := OrderedCollection new.
	authors := Set new.
	canReadMessages := true.

]

{ #category : #accessing }
DDChannel >> isAuthorActive: anAuthor [
	^ authors includes: anAuthor.
]

{ #category : #testing }
DDChannel >> isTextChannel [
	self subclassResponsibility .
]

{ #category : #'deferred-linking' }
DDChannel >> linkReplies [
	"Update reply links from id to aDDMessage"
	self messages do: [ :each |
		each repliesTo ifNotNil: [ |referencedMessage|
			referencedMessage := self getMessageWithId: each repliesTo.
			referencedMessage ifNil: [
				referencedMessage := DDUnscrapedMessage new
					id: each id;
					yourself ].
			each repliesTo: referencedMessage.
			referencedMessage addReply: each.
		].
	].
]

{ #category : #'context menu - charting' }
DDChannel >> messageIntervals [
	| sortedMessages |
	messageIntervals ifNotNil: [ ^ messageIntervals ].
	sortedMessages := DDMessage timeSorted: self messages.
	messageIntervals := (1 to: (sortedMessages size - 1)) collect: [ :index | | previous next |
		next := sortedMessages at: (index + 1).
		previous := sortedMessages at: index. 
		(next creationDateAndTime - previous creationDateAndTime) asDuration
	].
	^ messageIntervals
]

{ #category : #'context menu - charting' }
DDChannel >> messageIntervalsChart [
	| c plot intervals |
	<vzContextMenu>

	intervals := self messageIntervals collect: #asMinutes.
	(intervals isEmpty) ifTrue: [ ^ self inform: 'No messages found.' ].
	c := RSChart new.
	plot := RSLinePlot new x: (1 to: intervals size) y: intervals.
	c addPlot: plot.
	c addDecoration: RSVerticalTick new.
	c addDecoration: RSHorizontalTick new.
	c open.
]

{ #category : #accessing }
DDChannel >> messages [
	^ messages
]

{ #category : #accessing }
DDChannel >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
DDChannel >> parent [
	^ parent
]

{ #category : #accessing }
DDChannel >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
DDChannel >> server [
	self flag: #FIXME. "Relying on buggy implementation of `self containerServer`. See that method for possible causes of bugs."
	^ self containerServer
]

{ #category : #accessing }
DDChannel >> topic [
	^ topic
]

{ #category : #accessing }
DDChannel >> topic: anObject [
	topic := anObject
]
