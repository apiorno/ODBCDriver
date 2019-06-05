"
SQL handle datatype
"
Class {
	#name : #SQLHandle,
	#superclass : #FFIExternalStructure,
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLHandle class >> fields [
	" 
	SQLHANDLE defineFields
	"
	^ #(#(#value 'long') )
]

{ #category : #accessing }
SQLHandle >> value [
	"This method was automatically generated"
	^handle signedLongAt: 1
]

{ #category : #accessing }
SQLHandle >> value: anObject [
	"This method was automatically generated"
	handle signedLongAt: 1 put: anObject
]
