"
SQL short datatype
"
Class {
	#name : #SQLShort,
	#superclass : #FFIStructure,
	#classVars : [
		'OFFSET_VALUE'
	],
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLShort class >> fields [
	" 
	SQLShort defineFields
	"
	^ #(#(#value 'short') )
]

{ #category : #'field definition' }
SQLShort class >> fieldsDesc [ 
	^ #(
		short value;
		)
]

{ #category : #'accessing structure variables' }
SQLShort >> value [
	"This method was automatically generated"
	^handle signedShortAt: OFFSET_VALUE
]

{ #category : #'accessing structure variables' }
SQLShort >> value: anObject [
	"This method was automatically generated"
	handle signedShortAt: OFFSET_VALUE put: anObject
]
