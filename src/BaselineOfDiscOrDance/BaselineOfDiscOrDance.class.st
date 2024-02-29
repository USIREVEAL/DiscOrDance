"
I am a baseline for the DiscOrDance package.
"
Class {
	#name : #BaselineOfDiscOrDance,
	#superclass : #BaselineOf,
	#category : #'BaselineOfDiscOrDance-Base'
}

{ #category : #baselines }
BaselineOfDiscOrDance >> baseline: spec [
	<baseline>
	spec for: #common do: [
		"DiscOrDance is implemented and tested on Pharo 8 only at the moment."
		spec for: #'pharo8.x' do: [
			"Dependencies"
			self vizor: spec.
			self discordST: spec.

			"Packages"
			spec
				package: 'DiscOrDance';
				package: 'DiscOrDance-Exceptions' with: [ spec requires: #('DiscOrDance') ];
				package: 'DiscOrDance-Model' with: [ spec requires: #('DiscOrDance') ];
				package: 'DiscOrDance-Model-Unused' with: [ spec requires: #('DiscOrDance') ];
				package: 'DiscOrDance-Tests' with: [ spec requires: #('DiscOrDance') ];
				package: 'DiscOrDance-Visualization' with: [ spec requires: #('DiscOrDance') ].
		].
	].
]

{ #category : #baselines }
BaselineOfDiscOrDance >> discordST: spec [
	spec baseline: #DiscordSt
		"Original repository from Juraj Kubelka"
		"with: [ spec repository: 'github://JurajKubelka/DiscordSt/src' ]."
		"My forked repository"
		with: [ spec repository: 'github://wolfenmark/DiscordSt/src' ].

]

{ #category : #actions }
BaselineOfDiscOrDance >> incompatiblePharoVersion [
	| message |
	message := 'Unsupported Pharo version. DiscOrDance is compatible with and tested on Pharo 8 only. Please create a new Pharo 8 image and try the same procedure.'.
	Transcript open.
	Transcript crLog: message.
	Error new
		messageText: message;
		signal.

]

{ #category : #actions }
BaselineOfDiscOrDance >> incompatiblePharoVersion: packageLoader [
	| message |
	message := 'Unsupported Pharo version. DiscOrDance is compatible with and tested on Pharo 8 only. Please create a new Pharo 8 image and try the same procedure.'.
	Transcript open.
	Transcript crLog: message.
	Error new
		messageText: message;
		signal.

]

{ #category : #baselines }
BaselineOfDiscOrDance >> vizor: spec [
	spec baseline: 'Vizor'
		with: [ spec repository: 'github://USIREVEAL/vizor:v1.1.0' ].

]
