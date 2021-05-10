"
SQL float datatype
"
Class {
	#name : #SQLFloat,
	#superclass : #FFIStructure,
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLFloat class >> fields [
	" 
	SQLFloat defineFields
	"
	^ #(#(#value 'float') )
]

{ #category : #accessing }
SQLFloat >> value [
	"This method was automatically generated"
	^handle floatAt: 1
]

{ #category : #accessing }
SQLFloat >> value: anObject [
	"This method was automatically generated"
	handle floatAt: 1 put: anObject
]
