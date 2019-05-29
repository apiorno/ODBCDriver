"
SQL time datatype
"
Class {
	#name : #SQLTime,
	#superclass : #ExternalStructure,
	#category : #'ODBC- Model-Structure'
}

{ #category : #accessing }
SQLTime class >> fields [
	" 
	SQLTime defineFields
	"
	^ #(#(#hour 'ushort') #(#minute 'ushort') #(#second 'ushort') )
]

{ #category : #accessing }
SQLTime >> hour [
	"This method was automatically generated"
	^handle unsignedShortAt: 1
]

{ #category : #accessing }
SQLTime >> hour: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 1 put: anObject
]

{ #category : #accessing }
SQLTime >> minute [
	"This method was automatically generated"
	^handle unsignedShortAt: 3
]

{ #category : #accessing }
SQLTime >> minute: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 3 put: anObject
]

{ #category : #accessing }
SQLTime >> second [
	"This method was automatically generated"
	^handle unsignedShortAt: 5
]

{ #category : #accessing }
SQLTime >> second: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 5 put: anObject
]
