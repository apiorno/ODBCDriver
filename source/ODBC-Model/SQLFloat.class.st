"
SQL float datatype
"
Class {
	#name : #SQLFloat,
	#superclass : #FFIStructure,
	#classVars : [
		'OFFSET_VALUE'
	],
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLFloat class >> fields [
	" 
	SQLFloat defineFields
	"
	^ #(#(#value 'float') )
]

{ #category : #'field definition' }
SQLFloat class >> fieldsDesc [ 
	^ #(
		float value;
		)
]

{ #category : #'accessing structure variables' }
SQLFloat >> value [
	"This method was automatically generated"
	^handle floatAt: OFFSET_VALUE
]

{ #category : #'accessing structure variables' }
SQLFloat >> value: anObject [
	"This method was automatically generated"
	handle floatAt: OFFSET_VALUE put: anObject
]
