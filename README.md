# Calendar CLI

A menu-driven command-line calendar application built with Ruby.

## Features

- Add, edit, and remove events
- Only allow events in the future to be added
- Prevent overlapping events
- View events by:
  - Specific date
  - Specific month
  - All events

## Classes

The application has two main classes:

- `Calendar` - manages the events and handles calendar operations.
- `Event` - represents an individual calendar event.

`Calendar` has a composition relationship with `Event`, as events are created and managed by the calendar.

## Usage

Run the application from the terminal:

```bash
ruby main.rb