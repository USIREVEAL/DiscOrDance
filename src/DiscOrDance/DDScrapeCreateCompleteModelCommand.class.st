"
I am a command to create a complete model for the given server.
The configuration I use is not limited in number of messages retrieved.
"
Class {
	#name : #DDScrapeCreateCompleteModelCommand,
	#superclass : #DDScrapeCreateModelCommand,
	#category : #'DiscOrDance-Commands'
}

{ #category : #execution }
DDScrapeCreateCompleteModelCommand >> execute [
	self configuration: (
		DDGlobalConfiguration new
			limitMessages: false;
			messagesPerChannel: -1
	).
	
	super execute.
]
