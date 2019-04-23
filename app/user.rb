class User < ActiveRecord::Base
  has_many :commits
  validates :github_username, uniqueness: true

  def scrape_github
    doc = Nokogiri::HTML(open("http://github.com/#{self.github_username}"))
  end

  def get_commit_from_n_days(num = 0)
    scrape_github.css("rect")[-1 - num]
  end

  def check_commit
    information_hash = get_commit_from_n_days().attributes
    num = information_hash["data-count"].value.to_i
    date_string = information_hash["data-date"].value
    date = Date.strptime(date_string, "%Y-%m-%d")
    if num > 0 && date.today?
      Commit.create(user: self, date_reference: "#{date_string}-#{self.github_username}")
      return "#{self.name}: Nice! You've been committing for #{self.streak} day(s) in a row! ✅".green
    else
      self.update(streak: 0)
      return "#{self.name}: Disappointing... Your streak is reset to 0...  😢".red
    end
  end

  def self.check_all
    puts "=" * 25
    User.all.each_with_index do |user, index|
      puts user.check_commit
    end
    puts "=" * 25
  end
end
