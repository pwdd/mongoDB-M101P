require 'mongo'

class Solution
  attr_reader :collection
  Mongo::Logger.logger.level = ::Logger::INFO

  def self.mongo_client
    Mongo::Client.new('mongodb://localhost:27017')
  end

  def self.collection
    db = mongo_client.use('school')
    db[:students]
  end

  def self.update_scores
    cursor = collection.find({ 'scores.type' => 'homework' })
    cursor.each do |doc|
      scores = doc['scores']
      new_scores = remove_lowest_homework_score(scores)
      collection.update_one({ '_id' => doc['_id'] }, { '$set' => { 'scores' => new_scores }})
    end
  end

  def self.remove_lowest_homework_score(scores)
    # scores format example:
    # [ { "type" : "exam", "score" : 1.463179736705023 }, 
    #   { "type" : "quiz", "score" : 11.78273309957772 }, 
    #   { "type" : "homework", "score" : 6.676176060654615 }, 
    #   { "type" : "homework", "score" : 35.8740349954354 } ]
    homeworks = scores.select { |score| score.values.include?('homework') }
    min_score = homeworks.map { |grade| grade['score'] }.min

    scores.reject { |grade| grade['score'] == min_score &&
                            grade['type'] == 'homework' }
  end
end

Solution.update_scores