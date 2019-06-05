"
SQL date datatype
"
Class {
	#name : #SQLDate,
	#superclass : #FFIExternalStructure,
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLDate class >> fields [
	" 
	SQLDate defineFields
	"
	^ #(#(#year 'short') #(#month 'ushort') #(#day 'ushort') )
]

{ #category : #accessing }
SQLDate >> day [
	"This method was automatically generated"
	^handle unsignedShortAt: 5
]

{ #category : #accessing }
SQLDate >> day: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 5 put: anObject
]

{ #category : #accessing }
SQLDate >> month [
	"This method was automatically generated"
	^handle unsignedShortAt: 3
]

{ #category : #accessing }
SQLDate >> month: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 3 put: anObject
]

{ #category : #accessing }
SQLDate >> year [
	"This method was automatically generated"
	^handle signedShortAt: 1
]

{ #category : #accessing }
SQLDate >> year: anObject [
	"This method was automatically generated"
	handle signedShortAt: 1 put: anObject
]
