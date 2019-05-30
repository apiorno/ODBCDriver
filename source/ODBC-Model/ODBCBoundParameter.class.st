"
A bound parameter for an ODBC query.
"
Class {
	#name : #ODBCBoundParameter,
	#superclass : #Object,
	#instVars : [
		'data',
		'cType',
		'sqlType',
		'colWidth',
		'digits',
		'size'
	],
	#category : #'ODBC-Model-Definitions'
}

{ #category : #accessing }
ODBCBoundParameter >> cType [
	^cType
]

{ #category : #accessing }
ODBCBoundParameter >> cType: aNumber [
	cType := aNumber
]

{ #category : #accessing }
ODBCBoundParameter >> colWidth [
	^colWidth
]

{ #category : #accessing }
ODBCBoundParameter >> colWidth: aNumber [
	colWidth := aNumber
]

{ #category : #accessing }
ODBCBoundParameter >> data [
	^data
]

{ #category : #accessing }
ODBCBoundParameter >> data: anObject [
	data := anObject
]

{ #category : #accessing }
ODBCBoundParameter >> digits [
	^digits
]

{ #category : #accessing }
ODBCBoundParameter >> digits: aNumber [
	digits := aNumber
]

{ #category : #accessing }
ODBCBoundParameter >> handle [
	^data getHandle
]

{ #category : #accessing }
ODBCBoundParameter >> handle: aHandle [
	data := ExternalData fromHandle: aHandle type: ExternalType void asPointerType
]

{ #category : #initialize }
ODBCBoundParameter >> initialize [
	cType := 0.
	sqlType := 0.
	colWidth := 0.
	digits := 0.
	size := 0.
]

{ #category : #accessing }
ODBCBoundParameter >> size [
	^size
]

{ #category : #accessing }
ODBCBoundParameter >> size: aNumber [
	size := aNumber
]

{ #category : #accessing }
ODBCBoundParameter >> sqlType [
	^sqlType
]

{ #category : #accessing }
ODBCBoundParameter >> sqlType: aNumber [
	sqlType := aNumber
]
