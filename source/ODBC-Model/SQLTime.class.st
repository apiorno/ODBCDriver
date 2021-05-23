"
SQL time datatype
"
Class {
	#name : #SQLTime,
	#superclass : #FFIStructure,
	#classVars : [
		'OFFSET_HOUR',
		'OFFSET_MINUTE',
		'OFFSET_SECOND'
	],
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLTime class >> fields [
	" 
	SQLTime defineFields
	"
	^ #(#(#hour 'ushort') #(#minute 'ushort') #(#second 'ushort') )
]

{ #category : #'field definition' }
SQLTime class >> fieldsDesc [ 
	^ #(
		ushort hour;
		ushort minute;
		ushort second;
		)
]

{ #category : #'accessing structure variables' }
SQLTime >> hour [
	"This method was automatically generated"
	^handle unsignedShortAt: OFFSET_HOUR
]

{ #category : #'accessing structure variables' }
SQLTime >> hour: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: OFFSET_HOUR put: anObject
]

{ #category : #'accessing structure variables' }
SQLTime >> minute [
	"This method was automatically generated"
	^handle unsignedShortAt: OFFSET_MINUTE
]

{ #category : #'accessing structure variables' }
SQLTime >> minute: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: OFFSET_MINUTE put: anObject
]

{ #category : #'accessing structure variables' }
SQLTime >> second [
	"This method was automatically generated"
	^handle unsignedShortAt: OFFSET_SECOND
]

{ #category : #'accessing structure variables' }
SQLTime >> second: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: OFFSET_SECOND put: anObject
]
