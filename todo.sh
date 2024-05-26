#!/bin/bash

# File to store tasks
TODO_FILE="$HOME/todo_tasks.txt"

# Function to show the menu
show_menu() {
    echo "Todo List Manager"
    echo "1. Create a task"
    echo "2. Update a task"
    echo "3. Delete a task"
    echo "4. Show task information"
    echo "5. List tasks of a given day"
    echo "6. Search for a task by title"
    echo "7. List all tasks"
    echo "8. Exit"
}

# Function to show help
show_help() {
    case $1 in
        create)
            echo "Usage: todo create"
            echo "Prompts the user to create a new task with a title and due date (required), and optional description, location, and due time."
            ;;
        update)
            echo "Usage: todo update"
            echo "Prompts the user to update an existing task. The user must enter the task ID."
            echo "The current values are displayed, and the user can press Enter to keep them unchanged."
            ;;
        delete)
            echo "Usage: todo delete"
            echo "Prompts the user to delete an existing task. The user must enter the task ID."
            ;;
        show)
            echo "Usage: todo show"
            echo "Prompts the user to enter a task ID and displays all information about the task."
            ;;
        list)
            echo "Usage: todo list"
            echo "Prompts the user to enter a date (YYYY-MM-DD) and lists all tasks for that date, divided into completed and uncompleted sections."
            ;;
        search)
            echo "Usage: todo search"
            echo "Prompts the user to enter a title and searches for tasks matching that title."
            ;;
        listall)
            echo "Usage: todo listall"
            echo "List all tasks"
            ;;
        *)
            echo "Todo List Manager"
            echo "Available commands:"
            echo "  create   - Create a new task"
            echo "  update   - Update an existing task"
            echo "  delete   - Delete a task"
            echo "  show     - Show information about a task"
            echo "  list     - List tasks for a given day"
            echo "  search   - Search for a task by title"
            echo "  listall  - List all tasks"
            echo "  help     - Show help for a command"
            ;;
    esac
}

# Function to create a new task
create_task() {
    echo "Creating a new task..."
    read -p "Title (required): " title
    if [ -z "$title" ]; then
        echo "Title is required." >&2
        return
    fi

    read -p "Description: " description
    read -p "Location: " location
    read -p "Due date (YYYY-MM-DD) (required): " due_date
    if ! date -d "$due_date" &>/dev/null; then
        echo "Invalid due date format." >&2
        return
    fi
    read -p "Due time (HH:MM): " due_time
    read -p "Completed (yes/no): " completed

    id=$(date +%s)
    echo "$id|$title|$description|$location|$due_date|$due_time|$completed" >> $TODO_FILE
    echo "Task created with ID: $id"
}

# Function to update an existing task
update_task() {
    echo "Listing all tasks..."
    list_all_tasks

    read -p "Enter task ID to update: " task_id
    task=$(grep "^$task_id|" $TODO_FILE)
    if [ -z "$task" ]; then
        echo "Task ID not found." >&2
        return
    fi

    IFS='|' read -r id title description location due_date due_time completed <<< "$task"
    echo "Current values (press Enter to keep unchanged):"
    read -p "Title [$title]: " new_title
    read -p "Description [$description]: " new_description
    read -p "Location [$location]: " new_location
    read -p "Due date [$due_date] (YYYY-MM-DD): " new_due_date
    read -p "Due time [$due_time] (HH:MM): " new_due_time
    read -p "Completed [$completed] (yes/no): " new_completed

    new_title=${new_title:-$title}
    new_description=${new_description:-$description}
    new_location=${new_location:-$location}
    new_due_date=${new_due_date:-$due_date}
    new_due_time=${new_due_time:-$due_time}
    new_completed=${new_completed:-$completed}

    sed -i "/^$task_id|/c\\$task_id|$new_title|$new_description|$new_location|$new_due_date|$new_due_time|$new_completed" $TODO_FILE
    echo "Task updated."
}

# Function to list all tasks
list_all_tasks() {
    echo "ID|Title|Description|Location|Due Date|Due Time|Completed"
    cat $TODO_FILE
}

# Function to delete a task
delete_task() {
    read -p "Enter task ID to delete: " task_id
    if ! grep -q "^$task_id|" $TODO_FILE; then
        echo "Task ID not found." >&2
        return
    fi
    sed -i "/^$task_id|/d" $TODO_FILE
        echo "Task deleted."
}

# Function to show task information
show_task() {
    read -p "Enter task ID to show: " task_id
    task=$(grep "^$task_id|" $TODO_FILE)
    if [ -z "$task" ]; then
        echo "Task ID not found." >&2
        return
    fi
    IFS='|' read -r id title description location due_date due_time completed <<< "$task"
    echo "ID: $id"
    echo "Title: $title"
    echo "Description: $description"
    echo "Location: $location"
    echo "Due Date: $due_date"
    echo "Due Time: $due_time"
    echo "Completed: $completed"
}

# Function to list tasks for a given day
list_tasks() {
    read -p "Enter the date (YYYY-MM-DD) to list tasks: " date
    if ! date -d "$date" &>/dev/null; then
        echo "Invalid date format." >&2
        return
    fi
    echo "Tasks for $date:"
    echo "Completed:"
    grep "|$date|" $TODO_FILE | grep "|yes$" | while IFS='|' read -r id title description location due_date due_time completed; do
        echo "$id: $title"
    done
    echo "Uncompleted:"
    grep "|$date|" $TODO_FILE | grep "|no$" | while IFS='|' read -r id title description location due_date due_time completed; do
        echo "$id: $title"
    done
}

# Function to search a task by title
search_task() {
    read -p "Enter the title to search: " title
    grep "|$title|" $TODO_FILE | while IFS='|' read -r id title description location due_date due_time completed; do
        echo "$id: $title"
    done
}

# script logic
case $1 in
    help)
        show_help $2
        ;;
    create)
        create_task
        ;;
    update)
        update_task
        ;;
    delete)
        delete_task
        ;;
    show)
        show_task
        ;;
    list)
        list_tasks
        ;;
    search)
        search_task
        ;;
    listall)
        list_all_tasks
        ;;
    *)
        show_help
        ;;
esac


