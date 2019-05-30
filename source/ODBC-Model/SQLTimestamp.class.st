"
SQL timestamp datatype
"
Class {
	#name : #SQLTimestamp,
	#superclass : #ExternalStructure,
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLTimestamp class >> fields [
	" 
	SQLTimestamp defineFields
	"
	^ #(#(#year 'short') #(#month 'ushort') #(#day 'ushort') #(#hour 'ushort') #(#minute 'ushort') #(#second 'ushort') #(#fraction 'ulong') )
]

{ #category : #accessing }
SQLTimestamp >> day [
	"This method was automatically generated"
	^handle unsignedShortAt: 5
]

{ #category : #accessing }
SQLTimestamp >> day: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 5 put: anObject
]

{ #category : #accessing }
SQLTimestamp >> fraction [
	"This method was automatically generated"
	^handle unsignedLongAt: 13
]

{ #category : #accessing }
SQLTimestamp >> fraction: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 13 put: anObject
]

{ #category : #accessing }
SQLTimestamp >> hour [
	"This method was automatically generated"
	^handle unsignedShortAt: 7
]

{ #category : #accessing }
SQLTimestamp >> hour: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 7 put: anObject
]

{ #category : #accessing }
SQLTimestamp >> minute [
	"This method was automatically generated"
	^handle unsignedShortAt: 9
]

{ #category : #accessing }
SQLTimestamp >> minute: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 9 put: anObject
]

{ #category : #accessing }
SQLTimestamp >> month [
	"This method was automatically generated"
	^handle unsignedShortAt: 3
]

{ #category : #accessing }
SQLTimestamp >> month: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 3 put: anObject
]

{ #category : #accessing }
SQLTimestamp >> second [
	"This method was automatically generated"
	^handle unsignedShortAt: 11
]

{ #category : #accessing }
SQLTimestamp >> second: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 11 put: anObject
]

{ #category : #accessing }
SQLTimestamp >> year [
	"This method was automatically generated"
	^handle signedShortAt: 1
]

{ #category : #accessing }
SQLTimestamp >> year: anObject [
	"This method was automatically generated"
	handle signedShortAt: 1 put: anObject
]
