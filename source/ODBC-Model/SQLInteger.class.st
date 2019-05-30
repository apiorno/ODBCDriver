"
SQL integer datatype
"
Class {
	#name : #SQLInteger,
	#superclass : #ExternalStructure,
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLInteger class >> fields [
	" 
	SQLInteger defineFields 
	"
	^ #(#(#value 'long') )
]

{ #category : #accessing }
SQLInteger >> value [
	"This method was automatically generated"
	^handle signedLongAt: 1
]

{ #category : #accessing }
SQLInteger >> value: anObject [
	"This method was automatically generated"
	handle signedLongAt: 1 put: anObject
]
