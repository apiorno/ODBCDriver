"
A parameter description for ODBC
"
Class {
	#name : #ODBCParamDescription,
	#superclass : #Object,
	#instVars : [
		'dataType',
		'paramSize',
		'digits',
		'nullable'
	],
	#category : #'ODBC-Model-Definitions'
}

{ #category : #accessing }
ODBCParamDescription >> dataType [
	"The SQL data type associated with the parameter"
	^dataType
]

{ #category : #accessing }
ODBCParamDescription >> dataType: anInteger [
	"The SQL data type associated with the parameter"
	dataType := anInteger
]

{ #category : #accessing }
ODBCParamDescription >> digits [
	"The number of relevant digits for the parameter"
	^digits
]

{ #category : #accessing }
ODBCParamDescription >> digits: anInteger [
	"The number of relevant digits for the parameter"
	digits := anInteger
]

{ #category : #accessing }
ODBCParamDescription >> nullable [
	"Whether the parameter can be NULL"
	^nullable
]

{ #category : #accessing }
ODBCParamDescription >> nullable: aBool [
	"Whether the parameter can be NULL"
	nullable := aBool
]

{ #category : #accessing }
ODBCParamDescription >> paramSize [
	"The size of the parameter"
	^paramSize
]

{ #category : #accessing }
ODBCParamDescription >> paramSize: anInteger [
	"The size of the parameter"
	paramSize := anInteger
]
