"
I am a collection of global server statistics.
"
Class {
	#name : #DDStatistics,
	#superclass : #DDNode,
	#instVars : [
		'server',
		'authorStats',
		'messageStats',
		'serverStats',
		'activityStats',
		'conversationStats'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #accessing }
DDStatistics >> activityStats [
	^ activityStats
]

{ #category : #accessing }
DDStatistics >> activityStats: anObject [
	activityStats := anObject
]

{ #category : #accessing }
DDStatistics >> authorStats [
	^ authorStats
]

{ #category : #accessing }
DDStatistics >> authorStats: anObject [
	authorStats := anObject
]

{ #category : #accessing }
DDStatistics >> conversationStats [
	^ conversationStats
]

{ #category : #accessing }
DDStatistics >> conversationStats: anObject [
	conversationStats := anObject
]

{ #category : #exporting }
DDStatistics >> exportToCSV: fileName [
	| methods stats |
	FileSystem workingDirectory / (fileName , '.csv') writeStreamDo: [ :stream |
		stream
			nextPutAll: 'Model, ';
			nextPutAll: self name;
			cr;
			nextPutAll: 'Snapshot date, ';
			nextPutAll: (self printableDateAndTime: self server snapshotDate);
			cr;
			nextPutAll: 'First message date, ';
			nextPutAll: (self printableDateAndTime: (self activityStats at: #firstMessageDate));
			cr;
			nextPutAll: 'Activity duration, ';
			nextPutAll: (self printableDuration: (self activityStats at: #activityDuration));
			cr.

		stats := (((messageStats union: authorStats) union: serverStats) union: conversationStats) asOrderedDictionary.
		stats orderedKeys sort: [ :a :b | a asString < b asString ].
		stats keysAndValuesDo: [ :k :v |
			stream
				cr;
				nextPutAll: (VZGlyph new prettifyMenuName: k asString);
				nextPutAll: ', '.
				(v isKindOf: Collection)
					ifTrue: [ stream nextPutAll: v size asString ]
					ifFalse: [ stream nextPutAll: v asString ].
		].
	].
]

{ #category : #initialization }
DDStatistics >> initialize [
	super initialize.
	serverStats := Dictionary new.
	messageStats := Dictionary new.
	activityStats := Dictionary new.
	authorStats := Dictionary new.
	conversationStats := Dictionary new.
]

{ #category : #accessing }
DDStatistics >> messageStats [
	^ messageStats
]

{ #category : #accessing }
DDStatistics >> messageStats: anObject [
	messageStats := anObject
]

{ #category : #updating }
DDStatistics >> messages [
	^ self messageStats at: #messages
]

{ #category : #exporting }
DDStatistics >> printableDateAndTime: aDateAndTime [
	^ (((aDateAndTime rounded asUTC asString) allButLast: 6) copyReplaceAll: 'T' with: ' ') , ' UTC'.
]

{ #category : #exporting }
DDStatistics >> printableDuration: aDuration [
	| years yearsString remaining |
	years := (aDuration truncateTo: 1 year) / (365 days).
	(years > 0)
		ifTrue: [
			yearsString := years asString , ' year(s) '.
			remaining := aDuration - ((years*365) days) ]
		ifFalse: [
			yearsString := ''.
			remaining := aDuration. ].
	^ yearsString , (remaining asDuration roundTo: 1 minute) humanReadablePrintString copyReplaceAll: ',' with: ''
]

{ #category : #accessing }
DDStatistics >> server [
	^ server
]

{ #category : #accessing }
DDStatistics >> server: aDDServer [
	server := aDDServer
]

{ #category : #accessing }
DDStatistics >> serverStats [
	^ serverStats
]

{ #category : #accessing }
DDStatistics >> serverStats: anObject [
	serverStats := anObject
]

{ #category : #updating }
DDStatistics >> updateActivityStatistics [
	self activityStats at: #firstMessageDate put: self messages first createdAt.
	self activityStats at: #activityDuration put: self messages last createdAt - self messages first createdAt.

]

{ #category : #updating }
DDStatistics >> updateAuthorStatistics [
	self authorStats at: #members put: self server members.
	self authorStats at: #activeMembers put: self server activeMembers.
	self authorStats at: #inactiveMembers put: self server inactiveMembers.
	self authorStats at: #previouslyActiveAuthors put: self server previouslyActiveAuthors.

]

{ #category : #updating }
DDStatistics >> updateConversationStatistics [
	| conversations |
	conversations := self server conversations.
	self conversationStats at: #conversations put: conversations.
	self conversationStats at: #meaningfulConversations put: (conversations select: [:each | each messages size > 1]).
	self conversationStats at: #conversationsWithCode put: (conversations select: #involvesCode).
	self conversationStats at: #meaningfulConversationsWithCode put: ((self conversationStats at: #meaningfulConversations) select: #involvesCode).
	self conversationStats at: #averageConversationSpanMinutes put: (conversations reject: [ :each | each messages isEmpty ] thenCollect: #span) average asMinutes.
	self conversationStats at: #averageConversationMessages put: (conversations collect: [ :each | each messages size ]) average asFloat.
]

{ #category : #updating }
DDStatistics >> updateMessageStatistics [
	| timeSortedMessages |
	
	timeSortedMessages := self server timeSortedMessages.
	self messageStats at: #messages put: timeSortedMessages.
	
	self messageStats at: #messagesLastYear put: (timeSortedMessages select: [ :each | each createdAt asDateAndTime >= (self server snapshotDate - (Duration years: 1))]).
	self messageStats at: #messagesLast30Days put: ((messageStats at: #messagesLastYear) select: [ :each | each createdAt asDateAndTime >= (self server snapshotDate - (Duration days: 30))]).
	self messageStats at: #messagesLastWeek put: ((messageStats at: #messagesLast30Days) select: [ :each | each createdAt asDateAndTime >= (self server snapshotDate - (Duration days: 7))]).
	self messageStats at: #messagesLast24Hours put: ((messageStats at: #messagesLastWeek) select: [ :each | each createdAt asDateAndTime >= (self server snapshotDate - (Duration hours: 24))]).

	self authorStats at: #authorsActiveLastYear put: ((messageStats at: #messagesLastYear) collect: #author) asSet.
	self authorStats at: #authorsActiveLast30Days put: ((messageStats at: #messagesLast30Days) collect: #author) asSet.
	self authorStats at: #authorsActiveLastWeek put: ((messageStats at: #messagesLastWeek) collect: #author) asSet.
	self authorStats at: #authorsActiveLast24Hours put: ((messageStats at: #messagesLast24Hours) collect: #author) asSet.

	self messageStats at: #codeBlocks put: self server codeBlocks.
	self messageStats at: #messagesWithCodeBlocks put: self server messagesWithCodeBlocks.
	self messageStats at: #embeds put: self server embeds.
	self messageStats at: #messagesWithEmbeds put: self server messagesWithEmbeds.

]

{ #category : #updating }
DDStatistics >> updateStatistics [
	self name: self server name.
	self updateAuthorStatistics.
	self updateMessageStatistics.
	self updateStructureStatistics.
	self updateActivityStatistics.
	self updateConversationStatistics.

]

{ #category : #updating }
DDStatistics >> updateStructureStatistics [
	self serverStats at: #channels put: self server flatChannels.
	self serverStats at: #categories put: self server categories.

	self serverStats at: #textChannels put: self server textChannels.
	self serverStats at: #voiceChannels put: self server voiceChannels.

]
