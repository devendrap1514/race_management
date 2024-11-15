# Race Management Application

This is a web application built with Ruby on Rails for managing race events and students participating in the races. The system allows race organizers to create student, select students, assign lanes, and manage race details.

## Ruby Version
- Ruby version: **3.3.6**

## System Dependencies

- Rails: **8.0.0**
- PostgreSQL for the database
- Puma as the web server
- Bootstrap for front-end styling
- SassC for CSS pre-processing

## Configuration

1. Clone this repository to your local machine:
    ```git clone https://github.com/your-username/race-management.git
    ```

2. Install the required gems:
    ```bundle install
    ```

3. Ensure you have PostgreSQL installed on your machine, or you can use any other database system you'd prefer (though PostgreSQL is the default in this app).

## Database Setup

1. Create and set up the database:
    ```bin/rails db:create
    ```

2. Run database migrations:
    ```bin/rails db:migrate
    ```

3. If you need to seed the database with sample data, run:
    ```bin/rails db:seed
    ```

## Running the Test Suite

This application uses RSpec for testing. To run the test suite:

1. First, install the required gems for testing:
    ```bundle install
    ```

2. Run the tests:
    ```bundle exec rspec
    ```

For test coverage reports, we use `simplecov`, which will generate coverage statistics when running tests.


## Project Dependencies
Here are the gems used in this application:

### Core Dependencies
- `rails` - The Ruby on Rails framework.
- `pg` - PostgreSQL database adapter for Active Record.
- `puma` - The web server used to serve the app.
- `importmap-rails` - For JavaScript import maps.
- `turbo-rails` - Hotwire Turbo for SPA-like behavior.
- `stimulus-rails` - Hotwire Stimulus for JavaScript behavior.
- `sassc-rails` - SassC for CSS pre-processing.
- `bootstrap` - Front-end framework for styling.

### Development & Testing
- `rspec-rails` - For testing with RSpec.
- `factory_bot_rails` - For creating test data in your specs.
- `simplecov` - For code coverage reporting.
- `shoulda-matchers` - For easy-to-write RSpec matchers.
- `byebug` - For debugging in development.
- `web-console` - To access the Rails console through web pages in development.

### Miscellaneous
- `faker` - For generating fake data (useful for seeding the database).

### Example Usage

1. The teacher can create a student.
2. The teacher can create a race event with student participants.
3. Assign lanes to the students.
4. Confirm the lane assignments and submit them for the race.
5. Once the race is created, the teacher can assign the positions. 

This is a basic race management system, and further features (like race result tracking, user authentication, etc.) can be added as needed.
