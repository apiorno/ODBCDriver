"
SQL unsigned integer datatype
"
Class {
	#name : #SQLUInteger,
	#superclass : #ExternalStructure,
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLUInteger class >> fields [
	" 
	SQLUInteger defineFields
	"
	^ #(#(#value 'ulong') )
]

{ #category : #accessing }
SQLUInteger >> value [
	"This method was automatically generated"
	^handle unsignedLongAt: 1
]

{ #category : #accessing }
SQLUInteger >> value: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
]
