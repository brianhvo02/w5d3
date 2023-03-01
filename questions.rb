require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class User
    attr_accessor :id, :fname, :lname

    def initialize(hash)
        @id = hash['id']
        @fname = hash['fname']
        @lname = hash['lname']
    end

    def self.find_by_id(id)
        users = QuestionsDatabase.instance.execute("SELECT * FROM users WHERE id=#{id};")
        User.new(users.first)
    end

    def self.find_by_name(fname, lname)
        users = QuestionsDatabase.instance.execute("SELECT * FROM users WHERE fname=#{fname} lname=#{lname};")
        users.map { |hash| User.new(hash) }
    end
end

class Question
    attr_accessor :id, :title, :body, :author_id

    def initialize(hash)
        @id = hash['id']
        @title = hash['title']
        @body = hash['body']
        @author_id = hash['author_id']
    end

    def self.find_by_id(id)
        questions = QuestionsDatabase.instance.execute("SELECT * FROM questions WHERE id=#{id};")
        Question.new(questions.first)
    end

    def self.find_by_title(title)
        questions = QuestionsDatabase.instance.execute("SELECT * FROM questions WHERE title=#{title};")
        questions.map { |hash| Question.new(hash) }
    end

    def self.find_by_author_id(author_id)
        questions = QuestionsDatabase.instance.execute("SELECT * FROM questions WHERE author_id=#{author_id};")
        questions.map { |hash| Question.new(hash) }
    end
end

class Reply
    attr_accessor :id, :body, :user_id, :question_id, :parent_reply_id

    def initialize(hash)
        @id = hash['id']
        @body = hash['body']
        @user_id = hash['user_id']
        @question_id = hash['question_id']
        @parent_reply_id = hash['parent_reply_id']
    end

    def self.find_by_id(id)
        replies = QuestionsDatabase.instance.execute("SELECT * FROM replies WHERE id=#{id};")
        Reply.new(replies.first)
    end

    def self.find_by_user_id(user_id)
        replies = QuestionsDatabase.instance.execute("SELECT * FROM replies WHERE user_id=#{user_id};")
        replies.map { |hash| Reply.new(hash) }
    end

    def self.find_by_question_id(question_id)
        replies = QuestionsDatabase.instance.execute("SELECT * FROM replies WHERE question_id=#{question_id};")
        replies.map { |hash| Reply.new(hash) }
    end
end

class QuestionLike
    attr_accessor :id, :user_id, :question_id

    def initialize(hash)
        @id = hash['id']
        @user_id = hash['user_id']
        @question_id = hash['question_id']
    end

    def self.find_by_id(id)
        question_likes = QuestionsDatabase.instance.execute("SELECT * FROM question_likes WHERE id=#{id};")
        QuestionLike.new(question_likes.first)
    end
end

