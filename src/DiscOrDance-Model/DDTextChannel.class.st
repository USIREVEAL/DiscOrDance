"
I am a text channel.

I contain text messages.
"
Class {
	#name : #DDTextChannel,
	#superclass : #DDChannel,
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #accessing }
DDTextChannel >> getMessagesByAuthor [
	"Return the number of messages sent in the channel by each author."
	| count |
	
	count := Bag new.
	count addAll: (messages collect: [ :eachMessage | eachMessage author uniqueName]).
	^ count.
]

{ #category : #testing }
DDTextChannel >> isTextChannel [
	^ true.
]
