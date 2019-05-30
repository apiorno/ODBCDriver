"
SQL double datatype
"
Class {
	#name : #SQLDouble,
	#superclass : #ExternalStructure,
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLDouble class >> fields [
	" 
	SQLDouble defineFields
	"
	^ #(#(#value 'double') )
]

{ #category : #accessing }
SQLDouble >> value [
	"This method was automatically generated"
	^handle doubleAt: 1
]

{ #category : #accessing }
SQLDouble >> value: anObject [
	"This method was automatically generated"
	handle doubleAt: 1 put: anObject
]
