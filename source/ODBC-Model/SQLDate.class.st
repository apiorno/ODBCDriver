"
SQL date datatype
"
Class {
	#name : #SQLDate,
	#superclass : #FFIStructure,
	#classVars : [
		'OFFSET_DAY',
		'OFFSET_MONTH',
		'OFFSET_YEAR'
	],
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLDate class >> fields [
	" 
	SQLDate defineFields
	"
	^ #(#(#year 'short') #(#month 'ushort') #(#day 'ushort') )
]

{ #category : #'field definition' }
SQLDate class >> fieldsDesc [ 
	^ #(
		short year;
		ushort month;
		ushort day;
		)
]

{ #category : #'accessing structure variables' }
SQLDate >> day [
	"This method was automatically generated"
	^handle unsignedShortAt: OFFSET_DAY
]

{ #category : #'accessing structure variables' }
SQLDate >> day: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: OFFSET_DAY put: anObject
]

{ #category : #'accessing structure variables' }
SQLDate >> month [
	"This method was automatically generated"
	^handle unsignedShortAt: OFFSET_MONTH
]

{ #category : #'accessing structure variables' }
SQLDate >> month: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: OFFSET_MONTH put: anObject
]

{ #category : #'accessing structure variables' }
SQLDate >> year [
	"This method was automatically generated"
	^handle signedShortAt: OFFSET_YEAR
]

{ #category : #'accessing structure variables' }
SQLDate >> year: anObject [
	"This method was automatically generated"
	handle signedShortAt: OFFSET_YEAR put: anObject
]
