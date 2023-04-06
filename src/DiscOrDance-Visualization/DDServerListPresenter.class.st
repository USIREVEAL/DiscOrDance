"
I am a presenter of lists of DDServers.
I can show available servers and perform operations on them.

I use DDServerListEntryPresenter to show an entry for each server possibly available in the DiscOrDance bot.
"
Class {
	#name : #DDServerListPresenter,
	#superclass : #DDComponentPresenter,
	#instVars : [
		'servers'
	],
	#classInstVars : [
		'servers'
	],
	#category : #'DiscOrDance-Visualization-Presenters'
}

{ #category : #specs }
DDServerListPresenter class >> defaultLayout [
	^ SpBoxLayout newVertical
		add: #servers;
		yourself.

]

{ #category : #accessing }
DDServerListPresenter >> getListOfServersWithActions [
	| serverNames |
	serverNames := DDScraper new getServersList.
	^ serverNames collect: [ :each | | presenter |
		presenter := self instantiate: DDServerListEntryPresenter.
		presenter serverName: each
	].
]

{ #category : #initialization }
DDServerListPresenter >> initializePresenters [
	servers := self newComponentList.
	self getListOfServersWithActions do: [ :each | servers addPresenter: each ].

]

{ #category : #initialization }
DDServerListPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'DiscOrDance';
		initialExtent: 900@200.
]
