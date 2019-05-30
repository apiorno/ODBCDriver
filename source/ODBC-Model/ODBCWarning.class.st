"
An ODBC warning
"
Class {
	#name : #ODBCWarning,
	#superclass : #Notification,
	#instVars : [
		'details'
	],
	#pools : [
		'ODBCConstants'
	],
	#category : #'ODBC-Model-Errors'
}

{ #category : #'instance creation' }
ODBCWarning class >> details: aCollection [ 
	^ self new initializeDetails: aCollection
]

{ #category : #printing }
ODBCWarning >> defaultAction [
	self debug
]

{ #category : #initialization }
ODBCWarning >> initializeDetails: aCollection [ 
	details := aCollection.
	""
	self messageText: self asString
]

{ #category : #printing }
ODBCWarning >> printOn: aStream [ 
	super printOn: aStream.
	aStream nextPutAll: ' '.
	details
		do: [:each | aStream nextPutAll: each asString]
		separatedBy: [aStream nextPutAll: ', ']
]
