"
I am a view spec showing conversations.
"
Class {
	#name : #DDConversationsViewSpec,
	#superclass : #DDViewSpec,
	#category : #'DiscOrDance-Visualization-ViewSpecs-Conversations'
}

{ #category : #initialization }
DDConversationsViewSpec >> initialize [
	super initialize.
	self name: 'Conversations';
		layoutClass: RSHorizontalTreeLayout;
		entityClasses:
			{ DDTextChannel . DDCategory . DDStructuralEdge . DDConversation . DDNextConversationEdge } asSet;
		glyphMappings:
			{ DDCategory -> DDLabeledCategoryNodeGlyph .
			DDTextChannel -> DDLabeledCategoryNodeGlyph .
			DDConversation -> DDConversationGlyph .
			DDNextConversationEdge -> DDNextConversationEdgeGlyph }.
]
