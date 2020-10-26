# COMP2001 Coursework

This repository contains the code for both Part 1 and Part 2 of the COMP2001 coursework. 

### Part 1

A RESTful user authentication API developed in C# using the ASP.NET framework. It supports multiple HTTP methods including POST, GET, PUT, and DELETE. It doesn't have a UI.

### Part 2

A linked data application written in PHP that displays a dataset from [Plymouth DATA Place](https://plymouth.thedata.place/dataset). In this case, I have chosen [a dataset](https://plymouth.thedata.place/dataset/libraries/resource/7ca5c131-ba46-4133-ae6a-0dc8eb8a9281) in JSON format that contains the location of libraries in Plymouth. The application has three pages:

- **index.php**, which displays a link to the original data set, a link to the **data.php** page, a link to the **fetch.php** page, and the project vision.

- **data.php**, which displays the JSON data in a human readable format (in this case, an HTML table, and an optional modern card-based layout).

- **fetch.php**, which simply outputs the JSON data in a JSON-LD format. Both browsers and REST clients can use a GET request to fetch the data.
