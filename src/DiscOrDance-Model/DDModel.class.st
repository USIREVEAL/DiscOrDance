"
I am a model of Discord servers.

I know different servers and I can serialize/deserialize them.
I know how to populate the model from a collection servers.
"
Class {
	#name : #DDModel,
	#superclass : #DDNode,
	#instVars : [
		'servers',
		'globalConfiguration'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #'serialize/materialize' }
DDModel class >> checkModelsDirectory [
	"Checks if the models directory exists and creates it if it doesn't."
	| workingDir modelsDir |

	workingDir := FileSystem disk workingDirectory.
	modelsDir := workingDir / 'models'.
	modelsDir exists ifFalse: [ modelsDir createDirectory ].

]

{ #category : #'accessing-defaults' }
DDModel class >> defaultChannelDumpsDirectory [
	^ self defaultDumpsDirectory / 'single-channels'.
]

{ #category : #'accessing-defaults' }
DDModel class >> defaultDumpsDirectory [
	^ FileLocator imageDirectory asFileReference / 'dumps'.
]

{ #category : #versions }
DDModel class >> defaultFileExtension [
	^ '.fl'
]

{ #category : #'serialize/materialize' }
DDModel class >> ensureChannelDumpsDirectoryExists [
	"Checks if the default dumps directory for single channels exists in the current dumps directory and creates it if it doesn't."
	| channelDumpsDir |

	self ensureDumpsDirectoryExists.
	channelDumpsDir := self defaultDumpsDirectory / 'single-channels'.
	channelDumpsDir exists ifFalse: [ channelDumpsDir createDirectory ].

]

{ #category : #'serialize/materialize' }
DDModel class >> ensureDumpsDirectoryExists [
	"Checks if the default dumps directory exists in the current image directory and creates it if it doesn't."
	| dumpsDir |

	dumpsDir := self defaultDumpsDirectory.
	dumpsDir exists ifFalse: [ dumpsDir createDirectory ].

]

{ #category : #versions }
DDModel class >> latestVersion [
	^ 'v1_2'
]

{ #category : #'private - utility' }
DDModel class >> modelTypesDict [
	^ Dictionary newFrom: {
		#raw -> '_raw_' .
		#clean -> '_clean_' .
		#custom -> '_custom_'
	}.

]

{ #category : #'serialize/materialize' }
DDModel class >> serializeServer: aDDServer [
	self new serializeServer: aDDServer.
]

{ #category : #initialization }
DDModel >> configure: aDDGlobalConfiguration [
	globalConfiguration := aDDGlobalConfiguration.
]

{ #category : #'serialize/materialize' }
DDModel >> deserialize [
	"For each FUEL (.fl) file in ./models load a DDServer object and add it to `self servers` (see matching 'serialize')"
	| workingDir modelsDir serverFiles |
	
	workingDir := FileSystem disk workingDirectory.
	modelsDir := workingDir / 'models'.
	modelsDir exists ifTrue: [ 
		serverFiles := modelsDir children select: [ :each | each basename endsWith: '.fl' ].
		servers := serverFiles collect: [ :each | self deserializeServerFile: ('models/' , (each basename)) ].
	].
]

{ #category : #'serialize/materialize' }
DDModel >> deserialize: aSymbol server: serverName [
	"Load a DDServer object and add it to `self servers` (see matching 'serializeServer:')"
	
	self deserializeServerFile: (self getFilename: aSymbol fromServerName: serverName).

]

{ #category : #'serialize/materialize' }
DDModel >> deserializeServerFile: fileName [
	"Load a DDServer object and add it to `self servers` (see matching 'serializeServer:')"
	
	servers add: (FLMaterializer materializeFromFileNamed: fileName).

]

{ #category : #'serialize/materialize' }
DDModel >> getFilename: aSymbol fromServerName: serverName [
	| partialTypeName |
	partialTypeName := self class modelTypesDict
		at: aSymbol
		ifAbsent: [ Error signal: 'Unsupported model type: ', aSymbol printString. ].
	^ 'models/' , serverName , partialTypeName , self class latestVersion , self class defaultFileExtension
]

{ #category : #'serialize/materialize' }
DDModel >> getStatisticsName: aSymbol fromServerName: serverName [
	| partialTypeName |
	partialTypeName := self class modelTypesDict
		at: aSymbol
		ifAbsent: [ Error signal: 'Unsupported model type: ', aSymbol printString. ].
	^ 'models/' , serverName , partialTypeName , 'stats_' , self class latestVersion
]

{ #category : #accessing }
DDModel >> globalConfiguration [
	^ globalConfiguration
]

{ #category : #initialization }
DDModel >> initialize [
	super initialize.
	servers := OrderedCollection new.
]

{ #category : #initialization }
DDModel >> populate: aCollectionOfServers [
	| totalIterations currentIteration incrementPerIteration |
	totalIterations := aCollectionOfServers size.
	currentIteration := 0.
	incrementPerIteration := 1.0 / totalIterations.
	[ :job | job title: 'Scraping servers'.
		aCollectionOfServers do: [ :each |
			job
				progress: (incrementPerIteration * currentIteration);
				title: ('Scraping: ' , each asString).
			servers
				add: (DDServer new createServer: each with: globalConfiguration).
			currentIteration := currentIteration + 1.
		]
	] asJob run.

	"Print information about scraping times"
	servers do: [ :each | Transcript show: ('Scraping time for ' , (each name) , ' :' , (((each scrapingTime asDuration) roundTo: (2 second)) asString) , ' d:hh:mm:ss.' ); cr.].

]

{ #category : #'serialize/materialize' }
DDModel >> saveReadableStatistics: aSymbol for: aDDServer [
	| fileName stats |
	self class checkModelsDirectory.
	fileName := self getStatisticsName: aSymbol fromServerName: aDDServer name.
	stats := DDStatistics new server: aDDServer.
	stats updateStatistics.
	
	stats exportToCSV: fileName.

]

{ #category : #'serialize/materialize' }
DDModel >> serialize [
	"Save every server in the model to a file in the ./models directory (see matching 'deserialize')"

	servers do: [ :each | self serializeServer: each ].
]

{ #category : #'serialize/materialize' }
DDModel >> serialize: aSymbol server: aDDServer [
	| fileName serializeStart serializeStop serializationTime |
	serializeStart := DateAndTime now.

	self class checkModelsDirectory.
	fileName := self getFilename: aSymbol fromServerName: aDDServer name.
	FLSerializer serialize: aDDServer toFileNamed: fileName.
	self saveReadableStatistics: aSymbol for: aDDServer.

	serializeStop := DateAndTime now.
	serializationTime := (serializeStop - serializeStart) roundTo: 1 second.
	(aSymbol capitalized , ' server serialization took: ' , serializationTime humanReadablePrintString) traceCr.
]

{ #category : #'serialize/materialize' }
DDModel >> serializeServer: aDDServer [
	"Save aDDServer to a file in the ./models directory (see matching 'deserialize: serverName')"

	self globalConfiguration ifNil: [ self configure: aDDServer globalConfiguration ].
	
	aDDServer isCustomEdited
		ifTrue: [ self serialize: #custom server: aDDServer. ]
		ifFalse: [
			aDDServer isCleaned
				ifFalse: [
					self serialize: #raw server: aDDServer.
					aDDServer cleanModel. ].
				self serialize: #clean server: aDDServer. ].
]

{ #category : #accessing }
DDModel >> servers [
	^ servers
]

{ #category : #accessing }
DDModel >> servers: anObject [
	servers := anObject
]
