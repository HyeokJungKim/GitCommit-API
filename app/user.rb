class User < ActiveRecord::Base
  has_many :commits

  def get_commits
    response = RestClient.get("https://api.github.com/users/#{github_username}/events", {Authorization: "token #{ENV['API_KEY']}"})
    JSON.parse(response)
  end

  def find_first_push
    first_commit = get_commits.find{|event| event["type"] === "PushEvent"}
    if first_commit && DateTime.parse(first_commit["created_at"]).to_date == Date.today
      Commit.create(user: self, repository_name: first_commit["repo"]["name"], commit_reference: first_commit["payload"]["push_id"])
      return "#{self.name}: You've been committing for #{self.streak} day(s) in a row! ✅"
    elsif first_commit.nil?
      return nil
    else
      return "#{self.name}: Disappointing... 😢"
    end
  end

  def self.check_all
    User.all.each do |user|
      string = user.find_first_push
      if string
        puts string
      else
        puts "#{self.name}: ???"
      end
    end
  end
end
