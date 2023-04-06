"
I am DiscOrDance, a discord mining bot. I have a list of servers available for scraping, analyses, and insights.

To access the servers I use the token provided by the DDScraper class side method defaultToken. Provide your private token in DDScraper privateToken to explore servers where your private instance of DiscOrDance has been previously added (see top-level README.md for instructions).
"
Class {
	#name : #DiscOrDance,
	#superclass : #DDRoot,
	#instVars : [
		'servers'
	],
	#category : #'DiscOrDance-Base'
}

{ #category : #'private - utility' }
DiscOrDance class >> openForDevelopment [
	"Open System Browser with correct scope"
	| browsers browser scope windowGroup |
	scope := ClyPackageScope
		ofAll: {
			'BaselineOfDiscOrDance' asPackage .
			'DiscOrDance' asPackage .
			'DiscOrDance-Exceptions' asPackage.
			'DiscOrDance-Model' asPackage .
			'DiscOrDance-Model-Unused' asPackage .
			'DiscOrDance-Tests' asPackage .
			'DiscOrDance-Visualization' asPackage.
			'BaselineOfVizor' asPackage.
			'Vizor' asPackage.
			'Vizor-Tests' asPackage
		}
		in: ClyNavigationEnvironment currentImage.

	browser := Smalltalk tools browser open.
	browser setUpScopedModeWith: scope.
	browser owner createWindowGroup.
	windowGroup := browser owner owner owner owner.
	browsers := { DDServer . DDVisualization . VZObject }.
	browsers do: [ :each | | aBrowser |
		aBrowser := Smalltalk tools browser open.
		aBrowser setUpScopedModeWith: scope.
		windowGroup addWindow: aBrowser owner.
		aBrowser selectClass: each.
	].

	Iceberg showSystemRepositories.
	"Open Transcript"
	Transcript open.

]

{ #category : #utility }
DiscOrDance >> createServers [
	servers := DSBot new
		token: DDScraper defaultToken;
		servers.
]

{ #category : #initialization }
DiscOrDance >> initialize [
	super initialize.
	servers := OrderedCollection new.
]

{ #category : #accessors }
DiscOrDance >> servers [
	^ servers
]
