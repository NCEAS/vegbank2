from vegbank.app import create_app
import logging

if __name__ == '__main__':
   create_app().run(port=8000)
else:
   gunicorn_logger = logging.getLogger('gunicorn.error')

   root_logger = logging.getLogger()
   root_logger.handlers = gunicorn_logger.handlers
   root_logger.setLevel(gunicorn_logger.level)
   
   app = create_app() 