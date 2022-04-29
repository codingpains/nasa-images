## Problems to solve in order of priority.

1. Create a running client that can take parameters.
2. Parse the parameters in a way that can be used to feed requests to NASA Api
3. Create a NASA Api wrapper to request images from NASA. (At this point it works but not optimaly)
4. Extract all that needs to go into env variables from the code.
5. Handle fetching and input parsing errors.
6. Provide a caching mechanism with an interface such that can be replaced with any storage (Redis, Files, SQL, etc).

## Why I chose Ruby instead of Typescript or Go.

TL;DR
To save time and focus on the problem instead of the tech.

I have no significant experience writing code in Typescript or Go, I have looked into software build in those languages to triage errors, research for new features in a different service and I have done a few PR's to a repository in Typescript.
It would add no value to this project but it would have been time consuming to use them because of that. Also my local dev system has already everything to create ruby projects, reducing this overhead and allowing me to go straight to system design and coding.

## No folder structure?

Ideally I would've left just one file outside of a folder structure called client or nasa-client.
However I started having issues loading files inside of folders, I could've figured this out but in the end it would not add much value given the small size of this project.
My ideal folder structure would look like this:

```
 nasa-images
 | nasa-mars-images.rb
 | app
 | | api_error.rb
 | | image_query.rb
 | | input_parser.rb
 | | cache.rb 
 | | cache
 |   | tempfile.rb
 |   | sql.rb
 |   | redis.rb
 | nasa
 | | api
 |   | api_client.rb
 | spec
```

This structure includes files that I didn't include in the project.

## System Design
![nasa-client-system](https://user-images.githubusercontent.com/54297/165881246-126300ea-2e4e-426c-a493-d167d672d2a1.jpg)

**Bash client (nasa-mars-images.rb)** is just responsible for getting any input, send it to the input parser, use the result of that to create an image query and run it.
Spit out the result or handle an exception.

**InputParser** gets any input given as args to the client. This is the module I would spend the most time in. It will check the keys for anything missing or not allowed and validate the values are correct. e.g. `asof`is an argument that represents the date to consider as the starting point from which to look back N days, it must be validated and parsed into a time object so it can be used everywhere. This class or module is also responsible for all customization such as requesting images from other rovers, selecting the amount of days to return and even how many images per day.

**ImagesQuery** takes the input already parsed and performs a search in cache. Anything found will return directly from there, anything not present will be given to NasaApiClient to fetch.

**NasaClient** knows how to communicate with the Nasa Api given certain input. Despite the problem stating that just 3 images per day are to be requested and 10 days since a given day will be returned, this layer can be easily coded to support variables instead of hardcoded behaviour. That customization is provided by the InputParser.
