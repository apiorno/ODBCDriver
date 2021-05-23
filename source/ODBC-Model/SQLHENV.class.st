"
A handle to an ODBC environment 
"
Class {
	#name : #SQLHENV,
	#superclass : #FFIStructure,
	#classVars : [
		'OFFSET_VALUE'
	],
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLHENV class >> fields [
	" 
	SQLHENV defineFields 
	"
	^ #(#(#value 'long') )
]

{ #category : #'as yet unclassified' }
SQLHENV class >> fieldsDesc [
	^ #(
		void * value;
		)
]

{ #category : #'accessing structure variables' }
SQLHENV >> value [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_VALUE) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
SQLHENV >> value: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_VALUE put: anObject getHandle.
]
