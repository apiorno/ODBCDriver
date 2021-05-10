"
SQL short datatype
"
Class {
	#name : #SQLShort,
	#superclass : #FFIStructure,
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLShort class >> fields [
	" 
	SQLShort defineFields
	"
	^ #(#(#value 'short') )
]

{ #category : #accessing }
SQLShort >> value [
	"This method was automatically generated"
	^handle signedShortAt: 1
]

{ #category : #accessing }
SQLShort >> value: anObject [
	"This method was automatically generated"
	handle signedShortAt: 1 put: anObject
]
