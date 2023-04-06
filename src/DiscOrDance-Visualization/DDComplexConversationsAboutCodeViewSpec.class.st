"
I am a view spec showing conversations involving source code.
"
Class {
	#name : #DDComplexConversationsAboutCodeViewSpec,
	#superclass : #DDComplexConversationsViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs-Conversations'
}

{ #category : #initialization }
DDComplexConversationsAboutCodeViewSpec >> initialize [
	super initialize.
	self name: 'Conversations (complex view) - About Source Code';
		layoutClass: RSFlowLayout;
		entityClasses: { DDConversation } asSet;
		entityFilter: [ :entities | | conversations others |
			others := entities reject: [ :each | each isKindOf: DDConversation ].
			conversations := entities select: [ :each |
				(each isKindOf: DDConversation) and: [ each involvesCode ] ].
			(conversations , others)
		];
		sortingBlock: [ :entities | | others conversations |
			others := entities reject: [ :each | each isKindOf: DDConversation].
			conversations := DDConversation timeSorted: (entities select: [ :each | (each isKindOf: DDConversation) and: [ each messages size > 0 ] ]).
			(conversations , others) ].
]
