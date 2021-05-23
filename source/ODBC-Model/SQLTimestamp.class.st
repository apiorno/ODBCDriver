"
SQL timestamp datatype
"
Class {
	#name : #SQLTimestamp,
	#superclass : #FFIStructure,
	#classVars : [
		'OFFSET_DAY',
		'OFFSET_FRACTION',
		'OFFSET_HOUR',
		'OFFSET_MINUTE',
		'OFFSET_MONTH',
		'OFFSET_SECOND',
		'OFFSET_YEAR'
	],
	#category : #'ODBC-Model-Structure'
}

{ #category : #accessing }
SQLTimestamp class >> fields [
	" 
	SQLTimestamp defineFields
	"
	^ #(#(#year 'short') #(#month 'ushort') #(#day 'ushort') #(#hour 'ushort') #(#minute 'ushort') #(#second 'ushort') #(#fraction 'ulong') )
]

{ #category : #'field definition' }
SQLTimestamp class >> fieldsDesc [ 
	^ #(
		short year;
		ushort month;
		ushort day;
		ushort hour;
		ushort minute;
		ushort second;
		ulong fraction;
		)
]

{ #category : #'accessing structure variables' }
SQLTimestamp >> day [
	"This method was automatically generated"
	^handle unsignedShortAt: OFFSET_DAY
]

{ #category : #'accessing structure variables' }
SQLTimestamp >> day: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: OFFSET_DAY put: anObject
]

{ #category : #'accessing structure variables' }
SQLTimestamp >> fraction [
	"This method was automatically generated"
	^handle platformUnsignedLongAt: OFFSET_FRACTION
]

{ #category : #'accessing structure variables' }
SQLTimestamp >> fraction: anObject [
	"This method was automatically generated"
	^handle platformUnsignedLongAt: OFFSET_FRACTION put: anObject
]

{ #category : #'accessing structure variables' }
SQLTimestamp >> hour [
	"This method was automatically generated"
	^handle unsignedShortAt: OFFSET_HOUR
]

{ #category : #'accessing structure variables' }
SQLTimestamp >> hour: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: OFFSET_HOUR put: anObject
]

{ #category : #'accessing structure variables' }
SQLTimestamp >> minute [
	"This method was automatically generated"
	^handle unsignedShortAt: OFFSET_MINUTE
]

{ #category : #'accessing structure variables' }
SQLTimestamp >> minute: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: OFFSET_MINUTE put: anObject
]

{ #category : #'accessing structure variables' }
SQLTimestamp >> month [
	"This method was automatically generated"
	^handle unsignedShortAt: OFFSET_MONTH
]

{ #category : #'accessing structure variables' }
SQLTimestamp >> month: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: OFFSET_MONTH put: anObject
]

{ #category : #'accessing structure variables' }
SQLTimestamp >> second [
	"This method was automatically generated"
	^handle unsignedShortAt: OFFSET_SECOND
]

{ #category : #'accessing structure variables' }
SQLTimestamp >> second: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: OFFSET_SECOND put: anObject
]

{ #category : #'accessing structure variables' }
SQLTimestamp >> year [
	"This method was automatically generated"
	^handle signedShortAt: OFFSET_YEAR
]

{ #category : #'accessing structure variables' }
SQLTimestamp >> year: anObject [
	"This method was automatically generated"
	handle signedShortAt: OFFSET_YEAR put: anObject
]
