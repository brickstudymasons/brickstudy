Brickmasons notes (for maintainers of library):

Brain data pipeline:

	We use Freesurfer version 6.0. 
	More details coming

Release steps:
	Releases are made with a normal procedure, but with extra care as there is a notebook filter.
	Steps: 	
			0. ```git branch```, then always get on the main
			1. ```git checkout main```, 
			2. ```git pull``` , (on the main pull)
			3. ```git tag v0.0.x``` (use semantic versioning)
			4. ```git push tags````
			5. Here you can work from browser/Github interface for release, but we suggest using git
			6. If there is a problem, releases can be deleted via Github interface
			7. note the CI creates a main you did not push (filtering), so always pull again

