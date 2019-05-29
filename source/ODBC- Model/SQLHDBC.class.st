"
A handle to a database connection
"
Class {
	#name : #SQLHDBC,
	#superclass : #ExternalStructure,
	#category : #'ODBC- Model-Structure'
}

{ #category : #accessing }
SQLHDBC class >> fields [
	" 
	SQLHDBC defineFields 
	"
	^ #(#(#value 'long') )
]

{ #category : #accessing }
SQLHDBC >> value [
	"This method was automatically generated"
	^handle signedLongAt: 1
]

{ #category : #accessing }
SQLHDBC >> value: anObject [
	"This method was automatically generated"
	handle signedLongAt: 1 put: anObject
]
