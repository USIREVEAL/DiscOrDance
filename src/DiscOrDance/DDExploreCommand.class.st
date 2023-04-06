"
I am an explore command to explore different versions of the same model.
"
Class {
	#name : #DDExploreCommand,
	#superclass : #DDServerCommand,
	#category : #'DiscOrDance-Commands'
}

{ #category : #execution }
DDExploreCommand >> execute [
	DDVisualization new loadModel: self modelType forServer: self serverName; open.
]

{ #category : #'private - utility' }
DDExploreCommand >> modelType [
	self subclassResponsibility.
]
