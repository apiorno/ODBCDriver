"
An error while using ODBC
"
Class {
	#name : #ODBCError,
	#superclass : #Error,
	#instVars : [
		'details'
	],
	#pools : [
		'ODBCConstants'
	],
	#category : #'ODBC-Model-Errors'
}

{ #category : #'instance creation' }
ODBCError class >> details: aCollection [
	^ self new initializeDetails: aCollection
]

{ #category : #initialization }
ODBCError >> initializeDetails: aCollection [ 
	details := aCollection.
""
	self messageText: self asString
]

{ #category : #printing }
ODBCError >> printOn: aStream [ 
	super printOn: aStream.
aStream nextPutAll: ' '.
	details
		do: [:each | aStream nextPutAll: each asString]
		separatedBy: [aStream nextPutAll: ', ']
]
