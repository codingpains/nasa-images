## Problems to solve in order of priority.

1. Create a running client that can take parameters.
2. Parse the parameters in a way that can be used to feed requests to NASA Api
3. Create a NASA Api wrapper to request images from NASA. (At this point it works but not optimaly)
4. Extract all that needs to go into env variables from the code.
5. Handle fetching and input parsing errors.
6. Provide a caching mechanism with an interface such that can be replaced with any storage (Redis, Files, SQL, etc).

## Why choose Ruby instead of Typescript or Go.

I have no significant experience writing code in Typescript or Go, I have looked into software build in those languages to triage errors, research for new features in a different service and I have done a few PR's to a repository in Typescript.
It would add no value to this project but it would have been time consuming to use them because of that. Also my local dev system has already everything to create ruby projects, reducing this overhead and allowing me to go straight to system design and coding.
