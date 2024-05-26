# System-Programming-and-Administration-
Contains our todo Project for the system programming and administration course.

# Todo List Manager

A simple command-line tool for managing todo tasks.

## Design Choices

The Todo List Manager is implemented as a Bash script for simplicity and ease of use. The decision to use Bash scripting was made to ensure compatibility with most Unix-like systems without requiring any additional dependencies.

## Data Storage

Tasks are stored in a text file located at `$HOME/todo_tasks.txt`. Each task is represented by a single line in the file, with fields separated by '|'. The fields include:
- ID
- Title
- Description
- Location
- Due Date
- Due Time
- Completed

Example task format: `ID|Title|Description|Location|Due Date|Due Time|Completed`

## Code Organization

The code is organized into functions, each responsible for a specific task:
- `show_menu()`: Displays the main menu options.
- `show_help()`: Provides usage instructions for each command.
- `create_task()`: Creates a new task based on user input.
- `update_task()`: Updates an existing task based on user input.
- `list_all_tasks()`: Lists all tasks stored in the file.
- `delete_task()`: Deletes a task based on user input.
- `show_task()`: Displays detailed information about a specific task.
- `list_tasks()`: Lists tasks for a given day.
- `search_task()`: Searches for tasks by title.

## Running the Program

To run the program, execute the `todo.sh` script from the command line.

Example:
```bash
./todo.sh [command] (you can add options)

