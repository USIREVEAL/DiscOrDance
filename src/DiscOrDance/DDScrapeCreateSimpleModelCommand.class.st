"
I am a command to create a complete model for the given server.
The configuration I use is very limited in number of messages retrieved.
"
Class {
	#name : #DDScrapeCreateSimpleModelCommand,
	#superclass : #DDScrapeCreateModelCommand,
	#category : #'DiscOrDance-Commands'
}

{ #category : #execution }
DDScrapeCreateSimpleModelCommand >> execute [
	self configuration: (
		DDGlobalConfiguration new
			limitMessages: true;
			messagesPerChannel: 100
	).
	
	super execute.
]
