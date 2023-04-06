"
I am a message sent in a Discord server.

I know who sent me and in which channel.
I know time information about myself.
"
Class {
	#name : #DDMessage,
	#superclass : #DDNode,
	#instVars : [
		'id',
		'author',
		'content',
		'embeds',
		'attachments',
		'reactions',
		'codeBlocks',
		'containerChannel',
		'createdAt',
		'pointsOfInterest',
		'mentions',
		'userMentions',
		'roleMentions',
		'channelMentions',
		'lastEditedAt',
		'specialMentions',
		'repliesTo',
		'replies'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #'private - initialization' }
DDMessage class >> authorFrom: aDSMessage in: aDDChannel with: aDDMessage [
	| author |
	[ author := aDDChannel containerServer getAuthorWithId: aDSMessage author id. ]
		on: NotFound
		do: [
			author := DDAuthor createFromDS: aDSMessage author.
			author server: aDDChannel containerServer.
			aDDChannel containerServer addAuthor: author.
		].

	(aDDChannel isAuthorActive: author)
	ifFalse: [
		author makeActiveInChannel: aDDChannel withMessage: aDDMessage.
	].
	author addSentMessage: aDDMessage.

]

{ #category : #sorting }
DDMessage class >> authorSorted: aCollectionOfDDMessages [
	^ aCollectionOfDDMessages sorted: [ :a :b | a author name asLowercase < b author name asLowercase ].
]

{ #category : #'private - initialization' }
DDMessage class >> codeBlocksIn: aDDMessage [
	"Returns a collection of all code block elements included in single or triple backticks"
	| content codeBlocks |
	
	content := aDDMessage content.
	codeBlocks := OrderedCollection new.

	"All nonEmpty blocks between single backticks"
	codeBlocks addAll:
		((content allRegexMatches: '`(?!(``))([^`])*`(?!(``))')
			reject: [ :each | each = '``' ]
			thenCollect: [ :each | (each allButFirst:1) allButLast: 1]).
	
	"All nonEmpty blocks between triple backticks"
	codeBlocks addAll:
		((content allRegexMatches: '```([^`])+```')
			collect: [ :each | (each allButFirst:3) allButLast: 3]).

	self flag: #FIXME "Add check for blocks with syntax highlighting
		(i.e.
			```smalltalk
					smalltalk highlighted code...
			```
		)".
	^ codeBlocks collect: [ :each |
			DDCode new
				message: aDDMessage;
				codeSource: each;
				yourself.
		]
]

{ #category : #initialization }
DDMessage class >> createFromDS: aDSMessage inChannel: aChannel [
	| newMessage |

	newMessage := self new.
	
	newMessage id: aDSMessage id.

	self authorFrom: aDSMessage in: aChannel with: newMessage.

	"Handling structure and content"
	newMessage containerChannel: aChannel.
	newMessage content: aDSMessage content.
	
	"Handle reply messages"
	aDSMessage referencedMessage ifNotNil: [
		self flag: #FIXME. "Temporary fix to handle only replies. Other type of references should be supported. More robust to check message type for reply id (see discord api)."
		((aChannel id = aDSMessage messageReference channelId) and: (aChannel containerServer id = aDSMessage messageReference guildId)) ifTrue: [
			newMessage repliesTo: aDSMessage messageReference messageId.
		].
	].
	
	newMessage createdAt: aDSMessage timestamp.
	newMessage lastEditedAt: aDSMessage editedTimestamp.
	
	self mentionsFrom: aDSMessage in: aChannel with: newMessage.

	"Handling other special content"
	newMessage embeds: (aDSMessage embeds collect: [ :each | DDEmbed createFromDS: each ]).
	newMessage attachments: (aDSMessage attachments collect: [ :each | DDAttachment createFromDS: each ]).

	aDSMessage reactions ifNotNil: [ 
		newMessage reactions: (aDSMessage reactions collect: [ :each | DDReaction createFromDS: each withMessage: newMessage ]).
	].

	newMessage codeBlocks: (OrderedCollection withAll: (self codeBlocksIn: newMessage)).
	newMessage pointsOfInterest: (OrderedCollection withAll: (self pointsOfInterestIn: newMessage)).
	
	^ newMessage
]

{ #category : #'private - initialization' }
DDMessage class >> mentionsFrom: aDSMessage in: aDDChannel with: aDDMessage [
	| mentions |
	mentions := aDSMessage mentions collect: [ :eachUser | | author |
		[ DDUserMention new
				mentionedEntity: (aDDChannel containerServer getAuthorWithId: eachUser id);
				mentioningEntity: aDDMessage author. ]
			on: NotFound
			do: [
				author := DDAuthor createFromDS: eachUser.
				author server: aDDChannel containerServer.
				aDDChannel containerServer addAuthor: author.
			].
	].

	"Add user mentions"
	mentions do: [ :each | aDDMessage addMention: each ].

	"Add role mentions"
	mentions := aDSMessage mentionRoleIds collect: [ :eachId |
		DDRoleMention new
			mentionedEntity: (aDDChannel containerServer getRoleWithId: eachId);
			mentioningEntity: (aDDMessage author).
	].
	mentions do: [ :each | aDDMessage addMention: each ].
	
	"Add special mentions (i.e. @everyone)"
	aDSMessage hasMentionEveryone ifTrue: [ aDDMessage addMention: DDEveryoneMention new.	].

]

{ #category : #'private - initialization' }
DDMessage class >> pointsOfInterestIn: aDDMessage [
	"Returns a collection of points of interest in aDDMessage"
	| content poi |
	
	content := aDDMessage content.
	poi := OrderedCollection new.

	"All issue references"
	poi addAll:
		"((content asLowercase allRegexMatches: 'issue[: #]*(\d)*(?![ :])*')"
		((content asLowercase allRegexMatches: 'issue(?![: #]*)(\d)+')
			collect: [ :each | (each capitalized) ]).

	"All #number references assuming as possible issues"
	poi addAll:
		((content allRegexMatches: '#(\d)+')
			collect: [ :each | 'Issue(?) ' . each ]).
	
	^ poi collect: [ :each |
			DDPointOfInterest new
				message: aDDMessage;
				channel: aDDMessage containerChannel;
				criteria: each asString;
				yourself.
		]
]

{ #category : #sorting }
DDMessage class >> timeSorted: aCollectionOfDDMessages [
	^ aCollectionOfDDMessages sorted: [ :a :b | a createdAt asDateAndTime < b createdAt asDateAndTime ].
]

{ #category : #adding }
DDMessage >> addMention: aDDMention [
	self mentions add: aDDMention.
	(aDDMention isKindOf: DDRoleMention)
		ifTrue: [ self roleMentions add: aDDMention ].
	(aDDMention isKindOf: DDChannelMention)
		ifTrue: [ self channelMentions add: aDDMention ].
	(aDDMention isKindOf: DDUserMention)
		ifTrue: [ self userMentions add: aDDMention ].
	(aDDMention isKindOf: DDSpecialMention)
		ifTrue: [ self specialMentions add: aDDMention ].
]

{ #category : #accessing }
DDMessage >> addReply: aDDMessage [
	self replies add: aDDMessage
]

{ #category : #converting }
DDMessage >> asJSON [
	^ String streamContents: [ :stream |
		(NeoJSONWriter on: stream)
			prettyPrint: true;
			for: DateAndTime customDo: [ :mapping | mapping encoder:
				#printString ];
			for: DDAttachment customDo: [ :mapping | mapping encoder:
				#asJSON ];
			nextPut: self asJSONDictionary
	].
]

{ #category : #converting }
DDMessage >> asJSONDictionary [
	| dict |
	dict := {
		#id -> self id .
		#authorId -> self author id .
		#content -> self content .
		#timestamp -> self createdAt }
		asDictionary.
	self attachments ifNotEmpty: [ dict add: (#attachments -> self attachments) ].
	self repliesTo ifNotNil: [ dict add: (#repliesTo -> self repliesTo id) ].

	^ dict
]

{ #category : #accessing }
DDMessage >> attachments [
	^ attachments
]

{ #category : #accessing }
DDMessage >> attachments: anObject [
	attachments := anObject
]

{ #category : #accessing }
DDMessage >> author [
	^ author
]

{ #category : #accessing }
DDMessage >> author: anObject [
	author := anObject
]

{ #category : #accessing }
DDMessage >> channelMentions [
	^ channelMentions
]

{ #category : #accessing }
DDMessage >> channelMentions: anObject [
	channelMentions := anObject
]

{ #category : #'source code' }
DDMessage >> codeBlocks [
	^ codeBlocks
]

{ #category : #'source code' }
DDMessage >> codeBlocks: anObject [
	codeBlocks := anObject
]

{ #category : #'source code' }
DDMessage >> codeElementsForClasses: aCollectionOfClassnames [
	| classMatchingString |
	classMatchingString := '|' join: (aCollectionOfClassnames collect: [ :each | each surroundedBy: '\b' ]).
	^ codeBlocks flatCollect: [ :eachBlock | | classReferences |
		classReferences := eachBlock codeSource allRegexMatches: classMatchingString.
		classReferences collect: [ :eachReference |
				DDClassElement new
					referencedClassName: eachReference;
					code: eachBlock;
					yourself. ].
	]
]

{ #category : #accessing }
DDMessage >> containerChannel [
	^ containerChannel
]

{ #category : #accessing }
DDMessage >> containerChannel: anObject [
	containerChannel := anObject
]

{ #category : #accessing }
DDMessage >> content [
	^ content
]

{ #category : #accessing }
DDMessage >> content: anObject [
	content := anObject
]

{ #category : #accessing }
DDMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
DDMessage >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #accessing }
DDMessage >> creationDateAndTime [
	^ self createdAt asDateAndTime
]

{ #category : #accessing }
DDMessage >> embeds [
	^ embeds
]

{ #category : #accessing }
DDMessage >> embeds: anObject [
	embeds := anObject
]

{ #category : #accessing }
DDMessage >> getLink [
	"The message can be seen at this URL.
	'https://discord.com/channels' / serverId / channelId / messageId"
	^ 'https://discord.com/channels/{1}/{2}/{3}' format: { self containerChannel server id . self containerChannel id . self id }.
]

{ #category : #'source code' }
DDMessage >> hasCodeBlocks [
	^ codeBlocks isNotEmpty
]

{ #category : #testing }
DDMessage >> hasEmbeds [
	^ embeds isNotEmpty
]

{ #category : #'source code' }
DDMessage >> hasPointsOfInterest [
	^ self pointsOfInterest isNotEmpty
]

{ #category : #'source code' }
DDMessage >> hasSourceCode [
	^ self hasCodeBlocks and: [ self codeBlocks anySatisfy: [ :each | each isSourceCode ] ]
]

{ #category : #accessing }
DDMessage >> id [
	^ id
]

{ #category : #accessing }
DDMessage >> id: anObject [
	id := anObject
]

{ #category : #initialization }
DDMessage >> initialize [
	super initialize.
	
	mentions := OrderedCollection new.
	channelMentions := OrderedCollection new.
	userMentions := OrderedCollection new.
	roleMentions := OrderedCollection new.
	specialMentions := OrderedCollection new.
]

{ #category : #testing }
DDMessage >> isInConversationWith: aDDMessage [
	^ (self creationDateAndTime - aDDMessage creationDateAndTime) abs < self containerChannel class defaultConversationBreakTime
]

{ #category : #accessing }
DDMessage >> isReply [
	^ repliesTo isNotNil
]

{ #category : #accessing }
DDMessage >> keywords [
	^ self naturalLanguageContent allRegexMatches: '(\S+)'
]

{ #category : #accessing }
DDMessage >> lastEditedAt [
	^ lastEditedAt
]

{ #category : #accessing }
DDMessage >> lastEditedAt: anObject [
	lastEditedAt := anObject
]

{ #category : #'content parsing' }
DDMessage >> lineCount [
	^ content lines size.
]

{ #category : #accessing }
DDMessage >> mentions [
	^ mentions
]

{ #category : #accessing }
DDMessage >> mentions: anObject [
	mentions := anObject
]

{ #category : #'content parsing' }
DDMessage >> messageCount [
	"Helper method for uniform plotting of different counts related to messages"
	^ 1.
]

{ #category : #accessing }
DDMessage >> naturalLanguageContent [
	| baseContent |
	baseContent := self content.
	self codeBlocks do: [ :each | baseContent := baseContent copyReplaceAll: each codeSource with: '[[[SOURCE_CODE]]]' ].
	^ baseContent
]

{ #category : #'accessing - external' }
DDMessage >> openInBrowser [
	WebBrowser openOn: self getLink.
]

{ #category : #'accessing - external' }
DDMessage >> openInDiscord [
	<vzContextMenu>
	self openInBrowser.
]

{ #category : #accessing }
DDMessage >> pointsOfInterest [
	^ pointsOfInterest
]

{ #category : #accessing }
DDMessage >> pointsOfInterest: anObject [
	pointsOfInterest := anObject
]

{ #category : #printing }
DDMessage >> printOn: aStream [
	aStream << 'Message: ' << self content asString.
]

{ #category : #printing }
DDMessage >> printString [
	^ self createdAt asDateAndTime asStringYMDHM , ' UTC - ' , self author name , String cr , String cr , self content asString.
]

{ #category : #accessing }
DDMessage >> quotes [
	| quotes lineIndex lastMatch |
	lineIndex := 0.
	lastMatch := -1.
	quotes := OrderedCollection new.
	
	self content linesDo: [ :eachLine |
		lineIndex := lineIndex + 1.
		(eachLine matchesRegex: '^> .+$') ifTrue: [
			(lastMatch = (lineIndex - 1)) ifTrue: [ | temp |
				temp := quotes last , String cr , eachLine.
				quotes removeLast.
				quotes addLast: temp.
			] ifFalse: [ 
				quotes add: eachLine.
			].
			lastMatch := lineIndex.
		]
	].
	quotes ifNotEmpty: [ ^ quotes ] ifEmpty: [ ^ nil ].
]

{ #category : #accessing }
DDMessage >> reactions [
	^ reactions
]

{ #category : #accessing }
DDMessage >> reactions: anObject [
	reactions := anObject
]

{ #category : #accessing }
DDMessage >> replies [
	^ replies ifNil: [ replies := OrderedCollection new ]
]

{ #category : #accessing }
DDMessage >> repliesTo [
	^ repliesTo
]

{ #category : #accessing }
DDMessage >> repliesTo: aDDMessage [
	repliesTo := aDDMessage.
]

{ #category : #accessing }
DDMessage >> roleMentions [
	^ roleMentions
]

{ #category : #accessing }
DDMessage >> roleMentions: anObject [
	roleMentions := anObject
]

{ #category : #'content parsing' }
DDMessage >> sentenceCount [
	^ Error new signal: 'Sentence count is currently unsupported.'
]

{ #category : #'source code' }
DDMessage >> sourceCode [
	^ self codeBlocks select: [ :each | each isSourceCode ]
]

{ #category : #accessing }
DDMessage >> specialMentions [
	^ specialMentions
]

{ #category : #accessing }
DDMessage >> specialMentions: anObject [
	specialMentions := anObject
]

{ #category : #accessing }
DDMessage >> uncompressedContentSize [
	^ content asString size
]

{ #category : #accessing }
DDMessage >> userMentions [
	^ userMentions
]

{ #category : #accessing }
DDMessage >> userMentions: anObject [
	userMentions := anObject
]

{ #category : #'content parsing' }
DDMessage >> wordCount [
	self flag: #FIXME. "This is a very rudimentary word counter. Implement it in a more robust and accurate way."
	^ (self content allRegexMatches: '(\S+)') size.
]
