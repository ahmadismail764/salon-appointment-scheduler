# Salon Appointment Scheduler

This project is a command-line application for managing salon appointments. It allows customers to book appointments for various services offered by the salon. The application interacts with a PostgreSQL database to store and retrieve customer, service, and appointment information.

## Features

- Dynamically fetch and display available services.
- Add new customers to the database if they don't already exist.
- Schedule appointments for customers with a specified service and time.
- Store customer, service, and appointment data in a PostgreSQL database.

## Prerequisites

To run this project, you need:

1. **PostgreSQL** installed on your system.
2. A PostgreSQL user named `freecodecamp` with access to the database.
3. Bash shell to execute the script.

## Setup Instructions

1. Clone or download this repository to your local machine.
2. Navigate to the project directory:

   ```bash
   cd f:\Uni\salon-appointment-scheduler
   ```

3. Set up the database:
   - Open a PostgreSQL terminal and execute the `salon.sql` file to create the database and tables:

     ```bash
     psql --username=freecodecamp --file=salon.sql
     ```

## Running the Application

1. Run the `salon.sh` script:

   ```bash
   ./salon.sh
   ```

2. Follow the on-screen prompts to book an appointment.

## Database Schema

The database consists of three tables:

1. **customers**:
   - `customer_id`: Primary key.
   - `name`: Customer's name.
   - `phone`: Customer's phone number (unique).

2. **services**:
   - `service_id`: Primary key.
   - `name`: Name of the service.

3. **appointments**:
   - `appointment_id`: Primary key.
   - `customer_id`: Foreign key referencing `customers`.
   - `service_id`: Foreign key referencing `services`.
   - `time`: Appointment time.

## Example Services

The following services are preloaded into the database:

- Cut
- Color
- Perm
- Style
- Trim

## Notes

- Ensure the PostgreSQL service is running before executing the script.
- The script dynamically fetches services from the database, so any updates to the `services` table will be reflected in the application.

## License

This project is for educational purposes and is not licensed for commercial use.
