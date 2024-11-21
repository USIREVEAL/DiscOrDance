"
I am an author of messages on a Discord server.

I have been active in some categories and channels where I sent messages.

I have class side methods to support sorting and merging of collections of DDAuthor.
"
Class {
	#name : #DDAuthor,
	#superclass : #DDNode,
	#instVars : [
		'avatar',
		'avatarUrl',
		'id',
		'nickname',
		'roles',
		'uniqueName',
		'activeChannels',
		'activeCategories',
		'sentMessages',
		'server',
		'mergedInto',
		'avatarHash'
	],
	#classInstVars : [
		'defaultAvatar'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #sorting }
DDAuthor class >> activitySorted: aCollectionOfDDAuthor [
	^ aCollectionOfDDAuthor asOrderedCollection sorted: [ :a :b | a numberOfSentMessages > b numberOfSentMessages ]
]

{ #category : #sorting }
DDAuthor class >> alphaSorted: aCollectionOfDDAuthor [
	^ aCollectionOfDDAuthor sorted: [ :a :b | a name asLowercase < b name asLowercase ]
]

{ #category : #initialization }
DDAuthor class >> createFromDS: aDSUser [
	| newAuthor |
	newAuthor := self new.
	newAuthor id: aDSUser id.
	newAuthor name: aDSUser username.
	newAuthor uniqueName: (aDSUser username , '#' , aDSUser discriminator).
	newAuthor avatarUrl: aDSUser.
	^ newAuthor
]

{ #category : #accessing }
DDAuthor class >> defaultAvatar [
	^ defaultAvatar ifNil: [ defaultAvatar := ZnEasy getPng: 'https://discordapp.com/assets/322c936a8c8be1b803cd94861bdfa868.png' ]
]

{ #category : #sorting }
DDAuthor class >> firstMessageSorted: aCollectionOfDDAuthor [
	^ aCollectionOfDDAuthor asOrderedCollection sorted: [ :a :b | a firstMessage createdAt < b firstMessage createdAt ]
]

{ #category : #sorting }
DDAuthor class >> lastMessageSorted: aCollectionOfDDAuthor [
	^ aCollectionOfDDAuthor asOrderedCollection sorted: [ :a :b | a lastMessage createdAt > b lastMessage createdAt ]
]

{ #category : #sorting }
DDAuthor class >> lifespanSorted: aCollectionOfDDAuthor [
	^ aCollectionOfDDAuthor asOrderedCollection sorted: [ :a :b | a lifespan > b lifespan ]
]

{ #category : #'private - merging' }
DDAuthor class >> mergeGrouped: aCollectionOfGroups [
	| resultingDictionary |
	resultingDictionary := aCollectionOfGroups collect: [ :eachGroup | | newMerged |
		(eachGroup size > 1)
			ifTrue: [
				newMerged := DDMergedAuthor new.
				eachGroup do: [ :eachAuthor | newMerged addAlias: eachAuthor name forAuthor: eachAuthor ].
				newMerged. ]
			ifFalse: [ eachGroup asOrderedCollection first ].
	].
	^ resultingDictionary values.
]

{ #category : #merging }
DDAuthor class >> mergeSameName: aCollectionOfDDAuthor [
	| sameNameAuthors |
	sameNameAuthors := aCollectionOfDDAuthor groupedBy: [ :each | self normalizedName: each name ].
	^ self mergeGrouped: sameNameAuthors.
]

{ #category : #merging }
DDAuthor class >> mergeSamePrefix: aCollectionOfDDAuthor of: prefixLength [
	| samePrefixAuthors |
	samePrefixAuthors := aCollectionOfDDAuthor groupedBy: [ :each |
		(each name size > prefixLength)
			ifTrue: [ each name first: prefixLength ]
			ifFalse: [ each name ].
	].
	^ self mergeGrouped: samePrefixAuthors.
]

{ #category : #merging }
DDAuthor class >> normalizedName: aString [
	"Strong name normalization: only alphabetic characters are considered. Separators, numbers, special characters etc. are removed. Case is lowered."
	^ aString onlyLetters asLowercase.
]

{ #category : #merging }
DDAuthor class >> weaklyNormalizedName: aString [
	"Regex based filtering of non alphanumeric characters, number differences are kept. Case is lowered."
	^ '[^A-Za-z0-9]' asRegex copy: aString asLowercase replacingMatchesWith: ''


]

{ #category : #comparing }
DDAuthor >> <= anAuthor [
	^ self name asLowercase <= anAuthor name asLowercase.
]

{ #category : #comparing }
DDAuthor >> = anAuthor [
	(anAuthor isKindOf: self class) ifFalse: [ ^ false ].
	^ self id = anAuthor id.
]

{ #category : #accessing }
DDAuthor >> activeCategories [
	^ activeCategories
]

{ #category : #accessing }
DDAuthor >> activeChannels [
	^ activeChannels
]

{ #category : #visualization }
DDAuthor >> activityBasedGlyph [
"	This code should work better and be cleaner but in the end the size doesn't update properly
	resulting in misplaced (overlapping) elements inthe given layout.
	| glyph |
	glyph := self simpleGlyph.
	
	self flag: #FIXME Should get the RSBox in a more reliable/robust way.
	(glyph nodes at: 1) size: (self sentMessages size + 5).
	
	^ glyph.
"

	| newComposite newShape newLabel |
	newShape := RSBox new.
	newShape model: self.
	newShape width: self sentMessages size + 5.
	newShape height: self activeChannels size + 5.
	newShape color: Color green.
		
	newLabel := RSLabel new.
	newLabel model: self.
	newLabel text: self name.
	newLabel color: Color black.

	newComposite := RSComposite new.
	newComposite shapes: { newShape . newLabel }.
	newComposite model: self.
	newComposite @ RSPopup; @ RSDraggable.
	
	^ newComposite.
]

{ #category : #visualization }
DDAuthor >> activityHistogramByDays: numberOfDays [
	| chart plot values |
	values := self messageCreationDates collect: [ :each | ((each - Date today) days / numberOfDays) roundDownTo: 1 ].
	chart := RSChart new.
	plot := RSHistogramPlot new x: values.
	plot bins: 0 - (values min).
	"plot binningStrategy: RSSturgesBinning new."
	chart addPlot: plot.
	chart addDecoration: RSVerticalTick new.
	chart addDecoration: RSHorizontalTick new.
	chart open.
	^ chart

]

{ #category : #visualization }
DDAuthor >> activitySparkline [
	^ self activitySparklineLeftAlignable: false.
]

{ #category : #visualization }
DDAuthor >> activitySparklineLeftAlignable: aBoolean [
	| glyph |
	glyph := aBoolean
		ifTrue: [ DDCompactSparklineGlyph new ]
		ifFalse: [ DDSparklineGlyph new ].
	^ glyph
		entity: self;
		chartForRoassal
]

{ #category : #adding }
DDAuthor >> addActiveCategory: aCategory [
	activeCategories add: aCategory.
]

{ #category : #adding }
DDAuthor >> addActiveChannel: aChannel [
	activeChannels add: aChannel.
]

{ #category : #adding }
DDAuthor >> addSentMessage: aMessage [
	sentMessages add: aMessage.
	aMessage author: self.
]

{ #category : #converting }
DDAuthor >> asJSON [
	^ String streamContents: [ :stream |
		(NeoJSONWriter on: stream)
			prettyPrint: true;
			nextPut: self asJSONDictionary
	].
]

{ #category : #converting }
DDAuthor >> asJSONDictionary [
	^ { #id -> self id .
		#name -> self name .
		#uniqueName -> self uniqueName .
		#nickname -> self nickname } asDictionary
]

{ #category : #accessing }
DDAuthor >> avatar [
	^ avatar ifNil: [ self class defaultAvatar ]
]

{ #category : #accessing }
DDAuthor >> avatar: aForm [
	avatar := aForm
]

{ #category : #accessing }
DDAuthor >> avatarHash [
	^ avatarHash
]

{ #category : #accessing }
DDAuthor >> avatarHash: aString [
	avatarHash := aString
]

{ #category : #accessing }
DDAuthor >> avatarUrl: aDSUser [
	aDSUser hasAvatar
		ifTrue: [
			avatarHash := aDSUser avatarHash.
			avatarUrl := 'https://cdn.discordapp.com/avatars/' , aDSUser id , '/' , aDSUser avatarHash , '.png'.
			self avatar:
				([ ZnEasy getPng: avatarUrl ]
					on: Error
					do: [
						UIManager default inform: 'Could not retrieve avatar for ' , avatarUrl.
						Transcript show: 'Could not retrieve avatar for ' , avatarUrl.
						avatarUrl := nil.
						nil. ])
		]
		ifFalse: [
			avatarUrl := nil.
			self avatar: nil ].
]

{ #category : #visualization }
DDAuthor >> dailyActivityHistogram [
	<vzContextMenu>
	^ self activityHistogramByDays: 1
]

{ #category : #accessing }
DDAuthor >> firstMessage [
	^ (DDMessage timeSorted: self sentMessages) first
]

{ #category : #testing }
DDAuthor >> hasAvatar [
	^ self avatar isNotNil
]

{ #category : #testing }
DDAuthor >> hasMessages [
	^ self sentMessages isNotEmpty
]

{ #category : #comparing }
DDAuthor >> hash [
	^ self id hash.
]

{ #category : #accessing }
DDAuthor >> id [
	^ id
]

{ #category : #accessing }
DDAuthor >> id: anObject [
	id := anObject
]

{ #category : #initialization }
DDAuthor >> initialize [
	super initialize.
	activeChannels := Set new.
	activeCategories := Set new.
	roles := Set new.
	sentMessages := OrderedCollection new.
]

{ #category : #testing }
DDAuthor >> isActive [
	^ sentMessages isNotEmpty
]

{ #category : #testing }
DDAuthor >> isMember [
	^ self server members includes: self.
]

{ #category : #testing }
DDAuthor >> isMergedAuthor [
	^ false
]

{ #category : #accessing }
DDAuthor >> lastMessage [
	^ (DDMessage timeSorted: self sentMessages) last
]

{ #category : #accessing }
DDAuthor >> lifespan [
	^ self lastMessage createdAt - self firstMessage createdAt
]

{ #category : #initialization }
DDAuthor >> makeActiveInChannel: aChannel withMessage: aMessage [

	aChannel addAuthor: self.
	self addActiveChannel: aChannel.
	(aChannel parent isKindOf: DDCategory) ifTrue: [ self addActiveCategory: aChannel parent ].

]

{ #category : #accessing }
DDAuthor >> mergedInto [
	^ mergedInto
]

{ #category : #accessing }
DDAuthor >> mergedInto: aDDMergedAuthor [
	mergedInto := aDDMergedAuthor
]

{ #category : #accessing }
DDAuthor >> messageCreationDates [
	^ self sentMessages collect: [ :each | each createdAt asDate ]
]

{ #category : #accessing }
DDAuthor >> messagesByDay [
	^ self sentMessages groupedBy: [ :message | message createdAt asDate ]
]

{ #category : #visualization }
DDAuthor >> montlyActivityHistogram [
	<vzContextMenu>
	^ self activityHistogramByDays: 30
]

{ #category : #accessing }
DDAuthor >> nickname [
	^ nickname
]

{ #category : #accessing }
DDAuthor >> nickname: anObject [
	nickname := anObject
]

{ #category : #accessing }
DDAuthor >> numberOfSentMessages [
	^ self sentMessages size.
]

{ #category : #visualization }
DDAuthor >> openActivitySparkline [
	<vzContextMenu>
	self hasMessages
		ifFalse: [ self inform: 'Selected author has no activity.' ]
		ifTrue: [ self activitySparkline open ].
]

{ #category : #printing }
DDAuthor >> printString [
	^ self nickname ifNil: self name ifNotNil: [ self nickname , ' <' , self name , '>' ]
]

{ #category : #accessing }
DDAuthor >> roles [
	^ roles
]

{ #category : #accessing }
DDAuthor >> roles: anObject [
	roles := anObject
]

{ #category : #accessing }
DDAuthor >> sentMessages [
	^ sentMessages
]

{ #category : #accessing }
DDAuthor >> server [
	^ server
]

{ #category : #accessing }
DDAuthor >> server: anObject [
	server := anObject
]

{ #category : #visualization }
DDAuthor >> simpleGlyph [
	| newComposite newShape newLabel |
	newShape := RSBox new.
	newShape model: self.
	newShape width: 100.
	newShape height: 25.
	newShape color: Color green.
		
	newLabel := RSLabel new.
	newLabel model: self.
	newLabel text: self name.
	newLabel color: Color black.

	newComposite := RSComposite new.
	newComposite shapes: { newShape . newLabel }.
	newComposite model: self.
	newComposite @ RSPopup; @ RSDraggable.
	
	^ newComposite.

]

{ #category : #accessing }
DDAuthor >> uniqueName [
	^ uniqueName
]

{ #category : #accessing }
DDAuthor >> uniqueName: anObject [
	uniqueName := anObject
]

{ #category : #visualization }
DDAuthor >> weeklyActivityHistogram [
	<vzContextMenu>
	^ self activityHistogramByDays: 7
]

{ #category : #visualization }
DDAuthor >> yearlyActivityHistogram [
	<vzContextMenu>
	^ self activityHistogramByDays: 365
]
