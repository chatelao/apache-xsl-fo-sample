import sys
import os
from datetime import datetime

ROADMAP_FILE = 'ROADMAP.md'

def read_roadmap():
    if not os.path.exists(ROADMAP_FILE):
        return []
    with open(ROADMAP_FILE, 'r') as f:
        return f.readlines()

def write_roadmap(lines):
    with open(ROADMAP_FILE, 'w') as f:
        f.writelines(lines)

def add_task(task_text):
    lines = read_roadmap()
    header = []
    tasks = []

    found_roadmap_header = False
    for line in lines:
        if line.strip().startswith('# ROADMAP'):
            header.append(line)
            found_roadmap_header = True
        elif not found_roadmap_header and not tasks:
            header.append(line)
        else:
            tasks.append(line)

    if not found_roadmap_header and not header:
        header = ['# ROADMAP\n\n']

    new_task = f"- [ ] {task_text}\n"

    # Insert new tasks on the top of the list
    new_tasks = [new_task] + tasks

    write_roadmap(header + new_tasks)
    print(f"Added task: {task_text}")

def complete_task(task_text):
    lines = read_roadmap()
    new_lines = []
    task_found = False

    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    for line in lines:
        if task_text in line and '- [ ]' in line and not task_found:
            # Add a timestamp of completion on the end of each task when done
            completed_line = line.replace('- [ ]', '- [x]').rstrip() + f" (completed at {timestamp})\n"
            new_lines.append(completed_line)
            task_found = True
        else:
            new_lines.append(line)

    if task_found:
        write_roadmap(new_lines)
        print(f"Completed task: {task_text}")
    else:
        print(f"Task not found or already completed: {task_text}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python roadmap_manager.py [add|complete] \"task text\"")
        sys.exit(1)

    action = sys.argv[1]
    task = sys.argv[2]

    if action == "add":
        add_task(task)
    elif action == "complete":
        complete_task(task)
    else:
        print(f"Unknown action: {action}")
        sys.exit(1)
