"
A handle to an ODBC environment 
"
Class {
	#name : #SQLHENV,
	#superclass : #ExternalStructure,
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLHENV class >> fields [
	" 
	SQLHENV defineFields 
	"
	^ #(#(#value 'long') )
]

{ #category : #accessing }
SQLHENV >> value [
	"This method was automatically generated"
	^handle signedLongAt: 1
]

{ #category : #accessing }
SQLHENV >> value: anObject [
	"This method was automatically generated"
	handle signedLongAt: 1 put: anObject
]
