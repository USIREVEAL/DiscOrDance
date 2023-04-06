"
I am a scraper to build a model of all the discord servers present in the DiscOrDance bot.

I can create a new model, populate it and then serialize it. I can also load a model from a serialized version. I know global configuration details that I pass down to the model.

To enable the scraper to access private servers you should add your Discord bot Token to DDScraper privateToken class side method.

To create a default scraper:

```smalltalk
| ddScraper |
ddScraper := DDScraper new createModel.
ddScraper inspect.
```

To create a scraper with custom configuration (for example to limit number of retrieved messages to 25):

```smalltalk
| ddScraper ddConfig |
ddConfig := DDGlobalConfiguration new
	limitMessages: true;
	messagesPerChannel: 25.
ddScraper := DDScraper new
	globalConfiguration: ddConfig;
	createModel;
	inspect.
```


To create a scraper that retrieves all messages on the servers:

```smalltalk
| ddScraper ddConfig |
ddConfig := DDGlobalConfiguration new
	limitMessages: false.
ddScraper := DDScraper new
	globalConfiguration: ddConfig;
	createModel;
	inspect.
```


To load a model from a local serialized copy:

```smalltalk
| ddScraper |
ddScraper := DDScraper new loadModel.
ddScraper inspect.
```

"
Class {
	#name : #DDScraper,
	#superclass : #DDRoot,
	#instVars : [
		'model',
		'globalConfiguration',
		'bot'
	],
	#category : #'DiscOrDance-Base'
}

{ #category : #'accessing - defaults' }
DDScraper class >> defaultToken [
	"""Returns a default token based on an environment variable.
	Add your private token to environment variables as DISCORD_API_TOKEN to use it."""
	| message |
	message := 'Missing private authentication token. Example (run in playground): Smalltalk os environment at: ''DISCORD_API_TOKEN'' put: ''YOUR_TOKEN_HERE'''.
	^ Smalltalk os environment at: 'DISCORD_API_TOKEN' ifAbsent: [ Error new messageText: message; signal. ]
]

{ #category : #accessing }
DDScraper >> bot [
	^ bot ifNil: [ bot := DSBot new token: self class defaultToken ].
]

{ #category : #accessing }
DDScraper >> bot: anObject [
	bot := anObject
]

{ #category : #utility }
DDScraper >> createDummyModel [
	self createPartialModel: 'Wolfenmark'.
]

{ #category : #utility }
DDScraper >> createModel [
	self createPartialModel: nil.
]

{ #category : #utility }
DDScraper >> createPartialModel: partialServerName [
	| servers |
	servers := self bot servers.

	partialServerName ifNotNil: [ 
		servers := servers select: [ :each | (each name asString) includesSubstring: partialServerName. ].
	].
	model populate: servers.
	
	self flag: #FIXME "This serialization might be useful only if the object is to be persisted, otherwise it might be redundant. Provide a more general implementaiton.".
	model serialize.

]

{ #category : #accessing }
DDScraper >> getLocalServersList [
	"Return the name of every server having a local model available"
	| workingDir modelsDir serverFiles |
	
	workingDir := FileSystem disk workingDirectory.
	modelsDir := workingDir / 'models'.
	modelsDir exists
		ifTrue: [
			serverFiles := modelsDir children.
			^ serverFiles collect: [ :each |
					((each basename withoutSuffix: '.fl')
					withoutTrailingDigits)
					withoutSuffix: '_v'.
			].
		]
		ifFalse: [
			^ OrderedCollection new.
		].
]

{ #category : #accessing }
DDScraper >> getServersList [
	"Return a list of servers available to the DiscOrDance bot"
	| namesList |
	namesList := OrderedCollection new.
	namesList addAll: (self bot servers collect: #name).
	^ namesList.
]

{ #category : #accessing }
DDScraper >> globalConfiguration [
	^ globalConfiguration
]

{ #category : #accessing }
DDScraper >> globalConfiguration: anObject [
	globalConfiguration := anObject.
	model configure: globalConfiguration.
]

{ #category : #initialization }
DDScraper >> initialize [
	super initialize.
	globalConfiguration := DDGlobalConfiguration new.
	model := DDModel new.
	model configure: self globalConfiguration.
]

{ #category : #utility }
DDScraper >> loadModel [
	model := DDModel new deserialize.
]

{ #category : #accessing }
DDScraper >> model [
	^ model
]

{ #category : #accessing }
DDScraper >> model: anObject [
	model := anObject
]
