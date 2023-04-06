"
I am a domain related to a DDServer.

I store information to better access, use, elaborate information inside a Discord Server.

For example, I know the language and language features to use when parsing conversations in a server (e.g., stopwords).
"
Class {
	#name : #DDDomain,
	#superclass : #DDNode,
	#instVars : [
		'language',
		'stopwords',
		'punctuation'
	],
	#category : #'DiscOrDance-Model-Base'
}

{ #category : #running }
DDDomain class >> defaultLanguage [
	^ 'english'
]

{ #category : #running }
DDDomain class >> defaultPunctuation [
	^ { '!' . '"' . '#' . '$' . '%' . '&' . '\' . '''' . '(' . ')' . '*' . '+' . ',' . '-' . '.' . '/' . ':' . ';' . '<' . '=' . '>' . '?' . '@' . '[' . '\' . '\' . ']' . '^' . '_' . '`' . '{' . '|' . '}' . '~' . '```' }
]

{ #category : #running }
DDDomain class >> defaultStopwords [
	^ { 'been' . 'its' . 've' . 'these'. 'further'. 'it'. 'few'. 'don''t' . 'isn''t'. 'more'. 'weren'. 'wouldn''t'. 'theirs'. 'until'. 'his'. 'from'. 'the'. 'had'. 'are'. 'because'. 'when'. 'an'. 'haven'. 'o'. 'shan''t'. 'me'. 'hers'. 'both'. 'doing'. 'm'. 'mustn''t'. 'him'. 'd'. 'if'. 'should'. 'mustn'. 'such'. 'am'. 'over'. 'and'. 'that'. 'my'. 't'. 'that''ll'. 'very'. 'shouldn''t'. 'shan'. 'you''ll'. 'don'. 'won''t'. 'out'. 'on'. 'there'. 'couldn'. 'up'. 'should''ve'. 'those'. 'itself'. 'into'. 'only'. 'other'. 'off'. 'being'. 'this'. 'her'. 'below'. 'where'. 'just'. 's'. 'you''ve'. 'here'. 'to'. 'too'. 'were'. 'each'. 'about'. 'between'. 'hasn'. 'or'. 'wasn'. 'after'. 'of'. 'ain'. 'aren'. 'weren''t'. 'nor'. 'which'. 'under'. 'needn''t'. 'ma'. 'aren''t'. 'myself'. 'hadn'. 'why'. 'didn'. 'does'. 'no'. 'hasn''t'. 'above'. 'at'. 'while'. 'having'. 'not'. 'doesn''t'. 'you'. 'do'. 'so'. 'she'. 'own'. 'was'. 'again'. 'all'. 'yourselves'. 'doesn'. 'he'. 'their'. 'have'. 'wouldn'. 'be'. 'ourselves'. 'couldn''t'. 'didn''t'. 'once'. 'in'. 'haven''t'. 'same'. 'now'. 'what'. 'some'. 'we'. 'any'. 'himself'. 'before'. 'through'. 'has'. 'your'. 'needn'. 'against'. 'i'. 'ours'. 'you''re'. 'will'. 'for'. 'wasn''t'. 'them'. 'during'. 'you''d'. 'with'. 'who'. 'll'. 'can'. 'a'. 'then'. 'won'. 'most'. 'than'. 'by'. 'yours'. 'she''s'. 'yourself'. 're'. 'is'. 'how'. 'y'. 'herself'. 'as'. 'isn'. 'mightn'. 'did'. 'but'. 'it''s'. 'whom'. 'hadn''t'. 'they'. 'shouldn'. 'themselves'. 'our'. 'mightn''t'. 'down' . 'i''m' . 'would' . '`[[[source_code]]]`' . '```[[[source_code]]]```' }
]

{ #category : #accessing }
DDDomain >> language [
	^ language ifNil: [ self class defaultLanguage ]
]

{ #category : #accessing }
DDDomain >> language: aString [
	language := aString
]

{ #category : #accessing }
DDDomain >> punctuation [
	^ punctuation ifNil: [ self class defaultPunctuation ]
]

{ #category : #accessing }
DDDomain >> punctuation: anArrayOfStrings [
	punctuation := anArrayOfStrings
]

{ #category : #accessing }
DDDomain >> stopwords [
	^ stopwords ifNil: [ self class defaultStopwords ]
]

{ #category : #accessing }
DDDomain >> stopwords: anArrayOfStrings [
	stopwords := anArrayOfStrings
]
