**Here is the final result of the project**

To configure your database credentials, create a file named `.env` in the root directory of the project. You can use the provided `.env.example` as a template.

Below is the Curl command to populate the Database after the creation with the create-database-and-table.sh file located in the /app-volume directory, which will be automatically present in the container on the startup and any changes or file created in this /app-volume directory locally are instantly reflected in the container

Curl Command if executed outside of the container to populate the database

curl -X POST "http://localhost:8000/add_store/" -H "Content-Type: application/json" -d '{"name": "test_store"}'
