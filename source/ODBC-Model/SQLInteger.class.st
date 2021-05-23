"
SQL integer datatype
"
Class {
	#name : #SQLInteger,
	#superclass : #FFIStructure,
	#classVars : [
		'OFFSET_VALUE'
	],
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLInteger class >> fields [
	" 
	SQLInteger defineFields 
	"
	^ #(#(#value 'long') )
]

{ #category : #'field definition' }
SQLInteger class >> fieldsDesc [ 
	^ #(
		long value;
		)
]

{ #category : #'accessing structure variables' }
SQLInteger >> value [
	"This method was automatically generated"
	^handle platformLongAt: OFFSET_VALUE
]

{ #category : #'accessing structure variables' }
SQLInteger >> value: anObject [
	"This method was automatically generated"
	^handle platformLongAt: OFFSET_VALUE put: anObject
]
