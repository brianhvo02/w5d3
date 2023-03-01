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
        users = QuestionsDatabase.instance.execute("SELECT * FROM users WHERE fname='#{fname}' AND lname='#{lname}';")
        users.map { |hash| User.new(hash) }
    end

    def authored_questions
        #Called on a User, what questions have they written
        Question.find_by_author_id(self.id)
    end

    def authored_replies 
        Reply.find_by_user_id(self.id)
    end

    def followed_questions_for_user_id
        QuestionFollow.followed_questions_for_user_id(self.id)
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
        questions = QuestionsDatabase.instance.execute("SELECT * FROM questions WHERE title='#{title}';")
        questions.map { |hash| Question.new(hash) }
    end

    def self.find_by_author_id(author_id)
        questions = QuestionsDatabase.instance.execute("SELECT * FROM questions WHERE author_id=#{author_id};")
        questions.map { |hash| Question.new(hash) }
    end

    def author
        User.find_by_id(self.author_id)
    end

    def replies
        Reply.find_by_question_id(self.id)
    end

    def followers
        QuestionFollow.followers_for_question_id(self.id)
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

    def self.find_by_parent_reply_id(parent_reply_id)
        replies = QuestionsDatabase.instance.execute("SELECT * FROM replies WHERE parent_reply_id=#{parent_reply_id};")
        replies.map { |hash| Reply.new(hash) }
    end

    def author
        User.find_by_id(self.user_id)
    end

    def question 
        Question.find_by_id(self.question_id)
    end

    def parent_reply 
        return [] if self.parent_reply_id.nil?
        Reply.find_by_id(self.parent_reply_id)
    end

    def child_replies
        Reply.find_by_parent_reply_id(self.id)
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

class QuestionFollow
    attr_accessor :question_id, :user_id

    def initialize(hash)
        @question_id = hash['question_id']
        @user_id = hash['user_id']
    end

    def self.followers_for_question_id(question_id)
        #Will return an array of User objects
        #Steps: Join on Users_ID, (1,Brian,V) (1,Ryder,A). Then select and initialize  
        users = QuestionsDatabase.instance.execute(<<-SQL)
        SELECT 
            users.id, fname, lname
        FROM
            question_follows
        JOIN 
            users ON users.id = question_follows.user_id
        WHERE
        question_follows.question_id = '#{question_id}'
        SQL
        users.map {|hash| User.new(hash)}
    end

    def self.followed_questions_for_user_id(user_id)
        #Will return an array of User objects
        #Steps: Join on Users_ID, (1,Brian,V) (1,Ryder,A). Then select and initialize  
        questions = QuestionsDatabase.instance.execute(<<-SQL)
        SELECT 
            questions.id, title, body, author_id
        FROM
            question_follows
        JOIN 
            questions ON questions.id = question_follows.question_id
        WHERE
        question_follows.user_id = '#{user_id}'
        SQL
        questions.map {|hash| Question.new(hash)}
    end

end 



