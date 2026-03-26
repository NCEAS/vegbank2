from vegbank.app import create_app

if __name__ == '__main__':
   create_app().run(port=8000)
else:
   app = create_app() 