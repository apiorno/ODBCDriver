"
SQL small integer datatype
"
Class {
	#name : #SQLSmallInteger,
	#superclass : #ExternalStructure,
	#category : #'ODBC- Model-Structure'
}

{ #category : #accessing }
SQLSmallInteger class >> fields [
	"
	SQLSmallInteger defineFields
	"
	^#(
		(value 'short')
	)

]

{ #category : #accessing }
SQLSmallInteger >> value [
	"This method was automatically generated"
	^handle signedShortAt: 1
]

{ #category : #accessing }
SQLSmallInteger >> value: anObject [
	"This method was automatically generated"
	handle signedShortAt: 1 put: anObject
]
