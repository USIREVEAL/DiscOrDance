"
A DDMessageTest is a test class for testing the behavior of DDMessage
"
Class {
	#name : #DDMessageTest,
	#superclass : #TestCase,
	#category : #'DiscOrDance-Model-Tests'
}

{ #category : #test }
DDMessageTest >> testQuotes [
	| msg expected |
	msg := DDMessage new.
	expected := {
	'> this is a quote' .
	'> this another' .
	'> some larger' , String cr , '> quoted text' , String cr , '> with multilines'
	} asOrderedCollection.
	msg content:
'

>notquote
> this is a quote
test

text > with this
> this another
>> some

> some larger
> quoted text
> with multilines
>>>dunno

somefinaltext'.
	
	self assertCollection: msg quotes equals: expected.
]
