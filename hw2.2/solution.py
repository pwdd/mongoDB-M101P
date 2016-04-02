
import pymongo
import sys

# establish a connection to the database
connection = pymongo.MongoClient("mongodb://localhost")

# get a handle to the school database
db=connection.students
scores = db.grades


def find():

    query = {'type':'homework'}
#    projection = {'student_id':1, '_id':0}
    projection = {'student_id':1, 'type': 1, "score": 1, "_id": 0}
    sort = {'student_id': 1, 'score': 1}

    try:
        cursor = scores.find(query, projection).sort([('student_id', pymongo.ASCENDING), ('score', pymongo.ASCENDING)])

    except Exception as e:
        print "Unexpected error:", type(e), e

    counter = 0
    for doc in cursor:
        counter += 1
        if counter % 2 != 0:
            scores.delete_one(doc)

find()
