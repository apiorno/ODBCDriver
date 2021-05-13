"
SQL double datatype
"
Class {
	#name : #SQLDouble,
	#superclass : #FFIStructure,
	#classVars : [
		'OFFSET_VALUE'
	],
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLDouble class >> fields [
	" 
	SQLDouble defineFields
	"
	^ #(#(#value 'double') )
]

{ #category : #'field definition' }
SQLDouble class >> fieldsDesc [ 
	^ #(
		double value;
		)
]

{ #category : #'accessing structure variables' }
SQLDouble >> value [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_VALUE
]

{ #category : #'accessing structure variables' }
SQLDouble >> value: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_VALUE put: anObject
]
