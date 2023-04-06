"
I am a command that needs to know on which server it should be executed.
"
Class {
	#name : #DDServerCommand,
	#superclass : #DDCommand,
	#instVars : [
		'serverName'
	],
	#category : #'DiscOrDance-Commands'
}

{ #category : #accessing }
DDServerCommand >> serverName [
	^ serverName ifNil: [ Error new signal: 'Server name must be set before invoking ScraperServerCommands.' ].
]

{ #category : #accessing }
DDServerCommand >> serverName: aString [
	serverName := aString
]
