"
A handle to a statement
"
Class {
	#name : #SQLHSTMT,
	#superclass : #FFIStructure,
	#classVars : [
		'OFFSET_VALUE'
	],
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLHSTMT class >> fields [
	" 
	SQLHSTMT defineFields
	"
	^ #(#(#value 'long') )
]

{ #category : #'field definition' }
SQLHSTMT class >> fieldsDesc [ 
	^ #(
		void * value;
		)
]

{ #category : #'accessing structure variables' }
SQLHSTMT >> value [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_VALUE) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
SQLHSTMT >> value: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_VALUE put: anObject getHandle.
]
