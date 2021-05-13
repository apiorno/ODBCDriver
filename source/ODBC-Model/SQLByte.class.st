"
SQL byte datatype
"
Class {
	#name : #SQLByte,
	#superclass : #FFIStructure,
	#classVars : [
		'OFFSET_VALUE'
	],
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLByte class >> fields [
	" 
	SQLChar defineFields
	"
	^ #(#(#value 'byte') )
]

{ #category : #'field definition' }
SQLByte class >> fieldsDesc [ 
	^ #(
		byte value;		
		)
]

{ #category : #'accessing structure variables' }
SQLByte >> value [
	"This method was automatically generated"
	^handle unsignedByteAt: OFFSET_VALUE
]

{ #category : #'accessing structure variables' }
SQLByte >> value: anObject [
	"This method was automatically generated"
	handle unsignedByteAt: OFFSET_VALUE put: anObject
]
