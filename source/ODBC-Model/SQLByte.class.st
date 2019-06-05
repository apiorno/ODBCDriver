"
SQL byte datatype
"
Class {
	#name : #SQLByte,
	#superclass : #FFIExternalStructure,
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLByte class >> fields [
	" 
	SQLChar defineFields
	"
	^ #(#(#value 'byte') )
]

{ #category : #accessing }
SQLByte >> value [
	"This method was automatically generated"
	^handle unsignedByteAt: 1
]

{ #category : #accessing }
SQLByte >> value: anObject [
	"This method was automatically generated"
	handle unsignedByteAt: 1 put: anObject
]
