"
I am the root component for DiscOrDance Presenter hierarchy.
"
Class {
	#name : #DDComponentPresenter,
	#superclass : #SpPresenter,
	#category : #'DiscOrDance-Visualization-Presenters'
}

{ #category : #specs }
DDComponentPresenter class >> defaultLayout [
	^ self subclassResponsibility.
]

{ #category : #specs }
DDComponentPresenter class >> defaultSpec [
	^ self defaultLayout
]
