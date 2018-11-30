# Reminder

This application composed from two main parts: backend (`Ruby on Rails`) and frontend (`Angular`).
In the interface user can create a simple reminder with options: title, description, time and also can set the day (by clicking on the schedule or by write such like "4th of month", "every Friday"). Every reminder can be repeated weekly or monthly.

## Deployment

1. Clone the project
2. Docker-compose

   Check-up the ports in `docker-compose.yml`
   Up the docker-compose by `docker-compose up -d`
   ...Wait (yes, I know, this is not optimized containers, but after all, you can develop under those containers)
3. Change (if it necessary) settings for backend server in the `frontend/src/environments/environment.prod.ts`

## Nginx and frontend

After previous steps, you have completed all preparation for start developing and, also, have run the server.

Now, If you want to start `Angular` as a development server, simply run something like `docker exec -it reminder_angular_1 /home/frontend/run.sh`, where `reminder_angular_1` - name of your *angular* container. **Or** `docker exec -it reminder_angular_1 /home/frontend/build.sh` for build in the production mode.

## Tests

Backend covered with 100% (from catcover: `All Files (100.0% covered at 10.15 hits/line)`)

## Live demo

[Here](https://reminder.anocms.org)