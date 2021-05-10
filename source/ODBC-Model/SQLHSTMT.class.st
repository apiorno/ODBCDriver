"
A handle to a statement
"
Class {
	#name : #SQLHSTMT,
	#superclass : #FFIStructure,
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLHSTMT class >> fields [
	" 
	SQLHSTMT defineFields
	"
	^ #(#(#value 'long') )
]

{ #category : #accessing }
SQLHSTMT >> value [
	"This method was automatically generated"
	^handle signedLongAt: 1
]

{ #category : #accessing }
SQLHSTMT >> value: anObject [
	"This method was automatically generated"
	handle signedLongAt: 1 put: anObject
]
