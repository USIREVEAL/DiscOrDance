"
I am a presenter of a DDServer with buttons for the main operations possible on a server.
I can create a simplified model of a server for testing purposes.
I can create a complete model of a server.
I can open a visualization of a server.
"
Class {
	#name : #DDServerListEntryPresenter,
	#superclass : #DDComponentPresenter,
	#instVars : [
		'label',
		'createSimpleModel',
		'createCompleteModel',
		'exploreRawModelWithVizor',
		'exploreCleanedModelWithVizor',
		'exploreCustomModelWithVizor',
		'serverName'
	],
	#category : #'DiscOrDance-Visualization-Presenters'
}

{ #category : #specs }
DDServerListEntryPresenter class >> defaultLayout [
	^ SpBoxLayout newHorizontal
		add: #label expand: true fill: false padding:0;
		add: #createSimpleModel expand: false fill: false padding:0;
		add: #createCompleteModel expand: false fill: false padding:0;
		add: #exploreRawModelWithVizor expand: false fill: false padding:0;
		add: #exploreCleanedModelWithVizor expand: false fill: false padding:0;
		add: #exploreCustomModelWithVizor expand: false fill: false padding:0;
		yourself.
]

{ #category : #accessing }
DDServerListEntryPresenter >> createCompleteModel [
	DDScrapeCreateCompleteModelCommand new
		serverName: serverName;
		execute.
	^ self inform: 'Created complete model of ' , serverName.
]

{ #category : #accessing }
DDServerListEntryPresenter >> createSimpleModel [
	DDScrapeCreateSimpleModelCommand new
		serverName: serverName;
		execute.
	^ self inform: 'Created simple model of ' , serverName.
]

{ #category : #accessing }
DDServerListEntryPresenter >> exploreCleanedModel [
	DDExploreCleanedCommand new
		serverName: serverName;
		execute.
	^ self inform: 'Exploring cleaned model of ' , serverName.
]

{ #category : #accessing }
DDServerListEntryPresenter >> exploreCustomModel [
	DDExploreCustomCommand new
		serverName: serverName;
		execute.
	^ self inform: 'Exploring custom edited model of ' , serverName.
]

{ #category : #accessing }
DDServerListEntryPresenter >> exploreRawModel [
	DDExploreRawCommand new
		serverName: serverName;
		execute.
	^ self inform: 'Exploring raw model of ' , serverName.
]

{ #category : #initialization }
DDServerListEntryPresenter >> initializePresenters [
	label := self newLabel.
	createSimpleModel := self newButton
		label: 'simple';
		help: 'Create a simple model for testing';
		icon: (self application iconNamed: #smallAdd);
		action: [ self createSimpleModel ];
		yourself.
	createCompleteModel := self newButton
		label: 'complete';
		help: 'Create a complete model for exploration. This may take some time...';
		icon: (self application iconNamed: #smallAdd);
		action: [ self createCompleteModel ];
		yourself.
	exploreRawModelWithVizor := self newButton
		label: 'raw';
		help: 'Explore the currently stored raw model with Vizor';
		icon: (self application iconNamed: #smallDoIt);
		action: [ self exploreRawModel ];
		yourself.
	exploreCleanedModelWithVizor := self newButton
		label: 'cleaned';
		help: 'Explore the currently stored clean model with Vizor';
		icon: (self application iconNamed: #smallDoIt);
		action: [ self exploreCleanedModel ];
		yourself.
	exploreCustomModelWithVizor := self newButton
		label: 'custom';
		help: 'Explore the currently stored custom model with Vizor';
		icon: (self application iconNamed: #smallDoIt);
		action: [ self exploreCustomModel ];
		yourself.
]

{ #category : #accessing }
DDServerListEntryPresenter >> serverName [
	^ serverName
]

{ #category : #accessing }
DDServerListEntryPresenter >> serverName: aServerName [
	serverName := aServerName.
	label label: aServerName
]
