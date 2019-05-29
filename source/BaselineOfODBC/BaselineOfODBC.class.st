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
				group: 'CI' with: 'Tests';
				group: 'Development' with: #('Tests') ]
]

{ #category : #baseline }
BaselineOfODBC >> baselineODBC: spec [

	spec
		package: 'ODBC';
		group: 'Deployment' with: #('ODBC')
]

{ #category : #baseline }
BaselineOfODBC >> setUpDependencies: spec [

	"Nothing by now"

	
]
