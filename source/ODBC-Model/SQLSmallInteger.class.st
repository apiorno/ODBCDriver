"
SQL small integer datatype
"
Class {
	#name : #SQLSmallInteger,
	#superclass : #FFIStructure,
	#classVars : [
		'OFFSET_VALUE'
	],
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLSmallInteger class >> fields [
	"
	SQLSmallInteger defineFields
	"
	^#(
		(value 'short')
	)

]

{ #category : #'field definition' }
SQLSmallInteger class >> fieldsDesc [ 
	^ #(
		short value;
		)
]

{ #category : #'accessing structure variables' }
SQLSmallInteger >> value [
	"This method was automatically generated"
	^handle signedShortAt: OFFSET_VALUE
]

{ #category : #'accessing structure variables' }
SQLSmallInteger >> value: anObject [
	"This method was automatically generated"
	handle signedShortAt: OFFSET_VALUE put: anObject
]
