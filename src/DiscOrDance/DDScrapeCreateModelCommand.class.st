"
I am a command to create a model for a given server with the given configuration.
"
Class {
	#name : #DDScrapeCreateModelCommand,
	#superclass : #DDScrapeCommand,
	#category : #'DiscOrDance-Commands'
}

{ #category : #execution }
DDScrapeCreateModelCommand >> execute [
	DDScraper new globalConfiguration: self configuration;
	createPartialModel: self serverName.
]
