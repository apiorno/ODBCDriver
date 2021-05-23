"
A handle to a database connection
"
Class {
	#name : #SQLHDBC,
	#superclass : #FFIStructure,
	#classVars : [
		'OFFSET_VALUE'
	],
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLHDBC class >> fields [
	" 
	SQLHDBC defineFields 
	"
	^ #(#(#value 'long') )
]

{ #category : #'as yet unclassified' }
SQLHDBC class >> fieldsDesc [
	^ #(
		void * value;
		)
]

{ #category : #'accessing structure variables' }
SQLHDBC >> value [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_VALUE) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
SQLHDBC >> value: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_VALUE put: anObject getHandle.
]
