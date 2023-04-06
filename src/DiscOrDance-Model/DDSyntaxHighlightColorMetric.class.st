"
I am a metric mapping syntax highlight of a CodeBlock to a specific color when possible.

I map smalltalk highlighted code to green.
I map unknown highlighted code to red.
I map no highlighting to black.
"
Class {
	#name : #DDSyntaxHighlightColorMetric,
	#superclass : #DDColorMetric,
	#category : #'DiscOrDance-Model-Metrics'
}

{ #category : #accessing }
DDSyntaxHighlightColorMetric class >> description [
	^ 'Syntax highlighting of a code block'
]

{ #category : #accessing }
DDSyntaxHighlightColorMetric class >> highlightDictionary [
	self flag: #TODO. "Maybe we can retrieve a complete list of possible syntax highlights in MarkDown or ```code blocks``` and use that to classify and map different colors in the future."
	^ Dictionary newFrom: {
		#smalltalk -> Color green .
		#st -> Color green .
		#spec -> Color lightGreen .
		#'gofer new' -> Color lightGreen .
		#'gofer it' -> Color lightGreen .

		#bash -> Color lightOrange .
		#sh -> Color lightOrange .
		#shell -> Color lightOrange .
		#'#!/bin/sh' -> Color lightOrange .
		#bat -> Color lightOrange .

		#markdown -> Color lightCyan .
		#diff -> Color lightCyan .
		#html -> Color lightCyan .
		#yaml -> Color lightCyan .
		#tex -> Color lightCyan .
		#latex -> Color lightCyan .
		
		#python -> Color lightBlue .
		#js -> Color lightBlue .
		#java -> Color lightBlue .
		#ruby -> Color lightBlue .
		#c -> Color lightBlue .
		#clojure -> Color lightBlue .
		#assembly -> Color lightBlue .
		#r -> Color lightBlue .
		#sql -> Color lightBlue .

		#none -> Color gray .
	}
]

{ #category : #accessing }
DDSyntaxHighlightColorMetric class >> selectorOrBlock [
	"If a known mapping is returned for syntaxHighlight of the CodeBlock, the corresponding color is returned. Otherwise Color magenta is returned to mark possible extensions of the mapping dictionary."
	^ [ :node | self highlightDictionary at: node syntaxHighlight ifAbsent: [ Color magenta ]. ]
]

{ #category : #accessing }
DDSyntaxHighlightColorMetric class >> shortName [
	^ 'SYNTAX_HIGHLIGHT'
]
