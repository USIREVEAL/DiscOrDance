"
I am an attachment sent on a Discord channel.

I have a name, a size and an url to retrieve the actual file data.

When scraping the actual data is not retrieved (for space performance reasons) but they're available in the original DSAttachnemt and can be retrieved from the url anyways.
"
Class {
	#name : #DDAttachment,
	#superclass : #DDNode,
	#instVars : [
		'id',
		'url',
		'proxyUrl',
		'fileName',
		'fileSize'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #initialization }
DDAttachment class >> createFromDS: aDSAttachment [
	| newAttachment |
	newAttachment := self new.
	newAttachment id: aDSAttachment id.
	newAttachment fileName: aDSAttachment filename.
	newAttachment fileSize: aDSAttachment fileSize.
	newAttachment url: aDSAttachment url.
	newAttachment proxyUrl: aDSAttachment proxyUrl.
	^ newAttachment.

]

{ #category : #converting }
DDAttachment >> asJSON [
	^ String streamContents: [ :stream |
		(NeoJSONWriter on: stream)
			prettyPrint: true;
			nextPut: self asJSONDictionary
	].
]

{ #category : #converting }
DDAttachment >> asJSONDictionary [
	^ {
		#url -> self url }
		asDictionary
]

{ #category : #accessing }
DDAttachment >> fileName [
	^ fileName
]

{ #category : #accessing }
DDAttachment >> fileName: anObject [
	fileName := anObject
]

{ #category : #accessing }
DDAttachment >> fileSize [
	^ fileSize
]

{ #category : #accessing }
DDAttachment >> fileSize: anObject [
	fileSize := anObject
]

{ #category : #accessing }
DDAttachment >> id [
	^ id
]

{ #category : #accessing }
DDAttachment >> id: anObject [
	id := anObject
]

{ #category : #printing }
DDAttachment >> printOn: aStream [
	aStream << 'Attachment: ' << self fileName asString.
]

{ #category : #accessing }
DDAttachment >> proxyUrl [
	^ proxyUrl
]

{ #category : #accessing }
DDAttachment >> proxyUrl: anObject [
	proxyUrl := anObject
]

{ #category : #accessing }
DDAttachment >> url [
	^ url
]

{ #category : #accessing }
DDAttachment >> url: anObject [
	url := anObject
]
