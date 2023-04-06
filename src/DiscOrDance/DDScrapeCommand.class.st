"
I am an abstract command to be invoked on a DDScraper
I provide a context of a specific configuration.
"
Class {
	#name : #DDScrapeCommand,
	#superclass : #DDServerCommand,
	#instVars : [
		'configuration'
	],
	#category : #'DiscOrDance-Commands'
}

{ #category : #accessing }
DDScrapeCommand >> configuration [
	^ configuration ifNil: [ Error new signal: 'Configuration for the scraping must be set before invoking ScraperServerCommands.' ].

]

{ #category : #accessing }
DDScrapeCommand >> configuration: aDDGlobalConfiguration [
	configuration := aDDGlobalConfiguration
]
