"
I am an extension of a Vizor VZMenuBar providing my own menu entries.
"
Class {
	#name : #DDMenuBar,
	#superclass : #VZMenuBar,
	#instVars : [
		'server'
	],
	#category : #'DiscOrDance-Visualization-Presenters'
}

{ #category : #'restricting - channels' }
DDMenuBar >> addChannels: channels inMenu: aMenu [
	channels do: [ :each |
		aMenu addItem: [ :item |
			item
				name: each name;
				"iconName: #smallInfo;"
				description: 'Restrict some views to this channel.';
				action: [
					DDVisualization restrictViewToChannel: each.
					self reapplySpec. ]
		].
	].
]

{ #category : #actions }
DDMenuBar >> cleanModel [
	self server cleanModel.
	self updateGraph.
]

{ #category : #initialization }
DDMenuBar >> ddChannels [
	| newMenu |
	newMenu := self newMenu.
	self addChannels: (self server topLevelChannels) inMenu: newMenu.
	(self server categories) do: [ :each | | categoryMenu |
		categoryMenu := newMenu newMenu.
		self addChannels: each channels inMenu: categoryMenu.
		newMenu addItem: [ :item |
			item
				name: each name;
				subMenu: categoryMenu.
		].
	].
	^ newMenu
]

{ #category : #initialization }
DDMenuBar >> ddMenu [
	^ self newMenu
		addItem: [ :item |
			item
				name: 'Clean model';
				iconName: #smallInfo;
				description: 'Clean the current model';
				action: [ self cleanModel ] ];
		addItem: [ :item |
			item
				name: 'Renormalize static metrics';
				iconName: #smallInfo;
				description: 'Renormalize the static metrics based on the whole model';
				action: [ self renormalizeMetrics ] ];
		addItem: [ :item |
			item
				name: 'Renormalize static metrics based on current view';
				iconName: #smallInfo;
				description: 'Renormalize the static metrics based on the current view';
				action: [ self renormalizeMetricsFromView ] ];
		addItem: [ :item |
			item
				name: 'Regenerate graph';
				iconName: #smallInfo;
				description: 'Regenerate the full graph from the base model';
				action: [ self regenerateGraph ] ];
		addItem: [ :item |
			item
				name: 'Save model with current graph';
				iconName: #smallInfo;
				description: 'Save the model. If it is an uncleaned, also generate the cleaned version and save it.';
				action: [ self saveModel ] ];
		addItem: [ :item |
			item
				name: 'Remove current graph and save model';
				iconName: #smallInfo;
				description: 'Remove the current graph from the model, then save the model. If it is an uncleaned, also generate the cleaned version and save it.';
				action: [ self removeGraphAndSaveModel ] ];
		addItem: [ :item |
			item
				name: 'Save model as Customized';
				iconName: #smallInfo;
				description: 'Save the model as a special custom model after manual editing.';
				action: [ self saveCustomModel ] ];
		yourself
]

{ #category : #initialization }
DDMenuBar >> initialize [
	super initialize.
	menuBar
		addItem: [ :item |
			item name: 'DiscOrDance';
			subMenu: self ddMenu. ];
		addItem: [ :item |
			item name: 'Channel-restrict';
			subMenu: self ddChannels. ].

]

{ #category : #'view updating' }
DDMenuBar >> reapplySpec [
	| newView |
	newView := (self view builder
		graph: self view graph;
		originalEntities: self view originalEntities;
		viewSpec: self view lastViewSpec) build.
	self mainWindow view: newView.
	self view viewChanged.
]

{ #category : #actions }
DDMenuBar >> regenerateGraph [
	self server completeGraph: self server generateGraph.
	self updateGraph.
]

{ #category : #actions }
DDMenuBar >> removeGraphAndSaveModel [
	self server completeGraph: nil.
	DDModel serializeServer: self server.
]

{ #category : #actions }
DDMenuBar >> renormalizeMetrics [
	self server updateMetricsNormalization.
	self view viewChanged.
]

{ #category : #actions }
DDMenuBar >> renormalizeMetricsFromView [
	self server updateMetricsNormalizationFromView: self view.
	self view viewChanged.
]

{ #category : #actions }
DDMenuBar >> saveCustomModel [
	self server manualCustomize.
	DDModel serializeServer: self server.
]

{ #category : #actions }
DDMenuBar >> saveModel [
	DDModel serializeServer: self server.
]

{ #category : #accessing }
DDMenuBar >> server [
	^ server
]

{ #category : #accessing }
DDMenuBar >> server: aDDServer [
	server := aDDServer
]

{ #category : #'accessing model' }
DDMenuBar >> setModelBeforeInitialization: aDomainObject [
	self server: aDomainObject.
]

{ #category : #actions }
DDMenuBar >> updateGraph [
	| newView |
	self view graph: self server completeGraph.
	newView := (self view builder
		graph: self view graph;
		viewSpec: self view lastViewSpec) build.
	self mainWindow view: newView.
	self view viewChanged.
]
