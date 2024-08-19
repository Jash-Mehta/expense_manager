# Expense Manager 👩‍💻

Expense Manager is a Flutter application designed to help users manage their daily, weekly, and monthly expenses efficiently. The app utilizes SQLite for local data storage through the `sqflite` package and implements state management using the `GetX` package.

## Features

- **Add Expenses**: Easily add new expenses to keep track of your daily spending.
- **Edit Expenses**: Update or modify existing expenses as needed.
- **Delete Expenses**: Remove expenses that are no longer relevant.
- **View Summary**: Get a clear summary of your expenses, organized by week or month.
- **Graphical Representation**: View your expenses in graphical form for a better understanding of your spending patterns.
- **Local Notifications**: Receive reminders through local notifications when you open the app.

## Why GetX?

We use GetX for state management because it offers a lightweight and highly efficient solution with minimal boilerplate code. GetX provides:
- **Reactive Programming**: Easily manage the UI state with reactive variables that automatically update when their values change.
- **Dependency Injection**: Simplify the process of managing dependencies across the app.
- **Navigation**: Streamline navigation and routing within the app without the need for context.

## How to Use

### 1. Add an Expense
- **Step 1**: Open the **Dashboard** screen.
- **Step 2**: Tap the **Add Expense** button.
- **Step 3**: Fill in the details of the expense (e.g., amount, description) and save.

### 2. Edit an Expense
- **Step 1**: On the **Dashboard** screen, under the **Daily Expenses** heading, find the expense you want to edit.
- **Step 2**: Tap on the **expense name** to be redirected to the **Edit Expense** screen.
- **Step 3**: Make the necessary changes and save the updated expense.

### 3. Delete an Expense
- **Step 1**: On the **Dashboard** screen, under the **Daily Expenses** heading, locate the expense you wish to delete.
- **Step 2**: Swipe the expense entry to the **left** to reveal the delete option.
- **Step 3**: Confirm the deletion to remove the expense from the list.

### 4. View Expense Summary
- **Step 1**: In the **Dashboard** screen, tap the **Summary** section located in the app bar.
- **Step 2**: View the **Monthly** and **Weekly** data, represented both in list form and as graphs.

### 5. Local Notifications
- **Step 1**: The app uses the `local_notifications` package.
- **Step 2**: When you open the app, a local notification will trigger to remind you about your expenses.

### 6. Filter
- **Step 1**: On the **Dashboard** screen, under the **Daily Expenses** heading, there are two date selection buttons. Beside these buttons, there is a filter icon. Select the desired date range and click on the filter icon. The list will be updated, and you will see the filtered expenses.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Jash-Mehta/expense_manager.git
2. Navigate to the project directory
   ```bash
    cd expense_manager
3. Get the dependencies
   ```bash
   flutter pub get
4. Run the app
   ```bash
   flutter run
   
