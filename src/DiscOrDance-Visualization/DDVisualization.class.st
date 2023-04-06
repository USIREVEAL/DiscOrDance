"
I am the main application for visualizing DiscOrDance models.
"
Class {
	#name : #DDVisualization,
	#superclass : #SpApplication,
	#instVars : [
		'model',
		'vizorWindow',
		'serversList'
	],
	#classInstVars : [
		'restrictViewToChannel'
	],
	#category : #'DiscOrDance-Visualization-Base'
}

{ #category : #fixing }
DDVisualization class >> fixFonts [
	"Quick hack for fixing overlapping fonts in Roassal3 - suggested by the discord community, reported by Aron Fiechter"
	self flag: #FIXME "Actually this doesn't seem to solve the problem".
	FreeTypeFontProvider current updateFromSystem families
]

{ #category : #accessing }
DDVisualization class >> restrictViewToChannel [
	^ restrictViewToChannel
]

{ #category : #accessing }
DDVisualization class >> restrictViewToChannel: channelName [
	restrictViewToChannel := channelName
]

{ #category : #specs }
DDVisualization class >> viewSpecs [
	^ (DDViewSpec allSubclasses collect: [ :each | each new ]) sorted: [ :a :b | a name < b name ]
]

{ #category : #visualization }
DDVisualization >> createAuthorsMentionsViewInChannel: channelName [
	| authorsNodes membersNodes channel messages notMentioned |

	channel := self model firstChannelNamed: channelName.

	"Get channel authors (green) and other members (red)"
	authorsNodes := channel authors collect: #asVZNode.
	authorsNodes do: [ :each | each color: Color green. ].
	membersNodes := (self model authors asSet difference: channel authors) collect: #asVZNode.
	membersNodes do: [ :each | each color: Color red. ].

	graph initialize.
	graph addAll: authorsNodes , membersNodes.

	"Connect authors by userMentions relation"
	messages := channel messages.
	messages
		reject: [ :each | each mentions isEmpty ]
		thenDo: [ :each | | mentionee |
			mentionee := each author.
			each userMentions
				do: [ :eachMention |
					graph connectModel: mentionee andModel: eachMention mentionedEntity
			].
		].

	"Hide unmentioned authors"
	notMentioned := graph nodes reject: #hasEdges.
	self flag: #FIXME. "These nodes can be removed instead of hiding them"
	graph clearAndSelectAll: notMentioned.
	graph selection hideAll.

]

{ #category : #visualization }
DDVisualization >> createAuthorsMentionsViewWithAuthors: aCollectionOfDDAuthors [
	^ self createAuthorsMentionsViewWithAuthors: aCollectionOfDDAuthors ignoreMissing: false. 
]

{ #category : #visualization }
DDVisualization >> createAuthorsMentionsViewWithAuthors: aCollectionOfDDAuthors ignoreMissing: aBoolean [
	| authorsNodes messages mentionsByAuthor notMentioned |

	"Get channel authors (green) and other members (red)"
	authorsNodes := aCollectionOfDDAuthors collect: #asVZNode.
	authorsNodes do: [ :each | each color: Color green. ].

	graph initialize.
	graph addAll: authorsNodes.

	"Connect authors by userMentions relation"
	messages := aCollectionOfDDAuthors flatCollect: #sentMessages.
	mentionsByAuthor := (messages flatCollect: #userMentions) groupedBy: #mentioningEntity.
	mentionsByAuthor keysAndValuesDo: [ :eachMentioner :eachMentionsCollection | | byMentionee |
		byMentionee := eachMentionsCollection groupedBy: #mentionedEntity.
		byMentionee keysAndValuesDo: [ :eachMentionee :mentions |
			(graph findNodeByModel: eachMentionee)
				ifNotNil: [ | newEdge |
					newEdge := graph connectModel: eachMentioner andModel: eachMentionee.
					newEdge model: mentions size.
					newEdge width: mentions size.
				]
				ifNil: [
					aBoolean ifFalse: [
						Error new signal: 'One of the mentioned entities is not present in the graph. Use ignoreMissing: true to ignore this error and remove those edges.' ]
				].
		].
	].
	
	"Hide unmentioned authors"
	notMentioned := graph nodes reject: #hasEdges.
	self flag: #FIXME. "These nodes can be removed instead of hiding them"
	graph clearAndSelectAll: notMentioned.
	graph selection hideAll.

]

{ #category : #visualization }
DDVisualization >> createCategoryHierarchyView [
	| topLevelNodes categoryNodes nodes edges graph |

	nodes := OrderedCollection new.
	edges := OrderedCollection new.

	"Create nodes for categories"
	categoryNodes := model categories collect: [ :each | VZNode new model: each; color: Color gray; size: 7 ].
	nodes addAll: categoryNodes.
	
	"For each category create nodes for its channels and connect them to the category node with an endge"
	categoryNodes do: [ :eachCategory | | channelNodes categoryEdges |
		channelNodes := self getNodesFromEntities: eachCategory model channels.
		nodes addAll: channelNodes.
		categoryEdges := channelNodes collect: [ :eachNode | VZEdge between: eachCategory and: eachNode ].
		edges addAll: categoryEdges.
	].
	
	topLevelNodes := self getNodesFromEntities: model topLevelChannels.
	nodes addAll: topLevelNodes.

	graph nodes: nodes.
	graph edges: edges.

	"self normalizeNodeSizeBetween: 5.0 and: 100.0."
]

{ #category : #visualization }
DDVisualization >> createFlatChannelView [
	| categoryNodes nodes edges graph |

	nodes := OrderedCollection new.
	edges := OrderedCollection new.

	"Create nodes for categories"
	categoryNodes := self getNodesFromEntities: model flatChannels.
	nodes addAll: categoryNodes.
	
	graph nodes: nodes.
	graph edges: edges.

]

{ #category : #visualization }
DDVisualization >> createServerView: aServer [
	| contentShapes authorShapes overview |

	overview := RSGroup new.
	authorShapes := self getShapesFromAuthors: aServer.
	"overview add: (RSGroup new addAll: authorShapes)."
	canvas addAll: authorShapes.
	RSFlowLayout new on: authorShapes.


	contentShapes := self getShapesFromCategories: (aServer categories).
	"overview add: (RSGroup new addAll: contentShapes)."
	canvas addAll: contentShapes.
	RSFlowLayout new on: contentShapes.

]

{ #category : #accessing }
DDVisualization >> customizeMenu [
	| menuBar |
	menuBar := self vizorWindow instantiate: DDMenuBar on: self model.
	self vizorWindow menuBar: menuBar.
]

{ #category : #visualization }
DDVisualization >> getNodesFromEntities: aCollectionOfDDRootModel [
	^ aCollectionOfDDRootModel collect: [ :each | VZNode new model: each ].
]

{ #category : #visualization }
DDVisualization >> getShapesFromAuthors: aDDServer [
	"Create an author flow list with size proportional to the number of messages sent by each author."
	| authorShapes authorMessages |

	authorMessages := aDDServer getMessagesByAuthor sortedCounts.
	
	authorShapes := authorMessages collect: [ :each |
		RSBox new
			model: each value;
			height: each key;
			width: each key;
			color: Color green;
			@ RSDraggable;
			@ RSPopup;
			yourself.
	].

	^ authorShapes.
]

{ #category : #visualization }
DDVisualization >> getShapesFromCategories: categories [
	"Create shapes connected by edges for each category and their contained channels."
	| newShapes categoryShapes channelShapes |

	categoryShapes := categories collect:
	[ :each | each glyph ].

	channelShapes := OrderedCollection new.
	categories do:
	[ :eachCategory |
		eachCategory channels do: [ :eachChannel | 	channelShapes add: eachChannel glyph ].
	].

	newShapes := categoryShapes , channelShapes.

	^ newShapes.
]

{ #category : #visualization }
DDVisualization >> getShapesFromChannels: channels [
	"Return a visual representation of a list of channels"
	| newShapes |
	newShapes := channels collect:
	[ :each | each glyph ].

	^ newShapes
]

{ #category : #initialization }
DDVisualization >> initializeGraph [
	| view |

	view := VZViewBuilder new
		graph: model completeGraph;
		viewSpec: DDAuthorViewSpec new;
		build.
	model updateMetricsNormalization.

	self vizorWindow view: view.
	self customizeMenu.
]

{ #category : #examples }
DDVisualization >> loadExampleModel [
	self loadModel: #raw forServer: 'Wolfenmark bot development server'.
]

{ #category : #loading }
DDVisualization >> loadModel: aDDServer [
	model := aDDServer.
	self initializeGraph.

]

{ #category : #loading }
DDVisualization >> loadModel: modelType forServer: serverName [
	"modelType can be: #raw, #clean or #custom"
	model := (DDModel new deserialize: modelType server: serverName) servers at: 1.
	self initializeGraph.

]

{ #category : #accessing }
DDVisualization >> model [
	^ model
]

{ #category : #accessing }
DDVisualization >> model: anObject [
	model := anObject
]

{ #category : #'private - utility' }
DDVisualization >> normalizeNodeSizeBetween: lowerBound and: higherBound [
	"Quick hack method to normalize nodes size of the current graph given an interval"

	| widths heights minWidth maxWidth minHeight maxHeight widthRange heightRange boundRange |
	
	widths := graph nodes collect: #width.
	heights := graph nodes collect: #height.
	minWidth := widths min.
	maxWidth := widths max.
	minHeight := heights min.
	maxHeight := heights max.
	widthRange := maxWidth - minWidth.
	heightRange := maxHeight - minHeight.
	boundRange := higherBound - lowerBound.
	
	graph nodes do: [ :each |
		each width: (((each width asFloat - minWidth) / widthRange) * boundRange) + lowerBound.
		each height: (((each height asFloat - minHeight ) / heightRange) * boundRange) + lowerBound.
	]
]

{ #category : #'instance creation' }
DDVisualization >> open [
	vizorWindow openWithSpec.
]

{ #category : #visualization }
DDVisualization >> showServerSelector [
	serversList ifNil: [ serversList := self newPresenter: DDServerListPresenter ].
	serversList openWithSpec.
]

{ #category : #accessing }
DDVisualization >> vizorWindow [
	^ vizorWindow ifNil: [ vizorWindow := self newPresenter: VZMainWindow.	].

]

{ #category : #accessing }
DDVisualization >> vizorWindow: aVZMainWindow [
	vizorWindow := aVZMainWindow
]
