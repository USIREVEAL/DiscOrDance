"
I am a voice channel.
"
Class {
	#name : #DDVoiceChannel,
	#superclass : #DDChannel,
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #testing }
DDVoiceChannel >> isTextChannel [
	^ false.
]
