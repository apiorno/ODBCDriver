"
I represent the structure of the ODBC Driver project.

I load the packages of the project and its dependencies.

Public API and Key Messages

- baseline: aSpec
"
Class {
	#name : #BaselineOfODBC,
	#superclass : #BaselineOf,
	#category : #BaselineOfODBC
}

{ #category : #baseline }
BaselineOfODBC >> baseline: spec [

	<baseline>

	spec
		for: #pharo
		do: [ self
				setUpDependencies: spec;
				baselineODBC: spec.
			spec
				group: 'Deployment' with: 'Model';
				group: 'CI' with: 'Tests';
				group: 'Development' with: 'Tests' ]
]

{ #category : #baseline }
BaselineOfODBC >> baselineODBC: spec [

	spec
		package: 'ODBC-Model';
		group: 'Model' with: 'ODBC-Model';
		group: 'Tests' with: 'Model'
]

{ #category : #baseline }
BaselineOfODBC >> setUpDependencies: spec [

	"Nothing by now"

	
]
