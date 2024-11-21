"
I am a Discord server.

I know my structure in the form of categories and channels.
I know the messages sent in my channels.
I know the authors active that sent messages in my channels.
"
Class {
	#name : #DDServer,
	#superclass : #DDStructuralNode,
	#instVars : [
		'scrapingTime',
		'cleaned',
		'domain',
		'inferred',
		'customEdited',
		'completeGraph',
		'statistics',
		'snapshotDate',
		'graphGenerationTime',
		'categories',
		'roles',
		'topLevelChannels',
		'members',
		'authors',
		'emojis',
		'activeAuthors',
		'conversations',
		'globalConfiguration'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #accessing }
DDServer >> activeAuthors [
	^ activeAuthors
]

{ #category : #accessing }
DDServer >> activeAuthors: aCollectionOfDDAuthor [
	activeAuthors := aCollectionOfDDAuthor
]

{ #category : #accessing }
DDServer >> activeMembers [
	^ self members difference: self inactiveMembers
]

{ #category : #'accessing - sorted' }
DDServer >> activitySortedAuthors [
	^ DDAuthor activitySorted: self authors.
]

{ #category : #adding }
DDServer >> addActiveAuthor: anAuthor [
	activeAuthors add: anAuthor.
]

{ #category : #adding }
DDServer >> addAuthor: aDDAuthor [
	self authors add: aDDAuthor.
]

{ #category : #adding }
DDServer >> addEmoji: aDDEmoji [
	self emojis add: aDDEmoji.
]

{ #category : #'accessing - sorted' }
DDServer >> alphaSortedAuthors [
	^ DDAuthor alphaSorted: self authors.
]

{ #category : #converting }
DDServer >> asJSON [
	^ String streamContents: [ :stream |
		(NeoJSONWriter on: stream)
			prettyPrint: true;
			for: DateAndTime customDo: [ :mapping | mapping encoder: #printString ];
			for: DDAuthor customDo: [ :mapping | mapping encoder: #asJSONDictionary ];
			for: DDTextChannel customDo: [ :mapping | mapping encoder: #asJSONDictionary ];
			for: DDMessage customDo: [ :mapping | mapping encoder: #asJSONDictionary ];
			for: DDTopic customDo: [ :mapping | mapping encoder: #asJSONDictionary ];
			for: DDAttachment customDo: [ :mapping | mapping encoder: #asJSONDictionary ];
			nextPut: {
				#name -> self name .
				#id -> self id .
				#members -> self authors .
				#channels -> self textChannels } asDictionary.
	].
]

{ #category : #accessing }
DDServer >> authors [
	^ authors
]

{ #category : #accessing }
DDServer >> authors: anObject [
	authors := anObject
]

{ #category : #visualization }
DDServer >> authorsActivityView [
	| authorsActivityShapes composite authors |

	authors := self activeAuthors asOrderedCollection sort: [ :a :b | a sentMessages size > b sentMessages size ].
	authorsActivityShapes := authors collect: [ :each | each activityBasedGlyph ] as: RSGroup.
	
	RSNormalizer width
		from: 10;
		to: 1000;
		shapes: (authorsActivityShapes collect: [ :each | each shapes at:1 ]);
		normalize: #numberOfSentMessages.
	RSNormalizer width
		from: 10;
		to: 1000;
		shapes: authorsActivityShapes;
		normalize: #numberOfSentMessages.

	RSVerticalLineLayout on: authorsActivityShapes.
	

	composite := RSComposite new.
	composite model: self.
	composite shapes:	authorsActivityShapes.
	composite padding: 10.
	"composite updateLinesON."

	^ composite.
]

{ #category : #'accessing - channels' }
DDServer >> authorsNamed: aName [
	^ self authors select: [ :each | each name = aName ]
]

{ #category : #accessing }
DDServer >> categories [
	^ categories
]

{ #category : #accessing }
DDServer >> categories: anObject [
	categories := anObject
]

{ #category : #visualization }
DDServer >> categoriesRadialView: anRSCanvas [
	| flattened compositeViews allGroups allCompositeShapes textChannelComposites ellipseShapes |
	
	self flag: #FIXME "This piece of code should be refactored/rewritten in a more robust way
	when the bridge pattern is introduced in the visualization".

	compositeViews := categories collect: [ :each | each radialView: anRSCanvas ] as: RSGroup.
	allGroups := compositeViews collect: [ :each | each shapes ].
	flattened := allGroups flattened.
	allCompositeShapes := flattened select: [ :each | each isKindOf: RSComposite ].
	textChannelComposites := allCompositeShapes select: [ :each | each model isKindOf: DDTextChannel ].

	ellipseShapes := textChannelComposites collect: [ :each | each children at: 1 ].

	RSNormalizer size
		from: 20;
		to: 150;
		shapes: ellipseShapes;
		normalize: #numberOfMessages.

	^ compositeViews.
]

{ #category : #'accessing - channels' }
DDServer >> channelsNamed: aName [
	^ self flatChannels select: [ :each | each name = aName ]
]

{ #category : #'data cleaning' }
DDServer >> cleanModel [
	| mergedAuthors |
	cleaned ifTrue: [ Error new signal: 'Cleaning an already cleaned model is not currently supported.' ].
	self authors: (self removeDuplicateAuthors: self authors).
	mergedAuthors := self authors select: #isMergedAuthor.
	self substituteMerged: mergedAuthors.
	cleaned := true.
	completeGraph ifNotNil: [ self completeGraph: self generateGraph ].
]

{ #category : #'accessing - uncached' }
DDServer >> codeBlocks [
	^ self messages flatCollect: #codeBlocks
]

{ #category : #accessing }
DDServer >> completeGraph [
	^ completeGraph ifNil: [ completeGraph := self generateGraph ]
]

{ #category : #accessing }
DDServer >> completeGraph: aVZGraph [
	completeGraph := aVZGraph
]

{ #category : #accessing }
DDServer >> conversations [
	^ conversations
]

{ #category : #accessing }
DDServer >> conversations: aCollectionOfDDConversation [
	conversations := aCollectionOfDDConversation
]

{ #category : #creating }
DDServer >> createServer: aServer with: aDDGlobalConfiguration [
	| allChannels dsCategories dsTopLevelChannels parseStartingTime parseEndingTime |

	globalConfiguration := aDDGlobalConfiguration.
	
	parseStartingTime := DateAndTime now.
	self snapshotDate: parseStartingTime.
	
	self id: aServer id.

	aServer members do: [ :eachMember | | author |
		author := DDAuthor createFromDS: eachMember user.
		author server: self.
		author roles: (eachMember roleIds collect: [ :eachRoleId | DDRole new id: eachRoleId ]).
		author nickname: eachMember nick.
		self roles addAll: author roles.
		self members add: author.
		self authors add: author.
	].

	allChannels := aServer channels.
	
	name := aServer name.
	dsCategories := allChannels select: [ :each | each isKindOf: DSCategoryChannel ].
	dsCategories
		do: [ :eachDSCategory | | newCategory |
			newCategory := DDCategory createFromDS: eachDSCategory withParent: self.
			categories add: newCategory ]
		displayingProgress: [ :each | 'Analysing category ', each name asString ].
	
	dsTopLevelChannels := allChannels select: [ :each | (each isKindOf: DSGuildTextChannel) or: (each isKindOf: DSGuildVoiceChannel) ].
	dsTopLevelChannels
		do: [ :eachDSChannel | | newChannel |
			newChannel := DDChannel createFromDS: eachDSChannel withParent: self.
			topLevelChannels add: newChannel ]
		displayingProgress: [ :each | 'Analysing top-level channel ', each name asString ].

	parseEndingTime := DateAndTime now.
	scrapingTime := (parseEndingTime - parseStartingTime) asDuration.
	
	self generateInferredKnowledge.
	inferred := true.

	statistics := DDStatistics new server: self.
	statistics updateStatistics.
]

{ #category : #accessing }
DDServer >> domain [
	^ domain ifNil: [ domain := DDDomain new ]
]

{ #category : #'accessing - uncached' }
DDServer >> embeds [
	^ self messages flatCollect: #embeds
]

{ #category : #accessing }
DDServer >> emojis [
	^ emojis
]

{ #category : #accessing }
DDServer >> emojis: anObject [
	emojis := anObject
]

{ #category : #exporting }
DDServer >> exportToJSON [
	DDModel checkDumpsDirectory.
	FileSystem workingDirectory / 'dumps' / ((self name) , '_server_dump.json') writeStreamDo: [ :stream | stream nextPutAll: self asJSON ].
]

{ #category : #'finding/searching' }
DDServer >> findCodeElementsForClasses: aCollectionOfClassnames inMessages: aCollectionOfDDMessages [
	| result |
	result := aCollectionOfDDMessages
		select: #hasCodeBlocks
		thenCollect: [ :eachMessage |
				eachMessage codeElementsForClasses: aCollectionOfClassnames ].
	result := result reject: #isEmpty.
	^ result flattened
]

{ #category : #'accessing - channels' }
DDServer >> firstChannelNamed: aName [
	^ (self channelsNamed: aName) at: 1
]

{ #category : #accessing }
DDServer >> flatChannels [
	| channels |
	channels := OrderedCollection new.
	categories do: [ :each | channels addAll: each channels ].
	channels := channels , topLevelChannels.
	^ channels
]

{ #category : #'private - creation - graph' }
DDServer >> generateAuthorshipEdges: aVZGraph [
	| graphEdges |
	
	graphEdges := self messages collect: [ :each | DDAutorshipEdge between: each author and: each ].
	aVZGraph addEdges: graphEdges.

]

{ #category : #'private - creation - graph' }
DDServer >> generateCodeNodesAndEdges: aVZGraph [
	| classes elementNodes classNodes graphEdges |
	aVZGraph addNodes: self codeBlocks.
	
	classes := Collection withAllSubclasses collect: #name.
	elementNodes := self findCodeElementsForClasses: classes inMessages: self messages.
	classNodes := classes collect: [ :each | DDClassNode new name: each ].
	aVZGraph addNodes: elementNodes , classNodes.
	
	graphEdges := elementNodes collect: [ :each | DDCodeReferenceEdge between: (classNodes detect: [ :eachClass | eachClass name = each referencedClassName ]) and: each ].
	aVZGraph addEdges: graphEdges.

]

{ #category : #'private - creation - graph' }
DDServer >> generateConversationEdges: aVZGraph [
	| graphEdges |
	graphEdges := Set new.
	self flatChannels do: [ :each | | conversationStream c1 c2 |
		conversationStream := ReadStream on: each conversations.
		c1 := conversationStream next.
		self flag: #FIXME. "Adding edges between channels and conversations. Should be special edges ad-hoc."
		c1 ifNotNil: [ graphEdges add: (DDNextConversationEdge between: each and: c1) ].
		[conversationStream peek isNotNil] whileTrue: [ | messageStream m1 |
			c2 := conversationStream peek.
			"Edges between conversations"
			graphEdges add: (DDNextConversationEdge between: c1 and: c2).
			
			"Edges between conversation and DDCode nodes."
			graphEdges addAll: (c1 sourceCode collect: [ :eachCode | (DDCodeEdge between: eachCode and: c1) ]).
			
			"Edges between messages in a conversation"
			messageStream := ReadStream on: c1 messages.
			m1 := messageStream next.
			[messageStream peek isNotNil] whileTrue: [
				graphEdges add: (DDConversationFlowEdge between: m1 and: messageStream peek).
				m1 := messageStream next. ].
			c1 := conversationStream next.
		].
	].
	aVZGraph addEdges: graphEdges.

]

{ #category : #creating }
DDServer >> generateConversations [
	conversations := ((self flatChannels) flatCollect: [ :each | each conversations. ]).
]

{ #category : #'private - creation - graph' }
DDServer >> generateGraph [
	| nodes graphEdges graphStartingTime graphEndingTime |
	graphStartingTime := DateAndTime now.

	[ :job | job title: 'Generating complete graph...'.
		job progress: 0.0.
		graph := VZGraph new.
		nodes := (authors, emojis, categories, self flatChannels, self asOrderedCollection, self messages, self conversations) asSet.
		graph addNodes: nodes.
		job progress: 0.2.

		self generateAuthorshipEdges: graph.
		self generateCodeNodesAndEdges: graph.	
		self generatePOINodesAndEdges: graph.	
		self generateConversationEdges: graph.	
		job progress: 0.4.

		"nodes add: (nodes collect: #transitiveClosure)."
		graphEdges := self generateMentionEdges.
		graph addEdges: graphEdges.
		job progress: 0.6.

		graphEdges := self generateStructuralHierarchyEdges.
		graph addEdges: graphEdges.
		job progress: 0.8.

		self updateMetricsNormalization.
		job progress: 1.0.
	] asJob run.

	graphEndingTime := DateAndTime now.
	graphGenerationTime := graphEndingTime - graphStartingTime.
	('Graph generation took: ' , (graphGenerationTime roundTo: 1 second) humanReadablePrintString) traceCr.
	^ graph
]

{ #category : #creating }
DDServer >> generateInferredKnowledge [
	self generateConversations.
]

{ #category : #'private - creation - graph' }
DDServer >> generateMentionEdges [
	| collapsedMentions mentionsByAuthor |
	collapsedMentions := Set new.
	mentionsByAuthor := (self messages flatCollect: #userMentions) groupedBy: #mentioningEntity.
	mentionsByAuthor keysAndValuesDo: [ :eachMentioner :eachMentionsCollection | | byMentionee |
		byMentionee := eachMentionsCollection groupedBy: #mentionedEntity.
		byMentionee keysAndValuesDo: [ :eachMentionee :mentions | | newEdge |
			newEdge := DDUserMention new
					mentioningEntity: eachMentioner;
					mentionedEntity: eachMentionee;
					times: mentions size.
			eachMentioner addEdge: newEdge.
			eachMentionee addEdge: newEdge.

			collapsedMentions add: newEdge.
		].
	].

	^ collapsedMentions
]

{ #category : #'private - creation - graph' }
DDServer >> generatePOINodesAndEdges: aVZGraph [
	aVZGraph addNodes: self pointsOfInterest.
	
"
	channels := self pointsOfInterest collect: #channel.
	elementNodes := self findCodeElementsForClasses: classes inMessages: self messages.
	classNodes := classes collect: [ :each | DDClassNode new name: each ].
	aVZGraph addNodes: elementNodes , classNodes.
	
	graphEdges := elementNodes collect: [ :each | DDPOIReferenceEdge between: (classNodes detect: [ :eachClass | eachClass name = each referencedClassName ]) and: each ].
	aVZGraph addEdges: graphEdges.
"
]

{ #category : #'private - creation - graph' }
DDServer >> generateStructuralHierarchyEdges [
	| structuralEdges |
	
	structuralEdges := Set new.
	structuralEdges addAll: (self topLevelChannels collect: [ :eachChannel | DDStructuralEdge between: self and: eachChannel ]).
	self categories do: [ :eachCategory |
		structuralEdges add: (DDStructuralEdge between: self and: eachCategory).
		eachCategory channels do: [ :eachChannel |
			structuralEdges add: (DDStructuralEdge between: eachCategory and: eachChannel) ].
	].
	
	^ structuralEdges
]

{ #category : #'accessing - selective' }
DDServer >> getActiveAuthorLike: anAuthor [
	^ activeAuthors like: anAuthor ifAbsent: nil. 
]

{ #category : #'accessing - id' }
DDServer >> getAuthorWithId: authorId [
	^ self authors detect: [ :each | each id = authorId ].
]

{ #category : #'accessing - id' }
DDServer >> getChannelWithId: channelId [
	^ self flatChannels detect: [ :each | each id = channelId ].
]

{ #category : #accessing }
DDServer >> getContainerServer [
	^ self.
]

{ #category : #'accessing - id' }
DDServer >> getEmojiWithId: emojiId [
	^ self emojis detect: [ :each | each id = emojiId ].
]

{ #category : #'accessing - id' }
DDServer >> getMessageWithId: messageId [
	^ self messages detect: [ :each | each id = messageId ].
]

{ #category : #'accessing - selective' }
DDServer >> getMessagesByAuthor [
	"Return the number of messages sent in the server by each author."
	| count |
	count := 	Bag new.
	(categories collect: [ :eachCategory | eachCategory getMessagesByAuthor ]) do: [ :each | count addAll: each ].
	(topLevelChannels collect: [ :eachChannel | eachChannel getMessagesByAuthor ]) do: [ :each | count addAll: each ].
	^ count.
]

{ #category : #'accessing - id' }
DDServer >> getRoleWithId: roleId [
	^ self roles
		detect: [ :each | each id = roleId ]
		ifNone: [	 self roles add: (DDRole new id: roleId) ].
]

{ #category : #accessing }
DDServer >> globalConfiguration [
	^ globalConfiguration
]

{ #category : #testing }
DDServer >> hasInferred [
	^ inferred
]

{ #category : #'accessing - computed' }
DDServer >> inactiveMembers [
	^ (self authors select: #isMember) difference: activeAuthors
]

{ #category : #initialization }
DDServer >> initialize [
	super initialize.
	name := ''.
	categories := OrderedCollection new.
	topLevelChannels := OrderedCollection new.
	activeAuthors := Set new.
	roles := Set new.
	members := Set new.
	authors := Set new.
	emojis := Set new.
	globalConfiguration := DDGlobalConfiguration new.
	scrapingTime := 0 asDuration.
	cleaned := false.
	customEdited := false.

]

{ #category : #testing }
DDServer >> isCleaned [
	^ cleaned
]

{ #category : #testing }
DDServer >> isCustomEdited [
	^ customEdited
]

{ #category : #accessing }
DDServer >> lastMessage [
	^ self timeSortedMessages last
]

{ #category : #'private - updating' }
DDServer >> manualCustomize [
	customEdited := true.
]

{ #category : #accessing }
DDServer >> maxActiveChannelsForAuthors [
	^ (authors collect: [ :each | each activeChannels size ]) max.
]

{ #category : #accessing }
DDServer >> maxMessagesForAuthors [
	^ (authors collect: [ :each | each sentMessages size ]) max.
]

{ #category : #accessing }
DDServer >> maxMessagesInChannels [
	^ (categories collect: [ :each | each maxMessagesInChannels ]) max.
]

{ #category : #accessing }
DDServer >> members [
	^ members
]

{ #category : #accessing }
DDServer >> members: anObject [
	members := anObject
]

{ #category : #accessing }
DDServer >> mentions [
	^ self messages flatCollect: #mentions
]

{ #category : #'context menu - charting' }
DDServer >> messageIntervals [
	^ self flatChannels flatCollect: #messageIntervals.
]

{ #category : #accessing }
DDServer >> messages [
	^ self flatChannels flatCollect: [ :each | each messages ]
]

{ #category : #accessing }
DDServer >> messagesIn: aDDChannelOrAString [
	(aDDChannelOrAString isKindOf: DDChannel) ifTrue: [
		^ aDDChannelOrAString messages ]
	ifFalse: [
		self flag: #WARNING. "Interacting with limitations of channelsNamed, assuming to return only first channel with a specific name."
		^ ((self channelsNamed: aDDChannelOrAString) at: 1) messages ]
]

{ #category : #'accessing - uncached' }
DDServer >> messagesWithCodeBlocks [
	^ self messages select: #hasCodeBlocks
]

{ #category : #'accessing - uncached' }
DDServer >> messagesWithEmbeds [
	^ self messages select: #hasEmbeds
]

{ #category : #'accessing - statistics' }
DDServer >> numberOfCategories [
	^ self categories size.
]

{ #category : #'accessing - statistics' }
DDServer >> numberOfChannels [
	^ self flatChannels size.
]

{ #category : #visualization }
DDServer >> overview: anRSCanvas [
	"Return a composite shape which is an overview of the server containing a radialView of each category and an activityView for each author."
	| shapes composite categoryShapes authorShapes |

	categoryShapes := self categoriesRadialView: anRSCanvas.
	authorShapes := self authorsActivityView.

	categoryShapes @ RSDraggable.
	authorShapes @ RSDraggable.

	shapes := categoryShapes.
	shapes add: authorShapes.
	RSGridLayout new on: shapes.

	composite := RSComposite new.
	composite model: self.
	composite shapes:	shapes.
	composite padding: 10.
	"composite updateLinesON."

	^ composite.
]

{ #category : #'accessing - uncached' }
DDServer >> pointsOfInterest [
	^ self messages flatCollect: #pointsOfInterest
]

{ #category : #'accessing - computed' }
DDServer >> previouslyActiveAuthors [
	^ self activeAuthors difference: members
]

{ #category : #'data cleaning' }
DDServer >> removeDuplicateAuthors: aSetOfDDAuthor [
	"Simple merging strategy by using some data from the first author in the list of aliases"
	| mergedAuthors onlyMerged |
	
	self flag: #FIXME. "A better model is needed here but is a bit too complicated for the task needed at the moment."
	mergedAuthors := DDAuthor mergeSameName: aSetOfDDAuthor.
	onlyMerged := mergedAuthors select: #isMergedAuthor.
	onlyMerged do: [ :each | | referenceAuthor |
		referenceAuthor := each authors asOrderedCollection first.
		each name: referenceAuthor name.
		each id: referenceAuthor id.
		each server: referenceAuthor server.
		each nickname: referenceAuthor nickname.
		each uniqueName: referenceAuthor uniqueName.
	].
	^ mergedAuthors asSet
]

{ #category : #accessing }
DDServer >> roles [
	^ roles
]

{ #category : #accessing }
DDServer >> roles: anObject [
	roles := anObject
]

{ #category : #accessing }
DDServer >> scrapingTime [
	^ scrapingTime
]

{ #category : #'accessing - selective' }
DDServer >> selfMentions [
	| mentions |
	mentions := self messages flatCollect: #mentions.
	^ mentions select: [ :each | (each isKindOf: DDUserMention) and: [each mentionedEntity = each mentioningEntity] ].

]

{ #category : #accessing }
DDServer >> snapshotDate [
	^ snapshotDate
]

{ #category : #accessing }
DDServer >> snapshotDate: anObject [
	snapshotDate := anObject
]

{ #category : #visualization }
DDServer >> sparklineMultiview: aCollectionOfDDAuthors [
	| canvas shapes charts |

	canvas := RSCanvas new.
	charts := aCollectionOfDDAuthors collect: [ :each | each activitySparklineLeftAlignable: true ].

	shapes := charts collect: [ :each | | group |
		group := RSGroup new.
		each container: group.
		each build.
		group asShapeFor: each ].

	canvas addAll: shapes.
	RSCellLayout new gapSize: 2; on: canvas shapes.

	canvas @ RSCanvasController.
	^ canvas
]

{ #category : #accessing }
DDServer >> statistics [
	^ statistics
]

{ #category : #accessing }
DDServer >> statistics: anObject [
	statistics := anObject
]

{ #category : #'data cleaning' }
DDServer >> substituteMerged: aCollectionOfDDMergedAuthors [
	self substituteMerged: aCollectionOfDDMergedAuthors inAuthors: self activeAuthors.
	self substituteMerged: aCollectionOfDDMergedAuthors inAuthors: self members.
	self substituteMerged: aCollectionOfDDMergedAuthors inMentions: (self mentions select: [ :each | each isKindOf: DDUserMention ]).
	self substituteMerged: aCollectionOfDDMergedAuthors inMentions: self userMentions.
	self substituteMerged: aCollectionOfDDMergedAuthors inChannels: self flatChannels.
]

{ #category : #'data cleaning' }
DDServer >> substituteMerged: aCollectionOfDDMergedAuthors inAuthors: aCollectionOfAuthors [
	aCollectionOfDDMergedAuthors do: [ :eachMerged |
			(aCollectionOfAuthors includesAny: eachMerged authors)
				ifTrue: [
					eachMerged authors do: [ :eachAuthor |
						aCollectionOfAuthors remove: eachAuthor ifAbsent: [ nil ] ].
					aCollectionOfAuthors add: eachMerged. ].
	].
]

{ #category : #'data cleaning' }
DDServer >> substituteMerged: aCollectionOfDDMergedAuthors inChannels: aCollectionOfDDChannels [
	aCollectionOfDDChannels do: [ :eachChannel |
			eachChannel authors copy do: [ :eachAuthor |
					eachAuthor mergedInto ifNotNil: [
							eachChannel authors remove: eachAuthor.
							eachChannel authors add: eachAuthor mergedInto.
					]
			]
	].

]

{ #category : #'data cleaning' }
DDServer >> substituteMerged: aCollectionOfDDMergedAuthors inMentions: aCollectionOfDDMentions [
	| flatAuthors |
	flatAuthors := (aCollectionOfDDMergedAuthors flatCollect: #authors) asSet.
	aCollectionOfDDMentions
			select: [ :each | flatAuthors includes: each mentionedEntity ]
			thenDo: [ :eachMention |	eachMention changeMentionee: eachMention mentionedEntity mergedInto. ]
]

{ #category : #accessing }
DDServer >> textChannels [
	^ self flatChannels select: [ :each | each isTextChannel ].
]

{ #category : #accessing }
DDServer >> topLevelChannels [
	^ topLevelChannels
]

{ #category : #accessing }
DDServer >> topLevelChannels: anObject [
	topLevelChannels := anObject
]

{ #category : #'private - updating' }
DDServer >> updateMetricsNormalization [
	| codeBlocks collapsedMentions classReferences |
	codeBlocks := self messages flatCollect: #codeBlocks.
	collapsedMentions := graph edges select: [ :each | each isKindOf: DDUserMention ].
	classReferences := graph nodes select: [ :each | each isKindOf: DDClassNode ].

	DDNormalizedActiveAuthorsMetric max: (self flatChannels select: #isTextChannel thenCollect: [ :each | each authors size ]) max.
	DDNormalizedActiveChannelsMetric max: ((self authors collect: [ :each | each activeChannels size ]) max).
	DDNormalizedActivitySpanMetric min: 0 days asDuration.
	DDNormalizedActivitySpanMetric max: (self statistics activityStats at: #activityDuration).
	DDNormalizedCodeSizeMetric max: (codeBlocks isEmpty ifTrue: 1 ifFalse: [(codeBlocks collect: #size) max]).
	DDNormalizedContainedMessagesMetric max: (self flatChannels select: #isTextChannel thenCollect: [ :each | each messages size ]) max.
	DDNormalizedFirstMessageDateDifferenceMetric min: (self statistics activityStats at: #firstMessageDate) - DateAndTime now.
	DDNormalizedFirstMessageDateDifferenceMetric max: 0 days asDuration.
	DDNormalizedFirstMessageOffsetDateMetric min: (self statistics activityStats at: #firstMessageDate) - self lastMessage createdAt.
	DDNormalizedFirstMessageOffsetDateMetric max: 0 days asDuration.
	DDNormalizedLocsMetric max: (codeBlocks isEmpty ifTrue: 1 ifFalse: [(codeBlocks collect: #locs) max]).
	DDNormalizedMentionsMetric max: (collapsedMentions collect: #times) max.
	DDNormalizedSentMessagesMetric max: ((self authors collect: [ :each | each sentMessages size ]) max).
	DDNormalizedMaxDailySentMessagesMetric max: ((self authors select: [ :each | each hasMessages ] thenCollect: [ :each | (each messagesByDay collect: #size) max ]) max).
	DDNormalizedClassReferencesMetric max: (classReferences collect: [ :each | each edges size ]) max.


]

{ #category : #'private - updating' }
DDServer >> updateMetricsNormalizationFromView: aVZView [
	| entities textChannels authorEntities codeBlocks collapsedMentions classReferences |
	entities := aVZView entities.
	textChannels := entities select: [ :each | each isKindOf: DDTextChannel ].
	authorEntities := entities select: [ :each | each isKindOf: DDAuthor ].
	codeBlocks := entities select: [ :each | each isKindOf: DDCode ].
	collapsedMentions := entities select: [ :each | each isKindOf: DDUserMention ].
	classReferences := entities select: [ :each | each isKindOf: DDClassNode ].

	textChannels ifNotEmpty: [
		DDNormalizedActiveAuthorsMetric max: (textChannels collect: [ :each | each authors size ]) max.
		DDNormalizedContainedMessagesMetric max: (textChannels collect: [ :each | each messages size ]) max.
	].

	authorEntities ifNotEmpty: [
		DDNormalizedActiveChannelsMetric max: (authorEntities collect: [ :each | each activeChannels size ]) max.
		DDNormalizedSentMessagesMetric max: (authorEntities collect: [ :each | each sentMessages size ]) max.
		DDNormalizedMaxDailySentMessagesMetric max: ((authorEntities select: [ :each | each hasMessages ] thenCollect: [ :each | (each messagesByDay collect: #size) max ]) max).
	].

	codeBlocks ifNotEmpty: [
		DDNormalizedCodeSizeMetric max: (codeBlocks collect: #size) max.
		DDNormalizedLocsMetric max: (codeBlocks collect: #locs) max.
	].

	classReferences ifNotEmpty: [
		DDNormalizedClassReferencesMetric max: (classReferences collect: [ :each | each edges size ]) max.
	].

	collapsedMentions ifNotEmpty: [
		DDNormalizedMentionsMetric max: (collapsedMentions collect: #times) max.
	].

	DDNormalizedActivitySpanMetric min: 0 days asDuration.
	DDNormalizedActivitySpanMetric max: (self statistics activityStats at: #activityDuration).
	DDNormalizedFirstMessageDateDifferenceMetric min: (self statistics activityStats at: #firstMessageDate) - DateAndTime now.
	DDNormalizedFirstMessageDateDifferenceMetric max: 0 days asDuration.
	DDNormalizedFirstMessageOffsetDateMetric min: (self statistics activityStats at: #firstMessageDate) - self lastMessage createdAt.
	DDNormalizedFirstMessageOffsetDateMetric max: 0 days asDuration.

]

{ #category : #updating }
DDServer >> updateStatistics [
	self statistics: (DDStatistics new server: self; updateStatistics; yourself).
]

{ #category : #accessing }
DDServer >> userMentions [
	^ self messages flatCollect: #userMentions
]

{ #category : #accessing }
DDServer >> voiceChannels [
	self flag: #FIXME. "Stage channels are being introduced and I don't know how they are handled by the API. This code will break in the presence of channels different from Text/Voice"
	^ self flatChannels reject: [ :each | each isTextChannel ].
]
