import bottle
import pymongo

@bottle.route('/')
def index():
  # connect to mongoDB
  connection = pymongo.MongoClient('localhost', 27017)

  # attach to the test db
  db = connection.test

  # get handle for names collection
  name = db.names

  # find a single document
  item = name.find_one()

  return '<b>Hello %s!</b>' % item['name']

bottle.run(host='localhost', port=8082)