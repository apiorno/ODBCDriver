"
SQL unsigned integer datatype
"
Class {
	#name : #SQLUInteger,
	#superclass : #FFIStructure,
	#classVars : [
		'OFFSET_VALUE'
	],
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLUInteger class >> fields [
	" 
	SQLUInteger defineFields
	"
	^ #(#(#value 'ulong') )
]

{ #category : #'field definition' }
SQLUInteger class >> fieldsDesc [ 
	^ #(
		ulong value;
		)
]

{ #category : #'accessing structure variables' }
SQLUInteger >> value [
	"This method was automatically generated"
	^handle platformUnsignedLongAt: OFFSET_VALUE
]

{ #category : #'accessing structure variables' }
SQLUInteger >> value: anObject [
	"This method was automatically generated"
	^handle platformUnsignedLongAt: OFFSET_VALUE put: anObject
]
