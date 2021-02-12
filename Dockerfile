FROM node:lts as build-deps
WORKDIR /frontend
COPY ./frontend/react_app/package.json ./frontend/react_app/yarn.lock ./
RUN yarn
COPY ./frontend/react_app /frontend
RUN yarn build


FROM python:3.8


WORKDIR /app/backend

# Install Python dependencies
COPY ./backend/requirements.txt /app/backend/
RUN pip3 install --upgrade pip -r requirements.txt



# Add the rest of the code
COPY . /app/


COPY --from=build-deps /frontend/build /app/frontend/build

WORKDIR /app/frontend/build
RUN mkdir root && mv *.ico *.js *.json root
RUN mkdir /app/staticfiles

WORKDIR /app

# SECRET_KEY is only included here to avoid raising an error when generating static files.
# Be sure to add a real SECRET_KEY config variable in Heroku.
<<<<<<< HEAD
RUN DJANGO_SETTINGS_MODULE=mainapp.settings 
RUN chmod +x /app/backend/entrypoint.sh
RUN useradd -m myuser
USER myuser

EXPOSE $PORT

=======
RUN DJANGO_SETTINGS_MODULE=mainapp.settings.local_settings 
  

EXPOSE $PORT

CMD gunicorn backend/django_app/manage.py runserver 0.0.0.0:$PORT
>>>>>>> b6a43a2105f81481ff462e234bb19aa4fd37e14a
