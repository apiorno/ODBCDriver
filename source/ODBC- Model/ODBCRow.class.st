"
A row returned from a database query
"
Class {
	#name : #ODBCRow,
	#superclass : #IdentityDictionary,
	#pools : [
		'ODBCConstants'
	],
	#category : #'ODBC- Model-Definitions'
}

{ #category : #'error handling' }
ODBCRow >> doesNotUnderstand: aMessage [ 
	| originalSelector |
	originalSelector := aMessage selector.
	originalSelector isUnary ifFalse: [ ^ super doesNotUnderstand: aMessage ].
	{ 
		originalSelector.	"Camel case"
		(originalSelector capitalized)	"Pascal case"
	 } do: 
		[ :each | 
		self 
			at: each asSymbol
			ifPresent: [ :val | ^ val ] ].
	^ super doesNotUnderstand: aMessage
]

{ #category : #printing }
ODBCRow >> printOn: aStream withColumnDefinitions: aList [ 
	aList do: 
		[ :each | 
		aStream nextPutAll: (ODBCResultTable 
				formatItem: (self at: each key name) asString
				toWidth: each value) ]
]
