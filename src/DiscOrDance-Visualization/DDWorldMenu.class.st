"
I am a menu item with all the top-level entries for DiscOrDance.
"
Class {
	#name : #DDWorldMenu,
	#superclass : #Object,
	#category : #'DiscOrDance-Visualization-Menu'
}

{ #category : #utility }
DDWorldMenu class >> clearApplicationsByName: aName [
	| application windowsToRemove |
	
	self flag: #FIXME "If SpNullApplication is not a singleton this might lead to inconsistencies".
	application := SpNullApplication allInstances first.
	windowsToRemove := application windows select: [ :each | each window labelString = aName ].
	windowsToRemove do: [ :each | application windows remove: each ].
	windowsToRemove := application windows select: [ :each | each title = aName ].
	windowsToRemove do: [ :each | application windows remove: each ].

]

{ #category : #menu }
DDWorldMenu class >> menu00DiscOrDanceOn: aBuilder [
	<worldMenu>
	(aBuilder item: #DDVisualization)
		label: #DiscOrDance;
		"icon: self roassalIcon;"
		help: 'DiscOrDance a Discord mining and visualization tool.';
		order: 800
]

{ #category : #menu }
DDWorldMenu class >> menu01UtilitiesOn: aBuilder [
	<worldMenu>
	(aBuilder item: #DDVisualizationUtilities)
		parent: #DDVisualization;
		order: 700;
		label: 'Utilities';
		help: 'List of common utilities to keep at hand during development.'
]

{ #category : #menu }
DDWorldMenu class >> menu02ExamplesOn: aBuilder [
	<worldMenu>
	(aBuilder item: #DDVisualizationExamples)
		parent: #DDVisualization;
		order: 710;
		label: 'Examples';
		help: 'Example visualizations to demonstrate DiscOrDance.'
]

{ #category : #menu }
DDWorldMenu class >> menu03DiscOrDanceOn: aBuilder [
	<worldMenu>
	(aBuilder item: #DDDiscOrDanceUI)
		parent: #DDVisualization;
		order: 100;
		label: 'DiscOrDance';
		help: 'Show DiscOrDance to create models and browse servers.';
		icon: (self iconNamed: 'glamorousGo');
		action: [ DDVisualizationExample baseExample ]
]

{ #category : #menu }
DDWorldMenu class >> menu10OpenForDevelopment: aBuilder [
	<worldMenu>
	(aBuilder item: #DDVisualizationOpenForDevelopment)
		parent: #DDVisualizationUtilities;
		order: 0;
		label: 'Open for Development';
		icon: (self iconNamed: 'smallDebug');
		help: 'Open brwosers scoped with interesting classes to tackle development of new features.';
		action: [ DiscOrDance openForDevelopment ]
]

{ #category : #menu }
DDWorldMenu class >> menu11FixFontsOn: aBuilder [
	<worldMenu>
	(aBuilder item: #DDVisualizationFixFonts)
		parent: #DDVisualizationUtilities;
		order: 1;
		label: 'Fix fonts';
		icon: (self iconNamed: 'smallDebug');
		help: 'Temporary hack to try and fix Roassal3 fonts in the canvas.';
		action: [ DDVisualization fixFonts ]
]

{ #category : #menu }
DDWorldMenu class >> menu12GarbageCollectOn: aBuilder [
	<worldMenu>
	(aBuilder item: #DDGarbageCollect)
		parent: #DDVisualizationUtilities;
		order: 2;
		label: 'Garbage collect (5 times)';
		icon: (self iconNamed: 'smallDebug');
		help: 'Temporary hack to try and fix Roassal3 fonts in the canvas.';
		action: [ 5 timesRepeat: [ Smalltalk garbageCollect ] ].
]

{ #category : #menu }
DDWorldMenu class >> menu13SpNullApplicationInstancesOn: aBuilder [
	<worldMenu>
	(aBuilder item: #DDSpNullApplicationInstances)
		parent: #DDVisualizationUtilities;
		order: 3;
		label: 'SpNullApplication allInstances';
		help: 'See all instances of SpNullApplication.';
		action: [ SpNullApplication allInstances inspect ].
]

{ #category : #menu }
DDWorldMenu class >> menu14CleanDiscOrDancePresenterInstancesOn: aBuilder [
	<worldMenu>
	(aBuilder item: #DDPresenterInstances)
		parent: #DDVisualizationUtilities;
		order: 4;
		label: 'Clean DiscOrDance Presenters';
		help: 'Remove all instances of DiscOrDance related presenters.';
		action: [ self clearApplicationsByName: 'DiscOrDance' ].
]

{ #category : #menu }
DDWorldMenu class >> menu15CleanUntitledWindowPresenterInstancesOn: aBuilder [
	<worldMenu>
	(aBuilder item: #DDUntitledWindowInstances)
		parent: #DDVisualizationUtilities;
		order: 5;
		label: 'Clean Untitled Window Presenters';
		help: 'Remove all instances of "Untitled window" related presenters.';
		action: [ self clearApplicationsByName: 'Untitled window' ].
]

{ #category : #menu }
DDWorldMenu class >> menu21SampleModelOn: aBuilder [
	<worldMenu>
	(aBuilder item: #DDSampleModel)
		parent: #DDVisualizationExamples;
		order: 1;
		label: 'Create and inspect sample test server';
		help: 'Create and inspect a sample Discord server used for development.';
		action: [ DDVisualizationExample inspectSampleModel ]
]

{ #category : #menu }
DDWorldMenu class >> menu22SampleModelOn: aBuilder [
	<worldMenu>
	(aBuilder item: #DDVisualizationSampleModel)
		parent: #DDVisualizationExamples;
		order: 2;
		label: 'Show sample test server';
		help: 'Show a sample Discord server used for development.';
		action: [ DDVisualizationExample openSampleModelWithVizor ]
]
