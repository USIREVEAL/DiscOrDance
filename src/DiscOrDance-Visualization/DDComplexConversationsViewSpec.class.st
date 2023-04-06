"
I am a complex visualization for conversations.
I use DDAggregateConversationGlyph to represent conversations.
"
Class {
	#name : #DDComplexConversationsViewSpec,
	#superclass : #DDConversationsViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs-Conversations'
}

{ #category : #initialization }
DDComplexConversationsViewSpec >> initialize [
	super initialize.
	self name: 'Conversations (complex view)';
		glyphMappings:
			{ DDCategory -> DDLabeledCategoryNodeGlyph .
			DDTextChannel -> DDLabeledCategoryNodeGlyph .
			DDConversation -> DDAggregatedConversationGlyph .
			DDNextConversationEdge -> DDNextConversationEdgeGlyph }.
]
