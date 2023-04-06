Class {
	#name : #DDScraperTest,
	#superclass : #DDTestCase,
	#instVars : [
		'scraper'
	],
	#category : #'DiscOrDance-Tests-Scraper'
}

{ #category : #running }
DDScraperTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	scraper := DDScraper new.

]

{ #category : #tests }
DDScraperTest >> testGetLocalServersList [
	| list |
	list := scraper getLocalServersList.
	(list includes: 'Wolfenmark bot development server') ifFalse: [ 
		scraper createPartialModel: 'Wolfenmark bot development server'.
		list := scraper getLocalServersList.
	].

	self assert: list isNotEmpty.
	self assert: (list includes: 'Wolfenmark bot development server')
]

{ #category : #tests }
DDScraperTest >> testGetServersList [
	| list |
	list := scraper getServersList.

	self assert: list isNotEmpty.
	self assert: (list includes: 'Wolfenmark bot development server')
]
